namespace Utils
{
    float DegToRad(float degrees) { return degrees * Math::PI / 180.0f; }
}

class CachedImage
{
    string m_url;
    nvg::Texture@ m_texture;

    void DownloadFromURLAsync()
    {
        auto req = Net::HttpRequest();
        req.Method = Net::HttpMethod::Get;
        req.Url = m_url;
        req.Start();
        while (!req.Finished()) {
            yield();
        }
        @m_texture = nvg::LoadTexture(req.Buffer());
        if (m_texture.GetSize().x == 0 || m_texture.GetSize().x > 16384) {
            @m_texture = null;
        }
    }
}

namespace Images
{
    dictionary g_cachedImages;

    CachedImage@ FindExisting(const string &in url)
    {
        CachedImage@ ret = null;
        g_cachedImages.Get(url, @ret);
        return ret;
    }

    CachedImage@ CachedFromURL(const string &in url)
    {
        // Return existing image if it already exists
        auto existing = FindExisting(url);
        if (existing !is null) {
            return existing;
        }

        // Create a new cached image object and remember it for future reference
        auto ret = CachedImage();
        ret.m_url = url;
        g_cachedImages.Set(url, @ret);

        // Begin downloading
        startnew(CoroutineFunc(ret.DownloadFromURLAsync));
        return ret;
    }
}

interface IRpmSource
{
    float GetRpm(CSceneVehicleVisState@ vis);
}

namespace SmoothRpmSource
{
    class Entry
    {
        float Rpm;
        uint64 Timestamp;
        
        Entry(float rpm)
        {
            Rpm = rpm;
            Timestamp = Time::Now;
        }

        Entry(float rpm, uint64 timestamp)
        {
            Rpm = rpm;
            Timestamp = timestamp;
        }
    }
}

class SmoothRpmSource : IRpmSource
{
    private uint capacity = 128;
    private array<SmoothRpmSource::Entry@> buffer = {};
    private uint head = 0;
    private uint tail = 0;

    uint64 TimeoutMs = 500;

    SmoothRpmSource(uint64 timeoutMs)
    {
        TimeoutMs = timeoutMs;
        for (uint i = 0; i < capacity; i++)
        {
            buffer.InsertLast(null);
            @buffer[i] = SmoothRpmSource::Entry(0, 0);
        }
    }

    private float Raw(CSceneVehicleVisState@ vis)
    {
        return VehicleState::GetRPM(vis);
    }

    float GetRpm(CSceneVehicleVisState@ vis) override
    {
        float rpm = Raw(vis);

        uint64 cutoff = Time::Now - TimeoutMs;
        while (head != tail && buffer[head].Timestamp < cutoff)
        {
            // Forget old entries.
            head = (head + 1) % capacity;
        }

        // Add the new entry.
        buffer[tail].Rpm = rpm;
        buffer[tail].Timestamp = Time::Now;
        tail = (tail + 1) % capacity;

        if (tail == head)
        {
            // Capacity exceeded. Forget the oldest entry.
            head = (head + 1) % capacity;
        }

        float sum = 0;
        uint count = 0;
        uint idx = head;
        while (idx != tail)
        {
            sum += buffer[idx].Rpm;
            count++;
            idx = (idx + 1) % capacity;
        }

        return sum / count;
    }
}
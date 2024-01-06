class Gauge
{
    vec2 m_pos;
    vec2 m_size;

    vec2 m_resPos;
    vec2 m_center;

    IRpmSource@ m_rpmSource = SmoothRpmSource(PluginSettings::RpmSmoothingTimeout);
    float m_rpm = 0.0f;
    float m_speed = 0.0f;
    int m_gear = 0;
    int m_prevGear = 0;
    bool m_shifted = false;

    float m_minRpm = 200.0f; // Minimal RPM to avoid flickering at engine idle
    float m_maxRpm = 11000.0f;

    void InternalRender(CSceneVehicleVisState@ vis)
    {
        if (PluginSettings::ShowVelocity) {
            m_speed = vis.WorldVel.Length() * 3.6f;
        } else {
            m_speed = vis.FrontSpeed * 3.6f;
        }

        m_rpm = m_rpmSource.GetRpm(vis);
        m_gear = vis.CurGear;

        if (vis.CurGear == 0)
            m_gear = -1;

        if (m_gear != m_prevGear) {
            trace("Shifted from " + m_prevGear + " to " + m_gear + " at " + m_rpm + " RPM!");
            m_shifted = true;
            m_prevGear = m_gear;
        } else {
            m_shifted = false;
        }

        vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
		m_resPos = m_pos * (screenSize - m_size);
        m_center = vec2(m_size.x * 0.5f, m_size.y * 0.5f);
        nvg::Save();
		nvg::Translate(m_resPos.x, m_resPos.y);
		Render();
        nvg::Restore();
    }

    void Render()
    {
        RenderBackground();
        RenderSpeed();
        RenderRPM();
        RenderGear();
    }

    void RenderBackground(){}

    void RenderSpeed(){}

    void RenderRPM(){}

    void RenderGear(){}

    void RenderSettingsTab() {
        UI::Text("This theme does not have any settings.");
    }
}
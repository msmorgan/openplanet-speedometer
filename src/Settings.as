namespace PluginSettings
{
    [Setting name="Show Speedometer" category="General"]
    bool ShowSpeedometer = true;

    [Setting name="Hide when not playing" category="General"]
    bool HideWhenNotPlaying = true;

    [Setting name="Hide when interface is hidden" category="General"]
    bool HideWhenNotIFace = false;

    [Setting name="Locator Mode (move speedometer)" category="General"]
    bool LocatorMode = false;

    enum Themes {
        Basic,
        BasicDigital,
        Advanced,
        AdvancedDigital,
        TrackmaniaTurbo,
        Ascension2023
    }

    [Setting name="Theme" category="General"]
    Themes Theme = Themes::Basic;

    [Setting name="Position" category="General"]
    vec2 Position = vec2(1.0f, 1.06f);

    [Setting name="Size" category="General"]
    vec2 Size = vec2(350, 350);

    [Setting name="Use velocity instead of speed (useful for ice)" category="General"]
    bool ShowVelocity = false;

    [Setting name="RPM smoothing (ms, 0=none)" category="General"]
    uint64 RpmSmoothingTimeout = 250;

    [SettingsTab name="Theme Settings"]
    void RenderThemeSettingsTab()
    {
        g_speedometer.m_gauge.RenderSettingsTab();
    }
}
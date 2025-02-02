Speedometer@ g_speedometer;

void Main()
{
    @g_speedometer = Speedometer();
}

void Render()
{
#if MP4
    SetMP4Speedometer(false);
#endif
    g_speedometer.Render();
}

void RenderInterface()
{
    if (PluginSettings::LocatorMode) {
        Locator::Render("Speedometer", PluginSettings::Position, PluginSettings::Size);
        PluginSettings::Position = Locator::GetPos();
        PluginSettings::Size = Locator::GetSize();
    }
}

void RenderMenu()
{
    if(UI::MenuItem("\\$fa0" + Icons::Kenney::ButtonCircle + " \\$zSpeedometer", "", PluginSettings::ShowSpeedometer))
        PluginSettings::ShowSpeedometer = !PluginSettings::ShowSpeedometer;
}

void OnSettingsChanged()
{
    g_speedometer.UpdateGaugeTheme();
}

void OnDestroyed()
{
#if MP4
    SetMP4Speedometer(true);
#endif
}

void OnDisabled()
{
#if MP4
    SetMP4Speedometer(true);
#endif
}
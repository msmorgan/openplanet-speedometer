namespace AdvancedGaugeSettings
{
    // Background image
    [Setting hidden]
    bool AdvancedGaugeBackgroundVisible = false;

    [Setting hidden]
    string AdvancedGaugeBackgroundURL = "https://i.imgur.com/sz01oX3.png";

    [Setting hidden]
    float AdvancedGaugeBackgroundScale = 0.42f;

    [Setting hidden]
    float AdvancedGaugeBackgroundAlpha = 1.0f;

    // Speed
    [Setting hidden]
    vec4 AdvancedGaugeSpeedColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

    [Setting hidden]
    vec4 AdvancedGaugeSpeedIdleColor = vec4(0.0f, 0.0f, 0.0f, 0.5f);

    // RPM
    [Setting hidden]
    vec4 AdvancedGaugeRPMColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

    [Setting hidden]
    float AdvancedGaugeRPMBackgroundAlpha = 0.5;

    [Setting hidden]
    float AdvancedGaugeRPMBackgroundBrightness = 0.5;

    [Setting hidden]
    bool AdvancedGaugeRPMBackgroundSegmented = true;

    [Setting hidden]
    float AdvancedGaugeRPMBackgroundSize = 1.0;

    [Setting hidden]
    float AdvancedGaugeRPMBackgroundWidth = 1.5;

    [Setting hidden]
    vec4 AdvancedGaugeRPMBackgroundTickColor = vec4(0, 0, 0, 0.5);

    [Setting hidden]
    float AdvancedGaugeRPMBackgroundTickWidth = 0.005;

    [Setting hidden]
    float AdvancedGaugeRpmBackgroundTickLength = 1.5;

    [Setting hidden]
    bool AdvancedGaugeRPMNeedle = true;

    [Setting hidden]
    bool AdvancedGaugeRPMArc = true;

    [Setting hidden]
    float AdvancedGaugeRPMNeedleWidth = 0.02f;

    [Setting hidden]
    vec4 AdvancedGaugeRPMNeedleColor = vec4(1.0);

    [Setting hidden]
    float AdvancedGaugeRPMArcWidth = 0.04f;

    [Setting hidden]
    bool AdvancedGaugeRPMDownshiftUpshift = true;

    [Setting hidden]
    float AdvancedGaugeRPMDownshift = 6500;

    [Setting hidden]
    vec4 AdvancedGaugeRPMDownshiftColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);

    [Setting hidden]
    float AdvancedGaugeRPMUpshift = 10000;

    [Setting hidden]
    vec4 AdvancedGaugeRPMUpshiftColor = vec4(1.0f, 0.0f, 0.0f, 1.0f);

    // Gears
    [Setting hidden]
    vec4 AdvancedGaugeGearColor = vec4(0.2f, 1.0f, 0.6f, 1.0f);

    [Setting hidden]
    bool AdvancedGaugeGearDownshift = true;

    [Setting hidden]
    vec4 AdvancedGaugeGearDownshiftColor = vec4(1.0f, 0.6f, 0.2f, 1.0f);

    [Setting hidden]
    bool AdvancedGaugeGearUpshift = true;

    [Setting hidden]
    vec4 AdvancedGaugeGearUpshiftColor = vec4(1.0f, 0.4f, 0.4f, 1.0f);

    // [Setting hidden]
    array<vec2> AdvancedGaugeRpmThresholdsStadium = {
        vec2(0, 11000),
        vec2(0, 10125),
        vec2(5625, 9750),
        vec2(6800, 10385),
        vec2(6450, 10400),
        vec2(6725, 11000),
    };

    // [Setting hidden]
    array<vec2> AdvancedGaugeRpmThresholdsSnow = {
        vec2(0, 11000),
        vec2(0, 8000),
        vec2(6275, 10225),
        vec2(7333, 10650),
        vec2(7800, 10785),
        vec2(8333, 11000),
    };

    void ResetAllToDefault() {
        AdvancedGaugeBackgroundVisible = false;
        AdvancedGaugeBackgroundURL = "https://i.imgur.com/sz01oX3.png";
        AdvancedGaugeBackgroundScale = 0.42f;
        AdvancedGaugeBackgroundAlpha = 1.0f;

        AdvancedGaugeSpeedColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);
        AdvancedGaugeSpeedIdleColor = vec4(0.0f, 0.0f, 0.0f, 0.5f);

        AdvancedGaugeRPMColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);
        AdvancedGaugeRPMBackgroundAlpha = 0.5;
        AdvancedGaugeRPMBackgroundBrightness = 0.5;
        AdvancedGaugeRPMBackgroundSegmented = true;
        AdvancedGaugeRPMBackgroundWidth = 1.5;
        AdvancedGaugeRPMBackgroundSize = 1.0;
        AdvancedGaugeRPMNeedle = true;
        AdvancedGaugeRPMArc = true;
        AdvancedGaugeRPMNeedleWidth = 0.02f;
        AdvancedGaugeRPMArcWidth = 0.04f;
        AdvancedGaugeRPMDownshiftUpshift = true;
        AdvancedGaugeRPMDownshift = 6500;
        AdvancedGaugeRPMDownshiftColor = vec4(1.0f, 1.0f, 1.0f, 1.0f);
        AdvancedGaugeRPMUpshift = 10000;
        AdvancedGaugeRPMUpshiftColor = vec4(1.0f, 0.0f, 0.0f, 1.0f);

        AdvancedGaugeGearColor = vec4(0.075f, 1.0f, 0.553f, 1.0f);
        AdvancedGaugeGearDownshift = true;
        AdvancedGaugeGearDownshiftColor = vec4(1.0f, 0.0f, 0.0f, 1.0f);
        AdvancedGaugeGearUpshift = true;
        AdvancedGaugeGearUpshiftColor = vec4(1.0f, 0.0f, 0.0f, 1.0f);
    }
}
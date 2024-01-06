
class AdvancedGauge : Gauge
{

    float startAngle = Utils::DegToRad(110.0f);
    float endAngle = Utils::DegToRad(335.0f);
    float angleTotal = endAngle - startAngle;

    int m_GearFont;
    int m_SpeedFont;

    float m_upshiftRpm = AdvancedGaugeSettings::AdvancedGaugeRPMUpshift;
    float m_downshiftRpm = AdvancedGaugeSettings::AdvancedGaugeRPMDownshift;

    AdvancedGauge()
    {
        super();

        m_minRpm = 0;

        m_GearFont = nvg::LoadFont("src/Fonts/Oswald-Demi-Bold-Italic.ttf");
        m_SpeedFont = nvg::LoadFont("src/Fonts/Oswald-Light-Italic.ttf");
    }

    private float RpmToFraction(float value)
    {
        return Math::InvLerp(0, m_maxRpm, value);
    }

    private float FractionToAngle(float fraction)
    {
        return Math::Lerp(startAngle, endAngle, fraction);
    }

    private float RpmToAngle(float rpm)
    {
        return FractionToAngle(RpmToFraction(rpm));
    }

    private float NormalizedRpm {
        get {
            return RpmToFraction(m_rpm);
        }
    }
    

    private float CurrentAngle {
        get {
            return FractionToAngle(NormalizedRpm);
        }
    }

    private float DownshiftAngle {
        get {
            return RpmToAngle(m_downshiftRpm);
        }
    }

    private float UpshiftAngle {
        get {
            return RpmToAngle(m_upshiftRpm);
        }
    }

    private vec4 CurrentRPMColor {
        get {
            if (AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftUpshift) {
                if (CurrentAngle <= DownshiftAngle) {
                    return AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftColor;
                } else if (CurrentAngle >= UpshiftAngle) {
                    return AdvancedGaugeSettings::AdvancedGaugeRPMUpshiftColor;
                }
            }
            return AdvancedGaugeSettings::AdvancedGaugeRPMColor;
        }
    }

    private vec4 CurrentGearColor {
        get {
            if (AdvancedGaugeSettings::AdvancedGaugeGearDownshift && CurrentAngle <= DownshiftAngle) {
                return AdvancedGaugeSettings::AdvancedGaugeGearDownshiftColor;
            }
            if (AdvancedGaugeSettings::AdvancedGaugeGearUpshift && CurrentAngle >= UpshiftAngle) {
                return AdvancedGaugeSettings::AdvancedGaugeGearUpshiftColor;
            }
            return AdvancedGaugeSettings::AdvancedGaugeGearColor;
        }
    }

    private void DrawLine(vec2 start, vec2 end, float width, vec4 color)
    {
        nvg::BeginPath();
        nvg::MoveTo(start);
        nvg::LineTo(end);
        nvg::StrokeWidth(width);
        nvg::StrokeColor(color);
        nvg::Stroke();
    }

    private void DrawArc(vec2 center, float radius, float width, float angle0, float angle1, vec4 color)
    {
        nvg::BeginPath();
        nvg::Arc(center, radius, angle0, angle1, nvg::Winding::CW);
        nvg::StrokeWidth(width);
        nvg::StrokeColor(color);
        nvg::Stroke();
    }

    private vec4 MultiplyColor(vec4 color, float brightnessFactor, float alphaFactor = 1.0)
    {
        return color * vec4(vec3(brightnessFactor), alphaFactor);
    }

    void Render() override {
        // if (m_shifted)
        // {
            vec2 thresholds = AdvancedGaugeSettings::AdvancedGaugeRpmThresholdsStadium[Math::Max(0, m_gear)];
#if DEPENDENCY_CURRENTEFFECTS
            if (CurrentEffects::SnowCar) {
                thresholds = AdvancedGaugeSettings::AdvancedGaugeRpmThresholdsSnow[Math::Max(0, m_gear)];
            }
#endif
            m_upshiftRpm = thresholds.y;
            m_downshiftRpm = thresholds.x;
        // }
        nvg::Save();
        nvg::Translate(m_center);
        nvg::Scale(vec2(m_size.x));
        Gauge::Render();
        nvg::Restore();
    }

    void RenderBackground() override
    {
        if (AdvancedGaugeSettings::AdvancedGaugeBackgroundVisible) {
            auto image = Images::CachedFromURL(AdvancedGaugeSettings::AdvancedGaugeBackgroundURL);
            if (image.m_texture !is null){
                nvg::BeginPath();
                vec2 imageSize = image.m_texture.GetSize() * AdvancedGaugeSettings::AdvancedGaugeBackgroundScale;
                vec2 imageCenterPos = vec2(imageSize.x / 2.0f, imageSize.y / 2.0f);
                nvg::Rect(m_center - imageCenterPos, imageSize);
                nvg::FillPaint(nvg::TexturePattern(m_center - imageCenterPos, imageSize, 0, image.m_texture, AdvancedGaugeSettings::AdvancedGaugeBackgroundAlpha));
                nvg::Fill();
            }
        }
    }

    void RenderSpeed() override
    {
        mat3 transform = nvg::CurrentTransform();
        nvg::Restore();

        nvg::BeginPath();
        nvg::FontFace(m_SpeedFont);
        nvg::FontSize(m_size.x * 0.2f);
        // remove negative sign
        int speed = Text::ParseInt(Text::Format("%.0f", Math::Abs(m_speed)));
        vec2 margin = vec2(m_size.x * 0.07f, 60 + (m_size.y * 0.1f));
        if (m_speed > -1 && m_speed < 1) {
            nvg::FillColor(AdvancedGaugeSettings::AdvancedGaugeSpeedIdleColor);
            nvg::Text(m_center.x+margin.x, m_center.y+margin.y, "000");
        } else if (speed > 0 && speed < 10) {
            nvg::FillColor(AdvancedGaugeSettings::AdvancedGaugeSpeedIdleColor);
            nvg::Text(m_center.x+margin.x, m_center.y+margin.y, "00");

            vec2 bounds = nvg::TextBounds("00");

            nvg::FillColor(AdvancedGaugeSettings::AdvancedGaugeSpeedColor);
            nvg::Text(m_center.x+margin.x+bounds.x, m_center.y+margin.y, tostring(speed));
        } else if (speed >= 10 && speed < 100) {
            nvg::FillColor(AdvancedGaugeSettings::AdvancedGaugeSpeedIdleColor);
            nvg::Text(m_center.x+margin.x, m_center.y+margin.y, "0");

            vec2 bounds = nvg::TextBounds("0");

            nvg::FillColor(AdvancedGaugeSettings::AdvancedGaugeSpeedColor);
            nvg::Text(m_center.x+margin.x+bounds.x, m_center.y+margin.y, tostring(speed));
        } else {
            nvg::FillColor(AdvancedGaugeSettings::AdvancedGaugeSpeedColor);
            nvg::Text(m_center.x+margin.x, m_center.y+margin.y, Text::Format("%03d", speed));
        }

        nvg::Save();
        nvg::SetTransform(transform);
    }

    void RenderRPM() override
    {
        vec2 center = vec2(0);

        // background
        if (AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundAlpha > 0)
        {
            float bgRadius = 0.3 * AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundSize;
            float bgStrokeWidth = AdvancedGaugeSettings::AdvancedGaugeRPMArcWidth * AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundWidth;

            vec4 color;
            const float brightness = AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundBrightness;
            const float alpha = AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundAlpha;
            if (AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundSegmented) {
                // Per-zone segments for downshift, normal, and upshift.
                color = MultiplyColor(AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftColor, brightness, alpha);
                DrawArc(center, bgRadius, bgStrokeWidth, startAngle, DownshiftAngle, color);

                color = MultiplyColor(AdvancedGaugeSettings::AdvancedGaugeRPMColor, brightness, alpha);
                DrawArc(center, bgRadius, bgStrokeWidth, DownshiftAngle, UpshiftAngle, color);

                color = MultiplyColor(AdvancedGaugeSettings::AdvancedGaugeRPMUpshiftColor, brightness, alpha);
                DrawArc(center, bgRadius, bgStrokeWidth, UpshiftAngle, endAngle, color);

                if (AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickColor.w > 0) {
                    vec2 basis;
                    float tickInner = bgRadius + (bgStrokeWidth * AdvancedGaugeSettings::AdvancedGaugeRpmBackgroundTickLength / 2);
                    float tickOuter = bgRadius - (bgStrokeWidth * AdvancedGaugeSettings::AdvancedGaugeRpmBackgroundTickLength / 2);
                    float tickWidth = AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickWidth;
                    
                    basis = vec2(Math::Cos(DownshiftAngle), Math::Sin(DownshiftAngle));
                    DrawLine(tickInner * basis, tickOuter * basis, tickWidth, AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickColor);
                    basis = vec2(Math::Cos(UpshiftAngle), Math::Sin(UpshiftAngle));
                    DrawLine(tickInner * basis, tickOuter * basis, tickWidth, AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickColor);
                }

            } else {
                // Single segment.
                color = MultiplyColor(AdvancedGaugeSettings::AdvancedGaugeRPMColor, brightness, alpha);
                DrawArc(center, bgRadius, bgStrokeWidth, startAngle, endAngle, color);
            }
        }

        if (AdvancedGaugeSettings::AdvancedGaugeRPMArc) {
            DrawArc(
                center,
                0.3,
                AdvancedGaugeSettings::AdvancedGaugeRPMArcWidth,
                startAngle,
                CurrentAngle,
                CurrentRPMColor);
        }

        if (AdvancedGaugeSettings::AdvancedGaugeRPMNeedle) {
            nvg::BeginPath();
            nvg::StrokeWidth(AdvancedGaugeSettings::AdvancedGaugeRPMNeedleWidth);
            float length = 0.3 + (AdvancedGaugeSettings::AdvancedGaugeRPMArcWidth / 2);
            float outer = length;
            float inner = 0.08;
            vec2 basis = vec2(Math::Cos(CurrentAngle), Math::Sin(CurrentAngle));
            nvg::MoveTo(center + inner * basis);
            nvg::LineTo(center + outer * basis);
            nvg::StrokeColor(AdvancedGaugeSettings::AdvancedGaugeRPMNeedleColor);
            nvg::Stroke();
        }
    }

    void RenderGear() override
    {
        mat3 transform = nvg::CurrentTransform();
        nvg::Restore();

        nvg::BeginPath();
        nvg::StrokeWidth(m_size.x * 0.01f);
        nvg::Circle(m_center, m_size.x * 0.08);

        nvg::FillColor(CurrentGearColor);
        nvg::StrokeColor(CurrentGearColor);

        // gear text
        nvg::TextAlign(nvg::Align::Center);
        nvg::FontFace(m_GearFont);
        nvg::FontSize(m_size.x * 0.12f);
        string gear = tostring(m_gear);
        if (m_gear == -1) gear = "R";
        nvg::Text(m_center.x-1, m_center.y+m_size.x * 0.045, gear);

        nvg::Stroke();

        nvg::Save();
        nvg::SetTransform(transform);
    }

    void RenderSettingsTab() override
    {
        if (UI::Button("Reset all settings to default")) {
            AdvancedGaugeSettings::ResetAllToDefault();
        }
        UI::BeginTabBar("Basic Gauge Settings", UI::TabBarFlags::FittingPolicyResizeDown);
        if (UI::BeginTabItem("Background")) {
            UI::BeginChild("Background Settings");
            AdvancedGaugeSettings::AdvancedGaugeBackgroundVisible = UI::Checkbox("Display background", AdvancedGaugeSettings::AdvancedGaugeBackgroundVisible);

            if (AdvancedGaugeSettings::AdvancedGaugeBackgroundVisible) {
                AdvancedGaugeSettings::AdvancedGaugeBackgroundURL = UI::InputText("Image URL", AdvancedGaugeSettings::AdvancedGaugeBackgroundURL);
                AdvancedGaugeSettings::AdvancedGaugeBackgroundAlpha = UI::SliderFloat("Alpha", AdvancedGaugeSettings::AdvancedGaugeBackgroundAlpha,0,1);
                AdvancedGaugeSettings::AdvancedGaugeBackgroundScale = UI::SliderFloat("Scale", AdvancedGaugeSettings::AdvancedGaugeBackgroundScale,0.1f,0.5f);
           }

            UI::EndChild();
            UI::EndTabItem();
        }
        if (UI::BeginTabItem("Speed")) {
            UI::BeginChild("Speed Settings");
            AdvancedGaugeSettings::AdvancedGaugeSpeedColor = UI::InputColor4("Speed color", AdvancedGaugeSettings::AdvancedGaugeSpeedColor);
            AdvancedGaugeSettings::AdvancedGaugeSpeedIdleColor = UI::InputColor4("Idle color (000 speed)", AdvancedGaugeSettings::AdvancedGaugeSpeedIdleColor);

            UI::EndChild();
            UI::EndTabItem();
        }
        if (UI::BeginTabItem("RPM")) {
            UI::BeginChild("RPM Settings");
            AdvancedGaugeSettings::AdvancedGaugeRPMColor = UI::InputColor4("RPM Color", AdvancedGaugeSettings::AdvancedGaugeRPMColor);

            AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundAlpha = UI::SliderFloat("Background arc alpha", AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundAlpha, 0, 1);
            if (AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundAlpha > 0) {
                AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundBrightness = UI::SliderFloat("Background arc brightness", AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundBrightness, 0, 2);
                AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundSegmented = UI::Checkbox("Segmented (upshift/downshift colors)", AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundSegmented);
                AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundSize = UI::SliderFloat("Size (multiplier)", AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundSize, 0.5, 1.25);
                AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundWidth = UI::SliderFloat("Width (multiplier)", AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundWidth, 0, 2);
                AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickColor = UI::InputColor4("Tick color", AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickColor);
                AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickWidth = UI::InputFloat("Tick width", AdvancedGaugeSettings::AdvancedGaugeRPMBackgroundTickWidth);
                AdvancedGaugeSettings::AdvancedGaugeRpmBackgroundTickLength = UI::InputFloat("Tick length", AdvancedGaugeSettings::AdvancedGaugeRpmBackgroundTickLength);
            }

            AdvancedGaugeSettings::AdvancedGaugeRPMNeedle = UI::Checkbox("Needle", AdvancedGaugeSettings::AdvancedGaugeRPMNeedle);
            if (AdvancedGaugeSettings::AdvancedGaugeRPMNeedle)
                AdvancedGaugeSettings::AdvancedGaugeRPMNeedleWidth = UI::SliderFloat("Needle width", AdvancedGaugeSettings::AdvancedGaugeRPMNeedleWidth,0,0.1);

            AdvancedGaugeSettings::AdvancedGaugeRPMArc = UI::Checkbox("Arc", AdvancedGaugeSettings::AdvancedGaugeRPMArc);
            if (AdvancedGaugeSettings::AdvancedGaugeRPMArc)
                AdvancedGaugeSettings::AdvancedGaugeRPMArcWidth = UI::SliderFloat("Arc width", AdvancedGaugeSettings::AdvancedGaugeRPMArcWidth,0,0.1);

            AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftUpshift = UI::Checkbox("Downshift/Upshift indicators", AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftUpshift);

            if (AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftUpshift) {
                UI::TextDisabled("Theres values override the RPM color setting depending on the threshold");
                AdvancedGaugeSettings::AdvancedGaugeRPMDownshift = UI::SliderFloat("Downshift threshold", AdvancedGaugeSettings::AdvancedGaugeRPMDownshift, 0, 11000);
                AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftColor = UI::InputColor4("Downshift color", AdvancedGaugeSettings::AdvancedGaugeRPMDownshiftColor);

                AdvancedGaugeSettings::AdvancedGaugeRPMUpshift = UI::SliderFloat("Upshift threshold", AdvancedGaugeSettings::AdvancedGaugeRPMUpshift, 0, 11000);
                AdvancedGaugeSettings::AdvancedGaugeRPMUpshiftColor = UI::InputColor4("Upshift color", AdvancedGaugeSettings::AdvancedGaugeRPMUpshiftColor);
            }

            UI::EndChild();
            UI::EndTabItem();
        }
        if (UI::BeginTabItem("Gears")) {
            UI::BeginChild("Gears Settings");
            AdvancedGaugeSettings::AdvancedGaugeGearColor = UI::InputColor4("Gear color", AdvancedGaugeSettings::AdvancedGaugeGearColor);

            AdvancedGaugeSettings::AdvancedGaugeGearDownshift = UI::Checkbox("Downshift indicator", AdvancedGaugeSettings::AdvancedGaugeGearDownshift);
            if (AdvancedGaugeSettings::AdvancedGaugeGearDownshift) {
                AdvancedGaugeSettings::AdvancedGaugeGearDownshiftColor = UI::InputColor4("Downshift color", AdvancedGaugeSettings::AdvancedGaugeGearDownshiftColor);
            }

            AdvancedGaugeSettings::AdvancedGaugeGearUpshift = UI::Checkbox("Upshift indicator", AdvancedGaugeSettings::AdvancedGaugeGearUpshift);
            if (AdvancedGaugeSettings::AdvancedGaugeGearUpshift) {
                AdvancedGaugeSettings::AdvancedGaugeGearUpshiftColor = UI::InputColor4("Upshift color", AdvancedGaugeSettings::AdvancedGaugeGearUpshiftColor);
            }

            UI::EndChild();
            UI::EndTabItem();
        }
        UI::EndTabBar();
    }
}
Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62175 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932121AbeBVMDZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:03:25 -0500
From: Claudiu Beznea <claudiu.beznea@microchip.com>
To: <thierry.reding@gmail.com>, <shc_work@mail.ru>, <kgene@kernel.org>,
        <krzk@kernel.org>, <linux@armlinux.org.uk>,
        <mturquette@baylibre.com>, <sboyd@codeaurora.org>,
        <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
        <rodrigo.vivi@intel.com>, <airlied@linux.ie>, <kamil@wypas.org>,
        <b.zolnierkie@samsung.com>, <jdelvare@suse.com>,
        <linux@roeck-us.net>, <dmitry.torokhov@gmail.com>,
        <rpurdie@rpsys.net>, <jacek.anaszewski@gmail.com>, <pavel@ucw.cz>,
        <mchehab@kernel.org>, <sean@mess.org>, <lee.jones@linaro.org>,
        <daniel.thompson@linaro.org>, <jingoohan1@gmail.com>,
        <milo.kim@ti.com>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <corbet@lwn.net>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@free-electrons.com>
CC: <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-leds@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v3 05/10] pwm: add PWM mode to pwm_config()
Date: Thu, 22 Feb 2018 14:01:16 +0200
Message-ID: <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com>
In-Reply-To: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add PWM mode to pwm_config() function. The drivers which uses pwm_config()
were adapted to this change.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 arch/arm/mach-s3c24xx/mach-rx1950.c  | 11 +++++++++--
 drivers/bus/ts-nbus.c                |  2 +-
 drivers/clk/clk-pwm.c                |  3 ++-
 drivers/gpu/drm/i915/intel_panel.c   | 17 ++++++++++++++---
 drivers/hwmon/pwm-fan.c              |  2 +-
 drivers/input/misc/max77693-haptic.c |  2 +-
 drivers/input/misc/max8997_haptic.c  |  6 +++++-
 drivers/leds/leds-pwm.c              |  5 ++++-
 drivers/media/rc/ir-rx51.c           |  5 ++++-
 drivers/media/rc/pwm-ir-tx.c         |  5 ++++-
 drivers/video/backlight/lm3630a_bl.c |  4 +++-
 drivers/video/backlight/lp855x_bl.c  |  4 +++-
 drivers/video/backlight/lp8788_bl.c  |  5 ++++-
 drivers/video/backlight/pwm_bl.c     | 11 +++++++++--
 drivers/video/fbdev/ssd1307fb.c      |  3 ++-
 include/linux/pwm.h                  |  6 ++++--
 16 files changed, 70 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/mach-rx1950.c b/arch/arm/mach-s3c24xx/mach-rx1950.c
index e86ad6a68a0b..6feae73dcc73 100644
--- a/arch/arm/mach-s3c24xx/mach-rx1950.c
+++ b/arch/arm/mach-s3c24xx/mach-rx1950.c
@@ -386,8 +386,13 @@ static void rx1950_lcd_power(int enable)
 {
 	int i;
 	static int enabled;
+	struct pwm_caps caps = { };
+
 	if (enabled == enable)
 		return;
+
+	pwm_get_caps(lcd_pwm->chip, lcd_pwm, &caps);
+
 	if (!enable) {
 
 		/* GPC11-GPC15->OUTPUT */
@@ -433,14 +438,16 @@ static void rx1950_lcd_power(int enable)
 
 		/* GPB1->OUTPUT, GPB1->0 */
 		gpio_direction_output(S3C2410_GPB(1), 0);
-		pwm_config(lcd_pwm, 0, LCD_PWM_PERIOD);
+		pwm_config(lcd_pwm, 0, LCD_PWM_PERIOD,
+			   BIT(ffs(caps.modes) - 1));
 		pwm_disable(lcd_pwm);
 
 		/* GPC0->0, GPC10->0 */
 		gpio_direction_output(S3C2410_GPC(0), 0);
 		gpio_direction_output(S3C2410_GPC(10), 0);
 	} else {
-		pwm_config(lcd_pwm, LCD_PWM_DUTY, LCD_PWM_PERIOD);
+		pwm_config(lcd_pwm, LCD_PWM_DUTY, LCD_PWM_PERIOD,
+			   BIT(ffs(caps.modes) - 1));
 		pwm_enable(lcd_pwm);
 
 		gpio_direction_output(S3C2410_GPC(0), 1);
diff --git a/drivers/bus/ts-nbus.c b/drivers/bus/ts-nbus.c
index 073fd9011154..dcd2ca3bcd99 100644
--- a/drivers/bus/ts-nbus.c
+++ b/drivers/bus/ts-nbus.c
@@ -316,7 +316,7 @@ static int ts_nbus_probe(struct platform_device *pdev)
 	 * the atomic PWM API.
 	 */
 	pwm_apply_args(pwm);
-	ret = pwm_config(pwm, pargs.period, pargs.period);
+	ret = pwm_config(pwm, pargs.period, pargs.period, pargs.mode);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/clk/clk-pwm.c b/drivers/clk/clk-pwm.c
index 8cb9d117fdbf..605a6bffe893 100644
--- a/drivers/clk/clk-pwm.c
+++ b/drivers/clk/clk-pwm.c
@@ -92,7 +92,8 @@ static int clk_pwm_probe(struct platform_device *pdev)
 	 * atomic PWM API.
 	 */
 	pwm_apply_args(pwm);
-	ret = pwm_config(pwm, (pargs.period + 1) >> 1, pargs.period);
+	ret = pwm_config(pwm, (pargs.period + 1) >> 1, pargs.period,
+			 pargs.mode);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index adc51e452e3e..960556261787 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -633,8 +633,12 @@ static void pwm_set_backlight(const struct drm_connector_state *conn_state, u32
 {
 	struct intel_panel *panel = &to_intel_connector(conn_state->connector)->panel;
 	int duty_ns = DIV_ROUND_UP(level * CRC_PMIC_PWM_PERIOD_NS, 100);
+	struct pwm_caps caps = { };
 
-	pwm_config(panel->backlight.pwm, duty_ns, CRC_PMIC_PWM_PERIOD_NS);
+	pwm_get_caps(panel->backlight.pwm->chip, panel->backlight.pwm, &caps);
+
+	pwm_config(panel->backlight.pwm, duty_ns, CRC_PMIC_PWM_PERIOD_NS,
+		   BIT(ffs(caps.modes) - 1));
 }
 
 static void
@@ -821,9 +825,13 @@ static void pwm_disable_backlight(const struct drm_connector_state *old_conn_sta
 {
 	struct intel_connector *connector = to_intel_connector(old_conn_state->connector);
 	struct intel_panel *panel = &connector->panel;
+	struct pwm_caps caps = { };
+
+	pwm_get_caps(panel->backlight.pwm->chip, panel->backlight.pwm, &caps);
 
 	/* Disable the backlight */
-	pwm_config(panel->backlight.pwm, 0, CRC_PMIC_PWM_PERIOD_NS);
+	pwm_config(panel->backlight.pwm, 0, CRC_PMIC_PWM_PERIOD_NS,
+		   BIT(ffs(caps.modes) - 1));
 	usleep_range(2000, 3000);
 	pwm_disable(panel->backlight.pwm);
 }
@@ -1754,6 +1762,7 @@ static int pwm_setup_backlight(struct intel_connector *connector,
 {
 	struct drm_device *dev = connector->base.dev;
 	struct intel_panel *panel = &connector->panel;
+	struct pwm_caps caps = { };
 	int retval;
 
 	/* Get the PWM chip for backlight control */
@@ -1770,8 +1779,10 @@ static int pwm_setup_backlight(struct intel_connector *connector,
 	 */
 	pwm_apply_args(panel->backlight.pwm);
 
+	pwm_get_caps(panel->backlight.pwm->chip, panel->backlight.pwm, &caps);
+
 	retval = pwm_config(panel->backlight.pwm, CRC_PMIC_PWM_PERIOD_NS,
-			    CRC_PMIC_PWM_PERIOD_NS);
+			    CRC_PMIC_PWM_PERIOD_NS, BIT(ffs(caps.modes) - 1));
 	if (retval < 0) {
 		DRM_ERROR("Failed to configure the pwm chip\n");
 		pwm_put(panel->backlight.pwm);
diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c
index 70cc0d134f3c..bd05cd81d3d5 100644
--- a/drivers/hwmon/pwm-fan.c
+++ b/drivers/hwmon/pwm-fan.c
@@ -308,7 +308,7 @@ static int pwm_fan_resume(struct device *dev)
 
 	pwm_get_args(ctx->pwm, &pargs);
 	duty = DIV_ROUND_UP(ctx->pwm_value * (pargs.period - 1), MAX_PWM);
-	ret = pwm_config(ctx->pwm, duty, pargs.period);
+	ret = pwm_config(ctx->pwm, duty, pargs.period, pargs.mode);
 	if (ret)
 		return ret;
 	return pwm_enable(ctx->pwm);
diff --git a/drivers/input/misc/max77693-haptic.c b/drivers/input/misc/max77693-haptic.c
index 46b0f48fbf49..5fe2ff2b408b 100644
--- a/drivers/input/misc/max77693-haptic.c
+++ b/drivers/input/misc/max77693-haptic.c
@@ -76,7 +76,7 @@ static int max77693_haptic_set_duty_cycle(struct max77693_haptic *haptic)
 
 	pwm_get_args(haptic->pwm_dev, &pargs);
 	delta = (pargs.period + haptic->pwm_duty) / 2;
-	error = pwm_config(haptic->pwm_dev, delta, pargs.period);
+	error = pwm_config(haptic->pwm_dev, delta, pargs.period, pargs.mode);
 	if (error) {
 		dev_err(haptic->dev, "failed to configure pwm: %d\n", error);
 		return error;
diff --git a/drivers/input/misc/max8997_haptic.c b/drivers/input/misc/max8997_haptic.c
index 99bc762881d5..16de524dc489 100644
--- a/drivers/input/misc/max8997_haptic.c
+++ b/drivers/input/misc/max8997_haptic.c
@@ -73,7 +73,11 @@ static int max8997_haptic_set_duty_cycle(struct max8997_haptic *chip)
 
 	if (chip->mode == MAX8997_EXTERNAL_MODE) {
 		unsigned int duty = chip->pwm_period * chip->level / 100;
-		ret = pwm_config(chip->pwm, duty, chip->pwm_period);
+		struct pwm_caps caps = { };
+
+		pwm_get_caps(chip->pwm->chip, chip->pwm, &caps);
+		ret = pwm_config(chip->pwm, duty, chip->pwm_period,
+				 BIT(ffs(caps.modes) - 1));
 	} else {
 		int i;
 		u8 duty_index = 0;
diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index 8d456dc6c5bf..8ba942e96b63 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -39,8 +39,11 @@ struct led_pwm_priv {
 static void __led_pwm_set(struct led_pwm_data *led_dat)
 {
 	int new_duty = led_dat->duty;
+	struct pwm_caps caps = { };
 
-	pwm_config(led_dat->pwm, new_duty, led_dat->period);
+	pwm_get_caps(led_dat->pwm->chip, led_dat->pwm, &caps);
+	pwm_config(led_dat->pwm, new_duty, led_dat->period,
+		   BIT(ffs(caps.modes) - 1));
 
 	if (new_duty == 0)
 		pwm_disable(led_dat->pwm);
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 49265f02e772..a971b02ea021 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -55,10 +55,13 @@ static int init_timing_params(struct ir_rx51 *ir_rx51)
 {
 	struct pwm_device *pwm = ir_rx51->pwm;
 	int duty, period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, ir_rx51->freq);
+	struct pwm_caps caps = { };
 
 	duty = DIV_ROUND_CLOSEST(ir_rx51->duty_cycle * period, 100);
 
-	pwm_config(pwm, duty, period);
+	pwm_get_caps(pwm->chip, pwm, &caps);
+
+	pwm_config(pwm, duty, period, BIT(ffs(caps.modes) - 1));
 
 	return 0;
 }
diff --git a/drivers/media/rc/pwm-ir-tx.c b/drivers/media/rc/pwm-ir-tx.c
index 27d0f5837a76..c630e1b450a3 100644
--- a/drivers/media/rc/pwm-ir-tx.c
+++ b/drivers/media/rc/pwm-ir-tx.c
@@ -61,6 +61,7 @@ static int pwm_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 {
 	struct pwm_ir *pwm_ir = dev->priv;
 	struct pwm_device *pwm = pwm_ir->pwm;
+	struct pwm_caps caps = { };
 	int i, duty, period;
 	ktime_t edge;
 	long delta;
@@ -68,7 +69,9 @@ static int pwm_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
 	period = DIV_ROUND_CLOSEST(NSEC_PER_SEC, pwm_ir->carrier);
 	duty = DIV_ROUND_CLOSEST(pwm_ir->duty_cycle * period, 100);
 
-	pwm_config(pwm, duty, period);
+	pwm_get_caps(pwm->chip, pwm, &caps);
+
+	pwm_config(pwm, duty, period, BIT(ffs(caps.modes) - 1));
 
 	edge = ktime_get();
 
diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index 2030a6b77a09..696fa25dafd2 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -165,8 +165,10 @@ static void lm3630a_pwm_ctrl(struct lm3630a_chip *pchip, int br, int br_max)
 {
 	unsigned int period = pchip->pdata->pwm_period;
 	unsigned int duty = br * period / br_max;
+	struct pwm_caps caps = { };
 
-	pwm_config(pchip->pwmd, duty, period);
+	pwm_get_caps(pchip->pwmd->chip, pchip->pwmd, &caps);
+	pwm_config(pchip->pwmd, duty, period, BIT(ffs(caps.modes) - 1));
 	if (duty)
 		pwm_enable(pchip->pwmd);
 	else
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 939f057836e1..3d274c604862 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -240,6 +240,7 @@ static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
 	unsigned int period = lp->pdata->period_ns;
 	unsigned int duty = br * period / max_br;
 	struct pwm_device *pwm;
+	struct pwm_caps caps = { };
 
 	/* request pwm device with the consumer name */
 	if (!lp->pwm) {
@@ -256,7 +257,8 @@ static void lp855x_pwm_ctrl(struct lp855x *lp, int br, int max_br)
 		pwm_apply_args(pwm);
 	}
 
-	pwm_config(lp->pwm, duty, period);
+	pwm_get_caps(lp->pwm->chip, lp->pwm, &caps);
+	pwm_config(lp->pwm, duty, period, BIT(ffs(caps.modes) - 1));
 	if (duty)
 		pwm_enable(lp->pwm);
 	else
diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
index cf869ec90cce..06de3163650d 100644
--- a/drivers/video/backlight/lp8788_bl.c
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -128,6 +128,7 @@ static void lp8788_pwm_ctrl(struct lp8788_bl *bl, int br, int max_br)
 	unsigned int duty;
 	struct device *dev;
 	struct pwm_device *pwm;
+	struct pwm_caps caps = { };
 
 	if (!bl->pdata)
 		return;
@@ -153,7 +154,9 @@ static void lp8788_pwm_ctrl(struct lp8788_bl *bl, int br, int max_br)
 		pwm_apply_args(pwm);
 	}
 
-	pwm_config(bl->pwm, duty, period);
+	pwm_get_caps(bl->pwm->chip, bl->pwm, &caps);
+
+	pwm_config(bl->pwm, duty, period, BIT(ffs(caps.modes) - 1));
 	if (duty)
 		pwm_enable(bl->pwm);
 	else
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 1c2289ddd555..706a9ab053a7 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -63,10 +63,14 @@ static void pwm_backlight_power_on(struct pwm_bl_data *pb, int brightness)
 
 static void pwm_backlight_power_off(struct pwm_bl_data *pb)
 {
+	struct pwm_caps caps = { };
+
 	if (!pb->enabled)
 		return;
 
-	pwm_config(pb->pwm, 0, pb->period);
+	pwm_get_caps(pb->pwm->chip, pb->pwm, &caps);
+
+	pwm_config(pb->pwm, 0, pb->period, BIT(ffs(caps.modes) - 1));
 	pwm_disable(pb->pwm);
 
 	if (pb->enable_gpio)
@@ -96,6 +100,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 {
 	struct pwm_bl_data *pb = bl_get_data(bl);
 	int brightness = bl->props.brightness;
+	struct pwm_caps caps = { };
 	int duty_cycle;
 
 	if (bl->props.power != FB_BLANK_UNBLANK ||
@@ -108,7 +113,9 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
 
 	if (brightness > 0) {
 		duty_cycle = compute_duty_cycle(pb, brightness);
-		pwm_config(pb->pwm, duty_cycle, pb->period);
+		pwm_get_caps(pb->pwm->chip, pb->pwm, &caps);
+		pwm_config(pb->pwm, duty_cycle, pb->period,
+			   BIT(ffs(caps.modes) - 1));
 		pwm_backlight_power_on(pb, brightness);
 	} else
 		pwm_backlight_power_off(pb);
diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd1307fb.c
index f599520374dd..4b57dcb5799a 100644
--- a/drivers/video/fbdev/ssd1307fb.c
+++ b/drivers/video/fbdev/ssd1307fb.c
@@ -308,7 +308,8 @@ static int ssd1307fb_init(struct ssd1307fb_par *par)
 
 		par->pwm_period = pargs.period;
 		/* Enable the PWM */
-		pwm_config(par->pwm, par->pwm_period / 2, par->pwm_period);
+		pwm_config(par->pwm, par->pwm_period / 2, par->pwm_period,
+			   pargs.mode);
 		pwm_enable(par->pwm);
 
 		dev_dbg(&par->client->dev, "Using PWM%d with a %dns period.\n",
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index e62349f48129..0ba416ab2772 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -357,11 +357,12 @@ int pwm_adjust_config(struct pwm_device *pwm);
  * @pwm: PWM device
  * @duty_ns: "on" time (in nanoseconds)
  * @period_ns: duration (in nanoseconds) of one cycle
+ * @mode: PWM mode
  *
  * Returns: 0 on success or a negative error code on failure.
  */
 static inline int pwm_config(struct pwm_device *pwm, int duty_ns,
-			     int period_ns)
+			     int period_ns, unsigned long mode)
 {
 	struct pwm_state state;
 
@@ -377,6 +378,7 @@ static inline int pwm_config(struct pwm_device *pwm, int duty_ns,
 
 	state.duty_cycle = duty_ns;
 	state.period = period_ns;
+	state.mode = mode;
 	return pwm_apply_state(pwm, &state);
 }
 
@@ -537,7 +539,7 @@ static inline int pwm_adjust_config(struct pwm_device *pwm)
 }
 
 static inline int pwm_config(struct pwm_device *pwm, int duty_ns,
-			     int period_ns)
+			     int period_ns, unsigned long mode)
 {
 	return -EINVAL;
 }
-- 
2.7.4

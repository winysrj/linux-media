Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:57681 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932121AbeBVMCr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:02:47 -0500
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
Subject: [PATCH v3 01/10] pwm: extend PWM framework with PWM modes
Date: Thu, 22 Feb 2018 14:01:12 +0200
Message-ID: <1519300881-8136-2-git-send-email-claudiu.beznea@microchip.com>
In-Reply-To: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic PWM modes: normal and complementary. These modes should
differentiate the single output PWM channels from two outputs PWM
channels. These modes could be set as follow:
1. PWM channels with one output per channel:
- normal mode
2. PWM channels with two outputs per channel:
- normal mode
- complementary mode
Since users could use a PWM channel with two output as one output PWM
channel, the PWM normal mode is allowed to be set for PWM channels with
two outputs; in fact PWM normal mode should be supported by all PWMs.

The PWM capabilities were implemented per PWM channel. Every PWM controller
will register a function to get PWM capabilities. If this is not explicitly
set by the driver a default function will be used to retrieve the the PWM
capabilities (in this case the PWM capabilities will contain only PWM
normal mode). This function is set in pwmchip_add_with_polarity() as a
member of "struct pwm_chip". To retrieve capabilities the pwm_get_caps()
function could be used.

Every PWM channel will have associated a mode in the PWM state. Proper
helper functions were added to get/set PWM mode. The mode could also be set
from DT via flag cells. The valid DT modes could be located in
include/dt-bindings/pwm/pwm.h. Only modes supported by PWM channel could be
set. If nothing is specified for a PWM channel, via DT, the first available
mode will be used (normally, this will be PWM normal mode).

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/pwm/core.c  | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/pwm/sysfs.c | 56 ++++++++++++++++++++++++++++++
 include/linux/pwm.h | 87 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 237 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 1581f6ab1b1f..16a409d452c0 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -136,6 +136,8 @@ struct pwm_device *
 of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
+	struct pwm_caps caps;
+	int modebit;
 
 	/* check, whether the driver supports a third cell for flags */
 	if (pc->of_pwm_n_cells < 3)
@@ -152,11 +154,23 @@ of_pwm_xlate_with_flags(struct pwm_chip *pc, const struct of_phandle_args *args)
 	if (IS_ERR(pwm))
 		return pwm;
 
+	pwm_get_caps(pc, pwm, &caps);
+
 	pwm->args.period = args->args[1];
 	pwm->args.polarity = PWM_POLARITY_NORMAL;
+	pwm->args.mode = BIT(ffs(caps.modes) - 1);
+
+	if (args->args_count > 2) {
+		if (args->args[2] & PWM_POLARITY_INVERTED)
+			pwm->args.polarity = PWM_POLARITY_INVERSED;
 
-	if (args->args_count > 2 && args->args[2] & PWM_POLARITY_INVERTED)
-		pwm->args.polarity = PWM_POLARITY_INVERSED;
+		for (modebit = PWM_MODE_COMPLEMENTARY_BIT;
+		     modebit < PWM_MODE_CNT; modebit++)
+			if (args->args[2] & BIT(modebit)) {
+				pwm->args.mode = BIT(modebit);
+				break;
+			}
+	}
 
 	return pwm;
 }
@@ -166,6 +180,7 @@ static struct pwm_device *
 of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 {
 	struct pwm_device *pwm;
+	struct pwm_caps caps;
 
 	/* sanity check driver support */
 	if (pc->of_pwm_n_cells < 2)
@@ -182,7 +197,9 @@ of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args *args)
 	if (IS_ERR(pwm))
 		return pwm;
 
+	pwm_get_caps(pc, pwm, &caps);
 	pwm->args.period = args->args[1];
+	pwm->args.mode = BIT(ffs(caps.modes) - 1);
 
 	return pwm;
 }
@@ -250,6 +267,39 @@ static bool pwm_ops_check(const struct pwm_ops *ops)
 }
 
 /**
+ * pwm_get_caps() - get PWM capabilities
+ * @chip: PWM chip
+ * @pwm: PWM device to get the capabilities for
+ * @caps: returned capabilities
+ *
+ * Retrievers capabilities for PWM device.
+ */
+void pwm_get_caps(struct pwm_chip *chip, struct pwm_device *pwm,
+		  struct pwm_caps *caps)
+{
+	if (!chip || !pwm || !caps)
+		return;
+
+	if (chip->ops && chip->ops->get_caps)
+		pwm->chip->ops->get_caps(chip, pwm, caps);
+	else if (chip->get_default_caps)
+		chip->get_default_caps(caps);
+}
+EXPORT_SYMBOL_GPL(pwm_get_caps);
+
+static void pwmchip_get_default_caps(struct pwm_caps *caps)
+{
+	static const struct pwm_caps default_caps = {
+		.modes = PWM_MODE(NORMAL),
+	};
+
+	if (!caps)
+		return;
+
+	*caps = default_caps;
+}
+
+/**
  * pwmchip_add_with_polarity() - register a new PWM chip
  * @chip: the PWM chip to add
  * @polarity: initial polarity of PWM channels
@@ -264,7 +314,8 @@ int pwmchip_add_with_polarity(struct pwm_chip *chip,
 			      enum pwm_polarity polarity)
 {
 	struct pwm_device *pwm;
-	unsigned int i;
+	struct pwm_caps caps;
+	unsigned int i, j;
 	int ret;
 
 	if (!chip || !chip->dev || !chip->ops || !chip->npwm)
@@ -275,6 +326,8 @@ int pwmchip_add_with_polarity(struct pwm_chip *chip,
 
 	mutex_lock(&pwm_lock);
 
+	chip->get_default_caps = pwmchip_get_default_caps;
+
 	ret = alloc_pwms(chip->base, chip->npwm);
 	if (ret < 0)
 		goto out;
@@ -295,6 +348,16 @@ int pwmchip_add_with_polarity(struct pwm_chip *chip,
 		pwm->hwpwm = i;
 		pwm->state.polarity = polarity;
 
+		pwm_get_caps(chip, pwm, &caps);
+
+		/* Check if modes are supported. */
+		if (!pwm_caps_valid(caps)) {
+			ret = -EINVAL;
+			goto free;
+		}
+
+		pwm->state.mode = BIT(ffs(caps.modes) - 1);
+
 		if (chip->ops->get_state)
 			chip->ops->get_state(chip, pwm, &pwm->state);
 
@@ -316,6 +379,17 @@ int pwmchip_add_with_polarity(struct pwm_chip *chip,
 out:
 	mutex_unlock(&pwm_lock);
 	return ret;
+
+free:
+	for (j = 0; j < i; j++) {
+		pwm = &chip->pwms[j];
+		radix_tree_delete(&pwm_tree, pwm->pwm);
+	}
+	kfree(chip->pwms);
+	chip->pwms = NULL;
+
+	mutex_unlock(&pwm_lock);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pwmchip_add_with_polarity);
 
@@ -466,10 +540,17 @@ EXPORT_SYMBOL_GPL(pwm_free);
  */
 int pwm_apply_state(struct pwm_device *pwm, struct pwm_state *state)
 {
+	struct pwm_caps caps;
 	int err;
 
 	if (!pwm || !state || !state->period ||
-	    state->duty_cycle > state->period)
+	    state->duty_cycle > state->period ||
+	    !pwm_mode_valid(state->mode))
+		return -EINVAL;
+
+	/* Check if mode is supported by PWM. */
+	pwm_get_caps(pwm->chip, pwm, &caps);
+	if (!(caps.modes & state->mode))
 		return -EINVAL;
 
 	if (!memcmp(state, &pwm->state, sizeof(*state)))
@@ -530,6 +611,9 @@ int pwm_apply_state(struct pwm_device *pwm, struct pwm_state *state)
 
 			pwm->state.enabled = state->enabled;
 		}
+
+		/* No mode support for non-atomic PWM. */
+		pwm->state.mode = state->mode;
 	}
 
 	return 0;
@@ -579,6 +663,8 @@ int pwm_adjust_config(struct pwm_device *pwm)
 	pwm_get_args(pwm, &pargs);
 	pwm_get_state(pwm, &state);
 
+	state.mode = pargs.mode;
+
 	/*
 	 * If the current period is zero it means that either the PWM driver
 	 * does not support initial state retrieval or the PWM has not yet
@@ -767,6 +853,7 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 	unsigned int best = 0;
 	struct pwm_lookup *p, *chosen = NULL;
 	unsigned int match;
+	struct pwm_caps caps;
 	int err;
 
 	/* look up via DT first */
@@ -848,8 +935,10 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 	if (IS_ERR(pwm))
 		return pwm;
 
+	pwm_get_caps(chip, pwm, &caps);
 	pwm->args.period = chosen->period;
 	pwm->args.polarity = chosen->polarity;
+	pwm->args.mode = BIT(ffs(caps.modes) - 1);
 
 	return pwm;
 }
@@ -999,6 +1088,7 @@ static void pwm_dbg_show(struct pwm_chip *chip, struct seq_file *s)
 		seq_printf(s, " duty: %u ns", state.duty_cycle);
 		seq_printf(s, " polarity: %s",
 			   state.polarity ? "inverse" : "normal");
+		seq_printf(s, " mode: %s", pwm_mode_desc(state.mode));
 
 		seq_puts(s, "\n");
 	}
diff --git a/drivers/pwm/sysfs.c b/drivers/pwm/sysfs.c
index 83f2b0b15712..d9eb0eb63d23 100644
--- a/drivers/pwm/sysfs.c
+++ b/drivers/pwm/sysfs.c
@@ -223,11 +223,66 @@ static ssize_t capture_show(struct device *child,
 	return sprintf(buf, "%u %u\n", result.period, result.duty_cycle);
 }
 
+static ssize_t mode_show(struct device *child,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct pwm_device *pwm = child_to_pwm_device(child);
+	struct pwm_state state;
+	struct pwm_caps caps;
+	int modebit, len = 0;
+
+	pwm_get_state(pwm, &state);
+	pwm_get_caps(pwm->chip, pwm, &caps);
+
+	for (modebit = PWM_MODE_NORMAL_BIT; modebit < PWM_MODE_CNT; modebit++)
+		if (caps.modes & BIT(modebit)) {
+			if (state.mode == BIT(modebit))
+				len += scnprintf(buf + len,
+						 PAGE_SIZE - len, "[%s] ",
+						 pwm_mode_desc(BIT(modebit)));
+			else
+				len += scnprintf(buf + len,
+						 PAGE_SIZE - len, "%s ",
+						 pwm_mode_desc(BIT(modebit)));
+		}
+
+	len += scnprintf(buf + len, PAGE_SIZE - len, "\n");
+
+	return len;
+}
+
+static ssize_t mode_store(struct device *child,
+			  struct device_attribute *attr,
+			  const char *buf, size_t size)
+{
+	struct pwm_export *export = child_to_pwm_export(child);
+	struct pwm_device *pwm = export->pwm;
+	struct pwm_state state;
+	int modebit, ret;
+
+	for (modebit = PWM_MODE_NORMAL_BIT; modebit < PWM_MODE_CNT; modebit++)
+		if (sysfs_streq(buf, pwm_mode_desc(BIT(modebit))))
+			break;
+
+	if (modebit == PWM_MODE_CNT)
+		return -EINVAL;
+
+	mutex_lock(&export->lock);
+	pwm_get_state(pwm, &state);
+	state.mode = BIT(modebit);
+	ret = pwm_apply_state(pwm, &state);
+	mutex_unlock(&export->lock);
+
+	return ret ? : size;
+}
+
 static DEVICE_ATTR_RW(period);
 static DEVICE_ATTR_RW(duty_cycle);
 static DEVICE_ATTR_RW(enable);
 static DEVICE_ATTR_RW(polarity);
 static DEVICE_ATTR_RO(capture);
+static DEVICE_ATTR_RW(mode);
 
 static struct attribute *pwm_attrs[] = {
 	&dev_attr_period.attr,
@@ -235,6 +290,7 @@ static struct attribute *pwm_attrs[] = {
 	&dev_attr_enable.attr,
 	&dev_attr_polarity.attr,
 	&dev_attr_capture.attr,
+	&dev_attr_mode.attr,
 	NULL
 };
 ATTRIBUTE_GROUPS(pwm);
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 56518adc31dd..e62349f48129 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -26,9 +26,32 @@ enum pwm_polarity {
 };
 
 /**
+ * PWM modes
+ * @PWM_MODE_NORMAL_BIT: PWM has one output
+ * @PWM_MODE_COMPLEMENTARY_BIT: PWM has 2 outputs with opposite polarities
+ * @PWM_MODE_CNT: PWM modes count
+ */
+enum {
+	PWM_MODE_NORMAL_BIT,
+	PWM_MODE_COMPLEMENTARY_BIT,
+	PWM_MODE_CNT,
+};
+
+#define PWM_MODE(name)		BIT(PWM_MODE_##name##_BIT)
+
+/**
+ * struct pwm_caps - PWM capabilities
+ * @modes: PWM modes
+ */
+struct pwm_caps {
+	unsigned long modes;
+};
+
+/**
  * struct pwm_args - board-dependent PWM arguments
  * @period: reference period
  * @polarity: reference polarity
+ * @mode: reference mode
  *
  * This structure describes board-dependent arguments attached to a PWM
  * device. These arguments are usually retrieved from the PWM lookup table or
@@ -41,6 +64,7 @@ enum pwm_polarity {
 struct pwm_args {
 	unsigned int period;
 	enum pwm_polarity polarity;
+	unsigned long mode;
 };
 
 enum {
@@ -53,12 +77,14 @@ enum {
  * @period: PWM period (in nanoseconds)
  * @duty_cycle: PWM duty cycle (in nanoseconds)
  * @polarity: PWM polarity
+ * @mode: PWM mode
  * @enabled: PWM enabled status
  */
 struct pwm_state {
 	unsigned int period;
 	unsigned int duty_cycle;
 	enum pwm_polarity polarity;
+	unsigned long mode;
 	bool enabled;
 };
 
@@ -181,6 +207,7 @@ static inline void pwm_init_state(const struct pwm_device *pwm,
 	state->period = args.period;
 	state->polarity = args.polarity;
 	state->duty_cycle = 0;
+	state->mode = args.mode;
 }
 
 /**
@@ -254,6 +281,7 @@ pwm_set_relative_duty_cycle(struct pwm_state *state, unsigned int duty_cycle,
  * @get_state: get the current PWM state. This function is only
  *	       called once per PWM device when the PWM chip is
  *	       registered.
+ * @get_caps: get PWM capabilities.
  * @dbg_show: optional routine to show contents in debugfs
  * @owner: helps prevent removal of modules exporting active PWMs
  */
@@ -272,6 +300,8 @@ struct pwm_ops {
 		     struct pwm_state *state);
 	void (*get_state)(struct pwm_chip *chip, struct pwm_device *pwm,
 			  struct pwm_state *state);
+	void (*get_caps)(struct pwm_chip *chip, struct pwm_device *pwm,
+			 struct pwm_caps *caps);
 #ifdef CONFIG_DEBUG_FS
 	void (*dbg_show)(struct pwm_chip *chip, struct seq_file *s);
 #endif
@@ -287,6 +317,7 @@ struct pwm_ops {
  * @npwm: number of PWMs controlled by this chip
  * @pwms: array of PWM devices allocated by the framework
  * @of_xlate: request a PWM device given a device tree PWM specifier
+ * @get_default_caps: get default PWM capabilities
  * @of_pwm_n_cells: number of cells expected in the device tree PWM specifier
  */
 struct pwm_chip {
@@ -300,6 +331,7 @@ struct pwm_chip {
 
 	struct pwm_device * (*of_xlate)(struct pwm_chip *pc,
 					const struct of_phandle_args *args);
+	void (*get_default_caps)(struct pwm_caps *caps);
 	unsigned int of_pwm_n_cells;
 };
 
@@ -424,6 +456,37 @@ static inline void pwm_disable(struct pwm_device *pwm)
 	pwm_apply_state(pwm, &state);
 }
 
+static inline bool pwm_mode_valid(unsigned long mode)
+{
+	return (mode &&
+		hweight_long(mode) == 1 &&
+		ffs(mode) - 1 < PWM_MODE_CNT);
+}
+
+static inline bool pwm_caps_valid(struct pwm_caps caps)
+{
+	unsigned int last;
+
+	if (!caps.modes)
+		return false;
+
+	last = fls(caps.modes) - 1;
+	if (last >= PWM_MODE_CNT)
+		return false;
+
+	return true;
+}
+
+static inline const char * const pwm_mode_desc(unsigned long mode)
+{
+	static const char * const modes[] = { "normal", "complementary"	};
+
+	if (!pwm_mode_valid(mode))
+		return "invalid";
+
+	return modes[ffs(mode) - 1];
+}
+
 /* PWM provider APIs */
 int pwm_capture(struct pwm_device *pwm, struct pwm_capture *result,
 		unsigned long timeout);
@@ -438,6 +501,9 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
 					 unsigned int index,
 					 const char *label);
 
+void pwm_get_caps(struct pwm_chip *chip, struct pwm_device *pwm,
+		  struct pwm_caps *caps);
+
 struct pwm_device *of_pwm_xlate_with_flags(struct pwm_chip *pc,
 		const struct of_phandle_args *args);
 
@@ -498,6 +564,26 @@ static inline void pwm_disable(struct pwm_device *pwm)
 {
 }
 
+static inline bool pwm_mode_valid(unsigned long mode)
+{
+	return false;
+}
+
+static inline bool pwm_caps_valid(struct pwm_caps caps)
+{
+	return false;
+}
+
+static inline const char * const pwm_mode_desc(unsigned long mode)
+{
+	return NULL;
+}
+
+static inline void pwm_get_caps(struct pwm_chip *chip, struct pwm_device *pwm,
+				struct pwm_caps *caps)
+{
+}
+
 static inline int pwm_set_chip_data(struct pwm_device *pwm, void *data)
 {
 	return -EINVAL;
@@ -592,6 +678,7 @@ static inline void pwm_apply_args(struct pwm_device *pwm)
 	state.enabled = false;
 	state.polarity = pwm->args.polarity;
 	state.period = pwm->args.period;
+	state.mode = pwm->args.mode;
 
 	pwm_apply_state(pwm, &state);
 }
-- 
2.7.4

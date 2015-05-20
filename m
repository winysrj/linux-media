Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:17469 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbbETOKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 10:10:40 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v8 1/8] media: Add registration helpers for V4L2 flash
 sub-devices
Date: Wed, 20 May 2015 16:10:08 +0200
Message-id: <1432131015-22397-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds helper functions for registering/unregistering
LED Flash class devices as V4L2 sub-devices. The functions should
be called from the LED subsystem device driver. In case the
support for V4L2 Flash sub-devices is disabled in the kernel
config the functions' empty versions will be used.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/Kconfig                |   11 +
 drivers/media/v4l2-core/Makefile               |    2 +
 drivers/media/v4l2-core/v4l2-flash-led-class.c |  655 ++++++++++++++++++++++++
 include/media/v4l2-flash-led-class.h           |  139 +++++
 4 files changed, 807 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash-led-class.c
 create mode 100644 include/media/v4l2-flash-led-class.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index f7a01a7..b4b0229 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -44,6 +44,17 @@ config V4L2_MEM2MEM_DEV
         tristate
         depends on VIDEOBUF2_CORE
 
+# Used by LED subsystem flash drivers
+config V4L2_FLASH_LED_CLASS
+	tristate "V4L2 flash API for LED flash class devices"
+	depends on VIDEO_V4L2_SUBDEV_API
+	depends on LEDS_CLASS_FLASH
+	---help---
+	  Say Y here to enable V4L2 flash API support for LED flash
+	  class drivers.
+
+	  When in doubt, say N.
+
 # Used by drivers that need Videobuf modules
 config VIDEOBUF_GEN
 	tristate
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 63d29f2..dc3de00 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
+obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash-led-class.o
+
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
new file mode 100644
index 0000000..17d7498
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -0,0 +1,655 @@
+/*
+ * V4L2 flash LED sub-device registration helpers.
+ *
+ *	Copyright (C) 2015 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/led-class-flash.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <media/v4l2-flash-led-class.h>
+
+#define has_flash_op(v4l2_flash, op)				\
+	(v4l2_flash && v4l2_flash->ops->op)
+
+#define call_flash_op(v4l2_flash, op, arg)			\
+		(has_flash_op(v4l2_flash, op) ?			\
+			v4l2_flash->ops->op(v4l2_flash, arg) :	\
+			-EINVAL)
+
+enum ctrl_init_data_id {
+	LED_MODE,
+	TORCH_INTENSITY,
+	FLASH_INTENSITY,
+	INDICATOR_INTENSITY,
+	FLASH_TIMEOUT,
+	STROBE_SOURCE,
+	/*
+	 * Only above values are applicable to
+	 * the 'ctrls' array in the struct v4l2_flash.
+	 */
+	FLASH_STROBE,
+	STROBE_STOP,
+	STROBE_STATUS,
+	FLASH_FAULT,
+	NUM_FLASH_CTRLS,
+};
+
+static enum led_brightness __intensity_to_led_brightness(
+					struct v4l2_ctrl *ctrl, s32 intensity)
+{
+	intensity -= ctrl->minimum;
+	intensity /= (u32) ctrl->step;
+
+	/*
+	 * Indicator LEDs, unlike torch LEDs, are turned on/off basing on
+	 * the state of V4L2_CID_FLASH_INDICATOR_INTENSITY control only.
+	 * Therefore it must be possible to set it to 0 level which in
+	 * the LED subsystem reflects LED_OFF state.
+	 */
+	if (ctrl->minimum)
+		++intensity;
+
+	return intensity;
+}
+
+static s32 __led_brightness_to_intensity(struct v4l2_ctrl *ctrl,
+					 enum led_brightness brightness)
+{
+	/*
+	 * Indicator LEDs, unlike torch LEDs, are turned on/off basing on
+	 * the state of V4L2_CID_FLASH_INDICATOR_INTENSITY control only.
+	 * Do not decrement brightness read from the LED subsystem for
+	 * indicator LED as it may equal 0. For torch LEDs this function
+	 * is called only when V4L2_FLASH_LED_MODE_TORCH is set and the
+	 * brightness read is guaranteed to be greater than 0. In the mode
+	 * V4L2_FLASH_LED_MODE_NONE the cached torch intensity value is used.
+	 */
+	if (ctrl->id != V4L2_CID_FLASH_INDICATOR_INTENSITY)
+		--brightness;
+
+	return (brightness * ctrl->step) + ctrl->minimum;
+}
+
+static void v4l2_flash_set_led_brightness(struct v4l2_flash *v4l2_flash,
+					struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	enum led_brightness brightness;
+
+	if (has_flash_op(v4l2_flash, intensity_to_led_brightness))
+		brightness = call_flash_op(v4l2_flash,
+					intensity_to_led_brightness,
+					ctrl->val);
+	else
+		brightness = __intensity_to_led_brightness(ctrl, ctrl->val);
+	/*
+	 * In case a LED Flash class driver provides ops for custom
+	 * brightness <-> intensity conversion, it also must have defined
+	 * related v4l2 control step == 1. In such a case a backward conversion
+	 * from led brightness to v4l2 intensity is required to find out the
+	 * the aligned intensity value.
+	 */
+	if (has_flash_op(v4l2_flash, led_brightness_to_intensity))
+		ctrl->val = call_flash_op(v4l2_flash,
+					led_brightness_to_intensity,
+					brightness);
+
+	if (ctrl == ctrls[TORCH_INTENSITY] &&
+	    ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_TORCH)
+		return;
+
+	led_set_brightness(&v4l2_flash->fled_cdev->led_cdev, brightness);
+}
+
+static int v4l2_flash_update_led_brightness(struct v4l2_flash *v4l2_flash,
+					struct v4l2_ctrl *ctrl)
+{
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	int ret;
+
+	/*
+	 * Update torch brightness only if in TORCH_MODE. In other modes torch
+	 * led is turned off, which would spuriously inform the user space that
+	 * V4L2_CID_FLASH_TORCH_INTENSITY control value has changed to 0.
+	 */
+	if (ctrl == ctrls[TORCH_INTENSITY] &&
+	    ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_TORCH)
+		return 0;
+
+	ret = led_update_brightness(led_cdev);
+	if (ret < 0)
+		return ret;
+
+	if (has_flash_op(v4l2_flash, led_brightness_to_intensity))
+		ctrl->val = call_flash_op(v4l2_flash,
+						led_brightness_to_intensity,
+						led_cdev->brightness);
+	else
+		ctrl->val = __led_brightness_to_intensity(ctrl,
+						led_cdev->brightness);
+
+	return 0;
+}
+
+static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	bool is_strobing;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		return v4l2_flash_update_led_brightness(v4l2_flash, c);
+	case V4L2_CID_FLASH_INTENSITY:
+		ret = led_update_flash_brightness(fled_cdev);
+		if (ret < 0)
+			return ret;
+		/*
+		 * No conversion is needed as LED Flash class also uses
+		 * microamperes for flash intensity units.
+		 */
+		c->val = fled_cdev->brightness.val;
+		return 0;
+	case V4L2_CID_FLASH_STROBE_STATUS:
+		ret = led_get_flash_strobe(fled_cdev, &is_strobing);
+		if (ret < 0)
+			return ret;
+		c->val = is_strobing;
+		return 0;
+	case V4L2_CID_FLASH_FAULT:
+		/* LED faults map directly to V4L2 flash faults */
+		return led_get_flash_fault(fled_cdev, &c->val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static bool __software_strobe_mode_inactive(struct v4l2_ctrl **ctrls)
+{
+	return ((ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH) ||
+		(ctrls[STROBE_SOURCE] && (ctrls[STROBE_SOURCE]->val !=
+				V4L2_FLASH_STROBE_SOURCE_SOFTWARE)));
+}
+
+static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	bool external_strobe;
+	int ret = 0;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		switch (c->val) {
+		case V4L2_FLASH_LED_MODE_NONE:
+			led_set_brightness(led_cdev, LED_OFF);
+			return led_set_flash_strobe(fled_cdev, false);
+		case V4L2_FLASH_LED_MODE_FLASH:
+			/* Turn the torch LED off */
+			led_set_brightness(led_cdev, LED_OFF);
+			if (ctrls[STROBE_SOURCE]) {
+				external_strobe = (ctrls[STROBE_SOURCE]->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+
+				ret = call_flash_op(v4l2_flash,
+						external_strobe_set,
+						external_strobe);
+			}
+			return ret;
+		case V4L2_FLASH_LED_MODE_TORCH:
+			if (ctrls[STROBE_SOURCE]) {
+				ret = call_flash_op(v4l2_flash,
+						external_strobe_set,
+						false);
+				if (ret < 0)
+					return ret;
+			}
+			/* Stop flash strobing */
+			ret = led_set_flash_strobe(fled_cdev, false);
+			if (ret < 0)
+				return ret;
+
+			v4l2_flash_set_led_brightness(v4l2_flash,
+							ctrls[TORCH_INTENSITY]);
+			return 0;
+		}
+		break;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		external_strobe = (c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+		/*
+		 * For some hardware arrangements setting strobe source may
+		 * affect torch mode. Therefore, if not in the flash mode,
+		 * cache only this setting. It will be applied upon switching
+		 * to flash mode.
+		 */
+		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH)
+			return 0;
+
+		return call_flash_op(v4l2_flash, external_strobe_set,
+					external_strobe);
+	case V4L2_CID_FLASH_STROBE:
+		if (__software_strobe_mode_inactive(ctrls))
+			return -EBUSY;
+		return led_set_flash_strobe(fled_cdev, true);
+	case V4L2_CID_FLASH_STROBE_STOP:
+		if (__software_strobe_mode_inactive(ctrls))
+			return -EBUSY;
+		return led_set_flash_strobe(fled_cdev, false);
+	case V4L2_CID_FLASH_TIMEOUT:
+		/*
+		 * No conversion is needed as LED Flash class also uses
+		 * microseconds for flash timeout units.
+		 */
+		return led_set_flash_timeout(fled_cdev, c->val);
+	case V4L2_CID_FLASH_INTENSITY:
+		/*
+		 * No conversion is needed as LED Flash class also uses
+		 * microamperes for flash intensity units.
+		 */
+		return led_set_flash_brightness(fled_cdev, c->val);
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		v4l2_flash_set_led_brightness(v4l2_flash, c);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops v4l2_flash_ctrl_ops = {
+	.g_volatile_ctrl = v4l2_flash_g_volatile_ctrl,
+	.s_ctrl = v4l2_flash_s_ctrl,
+};
+
+static void __lfs_to_v4l2_ctrl_config(struct led_flash_setting *s,
+				struct v4l2_ctrl_config *c)
+{
+	c->min = s->min;
+	c->max = s->max;
+	c->step = s->step;
+	c->def = s->val;
+}
+
+static void __fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
+			  struct v4l2_flash_config *flash_cfg,
+			  struct v4l2_flash_ctrl_data *ctrl_init_data)
+{
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	const struct led_flash_ops *fled_cdev_ops = fled_cdev->ops;
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct v4l2_ctrl_config *ctrl_cfg;
+	u32 mask;
+
+	/* Init FLASH_FAULT ctrl data */
+	if (flash_cfg->flash_faults) {
+		ctrl_init_data[FLASH_FAULT].cid = V4L2_CID_FLASH_FAULT;
+		ctrl_cfg = &ctrl_init_data[FLASH_FAULT].config;
+		ctrl_cfg->id = V4L2_CID_FLASH_FAULT;
+		ctrl_cfg->max = flash_cfg->flash_faults;
+		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+				  V4L2_CTRL_FLAG_READ_ONLY;
+	}
+
+	/* Init INDICATOR_INTENSITY ctrl data */
+	if (flash_cfg->indicator_led) {
+		ctrl_init_data[INDICATOR_INTENSITY].cid =
+					V4L2_CID_FLASH_INDICATOR_INTENSITY;
+		ctrl_cfg = &ctrl_init_data[INDICATOR_INTENSITY].config;
+		__lfs_to_v4l2_ctrl_config(&flash_cfg->intensity, ctrl_cfg);
+		ctrl_cfg->id = V4L2_CID_FLASH_INDICATOR_INTENSITY;
+		ctrl_cfg->min = 0;
+		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+				  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
+
+		/* Indicator LED can have only faults and intensity controls. */
+		return;
+	}
+
+	/* Init FLASH_LED_MODE ctrl data */
+	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
+	       1 << V4L2_FLASH_LED_MODE_TORCH;
+	if (led_cdev->flags & LED_DEV_CAP_FLASH)
+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
+
+	ctrl_init_data[LED_MODE].cid = V4L2_CID_FLASH_LED_MODE;
+	ctrl_cfg = &ctrl_init_data[LED_MODE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_LED_MODE;
+	ctrl_cfg->max = V4L2_FLASH_LED_MODE_TORCH;
+	ctrl_cfg->menu_skip_mask = ~mask;
+	ctrl_cfg->def = V4L2_FLASH_LED_MODE_NONE;
+	ctrl_cfg->flags = 0;
+
+	/* Init TORCH_INTENSITY ctrl data */
+	ctrl_init_data[TORCH_INTENSITY].cid = V4L2_CID_FLASH_TORCH_INTENSITY;
+	ctrl_cfg = &ctrl_init_data[TORCH_INTENSITY].config;
+	__lfs_to_v4l2_ctrl_config(&flash_cfg->intensity, ctrl_cfg);
+	ctrl_cfg->id = V4L2_CID_FLASH_TORCH_INTENSITY;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
+
+	if (!(led_cdev->flags & LED_DEV_CAP_FLASH))
+		return;
+
+	/* Init FLASH_STROBE ctrl data */
+	ctrl_init_data[FLASH_STROBE].cid = V4L2_CID_FLASH_STROBE;
+	ctrl_cfg = &ctrl_init_data[FLASH_STROBE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE;
+
+	/* Init STROBE_STOP ctrl data */
+	ctrl_init_data[STROBE_STOP].cid = V4L2_CID_FLASH_STROBE_STOP;
+	ctrl_cfg = &ctrl_init_data[STROBE_STOP].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STOP;
+
+	/* Init FLASH_STROBE_SOURCE ctrl data */
+	if (flash_cfg->has_external_strobe) {
+		mask = (1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE) |
+		       (1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+		ctrl_init_data[STROBE_SOURCE].cid =
+					V4L2_CID_FLASH_STROBE_SOURCE;
+		ctrl_cfg = &ctrl_init_data[STROBE_SOURCE].config;
+		ctrl_cfg->id = V4L2_CID_FLASH_STROBE_SOURCE;
+		ctrl_cfg->max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+		ctrl_cfg->menu_skip_mask = ~mask;
+		ctrl_cfg->def = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+	}
+
+	/* Init STROBE_STATUS ctrl data */
+	if (fled_cdev_ops->strobe_get) {
+		ctrl_init_data[STROBE_STATUS].cid =
+					V4L2_CID_FLASH_STROBE_STATUS;
+		ctrl_cfg = &ctrl_init_data[STROBE_STATUS].config;
+		ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STATUS;
+		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+				  V4L2_CTRL_FLAG_READ_ONLY;
+	}
+
+	/* Init FLASH_TIMEOUT ctrl data */
+	if (fled_cdev_ops->timeout_set) {
+		ctrl_init_data[FLASH_TIMEOUT].cid = V4L2_CID_FLASH_TIMEOUT;
+		ctrl_cfg = &ctrl_init_data[FLASH_TIMEOUT].config;
+		__lfs_to_v4l2_ctrl_config(&fled_cdev->timeout, ctrl_cfg);
+		ctrl_cfg->id = V4L2_CID_FLASH_TIMEOUT;
+	}
+
+	/* Init FLASH_INTENSITY ctrl data */
+	if (fled_cdev_ops->flash_brightness_set) {
+		ctrl_init_data[FLASH_INTENSITY].cid = V4L2_CID_FLASH_INTENSITY;
+		ctrl_cfg = &ctrl_init_data[FLASH_INTENSITY].config;
+		__lfs_to_v4l2_ctrl_config(&fled_cdev->brightness, ctrl_cfg);
+		ctrl_cfg->id = V4L2_CID_FLASH_INTENSITY;
+		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+				  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
+	}
+}
+
+static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash,
+				struct v4l2_flash_config *flash_cfg)
+
+{
+	struct v4l2_flash_ctrl_data *ctrl_init_data;
+	struct v4l2_ctrl *ctrl;
+	struct v4l2_ctrl_config *ctrl_cfg;
+	int i, ret, num_ctrls = 0;
+
+	v4l2_flash->ctrls = devm_kzalloc(v4l2_flash->sd.dev,
+					sizeof(*v4l2_flash->ctrls) *
+					(STROBE_SOURCE + 1), GFP_KERNEL);
+	if (!v4l2_flash->ctrls)
+		return -ENOMEM;
+
+	/* allocate memory dynamically so as not to exceed stack frame size */
+	ctrl_init_data = kcalloc(NUM_FLASH_CTRLS, sizeof(*ctrl_init_data),
+					GFP_KERNEL);
+	if (!ctrl_init_data)
+		return -ENOMEM;
+
+	__fill_ctrl_init_data(v4l2_flash, flash_cfg, ctrl_init_data);
+
+	for (i = 0; i < NUM_FLASH_CTRLS; ++i)
+		if (ctrl_init_data[i].cid)
+			++num_ctrls;
+
+	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
+
+	for (i = 0; i < NUM_FLASH_CTRLS; ++i) {
+		ctrl_cfg = &ctrl_init_data[i].config;
+		if (!ctrl_init_data[i].cid)
+			continue;
+
+		if (ctrl_cfg->id == V4L2_CID_FLASH_LED_MODE ||
+		    ctrl_cfg->id == V4L2_CID_FLASH_STROBE_SOURCE)
+			ctrl = v4l2_ctrl_new_std_menu(&v4l2_flash->hdl,
+						&v4l2_flash_ctrl_ops,
+						ctrl_cfg->id,
+						ctrl_cfg->max,
+						ctrl_cfg->menu_skip_mask,
+						ctrl_cfg->def);
+		else
+			ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl,
+						&v4l2_flash_ctrl_ops,
+						ctrl_cfg->id,
+						ctrl_cfg->min,
+						ctrl_cfg->max,
+						ctrl_cfg->step,
+						ctrl_cfg->def);
+
+		if (ctrl)
+			ctrl->flags |= ctrl_cfg->flags;
+
+		if (i <= STROBE_SOURCE)
+			v4l2_flash->ctrls[i] = ctrl;
+	}
+
+	kfree(ctrl_init_data);
+
+	if (v4l2_flash->hdl.error) {
+		ret = v4l2_flash->hdl.error;
+		goto error_free_handler;
+	}
+
+	v4l2_ctrl_handler_setup(&v4l2_flash->hdl);
+
+	v4l2_flash->sd.ctrl_handler = &v4l2_flash->hdl;
+
+	return 0;
+
+error_free_handler:
+	v4l2_ctrl_handler_free(&v4l2_flash->hdl);
+	return ret;
+}
+
+static int __sync_device_with_v4l2_controls(struct v4l2_flash *v4l2_flash)
+{
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	int ret = 0;
+
+	if (ctrls[INDICATOR_INTENSITY]) {
+		v4l2_flash_set_led_brightness(v4l2_flash,
+						ctrls[INDICATOR_INTENSITY]);
+		return 0;
+	}
+
+	v4l2_flash_set_led_brightness(v4l2_flash, ctrls[TORCH_INTENSITY]);
+
+	if (ctrls[FLASH_TIMEOUT]) {
+		ret = led_set_flash_timeout(fled_cdev,
+					ctrls[FLASH_TIMEOUT]->val);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (ctrls[FLASH_INTENSITY]) {
+		ret = led_set_flash_brightness(fled_cdev,
+					ctrls[FLASH_INTENSITY]->val);
+		if (ret < 0)
+			return ret;
+	}
+
+	/*
+	 * For some hardware arrangements setting strobe source may affect
+	 * torch mode. Synchronize strobe source setting only if not in torch
+	 * mode. For torch mode case it will get synchronized upon switching
+	 * to flash mode.
+	 */
+	if (ctrls[STROBE_SOURCE] &&
+	    ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_TORCH)
+		ret = call_flash_op(v4l2_flash, external_strobe_set,
+					ctrls[STROBE_SOURCE]->val);
+
+	return ret;
+}
+
+/*
+ * V4L2 subdev internal operations
+ */
+
+static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	int ret = 0;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (!v4l2_fh_is_singular(&fh->vfh))
+		goto unlock;
+
+	led_sysfs_disable(led_cdev);
+	led_trigger_remove(led_cdev);
+
+	ret = __sync_device_with_v4l2_controls(v4l2_flash);
+
+unlock:
+	mutex_unlock(&led_cdev->led_access);
+	return ret;
+}
+
+static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
+	struct led_classdev_flash *fled_cdev = v4l2_flash->fled_cdev;
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	int ret = 0;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (v4l2_fh_is_singular(&fh->vfh)) {
+		if (v4l2_flash->ctrls[STROBE_SOURCE])
+			ret = v4l2_ctrl_s_ctrl(v4l2_flash->ctrls[STROBE_SOURCE],
+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
+		led_sysfs_enable(led_cdev);
+	}
+
+	mutex_unlock(&led_cdev->led_access);
+
+	return ret;
+}
+
+static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
+	.open = v4l2_flash_open,
+	.close = v4l2_flash_close,
+};
+
+static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
+	.queryctrl = v4l2_subdev_queryctrl,
+	.querymenu = v4l2_subdev_querymenu,
+};
+
+static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
+	.core = &v4l2_flash_core_ops,
+};
+
+struct v4l2_flash *v4l2_flash_init(
+	struct device *dev, struct device_node *of_node,
+	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
+	struct v4l2_flash_config *config)
+{
+	struct v4l2_flash *v4l2_flash;
+	struct led_classdev *led_cdev = &fled_cdev->led_cdev;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (!fled_cdev || !ops || !config)
+		return ERR_PTR(-EINVAL);
+
+	v4l2_flash = devm_kzalloc(led_cdev->dev, sizeof(*v4l2_flash),
+					GFP_KERNEL);
+	if (!v4l2_flash)
+		return ERR_PTR(-ENOMEM);
+
+	sd = &v4l2_flash->sd;
+	v4l2_flash->fled_cdev = fled_cdev;
+	v4l2_flash->ops = ops;
+	sd->dev = dev;
+	sd->of_node = of_node;
+	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
+	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	strlcpy(sd->name, config->dev_name, sizeof(sd->name));
+
+	ret = media_entity_init(&sd->entity, 0, NULL, 0);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
+	ret = v4l2_flash_init_controls(v4l2_flash, config);
+	if (ret < 0)
+		goto err_init_controls;
+
+	of_node_get(led_cdev->dev->of_node);
+
+	ret = v4l2_async_register_subdev(sd);
+	if (ret < 0)
+		goto err_async_register_sd;
+
+	return v4l2_flash;
+
+err_async_register_sd:
+	of_node_put(led_cdev->dev->of_node);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+err_init_controls:
+	media_entity_cleanup(&sd->entity);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_init);
+
+void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
+{
+	struct v4l2_subdev *sd;
+	struct led_classdev *led_cdev;
+
+	if (IS_ERR(v4l2_flash))
+		return;
+
+	sd = &v4l2_flash->sd;
+	led_cdev = &v4l2_flash->fled_cdev->led_cdev;
+
+	v4l2_async_unregister_subdev(sd);
+	of_node_put(led_cdev->dev->of_node);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	media_entity_cleanup(&sd->entity);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_release);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_DESCRIPTION("V4L2 Flash sub-device helpers");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
new file mode 100644
index 0000000..5c8389a
--- /dev/null
+++ b/include/media/v4l2-flash-led-class.h
@@ -0,0 +1,139 @@
+/*
+ * V4L2 flash LED sub-device registration helpers.
+ *
+ *	Copyright (C) 2015 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _V4L2_FLASH_H
+#define _V4L2_FLASH_H
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+
+struct led_classdev_flash;
+struct led_classdev;
+struct v4l2_flash;
+enum led_brightness;
+
+/*
+ * struct v4l2_flash_ctrl_data - flash control initialization data, filled
+ *				basing on the features declared by the LED Flash
+ *				class driver in the v4l2_flash_config
+ * @config:	initialization data for a control
+ * @cid:	contains v4l2 flash control id if the config
+ *		field was initialized, 0 otherwise
+ */
+struct v4l2_flash_ctrl_data {
+	struct v4l2_ctrl_config config;
+	u32 cid;
+};
+
+struct v4l2_flash_ops {
+	/* setup strobing the flash by hardware pin state assertion */
+	int (*external_strobe_set)(struct v4l2_flash *v4l2_flash,
+					bool enable);
+	/* convert intensity to brightness in a device specific manner */
+	enum led_brightness (*intensity_to_led_brightness)
+		(struct v4l2_flash *v4l2_flash, s32 intensity);
+	/* convert brightness to intensity in a device specific manner */
+	s32 (*led_brightness_to_intensity)
+		(struct v4l2_flash *v4l2_flash, enum led_brightness);
+};
+
+/**
+ * struct v4l2_flash_config - V4L2 Flash sub-device initialization data
+ * @dev_name:			the name of the media entity,
+				unique in the system
+ * @intensity:			constraints for the LED in a non-flash mode
+ * @flash_faults:		bitmask of flash faults that the LED Flash class
+				device can report; corresponding LED_FAULT* bit
+				definitions are available in the header file
+				<linux/led-class-flash.h>
+ * @has_external_strobe:	external strobe capability
+ * @indicator_led:		signifies that a led is of indicator type
+ */
+struct v4l2_flash_config {
+	char dev_name[32];
+	struct led_flash_setting intensity;
+	u32 flash_faults;
+	unsigned int has_external_strobe:1;
+	unsigned int indicator_led:1;
+};
+
+/**
+ * struct v4l2_flash - Flash sub-device context
+ * @fled_cdev:		LED Flash class device controlled by this sub-device
+ * @ops:		V4L2 specific flash ops
+ * @sd:			V4L2 sub-device
+ * @hdl:		flash controls handler
+ * @ctrls:		array of pointers to controls, whose values define
+ *			the sub-device state
+ */
+struct v4l2_flash {
+	struct led_classdev_flash *fled_cdev;
+	const struct v4l2_flash_ops *ops;
+
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl **ctrls;
+};
+
+static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(
+							struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct v4l2_flash, sd);
+}
+
+static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct v4l2_flash, hdl);
+}
+
+#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
+/**
+ * v4l2_flash_init - initialize V4L2 flash led sub-device
+ * @dev:	flash device, e.g. an I2C device
+ * @of_node:	of_node of the LED, may be NULL if the same as device's
+ * @fled_cdev:	the LED Flash class device to wrap
+ * @flash_ops:	V4L2 Flash device ops
+ * @config:	initialization data for V4L2 Flash sub-device
+ *
+ * Create V4L2 Flash sub-device wrapping given LED subsystem device.
+ *
+ * Returns: A valid pointer, or, when an error occurs, the return
+ * value is encoded using ERR_PTR(). Use IS_ERR() to check and
+ * PTR_ERR() to obtain the numeric return value.
+ */
+struct v4l2_flash *v4l2_flash_init(
+	struct device *dev, struct device_node *of_node,
+	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
+	struct v4l2_flash_config *config);
+
+/**
+ * v4l2_flash_release - release V4L2 Flash sub-device
+ * @flash: the V4L2 Flash sub-device to release
+ *
+ * Release V4L2 Flash sub-device.
+ */
+void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
+
+#else
+static inline struct v4l2_flash *v4l2_flash_init(
+	struct device *dev, struct device_node *of_node,
+	struct led_classdev_flash *fled_cdev, const struct v4l2_flash_ops *ops,
+	struct v4l2_flash_config *config)
+{
+	return NULL;
+}
+
+static inline void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
+{
+}
+#endif /* CONFIG_V4L2_FLASH_LED_CLASS */
+
+#endif /* _V4L2_FLASH_H */
-- 
1.7.9.5


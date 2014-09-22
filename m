Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:40497 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaIVPWE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 11:22:04 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v6 1/2] media: Add registration helpers for V4L2 flash
Date: Mon, 22 Sep 2014 17:21:48 +0200
Message-id: <1411399309-16418-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1411399309-16418-1-git-send-email-j.anaszewski@samsung.com>
References: <1411399309-16418-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds helper functions for registering/unregistering
LED class flash devices as V4L2 subdevs. The functions should
be called from the LED subsystem device driver. In case the
support for V4L2 Flash sub-devices is disabled in the kernel
config the functions' empty versions will be used.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/media/v4l2-core/Kconfig      |   11 +
 drivers/media/v4l2-core/Makefile     |    2 +
 drivers/media/v4l2-core/v4l2-flash.c |  502 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-flash.h           |  135 +++++++++
 4 files changed, 650 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 9ca0f8d..7e0c42f 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -35,6 +35,17 @@ config V4L2_MEM2MEM_DEV
         tristate
         depends on VIDEOBUF2_CORE
 
+# Used by LED subsystem flash drivers
+config V4L2_FLASH_LED_CLASS
+	tristate "Enable support for Flash sub-devices"
+	depends on VIDEO_V4L2_SUBDEV_API
+	depends on LEDS_CLASS_FLASH
+	---help---
+	  Say Y here to enable support for Flash sub-devices, which allow
+	  to control LED class devices with use of V4L2 Flash controls.
+
+	  When in doubt, say N.
+
 # Used by drivers that need Videobuf modules
 config VIDEOBUF_GEN
 	tristate
diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 63d29f2..44e858c 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
+obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash.o
+
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
new file mode 100644
index 0000000..2236f8b
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-flash.c
@@ -0,0 +1,502 @@
+/*
+ * V4L2 Flash LED sub-device registration helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/led-class-flash.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <media/v4l2-flash.h>
+
+#define has_flash_op(v4l2_flash, op)			\
+	(v4l2_flash && v4l2_flash->ops->op)
+
+#define call_flash_op(v4l2_flash, op, args...)		\
+		(has_flash_op(v4l2_flash, op) ?		\
+			v4l2_flash->ops->op(args) :	\
+			-EINVAL)
+
+static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
+					struct v4l2_ctrl *ctrl,
+					s32 intensity)
+{
+	s64 __intensity = intensity - ctrl->minimum;
+
+	do_div(__intensity, ctrl->step);
+
+	return __intensity + 1;
+}
+
+static inline s32 v4l2_flash_led_brightness_to_intensity(
+					struct v4l2_ctrl *ctrl,
+					enum led_brightness brightness)
+{
+	return ((brightness - 1) * ctrl->step) + ctrl->minimum;
+}
+
+static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	bool is_strobing;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		/*
+		 * Update torch brightness only if in TORCH_MODE,
+		 * as otherwise brightness_update op returns 0,
+		 * which would spuriously inform user space that
+		 * V4L2_CID_FLASH_TORCH_INTENSITY control value
+		 * has changed.
+		 */
+		if (ctrls[LED_MODE]->val == V4L2_FLASH_LED_MODE_TORCH) {
+			ret = led_update_brightness(led_cdev);
+			if (ret < 0)
+				return ret;
+			ctrls[TORCH_INTENSITY]->val =
+				v4l2_flash_led_brightness_to_intensity(
+						ctrls[TORCH_INTENSITY],
+						led_cdev->brightness);
+		}
+		return 0;
+	case V4L2_CID_FLASH_INTENSITY:
+		ret = led_update_flash_brightness(flash);
+		if (ret < 0)
+			return ret;
+		/* no conversion is needed */
+		c->val = flash->brightness.val;
+		return 0;
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		ret = led_update_indicator_brightness(flash);
+		if (ret < 0)
+			return ret;
+		/* no conversion is needed */
+		c->val = flash->indicator_brightness->val;
+		return 0;
+	case V4L2_CID_FLASH_STROBE_STATUS:
+		ret = led_get_flash_strobe(flash, &is_strobing);
+		if (ret < 0)
+			return ret;
+		c->val = is_strobing;
+		return 0;
+	case V4L2_CID_FLASH_FAULT:
+		/* led faults map directly to V4L2 flash faults */
+		return led_get_flash_fault(flash, &c->val);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
+	enum led_brightness torch_brightness;
+	bool external_strobe;
+	int ret = 0;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		switch (c->val) {
+		case V4L2_FLASH_LED_MODE_NONE:
+			led_set_torch_brightness(led_cdev, LED_OFF);
+			return led_set_flash_strobe(flash, false);
+		case V4L2_FLASH_LED_MODE_FLASH:
+			/* Turn torch LED off */
+			led_set_torch_brightness(led_cdev, LED_OFF);
+			external_strobe = (ctrls[STROBE_SOURCE]->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+
+			return call_flash_op(v4l2_flash, external_strobe_set,
+						v4l2_flash, external_strobe);
+		case V4L2_FLASH_LED_MODE_TORCH:
+			/* Stop flash strobing */
+			ret = led_set_flash_strobe(flash, false);
+			if (ret)
+				return ret;
+
+			torch_brightness =
+				v4l2_flash_intensity_to_led_brightness(
+						ctrls[TORCH_INTENSITY],
+						ctrls[TORCH_INTENSITY]->val);
+			led_set_torch_brightness(led_cdev, torch_brightness);
+			return ret;
+		}
+		break;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		external_strobe = (c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+
+		return call_flash_op(v4l2_flash, external_strobe_set,
+					v4l2_flash, external_strobe);
+	case V4L2_CID_FLASH_STROBE:
+		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH ||
+		    ctrls[STROBE_SOURCE]->val !=
+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
+			return -EINVAL;
+		return led_set_flash_strobe(flash, true);
+	case V4L2_CID_FLASH_STROBE_STOP:
+		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH ||
+		    ctrls[STROBE_SOURCE]->val !=
+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
+			return -EINVAL;
+		return led_set_flash_strobe(flash, false);
+	case V4L2_CID_FLASH_TIMEOUT:
+		return led_set_flash_timeout(flash, c->val);
+	case V4L2_CID_FLASH_INTENSITY:
+		/* no conversion is needed */
+		return led_set_flash_brightness(flash, c->val);
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		/* no conversion is needed */
+		return led_set_indicator_brightness(flash, c->val);
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		/*
+		 * If not in MODE_TORCH don't call led-class brightness_set
+		 * op, as it would result in turning the torch led on.
+		 * Instead the value is cached only and will be written
+		 * to the device upon transition to MODE_TORCH.
+		 */
+		if (ctrls[LED_MODE]->val == V4L2_FLASH_LED_MODE_TORCH) {
+			torch_brightness =
+				v4l2_flash_intensity_to_led_brightness(
+							ctrls[TORCH_INTENSITY],
+							c->val);
+			led_set_torch_brightness(led_cdev, torch_brightness);
+		}
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
+static void fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
+			  struct v4l2_flash_ctrl_config *flash_cfg,
+			  struct v4l2_flash_ctrl_data *ctrl_init_data)
+{
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	const struct led_flash_ops *flash_ops = flash->ops;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct v4l2_ctrl_config *ctrl_cfg;
+	u32 mask;
+	s64 max;
+
+	/* Init FLASH_LED_MODE ctrl data */
+	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
+	       1 << V4L2_FLASH_LED_MODE_TORCH;
+	if (flash)
+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
+
+	ctrl_init_data[LED_MODE].supported = true;
+	ctrl_cfg = &ctrl_init_data[LED_MODE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_LED_MODE;
+	ctrl_cfg->max = V4L2_FLASH_LED_MODE_TORCH;
+	ctrl_cfg->menu_skip_mask = ~mask;
+	ctrl_cfg->def = V4L2_FLASH_LED_MODE_NONE;
+	ctrl_cfg->flags = 0;
+
+	/* Init TORCH_INTENSITY ctrl data */
+	ctrl_init_data[TORCH_INTENSITY].supported = true;
+	ctrl_init_data[TORCH_INTENSITY].config = flash_cfg->torch_intensity;
+	ctrl_cfg = &ctrl_init_data[TORCH_INTENSITY].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_TORCH_INTENSITY;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	if (!(led_cdev->flags & LED_DEV_CAP_FLASH))
+		return;
+
+	/* Init FLASH_STROBE_SOURCE ctrl data */
+	mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+	if (flash_cfg->has_external_strobe) {
+		mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+		max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+	} else {
+		max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+	}
+
+	ctrl_init_data[STROBE_SOURCE].supported = true;
+	ctrl_cfg = &ctrl_init_data[STROBE_SOURCE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_SOURCE;
+	ctrl_cfg->max = max;
+	ctrl_cfg->menu_skip_mask = ~mask;
+	ctrl_cfg->def = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+
+	/* Init FLASH_STROBE ctrl data */
+	ctrl_init_data[FLASH_STROBE].supported = true;
+	ctrl_cfg = &ctrl_init_data[FLASH_STROBE].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = 1;
+	ctrl_cfg->step = 1;
+	ctrl_cfg->def = 0;
+	ctrl_cfg->flags = 0;
+
+	/* Init STROBE_STOP ctrl data */
+	ctrl_init_data[STROBE_STOP].supported = true;
+	ctrl_cfg = &ctrl_init_data[STROBE_STOP].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STOP;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = 1;
+	ctrl_cfg->step = 1;
+	ctrl_cfg->def = 0;
+	ctrl_cfg->flags = 0;
+
+	/* Init STROBE_STATUS ctrl data */
+	ctrl_init_data[STROBE_STATUS].supported = !!flash_ops->strobe_get;
+	ctrl_cfg = &ctrl_init_data[STROBE_STATUS].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STATUS;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = 1;
+	ctrl_cfg->step = 1;
+	ctrl_cfg->def = 1;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
+			   V4L2_CTRL_FLAG_READ_ONLY;
+
+	/* Init FLASH_TIMEOUT ctrl data */
+	ctrl_init_data[FLASH_TIMEOUT].supported = !!flash_ops->timeout_set;
+	ctrl_init_data[FLASH_TIMEOUT].config = flash_cfg->flash_timeout;
+	ctrl_cfg = &ctrl_init_data[FLASH_TIMEOUT].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_TIMEOUT;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	/* Init FLASH_INTENSITY ctrl data */
+	ctrl_init_data[FLASH_INTENSITY].supported =
+					!!flash_ops->flash_brightness_set;
+	ctrl_init_data[FLASH_INTENSITY].config = flash_cfg->flash_intensity;
+	ctrl_cfg = &ctrl_init_data[FLASH_INTENSITY].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_INTENSITY;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	/* Init INDICATOR_INTENSITY ctrl data */
+	ctrl_init_data[INDICATOR_INTENSITY].supported =
+					led_cdev->flags & LED_DEV_CAP_INDICATOR;
+	ctrl_init_data[INDICATOR_INTENSITY].config = flash_cfg->flash_intensity;
+	ctrl_cfg = &ctrl_init_data[INDICATOR_INTENSITY].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_INDICATOR_INTENSITY;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
+
+	/* Init FLASH_FAULT ctrl data */
+	ctrl_init_data[FLASH_FAULT].supported = !!flash_cfg->flash_faults;
+	ctrl_cfg = &ctrl_init_data[FLASH_FAULT].config;
+	ctrl_cfg->id = V4L2_CID_FLASH_FAULT;
+	ctrl_cfg->min = 0;
+	ctrl_cfg->max = flash_cfg->flash_faults;
+	ctrl_cfg->step = 0;
+	ctrl_cfg->def = 0;
+	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_ONLY;
+}
+
+static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash,
+				struct v4l2_flash_ctrl_config *flash_cfg)
+
+{
+	struct v4l2_flash_ctrl_data *ctrl_init_data;
+	struct v4l2_ctrl *ctrl;
+	struct v4l2_ctrl_config *ctrl_cfg;
+	int i, ret, num_ctrls = 0;
+
+	/* allocate memory dynamically so as not to exceed stack frame size */
+	ctrl_init_data = kcalloc(NUM_FLASH_CTRLS, sizeof(*ctrl_init_data),
+					GFP_KERNEL);
+	if (!ctrl_init_data)
+		return -ENOMEM;
+
+	memset(ctrl_init_data, 0, sizeof(*ctrl_init_data));
+
+	fill_ctrl_init_data(v4l2_flash, flash_cfg, ctrl_init_data);
+
+	for (i = 0; i < NUM_FLASH_CTRLS; ++i)
+		if (ctrl_init_data[i].supported)
+			++num_ctrls;
+
+	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
+
+	for (i = 0; i < NUM_FLASH_CTRLS; ++i) {
+		ctrl_cfg = &ctrl_init_data[i].config;
+		if (!ctrl_init_data[i].supported)
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
+/*
+ * V4L2 subdev internal operations
+ */
+
+static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret = 0;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (!v4l2_fh_is_singular(&fh->vfh)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	led_sysfs_disable(led_cdev);
+
+unlock:
+	mutex_unlock(&led_cdev->led_access);
+	return ret;
+}
+
+static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
+	struct led_classdev_flash *flash = v4l2_flash->flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret = 0;
+
+	mutex_lock(&led_cdev->led_access);
+
+	if (has_flash_op(v4l2_flash, external_strobe_set))
+		ret = call_flash_op(v4l2_flash, external_strobe_set,
+				v4l2_flash, false);
+	led_sysfs_enable(led_cdev);
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
+struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *flash,
+				   const struct v4l2_flash_ops *ops,
+				   struct v4l2_flash_ctrl_config *config)
+{
+	struct v4l2_flash *v4l2_flash;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	if (!flash || !ops || !config)
+		return ERR_PTR(-EINVAL);
+
+	v4l2_flash = kzalloc(sizeof(*v4l2_flash), GFP_KERNEL);
+	if (!v4l2_flash)
+		return ERR_PTR(-ENOMEM);
+
+	sd = &v4l2_flash->sd;
+	v4l2_flash->flash = flash;
+	v4l2_flash->ops = ops;
+	sd->dev = led_cdev->dev->parent;
+	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
+	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
+
+	ret = v4l2_flash_init_controls(v4l2_flash, config);
+	if (ret < 0)
+		goto err_init_controls;
+
+	ret = media_entity_init(&sd->entity, 0, NULL, 0);
+	if (ret < 0)
+		goto err_init_entity;
+
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
+	ret = v4l2_async_register_subdev(sd);
+	if (ret < 0)
+		goto err_init_entity;
+
+	return v4l2_flash;
+
+err_init_entity:
+	media_entity_cleanup(&sd->entity);
+err_init_controls:
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	kfree(v4l2_flash);
+
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_init);
+
+void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
+{
+	struct v4l2_subdev *sd = &v4l2_flash->sd;
+
+	if (!v4l2_flash)
+		return;
+
+	v4l2_async_unregister_subdev(sd);
+	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	kfree(v4l2_flash);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_release);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("V4L2 Flash sub-device helpers");
diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
new file mode 100644
index 0000000..9006638
--- /dev/null
+++ b/include/media/v4l2-flash.h
@@ -0,0 +1,135 @@
+/*
+ * V4L2 Flash LED sub-device registration helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _V4L2_FLASH_H
+#define _V4L2_FLASH_H
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+
+struct led_classdev_flash;
+struct led_classdev;
+struct v4l2_flash;
+enum led_brightness;
+
+enum ctrl_init_data_id {
+	LED_MODE,
+	TORCH_INTENSITY,
+	STROBE_SOURCE,
+	FLASH_STROBE,
+	STROBE_STOP,
+	STROBE_STATUS,
+	FLASH_TIMEOUT,
+	FLASH_INTENSITY,
+	INDICATOR_INTENSITY,
+	FLASH_FAULT,
+	NUM_FLASH_CTRLS,
+};
+
+/*
+ * struct v4l2_flash_ctrl_data - flash control initialization data -
+ *				 filled basing on flash features declared
+ *				 by the LED Flash Class driver
+ * @config:	initialization data for a control
+ * @supported:	indicates whether a control is supported
+ *		by the LED Flash Class driver
+ */
+struct v4l2_flash_ctrl_data {
+	struct v4l2_ctrl_config config;
+	bool supported;
+};
+
+struct v4l2_flash_ops {
+	/* setup strobing the flash by hardware pin state assertion */
+	int (*external_strobe_set)(struct v4l2_flash *v4l2_flash,
+					bool enable);
+};
+
+/**
+ * struct v4l2_flash_ctrl_config - V4L2 Flash controls initialization data
+ * @torch_intensity:		V4L2_CID_FLASH_TORCH_INTENSITY constraints
+ * @flash_intensity:		V4L2_CID_FLASH_INTENSITY constraints
+ * @indicator_intensity:	V4L2_CID_FLASH_INDICATOR_INTENSITY constraints
+ * @flash_timeout:		V4L2_CID_FLASH_TIMEOUT constraints
+ * @flash_fault:		possible flash faults
+ * @has_external_strobe:	external strobe capability
+ */
+struct v4l2_flash_ctrl_config {
+	struct v4l2_ctrl_config torch_intensity;
+	struct v4l2_ctrl_config flash_intensity;
+	struct v4l2_ctrl_config indicator_intensity;
+	struct v4l2_ctrl_config flash_timeout;
+	u32 flash_faults;
+	bool has_external_strobe;
+};
+
+/**
+ * struct v4l2_flash - Flash sub-device context
+ * @flash:		LED Flash Class device controlled by this sub-device
+ * @ops:		V4L2 specific flash ops
+ * @sd:			V4L2 sub-device
+ * @hdl:		flash controls handler
+ * @ctrls:		state defining controls
+ */
+struct v4l2_flash {
+	struct led_classdev_flash *flash;
+	const struct v4l2_flash_ops *ops;
+
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *ctrls[STROBE_SOURCE + 1];
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
+ * @led_fdev:	the LED Flash Class device to wrap
+ * @config:	initialization data for V4L2 Flash controls
+ * @flash_ops:	V4L2 Flash device ops
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+
+ * Returns: A valid pointer, or, when an error occurs, the return
+ * value is encoded using ERR_PTR(). Use IS_ERR() to check and
+ * PTR_ERR() to obtain the numeric return value.
+ */
+struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *led_fdev,
+				   const struct v4l2_flash_ops *ops,
+				   struct v4l2_flash_ctrl_config *config);
+
+/**
+ * v4l2_flash_release - release V4L2 Flash sub-device
+ * @flash: the V4L2 Flash device to release
+ *
+ * Release V4L2 flash led subdev.
+ */
+void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
+
+#else
+#define v4l2_flash_init(led_cdev, ops, config) (NULL)
+#define v4l2_flash_release(v4l2_flash)
+#endif /* CONFIG_V4L2_FLASH_LED_CLASS */
+
+#endif /* _V4L2_FLASH_H */
-- 
1.7.9.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13619 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbaDKO5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 10:57:46 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2 flash
 sub-devices
Date: Fri, 11 Apr 2014 16:56:56 +0200
Message-id: <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds helper functions for registering/unregistering
LED class flash devices as V4L2 subdevs. The functions should
be called from the LED subsystem device driver. In case the
support for V4L2 Flash sub-devices is disabled in the kernel
config the functions' empty versions will be used.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/Kconfig      |   10 +
 drivers/media/v4l2-core/Makefile     |    2 +
 drivers/media/v4l2-core/v4l2-flash.c |  393 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-flash.h           |  119 ++++++++++
 4 files changed, 524 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 2189bfb..1f8514d 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -35,6 +35,16 @@ config V4L2_MEM2MEM_DEV
         tristate
         depends on VIDEOBUF2_CORE
 
+# Used by LED subsystem flash drivers
+config V4L2_FLASH
+	bool "Enable support for Flash sub-devices"
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
index c6ae7ba..8e37ab4 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
+obj-$(CONFIG_V4L2_FLASH) += v4l2-flash.o
+
 obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
 obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
 obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
new file mode 100644
index 0000000..f1be332
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-flash.c
@@ -0,0 +1,393 @@
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
+#include <linux/leds_flash.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-flash.h>
+
+static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
+					struct led_ctrl *config,
+					u32 intensity)
+{
+	return intensity / config->step;
+}
+
+static inline u32 v4l2_flash_led_brightness_to_intensity(
+					struct led_ctrl *config,
+					enum led_brightness brightness)
+{
+	return brightness * config->step;
+}
+
+static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
+
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
+	struct led_flash *flash = led_cdev->flash;
+	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
+	u32 fault;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
+			ret = v4l2_call_flash_op(brightness_update, led_cdev);
+			if (ret < 0)
+				return ret;
+			ctrl->torch_intensity->val =
+				v4l2_flash_led_brightness_to_intensity(
+						&led_cdev->brightness_ctrl,
+						led_cdev->brightness);
+		}
+		return 0;
+	case V4L2_CID_FLASH_INTENSITY:
+		ret = v4l2_call_flash_op(flash_brightness_update, led_cdev);
+		if (ret < 0)
+			return ret;
+		/* no conversion is needed */
+		c->val = flash->brightness.val;
+		return 0;
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		ret = v4l2_call_flash_op(indicator_brightness_update, led_cdev);
+		if (ret < 0)
+			return ret;
+		/* no conversion is needed */
+		c->val = flash->indicator_brightness->val;
+		return 0;
+	case V4L2_CID_FLASH_STROBE_STATUS:
+		ret = v4l2_call_flash_op(strobe_get, led_cdev);
+		if (ret < 0)
+			return ret;
+		c->val = !!ret;
+		return 0;
+	case V4L2_CID_FLASH_FAULT:
+		/* led faults map directly to V4L2 flash faults */
+		ret = v4l2_call_flash_op(fault_get, led_cdev, &fault);
+		if (!ret)
+			c->val = fault;
+		return ret;
+	default:
+		return -EINVAL;
+	}
+}
+
+static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
+	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
+	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
+	enum led_brightness torch_brightness;
+	bool external_strobe;
+	int ret;
+
+	switch (c->id) {
+	case V4L2_CID_FLASH_LED_MODE:
+		switch (c->val) {
+		case V4L2_FLASH_LED_MODE_NONE:
+			v4l2_call_flash_op(brightness_set, led_cdev, 0);
+			return v4l2_call_flash_op(strobe_set, led_cdev, false);
+		case V4L2_FLASH_LED_MODE_FLASH:
+			/* Turn off torch LED */
+			v4l2_call_flash_op(brightness_set, led_cdev, 0);
+			external_strobe = (ctrl->source->val ==
+					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+			return v4l2_call_flash_op(external_strobe_set, led_cdev,
+							external_strobe);
+		case V4L2_FLASH_LED_MODE_TORCH:
+			/* Stop flash strobing */
+			ret = v4l2_call_flash_op(strobe_set, led_cdev, false);
+			if (ret)
+				return ret;
+			/* torch is always triggered by software */
+			ret = v4l2_call_flash_op(external_strobe_set, led_cdev,
+								false);
+			if (ret)
+				return ret;
+
+			torch_brightness =
+				v4l2_flash_intensity_to_led_brightness(
+						&led_cdev->brightness_ctrl,
+						ctrl->torch_intensity->val);
+			v4l2_call_flash_op(brightness_set, led_cdev,
+						torch_brightness);
+			return ret;
+		}
+		break;
+	case V4L2_CID_FLASH_STROBE_SOURCE:
+		return v4l2_call_flash_op(external_strobe_set, led_cdev,
+				c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
+	case V4L2_CID_FLASH_STROBE:
+		if (ctrl->led_mode->val != V4L2_FLASH_LED_MODE_FLASH ||
+		    ctrl->source->val != V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
+			return -EINVAL;
+		return v4l2_call_flash_op(strobe_set, led_cdev, true);
+	case V4L2_CID_FLASH_STROBE_STOP:
+		return v4l2_call_flash_op(strobe_set, led_cdev, false);
+	case V4L2_CID_FLASH_TIMEOUT:
+		ret =  v4l2_call_flash_op(timeout_set, led_cdev, c->val);
+	case V4L2_CID_FLASH_INTENSITY:
+		/* no conversion is needed */
+		return v4l2_call_flash_op(flash_brightness_set, led_cdev,
+								c->val);
+	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
+		/* no conversion is needed */
+		return v4l2_call_flash_op(indicator_brightness_set, led_cdev,
+								c->val);
+	case V4L2_CID_FLASH_TORCH_INTENSITY:
+		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
+			torch_brightness =
+				v4l2_flash_intensity_to_led_brightness(
+						&led_cdev->brightness_ctrl,
+						ctrl->torch_intensity->val);
+			v4l2_call_flash_op(brightness_set, led_cdev,
+						torch_brightness);
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
+static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash)
+
+{
+	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
+	struct led_flash *flash = led_cdev->flash;
+	bool has_indicator = flash->indicator_brightness;
+	struct v4l2_ctrl *ctrl;
+	struct led_ctrl *ctrl_cfg;
+	unsigned int mask;
+	int ret, max, num_ctrls;
+
+	num_ctrls = flash->has_flash_led ? 8 : 2;
+	if (flash->fault_flags)
+		++num_ctrls;
+	if (has_indicator)
+		++num_ctrls;
+
+	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
+
+	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
+	       1 << V4L2_FLASH_LED_MODE_TORCH;
+	if (flash->has_flash_led)
+		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
+
+	/* Configure FLASH_LED_MODE ctrl */
+	v4l2_flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(
+			&v4l2_flash->hdl,
+			&v4l2_flash_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
+			V4L2_FLASH_LED_MODE_TORCH, ~mask,
+			V4L2_FLASH_LED_MODE_NONE);
+
+	/* Configure TORCH_INTENSITY ctrl */
+	ctrl_cfg = &led_cdev->brightness_ctrl;
+	ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+				 V4L2_CID_FLASH_TORCH_INTENSITY,
+				 ctrl_cfg->min, ctrl_cfg->max,
+				 ctrl_cfg->step, ctrl_cfg->val);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	v4l2_flash->ctrl.torch_intensity = ctrl;
+
+	if (flash->has_flash_led) {
+		/* Configure FLASH_STROBE_SOURCE ctrl */
+		mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+
+		if (flash->has_external_strobe) {
+			mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+			max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
+		} else {
+			max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
+		}
+
+		v4l2_flash->ctrl.source = v4l2_ctrl_new_std_menu(
+					&v4l2_flash->hdl,
+					&v4l2_flash_ctrl_ops,
+					V4L2_CID_FLASH_STROBE_SOURCE,
+					max,
+					~mask,
+					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
+
+		/* Configure FLASH_STROBE ctrl */
+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+					  V4L2_CID_FLASH_STROBE, 0, 1, 1, 0);
+
+		/* Configure FLASH_STROBE_STOP ctrl */
+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+					  V4L2_CID_FLASH_STROBE_STOP,
+					  0, 1, 1, 0);
+
+		/* Configure FLASH_STROBE_STATUS ctrl */
+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+					 V4L2_CID_FLASH_STROBE_STATUS,
+					 0, 1, 1, 1);
+		if (ctrl)
+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
+				       V4L2_CTRL_FLAG_READ_ONLY;
+
+		/* Configure FLASH_TIMEOUT ctrl */
+		ctrl_cfg = &flash->timeout;
+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+					 V4L2_CID_FLASH_TIMEOUT, ctrl_cfg->min,
+					 ctrl_cfg->max, ctrl_cfg->step,
+					 ctrl_cfg->val);
+		if (ctrl)
+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+		/* Configure FLASH_INTENSITY ctrl */
+		ctrl_cfg = &flash->brightness;
+		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+					 V4L2_CID_FLASH_INTENSITY,
+					 ctrl_cfg->min, ctrl_cfg->max,
+					 ctrl_cfg->step, ctrl_cfg->val);
+		if (ctrl)
+			ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+		if (flash->fault_flags) {
+			/* Configure FLASH_FAULT ctrl */
+			ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl,
+						 &v4l2_flash_ctrl_ops,
+						 V4L2_CID_FLASH_FAULT, 0,
+						 flash->fault_flags,
+						 0, 0);
+			if (ctrl)
+				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
+					       V4L2_CTRL_FLAG_READ_ONLY;
+		}
+		if (has_indicator) {
+			/* Configure FLASH_INDICATOR_INTENSITY ctrl */
+			ctrl_cfg = flash->indicator_brightness;
+			ctrl = v4l2_ctrl_new_std(
+					&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
+					V4L2_CID_FLASH_INDICATOR_INTENSITY,
+					ctrl_cfg->min, ctrl_cfg->max,
+					ctrl_cfg->step, ctrl_cfg->val);
+			if (ctrl)
+				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+		}
+	}
+
+	if (v4l2_flash->hdl.error) {
+		ret = v4l2_flash->hdl.error;
+		goto error_free;
+	}
+
+	ret = v4l2_ctrl_handler_setup(&v4l2_flash->hdl);
+	if (ret < 0)
+		goto error_free;
+
+	v4l2_flash->subdev.ctrl_handler = &v4l2_flash->hdl;
+
+	return 0;
+
+error_free:
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
+	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
+
+	mutex_lock(&led_cdev->led_lock);
+	v4l2_call_flash_op(sysfs_lock, led_cdev);
+	mutex_unlock(&led_cdev->led_lock);
+
+	return 0;
+}
+
+static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
+	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
+
+	mutex_lock(&led_cdev->led_lock);
+	v4l2_call_flash_op(sysfs_unlock, led_cdev);
+	mutex_unlock(&led_cdev->led_lock);
+
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
+	.open = v4l2_flash_open,
+	.close = v4l2_flash_close,
+};
+
+static struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
+};
+
+int v4l2_flash_init(struct led_classdev *led_cdev,
+		    const struct v4l2_flash_ops *ops)
+{
+	struct v4l2_flash *flash = &led_cdev->flash->v4l2_flash;
+	struct v4l2_subdev *sd = &flash->subdev;
+	int ret;
+
+	if (!led_cdev || !ops)
+		return -EINVAL;
+
+	flash->led_cdev = led_cdev;
+	sd->dev = led_cdev->dev->parent;
+	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
+	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
+
+	flash->ops = ops;
+
+	ret = v4l2_flash_init_controls(flash);
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
+	return 0;
+
+err_init_entity:
+	media_entity_cleanup(&sd->entity);
+err_init_controls:
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_init);
+
+void v4l2_flash_release(struct led_classdev *led_cdev)
+{
+	struct v4l2_flash *flash = &led_cdev->flash->v4l2_flash;
+
+	v4l2_ctrl_handler_free(flash->subdev.ctrl_handler);
+	v4l2_async_unregister_subdev(&flash->subdev);
+	media_entity_cleanup(&flash->subdev.entity);
+}
+EXPORT_SYMBOL_GPL(v4l2_flash_release);
diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
new file mode 100644
index 0000000..fe16ddd
--- /dev/null
+++ b/include/media/v4l2-flash.h
@@ -0,0 +1,119 @@
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
+#define v4l2_call_flash_op(op, args...)		\
+	((v4l2_flash)->ops->op(args))		\
+
+struct led_classdev;
+enum led_brightness;
+
+struct v4l2_flash_ops {
+	void	(*brightness_set)(struct led_classdev *led_cdev,
+					enum led_brightness brightness);
+	int	(*brightness_update)(struct led_classdev *led_cdev);
+	int	(*flash_brightness_set)(struct led_classdev *led_cdev,
+					u32 brightness);
+	int	(*flash_brightness_update)(struct led_classdev *led_cdev);
+	int	(*strobe_set)(struct led_classdev *led_cdev,
+					bool state);
+	int	(*strobe_get)(struct led_classdev *led_cdev);
+	int	(*timeout_set)(struct led_classdev *led_cdev,
+					u32 timeout);
+	int	(*indicator_brightness_set)(struct led_classdev *led_cdev,
+					u32 brightness);
+	int	(*indicator_brightness_update)(struct led_classdev *led_cdev);
+	int	(*external_strobe_set)(struct led_classdev *led_cdev,
+					bool enable);
+	int	(*fault_get)(struct led_classdev *led_cdev,
+					u32 *fault);
+	void	(*sysfs_lock)(struct led_classdev *led_cdev);
+	void	(*sysfs_unlock)(struct led_classdev *led_cdev);
+};
+
+/**
+ * struct v4l2_flash_ctrl - controls that define the sub-dev's state
+ * @source:		V4L2_CID_FLASH_STROBE_SOURCE control
+ * @led_mode:		V4L2_CID_FLASH_LED_MODE control
+ * @torch_intensity:	V4L2_CID_FLASH_TORCH_INTENSITY control
+ */
+struct v4l2_flash_ctrl {
+	struct v4l2_ctrl *source;
+	struct v4l2_ctrl *led_mode;
+	struct v4l2_ctrl *torch_intensity;
+};
+
+/**
+ * struct v4l2_flash - Flash sub-device context
+ * @led_cdev:		LED class device controlled by this sub-device
+ * @ops:		LED class device ops
+ * @subdev:		V4L2 sub-device
+ * @hdl:		flash controls handler
+ * @ctrl:		state defining controls
+ */
+struct v4l2_flash {
+	struct led_classdev *led_cdev;
+	const struct v4l2_flash_ops *ops;
+
+	struct v4l2_subdev subdev;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_flash_ctrl ctrl;
+};
+
+static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct v4l2_flash, subdev);
+}
+
+static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
+{
+	return container_of(c->handler, struct v4l2_flash, hdl);
+}
+
+#ifdef CONFIG_V4L2_FLASH
+/**
+ * v4l2_flash_init - initialize V4L2 flash led sub-device
+ * @led_cdev: the LED to create subdev upon
+ * @ops: LED subsystem callbacks
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ */
+int v4l2_flash_init(struct led_classdev *led_cdev,
+		    const struct v4l2_flash_ops *ops);
+
+/**
+ * v4l2_flash_release - release V4L2 flash led sub-device
+ * @flash: a structure representing V4L2 flash led device
+ *
+ * Release V4L2 flash led subdev.
+ */
+void v4l2_flash_release(struct led_classdev *led_cdev);
+#else
+static inline int v4l2_flash_init(struct led_classdev *led_cdev,
+				  const struct v4l2_flash_ops *ops)
+{
+	return 0;
+}
+
+static inline void v4l2_flash_release(struct led_classdev *led_cdev)
+{
+}
+#endif /* CONFIG_V4L2_FLASH */
+
+#endif /* _V4L2_FLASH_H */
-- 
1.7.9.5


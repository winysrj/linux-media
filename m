Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41719 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327Ab2EDSc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 14:32:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3I00AHZGU82AA0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:32 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3I00643GTWGM@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:21 +0100 (BST)
Date: Fri, 04 May 2012 20:32:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 13/13] V4L: Add S5C73M3 sensor sub-device driver
In-reply-to: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1336156337-10935-14-git-send-email-s.nawrocki@samsung.com>
References: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 - initial working version
 - public header cleanup
 - add SPI slave driver and FW upload support
 - firmware load cleanup
 - change SPI driver initialization method
 - move SPI driver to separate file
 - capture context control
 - frame size enumeration
 - update to changed controls

This driver is a work in progress, it is included in this series
only to demonstrate how the new controls are used.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig                 |    8 +
 drivers/media/video/Makefile                |    1 +
 drivers/media/video/s5c73m3/Makefile        |    3 +
 drivers/media/video/s5c73m3/s5c73m3-ctrls.c |  687 +++++++++++++++
 drivers/media/video/s5c73m3/s5c73m3-spi.c   |  126 +++
 drivers/media/video/s5c73m3/s5c73m3.c       | 1243 +++++++++++++++++++++++++++
 drivers/media/video/s5c73m3/s5c73m3.h       |  442 ++++++++++
 include/media/s5c73m3.h                     |   62 ++
 8 files changed, 2572 insertions(+)
 create mode 100644 drivers/media/video/s5c73m3/Makefile
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3-ctrls.c
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3-spi.c
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3.c
 create mode 100644 drivers/media/video/s5c73m3/s5c73m3.h
 create mode 100644 include/media/s5c73m3.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f2479c5..4dd2aeb 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -556,6 +556,14 @@ config VIDEO_S5K6AA
 	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
 	  camera sensor with an embedded SoC image signal processor.
 
+config VIDEO_S5C73M3
+	tristate "Samsung S5C73M3 sensor support (experimental)"
+	depends on I2C && SPI && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on EXPERIMENTAL
+	---help---
+	  This is a V4L2 sensor-level driver for Samsung S5C73M3
+	  8 Mpixel camera.
+
 comment "Flash devices"
 
 config VIDEO_ADP1653
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index a6282a3..ef3d954 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -79,6 +79,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
+obj-$(CONFIG_VIDEO_S5C73M3)	+= s5c73m3/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
 
diff --git a/drivers/media/video/s5c73m3/Makefile b/drivers/media/video/s5c73m3/Makefile
new file mode 100644
index 0000000..c8a0a40
--- /dev/null
+++ b/drivers/media/video/s5c73m3/Makefile
@@ -0,0 +1,3 @@
+# Makefile for S5C73M3 camera driver
+
+obj-$(CONFIG_VIDEO_S5C73M3) += s5c73m3.o s5c73m3-spi.o s5c73m3-ctrls.o
diff --git a/drivers/media/video/s5c73m3/s5c73m3-ctrls.c b/drivers/media/video/s5c73m3/s5c73m3-ctrls.c
new file mode 100644
index 0000000..aa93889
--- /dev/null
+++ b/drivers/media/video/s5c73m3/s5c73m3-ctrls.c
@@ -0,0 +1,687 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <asm/sizes.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/media.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+#include <linux/videodev2.h>
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5c73m3.h>
+
+#include "s5c73m3.h"
+
+static int s5c73m3_get_af_status(struct s5c73m3 *state, struct v4l2_ctrl *ctrl)
+{
+	u16 reg = REG_AF_STATUS_UNFOCUSED;
+
+	int err = s5c73m3_read(state->i2c_client, REG_AF_STATUS, &reg);
+	/*err = s5c73m3_read(sd, 0x0009, 0x5840, &temp_status);*/
+
+	switch (reg) {
+	case REG_CAF_STATUS_FIND_SEARCH_DIR:
+	case REG_AF_STATUS_FOCUSING:
+	case REG_CAF_STATUS_FOCUSING:
+		ctrl->val = V4L2_AUTO_FOCUS_STATUS_BUSY;
+		break;
+	case REG_CAF_STATUS_FOCUSED:
+	case REG_AF_STATUS_FOCUSED:
+		ctrl->val = V4L2_AUTO_FOCUS_STATUS_REACHED;
+		break;
+	case REG_CAF_STATUS_UNFOCUSED:
+	case REG_AF_STATUS_UNFOCUSED:
+		ctrl->val = V4L2_AUTO_FOCUS_STATUS_LOST;
+		break;
+	default:
+		v4l2_info(&state->subdev, "Unknown AF status\n");
+		/* Fall through */
+	case REG_AF_STATUS_INVALID:
+		ctrl->val = V4L2_AUTO_FOCUS_STATUS_FAILED;
+		break;
+	}
+
+	return err;
+}
+
+static int s5c73m3_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	int err;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: ctrl: %s\n", __func__, ctrl->name);
+
+	if (state->power == 0)
+		return -EBUSY;
+
+	switch (ctrl->id) {
+	case V4L2_CID_FIRMWARE_VERSION:
+		/* FIXME: */
+		/* strlcpy(ctrl->string, state->exif.unique_id, ctrl->maximum); */
+		break;
+
+	case V4L2_CID_FOCUS_AUTO:
+		err = s5c73m3_get_af_status(state, state->ctrls.af_status);
+		if (err)
+			return err;
+		v4l2_dbg(1, s5c73m3_dbg, sd, "AF status: %#x\n",
+			 state->ctrls.af_status->val);
+		break;
+	}
+
+	return 0;
+}
+
+static int s5c73m3_set_colorfx(struct s5c73m3 *state, int val)
+{
+	static const unsigned short colorfx[][2] = {
+		{ V4L2_COLORFX_NONE,	 REG_IMAGE_EFFECT_NONE },
+		{ V4L2_COLORFX_BW,	 REG_IMAGE_EFFECT_MONO },
+		{ V4L2_COLORFX_SEPIA,	 REG_IMAGE_EFFECT_SEPIA },
+		{ V4L2_COLORFX_NEGATIVE, REG_IMAGE_EFFECT_NEGATIVE },
+		{ V4L2_COLORFX_AQUA,	 REG_IMAGE_EFFECT_AQUA },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(colorfx); i++) {
+		if (colorfx[i][0] != val)
+			continue;
+
+		v4l2_dbg(1, s5c73m3_dbg, &state->subdev,
+			 "Setting %s color effect\n",
+			 v4l2_ctrl_get_menu(state->ctrls.colorfx->id)[i]);
+
+		return s5c73m3_write_cmd(state, REG_IMAGE_EFFECT,
+					 colorfx[i][1]);
+	}
+	return -EINVAL;
+}
+
+/* Set exposure metering/exposure bias */
+static int s5c73m3_set_exposure(struct s5c73m3 *state, int auto_exp)
+{
+	struct v4l2_subdev *sd = &state->subdev;
+	struct s5c73m3_ctrls *ctrls = &state->ctrls;
+	int err = 0;
+
+	if (ctrls->exposure_metering->is_new) {
+		u16 metering;
+
+		switch (ctrls->exposure_metering->val) {
+		case V4L2_EXPOSURE_METERING_CENTER_WEIGHTED:
+			metering = REG_METERING_CENTER;
+			break;
+		case V4L2_EXPOSURE_METERING_SPOT:
+			metering = REG_METERING_SPOT;
+			break;
+		default:
+			metering = REG_METERING_AVERAGE;
+			break;
+		}
+
+		err = s5c73m3_write_cmd(state, REG_METERING, metering);
+	}
+
+	if (!err && ctrls->exposure_bias->is_new) {
+		u16 exp_bias = ctrls->exposure_bias->val;
+		err = s5c73m3_write_cmd(state, REG_EV, exp_bias);
+	}
+
+	v4l2_dbg(1, s5c73m3_dbg, sd,
+		 "%s: exposure bias: %#x, metering: %#x (%d)\n",  __func__,
+		 ctrls->exposure_bias->val, ctrls->exposure_metering->val, err);
+
+	return err;
+}
+
+static int s5c73m3_set_white_balance(struct s5c73m3 *state, int val)
+{
+	static const unsigned short wb[][2] = {
+		{ V4L2_WHITE_BALANCE_INCANDESCENT,  REG_AWB_MODE_INCANDESCENT },
+		{ V4L2_WHITE_BALANCE_FLUORESCENT,   REG_AWB_MODE_FLUORESCENT1 },
+		{ V4L2_WHITE_BALANCE_FLUORESCENT_H, REG_AWB_MODE_FLUORESCENT2 },
+		{ V4L2_WHITE_BALANCE_CLOUDY,        REG_AWB_MODE_CLOUDY },
+		{ V4L2_WHITE_BALANCE_DAYLIGHT,      REG_AWB_MODE_DAYLIGHT },
+		{ V4L2_WHITE_BALANCE_AUTO,          REG_AWB_MODE_AUTO },
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(wb); i++) {
+		if (wb[i][0] != val)
+			continue;
+
+		v4l2_dbg(1, s5c73m3_dbg, &state->subdev,
+			 "Setting white balance to: %s\n",
+			 v4l2_ctrl_get_menu(state->ctrls.auto_wb->id)[i]);
+
+		return s5c73m3_write_cmd(state, REG_AWB_MODE, wb[i][1]);
+	}
+
+	return -EINVAL;
+}
+
+static int s5c73m3_3a_lock(struct s5c73m3 *state, struct v4l2_ctrl *ctrl)
+{
+	bool awb_lock = ctrl->val & V4L2_LOCK_WHITE_BALANCE;
+	bool ae_lock = ctrl->val & V4L2_LOCK_EXPOSURE;
+	int err = 0;
+
+	if ((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_EXPOSURE) {
+		err = s5c73m3_write_cmd(state, REG_AE_CON,
+				ae_lock ? REG_AE_STOP : REG_AE_START);
+		if (err)
+			return err;
+	}
+
+	if (((ctrl->val ^ ctrl->cur.val) & V4L2_LOCK_WHITE_BALANCE)
+	    && state->ctrls.auto_wb->val) {
+		err = s5c73m3_write_cmd(state, REG_AWB_CON,
+			awb_lock ? REG_AWB_STOP : REG_AWB_START);
+	}
+
+	return err;
+}
+
+/* TODO: focus untested */
+
+static int s5c73m3_set_touch_auto_focus(struct s5c73m3 *state)
+{
+	struct v4l2_mbus_framefmt *mf = &state->format[PREVIEW_IDX];
+	struct i2c_client *client = state->i2c_client;
+	int err;
+
+	err = s5c73m3_i2c_write(client, 0xfcfc, 0x3310);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0050, 0x0009);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0054, REG_AF_TOUCH_POSITION);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0f14, state->focus.pos_x);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0f14, state->focus.pos_y);
+	/* FIXME: Find out what this width/height is really for */
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0f14, mf->width);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0f14, mf->height);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0050, 0x0009);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0054, 0x5000);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0f14, 0x0e0a);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0f14, 0x0000);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0054, 0x5080);
+	if (!err)
+		err = s5c73m3_i2c_write(client, 0x0f14, 0x0001);
+
+	return err;
+}
+
+static int s5c73m3_set_auto_focus(struct s5c73m3 *state, int caf)
+{
+	struct v4l2_subdev *sd = &state->subdev;
+	struct s5c73m3_ctrls *ctrls = &state->ctrls;
+	u8 af_mode = 0;
+	int err = 0;
+
+	if (ctrls->af_distance->is_new) {
+		switch (ctrls->af_distance->val) {
+		case V4L2_AUTO_FOCUS_RANGE_MACRO:
+			af_mode = 0;
+			break;
+		case V4L2_AUTO_FOCUS_RANGE_INFINITY:
+			af_mode = 0;
+			break;
+		case V4L2_AUTO_FOCUS_RANGE_NORMAL:
+			af_mode = 0;
+			break;
+		}
+	}
+
+	if (ctrls->af_area->is_new) {
+		if (ctrls->af_area->val == V4L2_AUTO_FOCUS_AREA_SPOT) {
+			v4l2_ctrl_activate(ctrls->af_distance, 0);
+			af_mode = 0;
+		} else {
+			/*
+			 * Activate the auto focus distance control only if
+			 * auto focus area is set to V4L2_AUTO_FOCUS_AREA_ALL
+			 */
+			v4l2_ctrl_activate(ctrls->af_distance, 1);
+		}
+	}
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "af_mode: %#x\n", af_mode);
+
+	if (ctrls->af_area->val == V4L2_AUTO_FOCUS_AREA_SPOT) {
+		err = s5c73m3_set_touch_auto_focus(state);
+		if (err < 0)
+			return err;
+
+		v4l2_dbg(1, s5c73m3_dbg, sd, "Focus position: x: %u, y: %u\n",
+			 state->focus.pos_x, state->focus.pos_y);
+	}
+
+	if (ctrls->af_stop->is_new) {
+		err = 0;
+		if (err < 0)
+			return err;
+		v4l2_dbg(1, s5c73m3_dbg, sd, "Auto focus stopped\n");
+	}
+
+	if (ctrls->af_start->is_new || ctrls->focus_auto->is_new) {
+		/* Start continuous or one-shot auto focusing */
+		err = 0;
+		v4l2_dbg(1, s5c73m3_dbg, sd, "%s auto focus started\n",
+			 caf ? "Continuous" : "One-shot");
+	}
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "af_mode: %#x (%d)\n", af_mode, err);
+
+	return err;
+}
+
+static int s5c73m3_set_contrast(struct s5c73m3 *state, int val)
+{
+	u16 reg = (val < 0) ? -val + 2 : val;
+	return s5c73m3_write_cmd(state, REG_CONTRAST, reg);
+}
+
+static int s5c73m3_set_saturation(struct s5c73m3 *state, int val)
+{
+	u16 reg = (val < 0) ? -val + 2 : val;
+	return s5c73m3_write_cmd(state, REG_SATURATION, reg);
+}
+
+static int s5c73m3_set_sharpness(struct s5c73m3 *state, int val)
+{
+	u16 reg = (val < 0) ? -val + 2 : val;
+	return s5c73m3_write_cmd(state, REG_SHARPNESS, reg);
+}
+
+static int s5c73m3_set_iso(struct s5c73m3 *state, int val)
+{
+	u32 iso;
+
+	if (val == V4L2_ISO_SENSITIVITY_MANUAL)
+		iso = state->ctrls.iso->val + 1;
+	else
+		iso = 0;
+
+	return s5c73m3_write_cmd(state, REG_ISO, iso);
+}
+
+static int s5c73m3_set_stabilization(struct s5c73m3 *state, int val)
+{
+	struct v4l2_subdev *sd = &state->subdev;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "Image stabilization: %d\n", val);
+
+	return s5c73m3_write_cmd(state, REG_AE_MODE, val  ?
+				 REG_AE_MODE_ANTI_SHAKE : REG_AE_MODE_AUTO_SET);
+}
+
+static int s5c73m3_set_still_capture(struct s5c73m3 *state, int on)
+{
+	return 0;
+}
+
+static int s5c73m3_set_jpeg_quality(struct s5c73m3 *state, int quality)
+{
+	int reg;
+
+	if (quality <= 65)
+		reg = REG_IMAGE_QUALITY_NORMAL;
+	else if (quality <= 75)
+		reg = REG_IMAGE_QUALITY_FINE;
+	else
+		reg = REG_IMAGE_QUALITY_SUPERFINE;
+
+	return s5c73m3_write_cmd(state, REG_IMAGE_QUALITY, reg);
+}
+
+static int s5c73m3_set_flash(struct s5c73m3 *state, int val)
+{
+	int err, flash;
+
+	switch (val) {
+	case FLASH_MODE_AUTO:
+		flash = REG_FLASH_MODE_AUTO;
+		break;
+	case FLASH_MODE_ON:
+		flash = REG_FLASH_MODE_ON;
+		break;
+	default:
+		flash = REG_FLASH_MODE_OFF;
+		break;
+	}
+
+	err = s5c73m3_write_cmd(state, REG_FLASH_MODE, flash);
+	if (err)
+		return err;
+	return s5c73m3_write_cmd(state, REG_FLASH_TORCH,
+				 val == FLASH_MODE_TORCH);
+}
+
+static int s5c73m3_set_scene_program(struct s5c73m3 *state, int val)
+{
+	static const unsigned short scene_lookup[] = {
+		REG_SCENE_MODE_NONE,	     /* V4L2_SCENE_MODE_NONE */
+		REG_SCENE_MODE_AGAINST_LIGHT,/* V4L2_SCENE_MODE_BACKLIGHT */
+		REG_SCENE_MODE_BEACH,	     /* V4L2_SCENE_MODE_BEACH_SNOW */
+		REG_SCENE_MODE_CANDLE,	     /* V4L2_SCENE_MODE_CANDLE_LIGHT */
+		REG_SCENE_MODE_DAWN,	     /* V4L2_SCENE_MODE_DAWN_DUSK */
+		REG_SCENE_MODE_FALL,	     /* V4L2_SCENE_MODE_FALL_COLORS */
+		REG_SCENE_MODE_FIRE,	     /* V4L2_SCENE_MODE_FIREWORKS */
+		REG_SCENE_MODE_LANDSCAPE,    /* V4L2_SCENE_MODE_LANDSCAPE */
+		REG_SCENE_MODE_NIGHT,	     /* V4L2_SCENE_MODE_NIGHT */
+		REG_SCENE_MODE_INDOOR,	     /* V4L2_SCENE_MODE_PARTY_INDOOR */
+		REG_SCENE_MODE_PORTRAIT,     /* V4L2_SCENE_MODE_PORTRAIT */
+		REG_SCENE_MODE_SPORTS,	     /* V4L2_SCENE_MODE_SPORTS */
+		REG_SCENE_MODE_SUNSET,	     /* V4L2_SCENE_MODE_SUNSET */
+		REG_SCENE_MODE_TEXT,	     /* V4L2_SCENE_MODE_TEXT */
+	};
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->subdev, "Setting %s scene mode\n",
+		 v4l2_ctrl_get_menu(state->ctrls.scene_mode->id)[val]);
+
+	return s5c73m3_write_cmd(state, REG_SCENE_MODE, scene_lookup[val]);
+}
+
+static int s5c73m3_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
+	/* struct i2c_client *client = v4l2_get_subdevdata(sd); */
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	int err = 0;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "ctrl: 0x%x, value: %d\n",
+		 ctrl->id, ctrl->val);
+
+	mutex_lock(&state->lock);
+	/*
+	 * If the device is not powered up by the host driver do
+	 * not apply any controls to H/W at this time. Instead
+	 * the controls will be restored right after power-up.
+	 */
+	if (state->power == 0)
+		goto unlock;
+
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		return -EINVAL;
+
+	switch (ctrl->id) {
+	case V4L2_CID_3A_LOCK:
+		err = s5c73m3_3a_lock(state, ctrl);
+		break;
+
+	case V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE:
+		err = s5c73m3_set_white_balance(state, ctrl->val);
+		break;
+
+	case V4L2_CID_CONTRAST:
+		err = s5c73m3_set_contrast(state, ctrl->val);
+		break;
+
+	case V4L2_CID_COLORFX:
+		err = s5c73m3_set_colorfx(state, ctrl->val);
+		break;
+
+	case V4L2_CID_EXPOSURE_AUTO:
+		err = s5c73m3_set_exposure(state, ctrl->val);
+		break;
+
+	case V4L2_CID_FLASH_MODE:
+		err = s5c73m3_set_flash(state, ctrl->val);
+		break;
+
+	case V4L2_CID_FOCUS_AUTO:
+		err = s5c73m3_set_auto_focus(state, ctrl->val);
+		break;
+
+	case V4L2_CID_IMAGE_STABILIZATION:
+		err = s5c73m3_set_stabilization(state, ctrl->val);
+		break;
+
+	case V4L2_CID_ISO_SENSITIVITY:
+		err = s5c73m3_set_iso(state, ctrl->val);
+		break;
+
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		err = s5c73m3_set_jpeg_quality(state, ctrl->val);
+		break;
+
+	case V4L2_CID_SATURATION:
+		err = s5c73m3_set_saturation(state, ctrl->val);
+		break;
+
+	case V4L2_CID_SCENE_MODE:
+		err = s5c73m3_set_scene_program(state, ctrl->val);
+		break;
+
+	case V4L2_CID_SHARPNESS:
+		err = s5c73m3_set_sharpness(state, ctrl->val);
+		break;
+
+	case V4L2_CID_SNAPSHOT:
+		err = s5c73m3_set_still_capture(state, ctrl->val);
+		break;
+
+	case V4L2_CID_WIDE_DYNAMIC_RANGE:
+		err = s5c73m3_write_cmd(state, REG_WDR, !!ctrl->val);
+		break;
+
+	case V4L2_CID_ZOOM_ABSOLUTE:
+		err = s5c73m3_write_cmd(state, REG_ZOOM_STEP, ctrl->val);
+		break;
+	}
+unlock:
+	mutex_unlock(&state->lock);
+	return err;
+}
+
+static const struct v4l2_ctrl_ops s5c73m3_ctrl_ops = {
+	.g_volatile_ctrl	= s5c73m3_g_volatile_ctrl,
+	.s_ctrl			= s5c73m3_s_ctrl,
+};
+
+static const char * const s5c73m3_flash_mode_menu[] = {
+	"Off", "Auto", "On", "Torch",
+};
+
+static const char * const s5c73m3_capture_ctx_menu[] = {
+	"Preview", "Still", "Camcorder",
+};
+
+static const struct v4l2_ctrl_config s5c73m3_ctrls[] = {
+	[0] = {
+		.ops = &s5c73m3_ctrl_ops,
+		.id = V4L2_CID_FIRMWARE_VERSION,
+		.type = V4L2_CTRL_TYPE_STRING,
+		.name = "Firmware version",
+		.min = 2,
+		.max = 128,
+		.step = 1,
+	},
+	[1] = {
+		.ops = &s5c73m3_ctrl_ops,
+		.id = V4L2_CID_CAPTURE_CTX,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "Capture Context",
+		.max = ARRAY_SIZE(s5c73m3_capture_ctx_menu) - 1,
+		.qmenu = s5c73m3_capture_ctx_menu,
+		.def = V4L2_CAPTURE_CTX_PREVIEW,
+	},
+	[2] = {
+		.ops = &s5c73m3_ctrl_ops,
+		.id = V4L2_CID_SNAPSHOT,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.name = "Snapshot",
+		.max = 1,
+		.step = 1,
+	},
+	[3] = {
+		.ops = &s5c73m3_ctrl_ops,
+		.id = V4L2_CID_FLASH_MODE,
+		.type = V4L2_CTRL_TYPE_MENU,
+		.name = "Flash Mode",
+		.max = ARRAY_SIZE(s5c73m3_flash_mode_menu) - 1,
+		.qmenu = s5c73m3_flash_mode_menu,
+	},
+};
+
+/* Supported manual ISO values */
+static const s64 iso_qmenu[] = {
+	/* REG_ISO: 0x0001...0x0004 */
+	100, 200, 400, 800,
+};
+
+/* Supported exposure bias values (-2.0EV...+2.0EV) */
+static const s64 ev_bias_qmenu[] = {
+	/* REG_EV: 0x0000...0x0008 */
+	-2000, -1500, -1000, -500, 0, 500, 1000, 1500, 2000
+};
+
+int s5c73m3_init_controls(struct s5c73m3 *state)
+{
+	const struct v4l2_ctrl_ops *ops = &s5c73m3_ctrl_ops;
+	struct s5c73m3_ctrls *ctrls = &state->ctrls;
+	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
+
+	int err = v4l2_ctrl_handler_init(hdl, 26);
+	if (err)
+		return err;
+
+	/* White balance */
+	ctrls->auto_wb = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
+			9, ~0x15e, V4L2_WHITE_BALANCE_AUTO);
+
+	/* Exposure (only automatic exposure) */
+	ctrls->auto_exposure = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_EXPOSURE_AUTO, 0, ~0x01, V4L2_EXPOSURE_AUTO);
+
+	ctrls->exposure_bias = v4l2_ctrl_new_std_int_menu(hdl, ops,
+			V4L2_CID_AUTO_EXPOSURE_BIAS,
+			ARRAY_SIZE(ev_bias_qmenu) - 1,
+			ARRAY_SIZE(ev_bias_qmenu)/2 - 1,
+			ev_bias_qmenu);
+
+	ctrls->exposure_metering = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_EXPOSURE_METERING,
+			2, ~0x7, V4L2_EXPOSURE_METERING_AVERAGE);
+
+	/* Auto focus */
+	ctrls->focus_auto = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_FOCUS_AUTO, 0, 1, 1, 0);
+
+	ctrls->af_start = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_START, 0, 1, 1, 0);
+
+	ctrls->af_stop = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_STOP, 0, 1, 1, 0);
+
+	ctrls->af_status = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_STATUS, 0, 0x07, 0, 0);
+
+	ctrls->af_distance = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_RANGE, 2, ~0x1,
+			V4L2_AUTO_FOCUS_RANGE_NORMAL);
+
+	/* whole frame and spot */
+	ctrls->af_area = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_AUTO_FOCUS_AREA, 1, ~0x03,
+			V4L2_AUTO_FOCUS_AREA_ALL);
+
+	/* ISO sensitivity */
+	ctrls->auto_iso = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_ISO_SENSITIVITY_AUTO, 1, 0,
+			V4L2_ISO_SENSITIVITY_AUTO);
+
+	ctrls->iso = v4l2_ctrl_new_std_int_menu(hdl, ops,
+			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
+			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
+
+	ctrls->contrast = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_CONTRAST, -2, 2, 1, 0);
+
+	ctrls->saturation = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_SATURATION, -2, 2, 1, 0);
+
+	ctrls->sharpness = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_SHARPNESS, -2, 2, 1, 0);
+
+	ctrls->zoom = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_ZOOM_ABSOLUTE, 0, 30, 1, 0);
+
+	ctrls->colorfx = v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_COLORFX,
+			V4L2_COLORFX_AQUA, ~0x40f, V4L2_COLORFX_NONE);
+
+	ctrls->wdr = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_WIDE_DYNAMIC_RANGE, 0, 1, 1, 0);
+
+	ctrls->stabilization = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_IMAGE_STABILIZATION, 0, 1, 1, 0);
+
+	ctrls->jpeg_quality = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY, 1, 100, 1, 80);
+
+	ctrls->scene_mode = v4l2_ctrl_new_std_menu(hdl, ops,
+			V4L2_CID_SCENE_MODE, V4L2_SCENE_MODE_TEXT, ~0x3fff,
+			V4L2_SCENE_MODE_NONE);
+
+	ctrls->ae_awb_lock = v4l2_ctrl_new_std(hdl, ops,
+			V4L2_CID_3A_LOCK, 0, 0x7, 0, 0);
+
+	v4l2_ctrl_new_custom(hdl, &s5c73m3_ctrls[0], NULL);
+	ctrls->capture_ctx = v4l2_ctrl_new_custom(hdl, &s5c73m3_ctrls[1], NULL);
+	ctrls->snapshot = v4l2_ctrl_new_custom(hdl, &s5c73m3_ctrls[2], NULL);
+	ctrls->flash_mode = v4l2_ctrl_new_custom(hdl, &s5c73m3_ctrls[3], NULL);
+
+	if (hdl->error) {
+		err = hdl->error;
+		v4l2_ctrl_handler_free(hdl);
+		return err;
+	}
+
+	v4l2_ctrl_auto_cluster(3, &ctrls->auto_exposure, 0, false);
+	ctrls->auto_iso->flags |= V4L2_CTRL_FLAG_VOLATILE |
+				V4L2_CTRL_FLAG_UPDATE;
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_iso, 0, false);
+	v4l2_ctrl_auto_cluster(2, &ctrls->auto_wb, 0, false);
+	ctrls->af_status->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	v4l2_ctrl_cluster(6, &ctrls->focus_auto);
+
+	state->subdev.ctrl_handler = hdl;
+
+	return 0;
+}
diff --git a/drivers/media/video/s5c73m3/s5c73m3-spi.c b/drivers/media/video/s5c73m3/s5c73m3-spi.c
new file mode 100644
index 0000000..50c915e
--- /dev/null
+++ b/drivers/media/video/s5c73m3/s5c73m3-spi.c
@@ -0,0 +1,126 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <asm/sizes.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/media.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include "s5c73m3.h"
+
+#define S5C73M3_SPI_DRV_NAME "S5C73M3-SPI"
+
+/*
+ * SPI driver
+ */
+static int spi_xmit(struct spi_device *spi_dev, const void *addr, const int len)
+{
+	struct spi_message msg;
+	int r;
+	struct spi_transfer xfer = {
+		.tx_buf	= addr,
+		.len	= len,
+	};
+
+	if (spi_dev == NULL) {
+		dev_err(&spi_dev->dev, "SPI device is uninitialized\n");
+		return -ENODEV;
+	}
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	r = spi_sync(spi_dev, &msg);
+	if (r < 0)
+		dev_err(&spi_dev->dev, "%s spi_sync failed %d\n", __func__, r);
+
+	return r;
+}
+
+int s5c73m3_spi_write(struct s5c73m3 *state, const void *addr,
+		      const unsigned int len, const unsigned int tx_size)
+{
+	struct spi_device *spi_dev = state->spi_dev;
+	u32 count = len / tx_size;
+	u32 extra = len % tx_size;
+	unsigned int i, j = 0;
+	u8 padding[32];
+	int r = 0;
+
+	memset(padding, 0, sizeof(padding));
+
+	for (i = 0; i < count ; i++) {
+		r = spi_xmit(spi_dev, addr + j, tx_size);
+		if (r < 0)
+			return r;
+		j += tx_size;
+	}
+
+	if (extra > 0) {
+		r = spi_xmit(spi_dev, addr + j, extra);
+		if (r < 0)
+			return r;
+	}
+
+	return spi_xmit(spi_dev, padding, sizeof(padding));
+}
+
+static int __devinit s5c73m3_spi_probe(struct spi_device *spi)
+{
+	int r;
+	struct s5c73m3 *state = container_of(spi->dev.driver, struct s5c73m3,
+					     spidrv.driver);
+	spi->bits_per_word = 32;
+
+	r = spi_setup(spi);
+	if (r < 0) {
+		dev_err(&spi->dev, "spi_setup() failed\n");
+		return r;
+	}
+
+	mutex_lock(&state->lock);
+	state->spi_dev = spi;
+	mutex_unlock(&state->lock);
+
+	v4l2_info(&state->subdev, "S5C73M3 SPI probed successfully\n");
+	return 0;
+}
+
+static int __devexit s5c73m3_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+
+int s5c73m3_register_spi_driver(struct s5c73m3 *state)
+{
+	struct spi_driver *spidrv = &state->spidrv;
+
+	spidrv->remove = __devexit_p(s5c73m3_spi_remove);
+	spidrv->probe = s5c73m3_spi_probe;
+	spidrv->driver.name = S5C73M3_SPI_DRV_NAME;
+	spidrv->driver.bus = &spi_bus_type;
+	spidrv->driver.owner = THIS_MODULE;
+
+	return spi_register_driver(spidrv);
+}
+
+void s5c73m3_unregister_spi_driver(struct s5c73m3 *state)
+{
+	spi_unregister_driver(&state->spidrv);
+}
diff --git a/drivers/media/video/s5c73m3/s5c73m3.c b/drivers/media/video/s5c73m3/s5c73m3.c
new file mode 100644
index 0000000..d7ce0d7
--- /dev/null
+++ b/drivers/media/video/s5c73m3/s5c73m3.c
@@ -0,0 +1,1243 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#define pr_fmt(fmt) "%s:%d " fmt, __func__, __LINE__
+
+#include <asm/sizes.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/media.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+#include <linux/videodev2.h>
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5c73m3.h>
+
+#include "s5c73m3.h"
+
+int s5c73m3_dbg = 3;
+module_param_named(debug, s5c73m3_dbg, int, 0644);
+
+static int inc_fw_index;
+module_param(inc_fw_index, int, 0644);
+
+static const char * const s5c73m3_supply_names[S5C73M3_MAX_SUPPLIES] = {
+	"VDD_INT",	/* Digital Core supply (1.2V), CAM_ISP_CORE_1.2V */
+	"VDDA",		/* Analog Core supply (1.2V), CAM_SENSOR_CORE_1.2V */
+	"VDD_REG",	/* Regulator input supply (2.8V), CAM_SENSOR_A2.8V */
+	"VDDIO_HOST",	/* Digital Host I/O power supply (1.8V...2.8V),
+			   CAM_ISP_SENSOR_1.8V */
+	"VDDIO_CIS",	/* Digital CIS I/O power (1.2V...1.8V),
+			   CAM_ISP_MIPI_1.2V */
+	"VDD_AF",	/* Lens, CAM_AF_2.8V */
+};
+
+static const char *firmware_files[] = {
+	"SlimISP.bin",
+	"SlimISP_OA.bin",
+/*	"SlimISP_OB.bin",
+	"SlimISP_OD.bin",
+	"SlimISP_SC.bin",
+	"SlimISP_SD.bin",
+	"SlimISP_GC.bin",
+	"SlimISP_GD.bin",
+	"SlimISP_GE.bin",
+	"SlimISP_GF.bin",
+	"SlimISP_ZC.bin",
+	"SlimISP_ZD.bin",
+	"SlimISP_ZE.bin",
+	"SlimISP_ZF.bin",
+*/
+};
+
+static const struct s5c73m3_frame_size s5c73m3_video_resolutions[] = {
+	{ 320,	240,	0x01, 0 },
+	{ 400,	300,	0x02, 0 },
+	{ 640,	480,	0x03, 0 },
+	{ 800,	600,	0x04, 0 },
+	{ 960,	720,	0x05, 0 },
+	{ 1280,	720,	0x06, 1 },
+	{ 1280,	960,	0x07, 1 },
+	{ 1600,	1200,	0x08, 1 },
+	{ 1632,	1224,	0x09, 1 },
+	{ 1920,	1080,	0x0a, 1 },
+	{ 1920,	1440,	0x0b, 1 },
+	{ 2304,	1296,	0x0c, 1 },
+	{ 2304,	1728,	0x0d, 1 },
+};
+
+static const struct s5c73m3_frame_size s5c73m3_snapshot_resolutions[] = {
+	{ 640,	480,	0x10, 0 },
+	{ 1280,	720,	0x40, 0 },
+	{ 1600,	1200,	0x70, 1 },
+	{ 2048,	1152,	0x80, 0 },
+	{ 2048,	1536,	0x90, 0 },
+	{ 3264,	2304,	0xe0, 0 },
+	{ 3264,	2448,	0xf0, 0 },
+};
+
+struct s5c73m3_regval {
+	u16 addr;
+	u16 val;
+};
+
+static const struct s5c73m3_pixfmt s5c73m3_formats[] = {
+	{
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+	}, {
+		.code		= V4L2_MBUS_FMT_JPEG_1X8,
+		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.mipi_data_type	= 1,
+	},
+};
+
+static const struct s5c73m3_interval s5c73m3_intervals[] = {
+	/* TODO: update pixel resolutions corresponding to the frame rates */
+	{ REG_AE_MODE_FIXED_7FPS, {142857, 1000000}, {1280, 1024} }, /* 7 fps */
+	{ REG_AE_MODE_FIXED_15FPS, {66667, 1000000}, {1280, 1024} }, /* 15 fps */
+	{ REG_AE_MODE_FIXED_20FPS, {50000, 1000000}, {1280, 720} },  /* 20 fps */
+	{ REG_AE_MODE_FIXED_30FPS, {33333, 1000000}, {640, 480} },   /* 30 fps */
+	{ REG_AE_MODE_FIXED_120FPS, {8333, 1000000}, {640, 480} },   /* 120 fps */
+};
+
+#define S5C73M3_DEFAULT_FRAME_INTERVAL 3 /* 30 fps */
+
+static inline bool is_user_defined_dt(enum v4l2_mbus_pixelcode code)
+{
+	return code == V4L2_MBUS_FMT_JPEG_1X8;
+}
+
+static void s5c73m3_fill_mbus_fmt(struct v4l2_mbus_framefmt *mf,
+				  const struct s5c73m3_frame_size *fs,
+				  u32 code)
+{
+	mf->width = fs->width;
+	mf->height = fs->height;
+	mf->code = code;
+	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mf->field = V4L2_FIELD_NONE;
+}
+
+int s5c73m3_i2c_write(struct i2c_client *client, u16 addr, u16 data)
+{
+	u8 buf[4] = { addr >> 8, addr & 0xff, data >> 8, data & 0xff };
+
+	int ret = i2c_master_send(client, buf, sizeof(buf));
+
+	v4l_dbg(4, s5c73m3_dbg, client, "%s: addr 0x%04x, data 0x%04x\n",
+		 __func__, addr, data);
+
+	if (ret == 4)
+		return 0;
+
+	return ret < 0 ? ret : -EREMOTEIO;
+}
+
+static int s5c73m3_i2c_bulk_write(struct i2c_client *client, const u32 *regs)
+{
+	int i, ret = 0;
+
+	for (i = 0; regs[i] != S5C73M3_ARRAY_END && !ret; i++)
+		ret = s5c73m3_i2c_write(client, regs[i] >> 16, regs[i]);
+
+	return ret;
+}
+
+static int s5c73m3_i2c_read(struct i2c_client *client, u16 addr, u16 *data)
+{
+	int ret;
+	u8 rbuf[2], wbuf[2] = { addr >> 8, addr & 0xff };
+	struct i2c_msg msg[2] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = sizeof(wbuf),
+			.buf = wbuf
+		}, {
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = sizeof(rbuf),
+			.buf = rbuf
+		}
+	};
+	/*
+	 * Issue repeated START after writing 2 address bytes and
+	 * just one STOP only after reading the data bytes.
+	 */
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret == 2) {
+		*data = be16_to_cpup((u16 *)rbuf);
+		v4l2_dbg(4, s5c73m3_dbg, client,
+			 "%s: addr: 0x%04x, data: 0x%04x\n",
+			 __func__, addr, *data);
+		return 0;
+	}
+
+	v4l2_err(client, "I2C read failed: addr: %04x, (%d)\n", addr, ret);
+
+	return ret >= 0 ? -EREMOTEIO : ret;
+}
+
+static int s5c73m3_write(struct i2c_client *client, u32 addr, u16 data)
+{
+	int ret;
+
+	ret = s5c73m3_i2c_write(client, REG_CMDWR_ADDRH, addr >> 16);
+	if (ret < 0)
+		return ret;
+
+	ret = s5c73m3_i2c_write(client, REG_CMDWR_ADDRL, addr & 0xffff);
+	if (ret < 0)
+		return ret;
+
+	return s5c73m3_i2c_write(client, REG_CMDBUF_ADDR, data);
+}
+
+int s5c73m3_read(struct i2c_client *client, u32 addr, u16 *data)
+{
+	int ret;
+
+	ret = s5c73m3_i2c_write(client, AHB_MSB_ADDR_PTR, 0x3310);
+	if (ret < 0)
+		return ret;
+
+	ret = s5c73m3_i2c_write(client, REG_CMDRD_ADDRH, addr >> 16);
+	if (ret < 0)
+		return ret;
+
+	ret = s5c73m3_i2c_write(client, REG_CMDRD_ADDRL, addr & 0xffff);
+	if (ret < 0)
+		return ret;
+
+	return s5c73m3_i2c_read(client, REG_CMDBUF_ADDR, data);
+}
+
+static int s5c73m3_check_status(struct s5c73m3 *state, unsigned int value)
+{
+	unsigned long end = jiffies + msecs_to_jiffies(500);
+	int ret = 0;
+	u16 status;
+
+	while (time_is_after_jiffies(end)) {
+		ret = s5c73m3_read(state->i2c_client, 0x00095080, &status);
+		if (ret < 0)
+			return ret;
+		if (status == value)
+			return 0;
+		usleep_range(5000, 10000);
+
+		v4l2_dbg(1, s5c73m3_dbg, &state->subdev, "status: %#x\n",
+			 status);
+	}
+
+	return ret < 0 ? ret : -ETIMEDOUT;
+}
+
+int s5c73m3_write_cmd(struct s5c73m3 *state, u32 addr, u16 data)
+{
+	struct i2c_client *client = state->i2c_client;
+	int r;
+
+	r = s5c73m3_check_status(state, 0xffff);
+	if (r < 0)
+		return r;
+
+	r = s5c73m3_i2c_write(client, AHB_MSB_ADDR_PTR, 0x3310);
+	if (r < 0)
+		return r;
+
+	r = s5c73m3_i2c_write(client, REG_CMDWR_ADDRH, 0x0009);
+	if (r < 0)
+		return r;
+
+	r = s5c73m3_i2c_write(client, REG_CMDWR_ADDRL, 0x5000);
+	if (r < 0)
+		return r;
+
+	r = s5c73m3_i2c_write(client, REG_CMDBUF_ADDR, addr & 0xffff);
+	if (r < 0)
+		return r;
+
+	r = s5c73m3_i2c_write(client, REG_CMDBUF_ADDR, data);
+	if (r < 0)
+		return r;
+
+	r = s5c73m3_i2c_write(client, REG_CMDWR_ADDRL, 0x5080);
+	if (r < 0)
+		return r;
+
+	return s5c73m3_i2c_write(client, REG_CMDBUF_ADDR, 0x0001);
+}
+
+static int s5c73m3_set_af_softlanding(struct v4l2_subdev *sd)
+{
+	return 0;
+}
+
+static int s5c73m3_load_fw(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	const struct firmware *fw;
+	int r;
+
+	r = request_firmware(&fw, firmware_files[state->fw_index],
+			     &client->dev);
+	if (r < 0) {
+		v4l2_err(sd, "Firmware request failed (%s)\n",
+			 firmware_files[state->fw_index]);
+		return -EINVAL;
+	}
+	/* TODO: Sanity check on firmware size */
+
+	printk(KERN_CONT "Loading firmware (%s, %d B)...",
+	       firmware_files[state->fw_index], fw->size);
+
+	/* FIXME: Passing tx_size more than 64 leads to an oops */
+	r = s5c73m3_spi_write(state, fw->data, fw->size, 64 /*60 * SZ_1K*/);
+	if (r < 0)
+		v4l2_err(sd, "SPI write failed\n");
+	else
+		printk(KERN_CONT "done.\n");
+
+	release_firmware(fw);
+
+	if (inc_fw_index) {
+		if (++state->fw_index >= ARRAY_SIZE(firmware_files))
+			state->fw_index = 0;
+	}
+
+	return r;
+}
+
+/*
+ * v4l2_subdev video operations
+ */
+
+static int s5c73m3_set_frame_size(struct s5c73m3 *state)
+{
+	const struct s5c73m3_frame_size *prev_size = state->prev_pix_size;
+	unsigned int chg_mode;
+	int r = 0;
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->subdev,
+		 "Preview size: %dx%d, reg_val: 0x%x\n",
+		 prev_size->width, prev_size->height, prev_size->reg_val);
+
+	/* FIXME: */
+	if (state->format[PREVIEW_IDX].code == V4L2_MBUS_FMT_JPEG_1X8)
+		chg_mode = CHG_MODE_INTERLEAVED;
+	else
+		chg_mode = CHG_MODE_YUV;
+
+	chg_mode |= prev_size->reg_val;
+
+	r = s5c73m3_write_cmd(state, REG_CHG_MODE, chg_mode);
+	if (r < 0)
+		return r;
+
+	/* s5c73m3_set_zoom(sd, 0); */
+	return r;
+}
+
+static int s5c73m3_set_frame_rate(struct s5c73m3 *state)
+{
+	int ret;
+
+	/*
+	 *  Image stabilization and frame rate are configured in same register.
+	 *  TODO: handle REG_AE_MODE_AUTO_SET
+	 */
+	if (state->ctrls.stabilization->val)
+		return 0;
+
+	if (WARN_ON(state->fiv == NULL))
+		return -EINVAL;
+
+	ret = s5c73m3_write_cmd(state, REG_AE_MODE, state->fiv->fps_reg);
+	if (!ret)
+		state->apply_fiv = 0;
+
+	return ret;
+}
+
+static int __s5c73m3_s_stream(struct s5c73m3 *state,
+			      struct v4l2_subdev *sd, int on)
+{
+	u16 mode;
+	int ret;
+
+	if (state->apply_fmt) {
+		/* FIXME: */
+		if (state->format[PREVIEW_IDX].code == V4L2_MBUS_FMT_JPEG_1X8)
+			mode = REG_IMG_OUTPUT_INTERLEAVED;
+		else
+			mode = REG_IMG_OUTPUT_YUV;
+
+		ret = s5c73m3_write_cmd(state, REG_IMG_OUTPUT, mode);
+		if (!ret)
+			ret = s5c73m3_set_frame_size(state);
+		if (ret)
+			return ret;
+		state->apply_fmt = 0;
+	}
+
+	switch (state->ctrls.capture_ctx->val) {
+	case V4L2_CAPTURE_CTX_PREVIEW:
+		v4l2_info(sd, "preview %s\n", on ? "on" : "off");
+		/* TODO: */
+		break;
+	case V4L2_CAPTURE_CTX_STILL:
+		v4l2_info(sd, "still capture %s\n", on ? "on" : "off");
+		/* TODO: */
+		break;
+	case V4L2_CAPTURE_CTX_CAMCORDER:
+		/* TODO: */
+		break;
+	}
+
+	ret = s5c73m3_write_cmd(state, REG_SENSOR_STREAMING, !!on);
+	if (ret || !on)
+		return ret;
+
+	ret = s5c73m3_check_status(state, 0xffff);
+	if (ret)
+		return ret;
+	/* if (state->apply_fiv) */
+		/* ret = s5c73m3_set_frame_rate(state); */
+
+	return ret;
+}
+
+static int s5c73m3_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	int ret;
+
+	mutex_lock(&state->lock);
+	ret = __s5c73m3_s_stream(state, sd, on);
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5c73m3_system_status_wait(struct s5c73m3 *state, u32 value,
+				      unsigned int delay, unsigned int steps)
+{
+	u16 reg = 0;
+
+	while (steps-- > 0) {
+		int ret = s5c73m3_read(state->i2c_client, 0x30100010, &reg);
+		if (ret < 0)
+			return ret;
+		if (reg == value)
+			return 0;
+		usleep_range(delay, delay + 25);
+	}
+	return -ETIMEDOUT;
+}
+
+static int s5c73m3_spi_boot(struct s5c73m3 *state, bool load_fw)
+{
+	struct i2c_client *client = state->i2c_client;
+	struct v4l2_subdev *sd = &state->subdev;
+	u16 sensor_fw;
+	int i, r;
+
+	/* Run ARM MCU */
+	r = s5c73m3_write(client, 0x30000004, 0xffff);
+	if (r < 0)
+		return r;
+
+	usleep_range(400, 500);
+
+	/* Check booting status */
+	r = s5c73m3_system_status_wait(state, 0x0c, 4, 150);
+	if (r < 0) {
+		v4l2_err(sd, "Booting failed: %d\n", r);
+		return r;
+	}
+
+	/* P,M,S and Boot Mode */
+	r = s5c73m3_write(client, 0x30100014, 0x2146);
+	if (r < 0)
+		return r;
+
+	r = s5c73m3_write(client, 0x30100010, 0x210c);
+	if (r < 0)
+		return r;
+
+	usleep_range(200, 250);
+
+	/* Check SPI status */
+	r = s5c73m3_system_status_wait(state, 0x210d, 60, 5000);
+	if (r < 0) {
+		v4l2_err(sd, "SPI not ready: %d\n", r);
+		return r;
+	}
+
+	/* Firmware download over SPI */
+	if (load_fw)
+		s5c73m3_load_fw(sd);
+
+	/* MCU reset */
+	r = s5c73m3_write(client, 0x30000004, 0xfffd);
+	if (r < 0)
+		return r;
+
+	/* Remap */
+	r = s5c73m3_write(client, 0x301000a4, 0x0183);
+	if (r < 0)
+		return r;
+
+	/* MCU restart */
+	r = s5c73m3_write(client, 0x30000004, 0xffff);
+
+	if (r < 0 || !load_fw)
+		return r;
+
+	for (i = 0; i < 3; i++) {
+		r = s5c73m3_read(client, 0x00000060 + i * 2, &sensor_fw);
+		if (r < 0)
+			return r;
+		state->sensor_fw[i * 2] = sensor_fw & 0xff;
+		state->sensor_fw[i * 2 + 1] = (sensor_fw >> 8) & 0xff;
+	}
+	state->sensor_fw[i * 2 + 2] = '\0';
+
+	v4l2_info(sd, "Sensor version: %s\n", state->sensor_fw);
+	return r;
+}
+
+static int s5c73m3_isp_init(struct s5c73m3 *state)
+{
+	struct i2c_client *client = state->i2c_client;
+	int ret;
+	static const u32 init_regs[] = {
+		0x00500009,
+		0x00545000,
+		0x0f140B08,
+		0x0f140000,
+		0x0f140900,
+		0x0f140403, /*640MHz*/
+		0x00545080,
+		0x0f140002,
+		S5C73M3_ARRAY_END
+	};
+
+	ret = s5c73m3_spi_boot(state, true);
+	if (ret < 0)
+		return ret;
+
+	return s5c73m3_i2c_bulk_write(client, init_regs);
+}
+
+static const struct s5c73m3_pixfmt *s5c73m3_get_pixfmt(
+				struct v4l2_mbus_framefmt *mf)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(s5c73m3_formats); i++) {
+		if (mf->colorspace == s5c73m3_formats[i].colorspace &&
+		    mf->code == s5c73m3_formats[i].code)
+			return &s5c73m3_formats[i];
+	}
+
+	return &s5c73m3_formats[0];
+}
+
+static int s5c73m3_try_format(struct s5c73m3 *state,
+			      struct v4l2_mbus_framefmt *mf,
+			      const struct s5c73m3_frame_size **fs,
+			      int op_mode)
+{
+	unsigned int i, min_err = UINT_MAX;
+	const struct s5c73m3_frame_size
+		*fsize = state->pix_sizes[op_mode],
+		*match = NULL;
+	const struct s5c73m3_pixfmt *pixfmt;
+
+	for (i = 0; i < state->pix_sizes_len[op_mode]; i++) {
+		int err;
+		err = abs(fsize->width - mf->width)
+			  + abs(fsize->height - mf->height);
+
+		if (err < min_err) {
+			min_err = err;
+			match = fsize;
+		}
+		fsize++;
+	}
+
+	if (match == NULL)
+		return -EINVAL;
+	if (fs)
+		*fs = match;
+
+	pixfmt = s5c73m3_get_pixfmt(mf);
+
+	s5c73m3_fill_mbus_fmt(mf, match, pixfmt->code);
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->subdev, "%dx%d, code: %#x\n",
+		 match->width, match->height, pixfmt->code);
+
+	return 0;
+}
+
+/*
+ * V4L2 subdev pad level and video operations
+ */
+
+static int s5c73m3_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *fi)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+
+	mutex_lock(&state->lock);
+	fi->interval = state->fiv->interval;
+	mutex_unlock(&state->lock);
+
+	return 0;
+}
+
+static int __s5c73m3_set_frame_interval(struct s5c73m3 *state,
+					struct v4l2_subdev_frame_interval *fi)
+{
+	const struct s5c73m3_frame_size *prev_size = state->prev_pix_size;
+	const struct s5c73m3_interval *fiv = &s5c73m3_intervals[0];
+	unsigned int err, min_err = UINT_MAX;
+	unsigned int i, fr_time;
+
+	if (fi->interval.denominator == 0)
+		return -EINVAL;
+
+	/* Frame interval in ms */
+	fr_time = fi->interval.numerator * 1000 / fi->interval.denominator;
+
+	for (i = 0; i < ARRAY_SIZE(s5c73m3_intervals); i++) {
+		const struct s5c73m3_interval *iv = &s5c73m3_intervals[i];
+
+		if (prev_size->width > iv->size.width ||
+		    prev_size->height > iv->size.height)
+			continue;
+
+		err = abs(iv->interval.numerator / 10000 - fr_time);
+		if (err < min_err) {
+			fiv = iv;
+			min_err = err;
+		}
+	}
+	state->fiv = fiv;
+
+	v4l2_dbg(1, s5c73m3_dbg, &state->subdev,
+		 "Changed frame interval to %u us\n", fiv->interval.numerator);
+	return 0;
+}
+
+static int s5c73m3_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *fi)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	int ret;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "Setting %d/%d frame interval\n",
+		 fi->interval.numerator, fi->interval.denominator);
+
+	mutex_lock(&state->lock);
+
+	ret = __s5c73m3_set_frame_interval(state, fi);
+	if (!ret) {
+		if (state->streaming)
+			ret = s5c73m3_set_frame_rate(state);
+		else
+			state->apply_fiv = 1;
+	}
+	mutex_unlock(&state->lock);
+	return ret;
+}
+
+static int s5c73m3_enum_frame_interval(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_frame_interval_enum *fie)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	const struct s5c73m3_interval *fi;
+	int ret = 0;
+
+	if (fie->index > ARRAY_SIZE(s5c73m3_intervals))
+		return -EINVAL;
+
+	v4l_bound_align_image(&fie->width, S5C73M3_WIN_WIDTH_MIN,
+			      S5C73M3_WIN_WIDTH_MAX, 1,
+			      &fie->height, S5C73M3_WIN_HEIGHT_MIN,
+			      S5C73M3_WIN_HEIGHT_MAX, 1, 0);
+
+	mutex_lock(&state->lock);
+	fi = &s5c73m3_intervals[fie->index];
+	if (fie->width > fi->size.width || fie->height > fi->size.height)
+		ret = -EINVAL;
+	else
+		fie->interval = fi->interval;
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5c73m3_get_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	struct v4l2_mbus_framefmt *mf;
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, 0);
+		fmt->format = *mf;
+		return 0;
+	}
+	mutex_lock(&state->lock);
+
+	if (fmt->pad == S5C73M3_OUTIF_SOURCE_PAD)
+		fmt->format = state->format[PREVIEW_IDX];
+	else
+		fmt->format = state->format[CAPTURE_IDX];
+
+	mutex_unlock(&state->lock);
+	return 0;
+}
+
+static int s5c73m3_set_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	const struct s5c73m3_frame_size *frame_size = NULL;
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	struct v4l2_mbus_framefmt *mf;
+	int idx, ret = 0;
+
+	mutex_lock(&state->lock);
+
+	if (fmt->pad == S5C73M3_OUTIF_SOURCE_PAD)
+		idx = PREVIEW_IDX;
+	else
+		idx = CAPTURE_IDX;
+	s5c73m3_try_format(state, &fmt->format, &frame_size, idx);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+	} else {
+		if (state->streaming && idx != PREVIEW_IDX) {
+			ret = -EBUSY;
+		} else {
+			mf = &state->format[idx];
+			/* if (!state->power) */
+				state->apply_fmt = 1;
+		}
+	}
+	if (!ret && mf) {
+		*mf = fmt->format;
+		if (frame_size) {
+			state->prev_pix_size = frame_size;
+			/* if (state->power) */
+			/*	ret = s5c73m3_set_frame_size(state); */
+		}
+
+		v4l2_dbg(1, s5c73m3_dbg, sd, "%s: %dx%d, code: 0x%x\n",
+			 __func__, mf->width, mf->height, mf->code);
+	}
+
+	pr_info("reg_val: 0x%x\n", state->prev_pix_size->reg_val);
+
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5c73m3_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(s5c73m3_formats))
+		return -EINVAL;
+
+	code->code = s5c73m3_formats[code->index].code;
+	return 0;
+}
+
+static int s5c73m3_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	int i = ARRAY_SIZE(s5c73m3_formats);
+	int idx;
+
+	while (--i)
+		if (fse->code == s5c73m3_formats[i].code)
+			break;
+
+	fse->code = s5c73m3_formats[i].code;
+
+	/* FIXME: need to select pixel resolution list differently */
+	if (fse->code == V4L2_MBUS_FMT_JPEG_1X8)
+		idx = CAPTURE_IDX;
+	else
+		idx = PREVIEW_IDX;
+
+	if (fse->index >= state->pix_sizes_len[idx])
+		return -EINVAL;
+
+	fse->min_width  = state->pix_sizes[idx][fse->index].width;
+	fse->max_width  = fse->min_width;
+	fse->max_height = state->pix_sizes[idx][fse->index].height;
+	fse->min_height = fse->max_height;
+
+	return 0;
+}
+
+static int s5c73m3_set_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	struct v4l2_mbus_framefmt *mf = &state->format[PREVIEW_IDX];
+	struct v4l2_rect *r = &sel->r;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: (%d,%d) %dx%d, %#x\n", __func__,
+		 r->left, r->top, r->width, r->height, sel->target);
+
+	if (sel->target != V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL) {
+		v4l2_err(sd, "Unsupported selection target: %#x", sel->target);
+		return -EINVAL;
+	}
+
+	r->left = clamp_t(s32, r->left, 0, mf->width);
+	r->top = clamp_t(s32, r->top, 0, mf->height);
+	r->width = 0;
+	r->height = 0;
+
+	state->focus.pos_x = r->left;
+	state->focus.pos_y = r->top;
+
+	return 0;
+}
+
+static int s5c73m3_get_selection(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_selection *sel)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	struct v4l2_mbus_framefmt *mf = &state->format[PREVIEW_IDX];
+
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL:
+		sel->r.left = state->focus.pos_x;
+		sel->r.top = state->focus.pos_y;
+		break;
+	case V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_BOUNDS:
+		sel->r.width = mf->width;
+		sel->r.height = mf->height;
+		sel->r.left = 0;
+		sel->r.top = 0;
+		break;
+	default:
+		v4l2_err(sd, "Unsupported selection target: %#x", sel->target);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int s5c73m3_log_status(struct v4l2_subdev *sd)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+
+	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
+
+	v4l2_info(sd, "power: %d, apply_fmt: %d, apply_ctrls: %d\n",
+		  state->power, state->apply_fmt, state->apply_ctrls);
+
+	return 0;
+}
+
+/*
+ * V4L2 subdev internal operations
+ */
+static int s5c73m3_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+
+	if (state->fw_error) {
+		v4l2_err(sd, "Wrong firmware state\n");
+		return -ENXIO;
+	}
+
+	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_video_resolutions[0],
+			      s5c73m3_formats[0].code);
+	return 0;
+}
+
+static int s5c73m3_gpio_set_value(struct s5c73m3 *priv, int id, u32 val)
+{
+	if (!gpio_is_valid(priv->gpio[id].gpio))
+		return 0;
+	gpio_set_value(priv->gpio[id].gpio, !!val);
+	return 1;
+}
+
+static int s5c73m3_gpio_assert(struct s5c73m3 *priv, int id)
+{
+	return s5c73m3_gpio_set_value(priv, id, priv->gpio[id].level);
+}
+
+static int s5c73m3_gpio_deassert(struct s5c73m3 *priv, int id)
+{
+	return s5c73m3_gpio_set_value(priv, id, !priv->gpio[id].level);
+}
+
+static int __s5c73m3_power_on(struct s5c73m3 *state)
+{
+	int i, ret;
+
+	for (i = 0; i < S5C73M3_MAX_SUPPLIES; i++) {
+		ret = regulator_enable(state->supplies[i].consumer);
+		if (ret)
+			goto err;
+	}
+
+	s5c73m3_gpio_deassert(state, STBY);
+	usleep_range(100, 200);
+
+	s5c73m3_gpio_deassert(state, RST);
+	usleep_range(50, 100);
+
+	return 0;
+err:
+	for (--i; i >= 0; i--)
+		regulator_disable(state->supplies[i].consumer);
+	return ret;
+}
+
+static int __s5c73m3_power_off(struct s5c73m3 *state)
+{
+	int i, ret;
+
+	if (s5c73m3_gpio_assert(state, RST))
+		usleep_range(10, 50);
+
+	if (s5c73m3_gpio_assert(state, STBY))
+		usleep_range(100, 200);
+	state->streaming = 0;
+
+	for (i = S5C73M3_MAX_SUPPLIES - 1; i >= 0; i--) {
+		ret = regulator_disable(state->supplies[i].consumer);
+		if (ret)
+			goto err;
+	}
+	return 0;
+err:
+	for (++i; i < S5C73M3_MAX_SUPPLIES; i++)
+		regulator_enable(state->supplies[i].consumer);
+
+	return ret;
+}
+
+/*
+ * V4L2 subdev core and video operations
+ */
+static int s5c73m3_set_power(struct v4l2_subdev *sd, int on)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	int ret = 0;
+
+	mutex_lock(&state->lock);
+
+	if (on && !on == state->power) {
+		ret = __s5c73m3_power_on(state);
+		if (!ret)
+			ret = s5c73m3_isp_init(state);
+		if (!ret) {
+			state->apply_ctrls = 1;
+			state->apply_fiv = 1;
+			state->apply_fmt = 1;
+		}
+	} else if (!on && !on == state->power) {
+		ret = s5c73m3_set_af_softlanding(sd);
+		if (!ret)
+			ret = __s5c73m3_power_off(state);
+		else
+			v4l2_err(sd, "Soft landing lens failed\n");
+	}
+	if (!ret)
+		state->power += on ? 1 : -1;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "%s: power: %d\n",
+		 __func__, state->power);
+
+	mutex_unlock(&state->lock);
+	return ret;
+}
+
+static int s5c73m3_registered(struct v4l2_subdev *sd)
+{
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+	int ret;
+
+	v4l2_dbg(1, s5c73m3_dbg, sd, "%s:\n", __func__);
+
+	mutex_lock(&state->lock);
+
+	ret = __s5c73m3_power_on(state);
+	if (ret == 0)
+		ret = s5c73m3_spi_boot(state, false);
+	__s5c73m3_power_off(state);
+
+	mutex_unlock(&state->lock);
+	return ret;
+}
+
+static const struct v4l2_subdev_internal_ops s5c73m3_internal_ops = {
+	.registered	= s5c73m3_registered,
+	.open		= s5c73m3_open,
+};
+
+static const struct v4l2_subdev_core_ops s5c73m3_core_ops = {
+	.load_fw	= s5c73m3_load_fw,
+	.s_power	= s5c73m3_set_power,
+	.log_status	= s5c73m3_log_status,
+};
+
+static const struct v4l2_subdev_pad_ops s5c73m3_pad_ops = {
+	.enum_mbus_code		= s5c73m3_enum_mbus_code,
+	.enum_frame_size	= s5c73m3_enum_frame_size,
+	.enum_frame_interval	= s5c73m3_enum_frame_interval,
+	.set_selection		= s5c73m3_set_selection,
+	.get_selection		= s5c73m3_get_selection,
+	.get_fmt		= s5c73m3_get_fmt,
+	.set_fmt		= s5c73m3_set_fmt,
+};
+
+static const struct v4l2_subdev_video_ops s5c73m3_video_ops = {
+	.g_frame_interval	= s5c73m3_g_frame_interval,
+	.s_frame_interval	= s5c73m3_s_frame_interval,
+	.s_stream		= s5c73m3_s_stream,
+};
+
+static const struct v4l2_subdev_ops s5c73m3_subdev_ops = {
+	.core	= &s5c73m3_core_ops,
+	.pad	= &s5c73m3_pad_ops,
+	.video	= &s5c73m3_video_ops,
+};
+
+/*
+ * GPIO control helpers
+ */
+static int s5c73m3_configure_gpio(int nr, int val, const char *name)
+{
+	unsigned long flags = val ? GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW;
+	int ret;
+
+	if (!gpio_is_valid(nr))
+		return 0;
+	ret = gpio_request_one(nr, flags, name);
+	if (!ret)
+		gpio_export(nr, 0);
+	return ret;
+}
+
+static int s5c73m3_free_gpios(struct s5c73m3 *state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(state->gpio); i++) {
+		if (!gpio_is_valid(state->gpio[i].gpio))
+			continue;
+		gpio_free(state->gpio[i].gpio);
+		state->gpio[i].gpio = -EINVAL;
+	}
+	return 0;
+}
+
+static int s5c73m3_configure_gpios(struct s5c73m3 *state,
+				   const struct s5c73m3_platform_data *pdata)
+{
+	const struct s5c73m3_gpio *gpio = &pdata->gpio_stby;
+	int ret;
+
+	state->gpio[STBY].gpio = -EINVAL;
+	state->gpio[RST].gpio  = -EINVAL;
+
+	ret = s5c73m3_configure_gpio(gpio->gpio, gpio->level, "S5C73M3_STBY");
+	if (ret) {
+		s5c73m3_free_gpios(state);
+		return ret;
+	}
+	state->gpio[STBY] = *gpio;
+	if (gpio_is_valid(gpio->gpio))
+		gpio_set_value(gpio->gpio, 0);
+
+	gpio = &pdata->gpio_reset;
+	ret = s5c73m3_configure_gpio(gpio->gpio, gpio->level, "S5C73M3_RST");
+	if (ret) {
+		s5c73m3_free_gpios(state);
+		return ret;
+	}
+	state->gpio[RST] = *gpio;
+	if (gpio_is_valid(gpio->gpio))
+		gpio_set_value(gpio->gpio, 0);
+
+	return 0;
+}
+
+static int __devinit s5c73m3_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
+{
+	const struct s5c73m3_platform_data *pdata = client->dev.platform_data;
+	struct v4l2_subdev *sd;
+	struct s5c73m3 *state;
+	int ret, i;
+
+	if (pdata == NULL) {
+		dev_err(&client->dev, "Platform data not specified\n");
+		return -EINVAL;
+	}
+
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	mutex_init(&state->lock);
+	sd = &state->subdev;
+
+	v4l2_i2c_subdev_init(sd, client, &s5c73m3_subdev_ops);
+	strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
+
+	sd->internal_ops = &s5c73m3_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	state->pads[S5C73M3_OUTIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
+	state->pads[S5C73M3_JPEG_SINK_PAD].flags = MEDIA_PAD_FL_SINK;
+	state->pads[S5C73M3_ISP_SINK_PAD].flags = MEDIA_PAD_FL_SINK;
+	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+
+	ret = media_entity_init(&sd->entity, S5C73M3_NUM_PADS, state->pads, 0);
+	if (ret < 0)
+		return ret;
+
+	state->mclk_frequency = pdata->mclk_frequency;
+	state->bus_type = pdata->bus_type;
+
+	ret = s5c73m3_configure_gpios(state, pdata);
+	if (ret)
+		goto out_err1;
+
+	for (i = 0; i < S5C73M3_MAX_SUPPLIES; i++)
+		state->supplies[i].supply = s5c73m3_supply_names[i];
+
+	ret = regulator_bulk_get(&client->dev, S5C73M3_MAX_SUPPLIES,
+			       state->supplies);
+	if (ret) {
+		dev_err(&client->dev, "failed to get regulators\n");
+		goto out_err2;
+	}
+
+	ret = s5c73m3_init_controls(state);
+	if (ret)
+		goto out_err3;
+
+	state->pix_sizes[PREVIEW_IDX]	  = s5c73m3_video_resolutions;
+	state->pix_sizes_len[PREVIEW_IDX] = ARRAY_SIZE(s5c73m3_video_resolutions);
+	state->prev_pix_size		  = &s5c73m3_video_resolutions[1];
+
+	s5c73m3_fill_mbus_fmt(&state->format[PREVIEW_IDX], state->prev_pix_size,
+			      s5c73m3_formats[0].code /* FIXME */);
+
+	state->pix_sizes[CAPTURE_IDX]	  = s5c73m3_snapshot_resolutions;
+	state->pix_sizes_len[CAPTURE_IDX] = ARRAY_SIZE(s5c73m3_snapshot_resolutions);
+	state->cap_pix_size		  = &s5c73m3_snapshot_resolutions[1];
+
+	s5c73m3_fill_mbus_fmt(&state->format[CAPTURE_IDX], state->cap_pix_size,
+			      s5c73m3_formats[2].code /* FIXME */);
+
+	state->fiv = &s5c73m3_intervals[S5C73M3_DEFAULT_FRAME_INTERVAL];
+
+	ret = s5c73m3_register_spi_driver(state);
+	if (ret < 0)
+		goto out_err3;
+
+	state->i2c_client = client;
+
+	state->fw_index = 0;
+
+	v4l2_info(sd, "%s: completed succesfully\n", __func__);
+	return 0;
+
+out_err3:
+	regulator_bulk_free(S5C73M3_MAX_SUPPLIES, state->supplies);
+out_err2:
+	s5c73m3_free_gpios(state);
+out_err1:
+	media_entity_cleanup(&sd->entity);
+	return ret;
+}
+
+static int __devexit s5c73m3_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct s5c73m3 *state = subdev_to_s5c73m3(sd);
+
+	v4l2_device_unregister_subdev(sd);
+
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	media_entity_cleanup(&sd->entity);
+
+	s5c73m3_unregister_spi_driver(state);
+	regulator_bulk_free(S5C73M3_MAX_SUPPLIES, state->supplies);
+	s5c73m3_free_gpios(state);
+
+	return 0;
+}
+
+static const struct i2c_device_id s5c73m3_id[] = {
+	{ DRIVER_NAME, 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, s5c73m3_id);
+
+static struct i2c_driver s5c73m3_i2c_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+	},
+	.probe		= s5c73m3_probe,
+	.remove		= __devexit_p(s5c73m3_remove),
+	.id_table	= s5c73m3_id,
+};
+
+module_i2c_driver(s5c73m3_i2c_driver);
+
+MODULE_DESCRIPTION("Samsung S5C73M3 camera driver");
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/s5c73m3/s5c73m3.h b/drivers/media/video/s5c73m3/s5c73m3.h
new file mode 100644
index 0000000..f37370f
--- /dev/null
+++ b/drivers/media/video/s5c73m3/s5c73m3.h
@@ -0,0 +1,442 @@
+/*
+ * Samsung LSI S5C73M3 8M pixel camera driver
+ *
+ * Copyright (C) 2012, Samsung Electronics, Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef S5C73M3_H_
+#define S5C73M3_H_
+
+#include <linux/kernel.h>
+#include <linux/regulator/consumer.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+#include <media/s5c73m3.h>
+
+/*
+ * Subdev private controls
+ */
+
+#define V4L2_CID_FIRMWARE_VERSION	(V4L2_CTRL_CLASS_CAMERA | 0x1001)
+/* Capture context */
+#define V4L2_CID_CAPTURE_CTX		(V4L2_CTRL_CLASS_CAMERA | 0x1002)
+enum s5c73m3_capture_ctx {
+	V4L2_CAPTURE_CTX_PREVIEW,
+	V4L2_CAPTURE_CTX_STILL,
+	V4L2_CAPTURE_CTX_CAMCORDER,
+};
+/* Snapshot trigger */
+#define V4L2_CID_SNAPSHOT		(V4L2_CTRL_CLASS_CAMERA | 0x1003)
+/* Flash mode */
+#define V4L2_CID_FLASH_MODE		(V4L2_CTRL_CLASS_CAMERA | 0x1004)
+enum s5c73m3_flash_mode {
+	FLASH_MODE_AUTO,
+	FLASH_MODE_ON,
+	FLASH_MODE_OFF,
+	FLASH_MODE_TORCH,
+};
+
+#define DRIVER_NAME			"S5C73M3"
+#define S5C73M3_FW_FILENAME		"SlimISP.bin"
+
+#define S5C73M3_FW_VER_LEN		22
+#define S5C73M3_FW_VER_FILE_CUR		0x16FF00
+#define S5C73M3_FLASH_BASE_ADDR		0x10000000
+#define S5C73M3_INT_RAM_BASE_ADDR	0x68000000
+
+#define S5C73M3_INTERLEAVED_SIZE_MAX	(8 * SZ_1M)
+#define S5C73M3_JPEG_MAXSIZE		0x800000
+#define S5C73M3_YUV_MAXSIZE		0x3F4800 /*FHD*/
+#define S5C73M3_POINTER_MAXSIZE		0x10E0 /*FHD*/
+
+#define S5C73M3_WIN_WIDTH_MAX		1280
+#define S5C73M3_WIN_HEIGHT_MAX		1024
+#define S5C73M3_WIN_WIDTH_MIN		8
+#define S5C73M3_WIN_HEIGHT_MIN		8
+#define S5C73M3_EMBEDDED_DATA_SIZE	SZ_4K
+
+/* Subdev pad index definitions */
+#define S5C73M3_OUTIF_SOURCE_PAD	0
+#define S5C73M3_JPEG_SINK_PAD		1
+#define S5C73M3_ISP_SINK_PAD		2
+#define S5C73M3_NUM_PADS		3
+
+/*
+ * Register definitions
+ */
+#define S5C73M3_REG(_addrh, _addrl) (((_addrh) << 16) | _addrl)
+
+/*
+ * FIXME: The CMD* register address names are a guess only. They are
+ * analogous to the S5K6AA sensor convention and are by no means
+ * correllated with the (non-existent?) S5C73M3 registers documentation.
+ */
+#define AHB_MSB_ADDR_PTR		0xfcfc
+#define REG_CMDWR_ADDRH			0x0050
+#define REG_CMDWR_ADDRL			0x0054
+#define REG_CMDRD_ADDRH			0x0058
+#define REG_CMDRD_ADDRL			0x005c
+#define REG_CMDBUF_ADDR			0x0f14
+
+#define REG_IMG_OUTPUT			S5C73M3_REG(0, 0x0902)
+#define  REG_IMG_OUTPUT_HDR		0x0008
+#define  REG_IMG_OUTPUT_YUV		0x0009
+#define  REG_IMG_OUTPUT_INTERLEAVED	0x000d
+
+#define REG_STILL_PRE_FLASH		S5C73M3_REG(0, 0x0a00)
+#define  REG_STILL_PRE_FLASH_FIRE	0x0000
+#define  REG_STILL_PRE_FLASH_NON_FIRED	0x0000
+#define  REG_STILL_PRE_FLASH_FIRED	0x0001
+
+#define REG_STILL_MAIN_FLASH		S5C73M3_REG(0, 0x0a02)
+#define  REG_STILL_MAIN_FLASH_CANCEL	0x0001
+#define  REG_STILL_MAIN_FLASH_FIRE	0x0002
+
+#define REG_ZOOM_STEP			S5C73M3_REG(0, 0x0b00)
+
+#define REG_IMAGE_EFFECT		S5C73M3_REG(0, 0x0b0a)
+#define  REG_IMAGE_EFFECT_NONE		0x0001
+#define  REG_IMAGE_EFFECT_NEGATIVE	0x0002
+#define  REG_IMAGE_EFFECT_AQUA		0x0003
+#define  REG_IMAGE_EFFECT_SEPIA		0x0004
+#define  REG_IMAGE_EFFECT_MONO		0x0005
+
+#define REG_IMAGE_QUALITY		S5C73M3_REG(0, 0x0b0c)
+#define  REG_IMAGE_QUALITY_SUPERFINE	0x0000
+#define  REG_IMAGE_QUALITY_FINE		0x0001
+#define  REG_IMAGE_QUALITY_NORMAL	0x0002
+
+#define REG_FLASH_MODE			S5C73M3_REG(0, 0x0b0e)
+#define  REG_FLASH_MODE_OFF		0x0000
+#define  REG_FLASH_MODE_ON		0x0001
+#define  REG_FLASH_MODE_AUTO		0x0002
+
+#define REG_FLASH_STATUS		S5C73M3_REG(0, 0x0b80)
+#define  REG_FLASH_STATUS_OFF		0x0001
+#define  REG_FLASH_STATUS_ON		0x0002
+#define  REG_FLASH_STATUS_AUTO		0x0003
+
+#define REG_FLASH_TORCH			S5C73M3_REG(0, 0x0b12)
+#define  REG_FLASH_TORCH_OFF		0x0000
+#define  REG_FLASH_TORCH_ON		0x0001
+
+#define REG_AE_NEEDS_FLASH		S5C73M3_REG(0, 0x0cba)
+#define  REG_AE_NEEDS_FLASH_OFF		0x0000
+#define  REG_AE_NEEDS_FLASH_ON		0x0001
+
+#define REG_CHG_MODE			S5C73M3_REG(0, 0x0b10)
+#define  CHG_MODE_YUV			0x8000
+#define  CHG_MODE_INTERLEAVED		0x8010
+
+#define  CHG_MODE_YUV_320_240		0x8001
+#define  CHG_MODE_YUV_400_300		0x8002
+#define  CHG_MODE_YUV_640_480		0x8003
+#define  CHG_MODE_YUV_800_600		0x8004
+#define  CHG_MODE_YUV_960_720		0x8005
+#define  CHG_MODE_YUV_1280_720		0x8006
+#define  CHG_MODE_YUV_1280_960		0x8007
+#define  CHG_MODE_YUV_1600_1200		0x8008
+#define  CHG_MODE_YUV_1632_1224		0x8009
+#define  CHG_MODE_YUV_1920_1080		0x800a
+#define  CHG_MODE_YUV_1920_1440		0x800b
+#define  CHG_MODE_YUV_2304_1296		0x800c
+#define  CHG_MODE_YUV_2304_1728		0x800d
+
+#define  CHG_MODE_JPEG_640_480		0x0010
+#define  CHG_MODE_JPEG_800_450		0x0020
+#define  CHG_MODE_JPEG_800_600		0x0030
+#define  CHG_MODE_JPEG_1600_960		0x0040
+#define  CHG_MODE_JPEG_1600_1200	0x0050
+#define  CHG_MODE_JPEG_2048_1152	0x0060
+#define  CHG_MODE_JPEG_2048_1536	0x0070
+#define  CHG_MODE_JPEG_2560_1440	0x0080
+#define  CHG_MODE_JPEG_2560_1920	0x0090
+#define  CHG_MODE_JPEG_3072_1728	0x00a0
+#define  CHG_MODE_JPEG_3264_2304	0x00b0
+#define  CHG_MODE_JPEG_3264_1836	0x00c0
+#define  CHG_MODE_JPEG_3264_2448	0x00d0
+
+#define REG_AF_CON			S5C73M3_REG(0, 0x0e00)
+#define  REG_AF_CON_STOP		0x0000
+#define  REG_AF_CON_SCAN		0x0001 /* AF_SCAN: Full Search */
+#define  REG_AF_CON_START		0x0002 /* AF_START: Fast Search */
+
+#define REG_AF_CAL			S5C73M3_REG(0, 0x0e06)
+#define REG_AF_TOUCH_AF			S5C73M3_REG(0, 0x0e0a)
+
+#define REG_AF_STATUS			S5C73M3_REG(0x0009, 0x5e80)
+#define  REG_CAF_STATUS_FIND_SEARCH_DIR 0x0001
+#define  REG_CAF_STATUS_FOCUSING	0x0002
+#define  REG_CAF_STATUS_FOCUSED		0x0003
+#define  REG_CAF_STATUS_UNFOCUSED	0x0004
+#define  REG_AF_STATUS_INVALID		0x0010
+#define  REG_AF_STATUS_FOCUSING		0x0020
+#define  REG_AF_STATUS_FOCUSED		0x0030
+#define  REG_AF_STATUS_UNFOCUSED	0x0040
+
+#define REG_AF_TOUCH_POSITION		S5C73M3_REG(0, 0x5e8e)
+#define REG_AF_FACE_ZOOM		S5C73M3_REG(0, 0x0e10)
+
+#define REG_AF_MODE			S5C73M3_REG(0, 0x0e02)
+#define  REG_AF_MODE_NORMAL		0x0000
+#define  REG_AF_MODE_MACRO		0x0001
+#define  REG_AF_MODE_MOVIE_CAF_START	0x0002
+#define  REG_AF_MODE_MOVIE_CAF_STOP	0x0003
+#define  REG_AF_MODE_PREVIEW_CAF_START	0x0004
+#define  REG_AF_MODE_PREVIEW_CAF_STOP	0x0005
+
+#define REG_AF_SOFTLANDING		S5C73M3_REG(0, 0x0e16)
+#define  REG_AF_SOFTLANDING_ON		0x0000
+
+#define REG_FACE_DET			S5C73M3_REG(0, 0x0e0c)
+#define  REG_FACE_DET_OFF		0x0000
+#define  REG_FACE_DET_ON		0x0001
+
+#define REG_FACE_DET_OSD		S5C73M3_REG(0, 0x0e0e)
+#define  REG_FACE_DET_OSD_OFF		0x0000
+#define  REG_FACE_DET_OSD_ON		0x0001
+
+#define REG_AE_CON			S5C73M3_REG(0, 0x0c00)
+#define  REG_AE_STOP			0x0000 /* lock */
+#define  REG_AE_START			0x0001 /* unlock */
+
+#define REG_ISO				S5C73M3_REG(0, 0x0c02)
+#define  REG_ISO_AUTO			0x0000
+#define  REG_ISO_100			0x0001
+#define  REG_ISO_200			0x0002
+#define  REG_ISO_400			0x0003
+#define  REG_ISO_800			0x0004
+#define  REG_ISO_SPORTS			0x0005
+#define  REG_ISO_NIGHT			0x0006
+#define  REG_ISO_INDOOR			0x0007
+
+/* 0x00000 (-2.0 EV)...0x0008 (2.0 EV), 0.5EV step */
+#define REG_EV				S5C73M3_REG(0, 0x0c04)
+
+#define REG_METERING			S5C73M3_REG(0, 0x0c06)
+#define  REG_METERING_CENTER		0x0000
+#define  REG_METERING_SPOT		0x0001
+#define  REG_METERING_AVERAGE		0x0002
+#define  REG_METERING_SMART		0x0003
+
+#define REG_WDR				S5C73M3_REG(0, 0x0c08)
+#define  REG_WDR_OFF			0x0000
+#define  REG_WDR_ON			0x0001
+
+#define REG_AE_MODE			S5C73M3_REG(0, 0x0c1e)
+#define  REG_AE_MODE_AUTO_SET		0x0000
+#define  REG_AE_MODE_FIXED_30FPS	0x0002
+#define  REG_AE_MODE_FIXED_20FPS	0x0003
+#define  REG_AE_MODE_FIXED_15FPS	0x0004
+#define  REG_AE_MODE_FIXED_120FPS	0x0008
+#define  REG_AE_MODE_FIXED_7FPS		0x0009
+#define  REG_AE_MODE_ANTI_SHAKE		0x0013
+
+/* 0x0000...0x0004 -> sharpness: 0, 1, 2, -1, -2 */
+#define REG_SHARPNESS			S5C73M3_REG(0, 0x0c14)
+
+/* 0x0000...0x0004 -> saturation: 0, 1, 2, -1, -2 */
+#define REG_SATURATION			S5C73M3_REG(0, 0x0c16)
+
+/* 0x0000...0x0004 -> contrast: 0, 1, 2, -1, -2 */
+#define REG_CONTRAST			S5C73M3_REG(0, 0x0c18)
+
+#define REG_SCENE_MODE			S5C73M3_REG(0, 0x0c1a)
+#define  REG_SCENE_MODE_NONE		0x0000
+#define  REG_SCENE_MODE_PORTRAIT	0x0001
+#define  REG_SCENE_MODE_LANDSCAPE	0x0002
+#define  REG_SCENE_MODE_SPORTS		0x0003
+#define  REG_SCENE_MODE_INDOOR		0x0004
+#define  REG_SCENE_MODE_BEACH		0x0005
+#define  REG_SCENE_MODE_SUNSET		0x0006
+#define  REG_SCENE_MODE_DAWN		0x0007
+#define  REG_SCENE_MODE_FALL		0x0008
+#define  REG_SCENE_MODE_NIGHT		0x0009
+#define  REG_SCENE_MODE_AGAINST_LIGHT	0x000a
+#define  REG_SCENE_MODE_FIRE		0x000b
+#define  REG_SCENE_MODE_TEXT		0x000c
+#define  REG_SCENE_MODE_CANDLE		0x000d
+
+#define REG_AE_AUTO_BRACKET		S5C73M3_REG(0, 0x0b14)
+#define  REG_AE_AUTO_BRAKET_EV05	0x0080
+#define  REG_AE_AUTO_BRAKET_EV10	0x0100
+#define  REG_AE_AUTO_BRAKET_EV15	0x0180
+#define  REG_AE_AUTO_BRAKET_EV20	0x0200
+
+#define REG_SENSOR_STREAMING		S5C73M3_REG(0, 0x090a)
+#define  REG_SENSOR_STREAMING_OFF	0x0000
+#define  REG_SENSOR_STREAMING_ON	0x0001
+
+#define REG_AWB_MODE			S5C73M3_REG(0, 0x0d02)
+#define  REG_AWB_MODE_INCANDESCENT	0x0000
+#define  REG_AWB_MODE_FLUORESCENT1	0x0001
+#define  REG_AWB_MODE_FLUORESCENT2	0x0002
+#define  REG_AWB_MODE_DAYLIGHT		0x0003
+#define  REG_AWB_MODE_CLOUDY		0x0004
+#define  REG_AWB_MODE_AUTO		0x0005
+
+#define REG_AWB_CON			S5C73M3_REG(0, 0x0d00)
+#define  REG_AWB_STOP			0x0000 /* lock */
+#define  REG_AWB_START			0x0001 /* unlock */
+
+#define S5C73M3_ARRAY_END		0xffffffff
+
+#define S5C73M3_MAX_SUPPLIES		6
+
+struct s5c73m3_ctrls {
+	struct v4l2_ctrl_handler handler;
+	struct {
+		/* exposure/exposure bias cluster */
+		struct v4l2_ctrl *auto_exposure;
+		struct v4l2_ctrl *exposure_bias;
+		struct v4l2_ctrl *exposure_metering;
+	};
+	struct {
+		/* iso/auto iso cluster */
+		struct v4l2_ctrl *auto_iso;
+		struct v4l2_ctrl *iso;
+	};
+	struct v4l2_ctrl *auto_wb;
+	struct {
+		/* continuous auto focus/auto focus cluster */
+		struct v4l2_ctrl *focus_auto;
+		struct v4l2_ctrl *af_start;
+		struct v4l2_ctrl *af_stop;
+		struct v4l2_ctrl *af_status;
+		struct v4l2_ctrl *af_distance;
+		struct v4l2_ctrl *af_area;
+	};
+
+	struct v4l2_ctrl *ae_awb_lock;
+	struct v4l2_ctrl *colorfx;
+	struct v4l2_ctrl *contrast;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *sharpness;
+	struct v4l2_ctrl *zoom;
+	struct v4l2_ctrl *wdr;
+	struct v4l2_ctrl *stabilization;
+	struct v4l2_ctrl *jpeg_quality;
+	struct v4l2_ctrl *flash_mode;
+	struct v4l2_ctrl *scene_mode;
+	struct v4l2_ctrl *capture_ctx;
+	struct v4l2_ctrl *snapshot;
+};
+
+enum s5c73m3_gpio_id {
+	STBY,
+	RST,
+	GPIO_NUM,
+};
+
+struct s5c73m3_focus {
+	unsigned short pos_x;
+	unsigned short pos_y;
+};
+
+struct s5c73m3_pixfmt {
+	enum v4l2_mbus_pixelcode code;
+	u32 colorspace;
+	u8  mipi_data_type;
+};
+
+struct s5c73m3_interval {
+	u16 fps_reg;
+	struct v4l2_fract interval;
+	/* Maximum rectangle for the interval */
+	struct v4l2_frmsize_discrete size;
+};
+
+struct s5c73m3 {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[S5C73M3_NUM_PADS];
+
+	struct spi_driver spidrv;
+	struct spi_device *spi_dev;
+	struct i2c_client *i2c_client;
+
+	struct regulator_bulk_data supplies[S5C73M3_MAX_SUPPLIES];
+	struct s5c73m3_gpio gpio[GPIO_NUM];
+
+	/* External master clock frequency */
+	unsigned long mclk_frequency;
+	/* Video bus type - MIPI-CSI2/paralell */
+	enum v4l2_mbus_type bus_type;
+
+	const struct s5c73m3_frame_size *pix_sizes[2];
+#define PREVIEW_IDX 0
+#define CAPTURE_IDX 1
+	unsigned int pix_sizes_len[2];
+
+	const struct s5c73m3_frame_size *prev_pix_size;
+	const struct s5c73m3_frame_size *cap_pix_size;
+	u8 wide_res;
+
+	const struct s5c73m3_interval *fiv;
+
+	/* protects the struct members below */
+	struct mutex lock;
+
+	int fw_index;
+
+	struct s5c73m3_ctrls ctrls;
+	struct v4l2_mbus_framefmt format[2];
+
+	u8 streaming;
+	u8 apply_fmt;
+	u8 apply_crop;
+	u8 apply_ctrls;
+	u8 apply_fiv;
+	u8 isp_ready;
+
+	struct s5c73m3_focus focus;
+
+	unsigned short fw_error;
+	unsigned short power;
+
+	char sensor_fw[10];
+};
+
+struct s5c73m3_frame_size {
+	u32 width;
+	u32 height;
+	u8 reg_val;
+	/* Wide resolution is set to 1 : height / width < 0.65 */
+	u8 wide_res; /* for POSTVIEW only */
+};
+
+extern int s5c73m3_dbg;
+
+/*
+ * Function prototypes
+ */
+int s5c73m3_register_spi_driver(struct s5c73m3 *state);
+void s5c73m3_unregister_spi_driver(struct s5c73m3 *state);
+int s5c73m3_spi_write(struct s5c73m3 *state, const void *addr,
+		      const unsigned int len, const unsigned int tx_size);
+
+int s5c73m3_i2c_write(struct i2c_client *client, u16 addr, u16 data);
+int s5c73m3_read(struct i2c_client *client, u32 addr, u16 *data);
+int s5c73m3_write_cmd(struct s5c73m3 *state, u32 addr, u16 data);
+int s5c73m3_init_controls(struct s5c73m3 *state);
+
+static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
+{
+	return &container_of(ctrl->handler, struct s5c73m3,
+			     ctrls.handler)->subdev;
+}
+
+static inline struct s5c73m3 *subdev_to_s5c73m3(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct s5c73m3, subdev);
+}
+#endif	/* S5C73M3_H_ */
diff --git a/include/media/s5c73m3.h b/include/media/s5c73m3.h
new file mode 100644
index 0000000..9110861
--- /dev/null
+++ b/include/media/s5c73m3.h
@@ -0,0 +1,62 @@
+/*
+ * Driver for S5C73M3
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef MEDIA_S5C73M3__
+#define MEDIA_S5C73M3__
+
+#include <linux/videodev2.h>
+#include <media/v4l2-mediabus.h>
+
+/**
+ * struct s5c73m3_gpio - data structure describing a GPIO
+ * @gpio:  GPIO number
+ * @level: indicates active state of the @gpio
+ */
+struct s5c73m3_gpio {
+	int gpio;
+	int level;
+};
+
+/**
+ * struct s5c73m3_platform_data - s5c73m3 driver platform data
+ * @mclk_frequency: sensor's master clock frequency in Hz
+ * @gpio_reset:  GPIO driving RESET pin
+ * @gpio_stby:   GPIO driving STBY pin
+ * @nlanes:      maximum number of MIPI-CSI lanes used
+ * @horiz_flip:  default horizontal image flip value, non zero to enable
+ * @vert_flip:   default vertical image flip value, non zero to enable
+ */
+
+struct s5c73m3_platform_data {
+	unsigned long mclk_frequency;
+
+	struct s5c73m3_gpio gpio_reset;
+	struct s5c73m3_gpio gpio_stby;
+
+	enum v4l2_mbus_type bus_type;
+	u8 nlanes;
+	u8 horiz_flip;
+	u8 vert_flip;
+};
+
+#define V4L2_CID_CAM_SENSOR_FW_VER (V4L2_CID_CAMERA_CLASS_BASE + 28)
+#define V4L2_CID_CAM_PHONE_FW_VER (V4L2_CID_CAMERA_CLASS_BASE + 29)
+
+enum stream_mode_t {
+	STREAM_MODE_CAM_OFF,
+	STREAM_MODE_CAM_ON,
+	STREAM_MODE_MOVIE_OFF,
+	STREAM_MODE_MOVIE_ON,
+};
+
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_LEFT	(V4L2_CID_CAMERA_CLASS_BASE+37)
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_TOP	(V4L2_CID_CAMERA_CLASS_BASE+38)
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_WIDTH	(V4L2_CID_CAMERA_CLASS_BASE+39)
+#define V4L2_CID_FOCUS_AUTO_RECTANGLE_HEIGHT	(V4L2_CID_CAMERA_CLASS_BASE+40)
+
+#endif /* MEDIA_S5C73M3__ */
-- 
1.7.10


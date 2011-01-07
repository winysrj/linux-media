Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3987 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab1AGMrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 07:47:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCH 1/5] v4l2-subdev: remove core.s_config and v4l2_i2c_new_subdev_cfg()
Date: Fri,  7 Jan 2011 13:47:31 +0100
Message-Id: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The core.s_config op was meant for legacy drivers that needed to work with old
pre-2.6.26 kernels. This is no longer relevant. Unfortunately, this op was
incorrectly called from several drivers.

Replace those occurences with proper i2c_board_info structs and call
v4l2_i2c_new_subdev_board.

After these changes v4l2_i2c_new_subdev_cfg() was no longer used, so remove
that function as well.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cafe_ccic.c            |   11 +++-
 drivers/media/video/cx25840/cx25840-core.c |   22 ++------
 drivers/media/video/em28xx/em28xx-cards.c  |   18 ++++---
 drivers/media/video/ivtv/ivtv-i2c.c        |    9 +++-
 drivers/media/video/mt9v011.c              |   29 ++++-------
 drivers/media/video/mt9v011.h              |   36 -------------
 drivers/media/video/mt9v011_regs.h         |   36 +++++++++++++
 drivers/media/video/ov7670.c               |   74 ++++++++++++----------------
 drivers/media/video/sr030pc30.c            |   10 ----
 drivers/media/video/v4l2-common.c          |   19 +------
 include/media/mt9v011.h                    |   17 ++++++
 include/media/v4l2-common.h                |   13 +-----
 include/media/v4l2-subdev.h                |    6 +--
 13 files changed, 130 insertions(+), 170 deletions(-)
 delete mode 100644 drivers/media/video/mt9v011.h
 create mode 100644 drivers/media/video/mt9v011_regs.h
 create mode 100644 include/media/mt9v011.h

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 789087c..7488b47 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -2001,6 +2001,11 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		.min_width = 320,
 		.min_height = 240,
 	};
+	struct i2c_board_info ov7670_info = {
+		.type = "ov7670",
+		.addr = 0x42,
+		.platform_data = &sensor_cfg,
+	};
 
 	/*
 	 * Start putting together one of our big camera structures.
@@ -2062,9 +2067,9 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	if (dmi_check_system(olpc_xo1_dmi))
 		sensor_cfg.clock_speed = 45;
 
-	cam->sensor_addr = 0x42;
-	cam->sensor = v4l2_i2c_new_subdev_cfg(&cam->v4l2_dev, &cam->i2c_adapter,
-			"ov7670", 0, &sensor_cfg, cam->sensor_addr, NULL);
+	cam->sensor_addr = ov7670_info.addr;
+	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev, &cam->i2c_adapter,
+			&ov7670_info, NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_smbus;
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index dfb198d..9b384ac 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1682,20 +1682,6 @@ static int cx25840_log_status(struct v4l2_subdev *sd)
 	return 0;
 }
 
-static int cx25840_s_config(struct v4l2_subdev *sd, int irq, void *platform_data)
-{
-	struct cx25840_state *state = to_state(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	if (platform_data) {
-		struct cx25840_platform_data *pdata = platform_data;
-
-		state->pvr150_workaround = pdata->pvr150_workaround;
-		set_input(client, state->vid_input, state->aud_input);
-	}
-	return 0;
-}
-
 static int cx23885_irq_handler(struct v4l2_subdev *sd, u32 status,
 			       bool *handled)
 {
@@ -1787,7 +1773,6 @@ static const struct v4l2_ctrl_ops cx25840_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops cx25840_core_ops = {
 	.log_status = cx25840_log_status,
-	.s_config = cx25840_s_config,
 	.g_chip_ident = cx25840_g_chip_ident,
 	.g_ctrl = v4l2_subdev_g_ctrl,
 	.s_ctrl = v4l2_subdev_s_ctrl,
@@ -1974,7 +1959,6 @@ static int cx25840_probe(struct i2c_client *client,
 	state->vid_input = CX25840_COMPOSITE7;
 	state->aud_input = CX25840_AUDIO8;
 	state->audclk_freq = 48000;
-	state->pvr150_workaround = 0;
 	state->audmode = V4L2_TUNER_MODE_LANG1;
 	state->vbi_line_offset = 8;
 	state->id = id;
@@ -2019,6 +2003,12 @@ static int cx25840_probe(struct i2c_client *client,
 	v4l2_ctrl_cluster(2, &state->volume);
 	v4l2_ctrl_handler_setup(&state->hdl);
 
+	if (client->dev.platform_data) {
+		struct cx25840_platform_data *pdata = client->dev.platform_data;
+
+		state->pvr150_workaround = pdata->pvr150_workaround;
+	}
+
 	cx25840_ir_probe(sd);
 	return 0;
 }
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 8af302b..2822aeb 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -33,6 +33,7 @@
 #include <media/saa7115.h>
 #include <media/tvp5150.h>
 #include <media/tvaudio.h>
+#include <media/mt9v011.h>
 #include <media/i2c-addr.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
@@ -1917,11 +1918,6 @@ static unsigned short tvp5150_addrs[] = {
 	I2C_CLIENT_END
 };
 
-static unsigned short mt9v011_addrs[] = {
-	0xba >> 1,
-	I2C_CLIENT_END
-};
-
 static unsigned short msp3400_addrs[] = {
 	0x80 >> 1,
 	0x88 >> 1,
@@ -2623,11 +2619,17 @@ void em28xx_card_setup(struct em28xx *dev)
 			"tvp5150", 0, tvp5150_addrs);
 
 	if (dev->em28xx_sensor == EM28XX_MT9V011) {
+		struct mt9v011_platform_data pdata;
+		struct i2c_board_info mt9v011_info = {
+			.type = "mt9v011",
+			.addr = 0xba >> 1,
+			.platform_data = &pdata,
+		};
 		struct v4l2_subdev *sd;
 
-		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-			 &dev->i2c_adap, "mt9v011", 0, mt9v011_addrs);
-		v4l2_subdev_call(sd, core, s_config, 0, &dev->sensor_xtal);
+		pdata.xtal = dev->sensor_xtal;
+		sd = v4l2_i2c_new_subdev_board(&dev->v4l2_dev, &dev->i2c_adap,
+				&mt9v011_info, NULL);
 	}
 
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index e103b8f..9fb86a0 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -300,10 +300,15 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 				adap, type, 0, I2C_ADDRS(hw_addrs[idx]));
 	} else if (hw == IVTV_HW_CX25840) {
 		struct cx25840_platform_data pdata;
+		struct i2c_board_info cx25840_info = {
+			.type = "cx25840",
+			.addr = hw_addrs[idx],
+			.platform_data = &pdata,
+		};
 
 		pdata.pvr150_workaround = itv->pvr150_workaround;
-		sd = v4l2_i2c_new_subdev_cfg(&itv->v4l2_dev,
-				adap, type, 0, &pdata, hw_addrs[idx], NULL);
+		sd = v4l2_i2c_new_subdev_board(&itv->v4l2_dev, adap,
+				&cx25840_info, NULL);
 	} else {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, type, hw_addrs[idx], NULL);
diff --git a/drivers/media/video/mt9v011.c b/drivers/media/video/mt9v011.c
index 209ff97..f3f73d3 100644
--- a/drivers/media/video/mt9v011.c
+++ b/drivers/media/video/mt9v011.c
@@ -12,7 +12,8 @@
 #include <asm/div64.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
-#include "mt9v011.h"
+#include <media/mt9v011.h>
+#include "mt9v011_regs.h"
 
 MODULE_DESCRIPTION("Micron mt9v011 sensor driver");
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
@@ -469,23 +470,6 @@ static int mt9v011_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 	return 0;
 }
 
-static int mt9v011_s_config(struct v4l2_subdev *sd, int dumb, void *data)
-{
-	struct mt9v011 *core = to_mt9v011(sd);
-	unsigned *xtal = data;
-
-	v4l2_dbg(1, debug, sd, "s_config called\n");
-
-	if (xtal) {
-		core->xtal = *xtal;
-		v4l2_dbg(1, debug, sd, "xtal set to %d.%03d MHz\n",
-			 *xtal / 1000000, (*xtal / 1000) % 1000);
-	}
-
-	return 0;
-}
-
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9v011_g_register(struct v4l2_subdev *sd,
 			      struct v4l2_dbg_register *reg)
@@ -536,7 +520,6 @@ static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
 	.g_ctrl = mt9v011_g_ctrl,
 	.s_ctrl = mt9v011_s_ctrl,
 	.reset = mt9v011_reset,
-	.s_config = mt9v011_s_config,
 	.g_chip_ident = mt9v011_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = mt9v011_g_register,
@@ -596,6 +579,14 @@ static int mt9v011_probe(struct i2c_client *c,
 	core->height = 480;
 	core->xtal = 27000000;	/* Hz */
 
+	if (c->dev.platform_data) {
+		struct mt9v011_platform_data *pdata = c->dev.platform_data;
+
+		core->xtal = pdata->xtal;
+		v4l2_dbg(1, debug, sd, "xtal set to %d.%03d MHz\n",
+			core->xtal / 1000000, (core->xtal / 1000) % 1000);
+	}
+
 	v4l_info(c, "chip found @ 0x%02x (%s - chip version 0x%04x)\n",
 		 c->addr << 1, c->adapter->name, version);
 
diff --git a/drivers/media/video/mt9v011.h b/drivers/media/video/mt9v011.h
deleted file mode 100644
index 3350fd6..0000000
--- a/drivers/media/video/mt9v011.h
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
- *
- * Copyright (c) 2009 Mauro Carvalho Chehab (mchehab@redhat.com)
- * This code is placed under the terms of the GNU General Public License v2
- */
-
-#ifndef MT9V011_H_
-#define MT9V011_H_
-
-#define R00_MT9V011_CHIP_VERSION	0x00
-#define R01_MT9V011_ROWSTART		0x01
-#define R02_MT9V011_COLSTART		0x02
-#define R03_MT9V011_HEIGHT		0x03
-#define R04_MT9V011_WIDTH		0x04
-#define R05_MT9V011_HBLANK		0x05
-#define R06_MT9V011_VBLANK		0x06
-#define R07_MT9V011_OUT_CTRL		0x07
-#define R09_MT9V011_SHUTTER_WIDTH	0x09
-#define R0A_MT9V011_CLK_SPEED		0x0a
-#define R0B_MT9V011_RESTART		0x0b
-#define R0C_MT9V011_SHUTTER_DELAY	0x0c
-#define R0D_MT9V011_RESET		0x0d
-#define R1E_MT9V011_DIGITAL_ZOOM	0x1e
-#define R20_MT9V011_READ_MODE		0x20
-#define R2B_MT9V011_GREEN_1_GAIN	0x2b
-#define R2C_MT9V011_BLUE_GAIN		0x2c
-#define R2D_MT9V011_RED_GAIN		0x2d
-#define R2E_MT9V011_GREEN_2_GAIN	0x2e
-#define R35_MT9V011_GLOBAL_GAIN		0x35
-#define RF1_MT9V011_CHIP_ENABLE		0xf1
-
-#define MT9V011_VERSION			0x8232
-#define MT9V011_REV_B_VERSION		0x8243
-
-#endif
diff --git a/drivers/media/video/mt9v011_regs.h b/drivers/media/video/mt9v011_regs.h
new file mode 100644
index 0000000..d6a5a08
--- /dev/null
+++ b/drivers/media/video/mt9v011_regs.h
@@ -0,0 +1,36 @@
+/*
+ * mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
+ *
+ * Copyright (c) 2009 Mauro Carvalho Chehab (mchehab@redhat.com)
+ * This code is placed under the terms of the GNU General Public License v2
+ */
+
+#ifndef MT9V011_REGS_H_
+#define MT9V011_REGS_H_
+
+#define R00_MT9V011_CHIP_VERSION	0x00
+#define R01_MT9V011_ROWSTART		0x01
+#define R02_MT9V011_COLSTART		0x02
+#define R03_MT9V011_HEIGHT		0x03
+#define R04_MT9V011_WIDTH		0x04
+#define R05_MT9V011_HBLANK		0x05
+#define R06_MT9V011_VBLANK		0x06
+#define R07_MT9V011_OUT_CTRL		0x07
+#define R09_MT9V011_SHUTTER_WIDTH	0x09
+#define R0A_MT9V011_CLK_SPEED		0x0a
+#define R0B_MT9V011_RESTART		0x0b
+#define R0C_MT9V011_SHUTTER_DELAY	0x0c
+#define R0D_MT9V011_RESET		0x0d
+#define R1E_MT9V011_DIGITAL_ZOOM	0x1e
+#define R20_MT9V011_READ_MODE		0x20
+#define R2B_MT9V011_GREEN_1_GAIN	0x2b
+#define R2C_MT9V011_BLUE_GAIN		0x2c
+#define R2D_MT9V011_RED_GAIN		0x2d
+#define R2E_MT9V011_GREEN_2_GAIN	0x2e
+#define R35_MT9V011_GLOBAL_GAIN		0x35
+#define RF1_MT9V011_CHIP_ENABLE		0xf1
+
+#define MT9V011_VERSION			0x8232
+#define MT9V011_REV_B_VERSION		0x8243
+
+#endif
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index c881a64..d4e7c11 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -1449,47 +1449,6 @@ static int ov7670_g_chip_ident(struct v4l2_subdev *sd,
 	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_OV7670, 0);
 }
 
-static int ov7670_s_config(struct v4l2_subdev *sd, int dumb, void *data)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct ov7670_config *config = data;
-	struct ov7670_info *info = to_state(sd);
-	int ret;
-
-	info->clock_speed = 30; /* default: a guess */
-
-	/*
-	 * Must apply configuration before initializing device, because it
-	 * selects I/O method.
-	 */
-	if (config) {
-		info->min_width = config->min_width;
-		info->min_height = config->min_height;
-		info->use_smbus = config->use_smbus;
-
-		if (config->clock_speed)
-			info->clock_speed = config->clock_speed;
-	}
-
-	/* Make sure it's an ov7670 */
-	ret = ov7670_detect(sd);
-	if (ret) {
-		v4l_dbg(1, debug, client,
-			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
-			client->addr << 1, client->adapter->name);
-		kfree(info);
-		return ret;
-	}
-	v4l_info(client, "chip found @ 0x%02x (%s)\n",
-			client->addr << 1, client->adapter->name);
-
-	info->fmt = &ov7670_formats[0];
-	info->sat = 128;	/* Review this */
-	info->clkrc = info->clock_speed / 30;
-
-	return 0;
-}
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int ov7670_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
 {
@@ -1528,7 +1487,6 @@ static const struct v4l2_subdev_core_ops ov7670_core_ops = {
 	.s_ctrl = ov7670_s_ctrl,
 	.queryctrl = ov7670_queryctrl,
 	.reset = ov7670_reset,
-	.s_config = ov7670_s_config,
 	.init = ov7670_init,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register = ov7670_g_register,
@@ -1558,6 +1516,7 @@ static int ov7670_probe(struct i2c_client *client,
 {
 	struct v4l2_subdev *sd;
 	struct ov7670_info *info;
+	int ret;
 
 	info = kzalloc(sizeof(struct ov7670_info), GFP_KERNEL);
 	if (info == NULL)
@@ -1565,6 +1524,37 @@ static int ov7670_probe(struct i2c_client *client,
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov7670_ops);
 
+	info->clock_speed = 30; /* default: a guess */
+	if (client->dev.platform_data) {
+		struct ov7670_config *config = client->dev.platform_data;
+
+		/*
+		 * Must apply configuration before initializing device, because it
+		 * selects I/O method.
+		 */
+		info->min_width = config->min_width;
+		info->min_height = config->min_height;
+		info->use_smbus = config->use_smbus;
+
+		if (config->clock_speed)
+			info->clock_speed = config->clock_speed;
+	}
+
+	/* Make sure it's an ov7670 */
+	ret = ov7670_detect(sd);
+	if (ret) {
+		v4l_dbg(1, debug, client,
+			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
+			client->addr << 1, client->adapter->name);
+		kfree(info);
+		return ret;
+	}
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	info->fmt = &ov7670_formats[0];
+	info->sat = 128;	/* Review this */
+	info->clkrc = info->clock_speed / 30;
 	return 0;
 }
 
diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index 864696b..c901721 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -714,15 +714,6 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
 	return ret;
 }
 
-static int sr030pc30_s_config(struct v4l2_subdev *sd,
-			      int irq, void *platform_data)
-{
-	struct sr030pc30_info *info = to_sr030pc30(sd);
-
-	info->pdata = platform_data;
-	return 0;
-}
-
 static int sr030pc30_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	return 0;
@@ -763,7 +754,6 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 }
 
 static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
-	.s_config	= sr030pc30_s_config,
 	.s_power	= sr030pc30_s_power,
 	.queryctrl	= sr030pc30_queryctrl,
 	.s_ctrl		= sr030pc30_s_ctrl,
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 3f0871b..810eef4 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -407,18 +407,6 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
 	/* Decrease the module use count to match the first try_module_get. */
 	module_put(client->driver->driver.owner);
 
-	if (sd) {
-		/* We return errors from v4l2_subdev_call only if we have the
-		   callback as the .s_config is not mandatory */
-		int err = v4l2_subdev_call(sd, core, s_config,
-				info->irq, info->platform_data);
-
-		if (err && err != -ENOIOCTLCMD) {
-			v4l2_device_unregister_subdev(sd);
-			sd = NULL;
-		}
-	}
-
 error:
 	/* If we have a client but no subdev, then something went wrong and
 	   we must unregister the client. */
@@ -428,9 +416,8 @@ error:
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board);
 
-struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, const char *client_type,
-		int irq, void *platform_data,
 		u8 addr, const unsigned short *probe_addrs)
 {
 	struct i2c_board_info info;
@@ -440,12 +427,10 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
 	memset(&info, 0, sizeof(info));
 	strlcpy(info.type, client_type, sizeof(info.type));
 	info.addr = addr;
-	info.irq = irq;
-	info.platform_data = platform_data;
 
 	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, probe_addrs);
 }
-EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_cfg);
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
 
 /* Return i2c client address of v4l2_subdev. */
 unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd)
diff --git a/include/media/mt9v011.h b/include/media/mt9v011.h
new file mode 100644
index 0000000..ea29fc7
--- /dev/null
+++ b/include/media/mt9v011.h
@@ -0,0 +1,17 @@
+/* mt9v011 sensor
+ *
+ * Copyright (C) 2011 Hans Verkuil <hverkuil@xs4all.nl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MT9V011_H__
+#define __MT9V011_H__
+
+struct mt9v011_platform_data {
+	unsigned xtal;	/* Hz */
+};
+
+#endif
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 2d65b35..a659319 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -138,21 +138,10 @@ struct v4l2_subdev_ops;
 
 /* Load an i2c module and return an initialized v4l2_subdev struct.
    The client_type argument is the name of the chip that's on the adapter. */
-struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, const char *client_type,
-		int irq, void *platform_data,
 		u8 addr, const unsigned short *probe_addrs);
 
-/* Load an i2c module and return an initialized v4l2_subdev struct.
-   The client_type argument is the name of the chip that's on the adapter. */
-static inline struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter, const char *client_type,
-		u8 addr, const unsigned short *probe_addrs)
-{
-	return v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter, client_type, 0, NULL,
-				       addr, probe_addrs);
-}
-
 struct i2c_board_info;
 
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index b0316a7..42fbe46 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -106,10 +106,7 @@ struct v4l2_subdev_io_pin_config {
 	u8 strength;	/* Pin drive strength */
 };
 
-/* s_config: if set, then it is always called by the v4l2_i2c_new_subdev*
-	functions after the v4l2_subdev was registered. It is used to pass
-	platform data to the subdev which can be used during initialization.
-
+/*
    s_io_pin_config: configure one or more chip I/O pins for chips that
 	multiplex different internal signal pads out to IO pins.  This function
 	takes a pointer to an array of 'n' pin configuration entries, one for
@@ -141,7 +138,6 @@ struct v4l2_subdev_io_pin_config {
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
-	int (*s_config)(struct v4l2_subdev *sd, int irq, void *platform_data);
 	int (*s_io_pin_config)(struct v4l2_subdev *sd, size_t n,
 				      struct v4l2_subdev_io_pin_config *pincfg);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
-- 
1.7.0.4


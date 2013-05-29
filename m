Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2069 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab3E2LAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Johnson <brijohn@gmail.com>
Subject: [PATCHv1 09/38] gspca: remove g_chip_ident
Date: Wed, 29 May 2013 12:59:42 +0200
Message-Id: <1369825211-29770-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove g_chip_ident and replace it with g_chip_info.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Brian Johnson <brijohn@gmail.com>
---
 drivers/media/usb/gspca/gspca.c   |   32 +++++++++---------
 drivers/media/usb/gspca/gspca.h   |    6 ++--
 drivers/media/usb/gspca/pac7302.c |   19 +----------
 drivers/media/usb/gspca/sn9c20x.c |   67 +++++++++----------------------------
 4 files changed, 34 insertions(+), 90 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 5995ec4..b7ae872 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1029,33 +1029,35 @@ static int gspca_get_mode(struct gspca_dev *gspca_dev,
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-static int vidioc_g_register(struct file *file, void *priv,
-			struct v4l2_dbg_register *reg)
+static int vidioc_g_chip_info(struct file *file, void *priv,
+				struct v4l2_dbg_chip_info *chip)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	gspca_dev->usb_err = 0;
-	return gspca_dev->sd_desc->get_register(gspca_dev, reg);
+	if (gspca_dev->sd_desc->get_chip_info)
+		return gspca_dev->sd_desc->get_chip_info(gspca_dev, chip);
+	return chip->match.addr ? -EINVAL : 0;
 }
 
-static int vidioc_s_register(struct file *file, void *priv,
-			const struct v4l2_dbg_register *reg)
+static int vidioc_g_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	gspca_dev->usb_err = 0;
-	return gspca_dev->sd_desc->set_register(gspca_dev, reg);
+	return gspca_dev->sd_desc->get_register(gspca_dev, reg);
 }
-#endif
 
-static int vidioc_g_chip_ident(struct file *file, void *priv,
-			struct v4l2_dbg_chip_ident *chip)
+static int vidioc_s_register(struct file *file, void *priv,
+		const struct v4l2_dbg_register *reg)
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
 	gspca_dev->usb_err = 0;
-	return gspca_dev->sd_desc->get_chip_ident(gspca_dev, chip);
+	return gspca_dev->sd_desc->set_register(gspca_dev, reg);
 }
+#endif
 
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 				struct v4l2_fmtdesc *fmtdesc)
@@ -1974,10 +1976,10 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_info	= vidioc_g_chip_info,
 	.vidioc_g_register	= vidioc_g_register,
 	.vidioc_s_register	= vidioc_s_register,
 #endif
-	.vidioc_g_chip_ident	= vidioc_g_chip_ident,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
@@ -2086,14 +2088,10 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_DQBUF);
 	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QBUF);
 	v4l2_disable_ioctl_locking(&gspca_dev->vdev, VIDIOC_QUERYBUF);
-	if (!gspca_dev->sd_desc->get_chip_ident)
-		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_G_CHIP_IDENT);
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	if (!gspca_dev->sd_desc->get_chip_ident ||
-	    !gspca_dev->sd_desc->get_register)
+	if (!gspca_dev->sd_desc->get_register)
 		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_G_REGISTER);
-	if (!gspca_dev->sd_desc->get_chip_ident ||
-	    !gspca_dev->sd_desc->set_register)
+	if (!gspca_dev->sd_desc->set_register)
 		v4l2_disable_ioctl(&gspca_dev->vdev, VIDIOC_DBG_S_REGISTER);
 #endif
 	if (!gspca_dev->sd_desc->get_jcomp)
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index ef8efeb..ac0b11f 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -78,8 +78,8 @@ typedef int (*cam_get_reg_op) (struct gspca_dev *,
 				struct v4l2_dbg_register *);
 typedef int (*cam_set_reg_op) (struct gspca_dev *,
 				const struct v4l2_dbg_register *);
-typedef int (*cam_ident_op) (struct gspca_dev *,
-				struct v4l2_dbg_chip_ident *);
+typedef int (*cam_chip_info_op) (struct gspca_dev *,
+				struct v4l2_dbg_chip_info *);
 typedef void (*cam_streamparm_op) (struct gspca_dev *,
 				  struct v4l2_streamparm *);
 typedef void (*cam_pkt_op) (struct gspca_dev *gspca_dev,
@@ -112,8 +112,8 @@ struct sd_desc {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	cam_set_reg_op set_register;
 	cam_get_reg_op get_register;
+	cam_chip_info_op get_chip_info;
 #endif
-	cam_ident_op get_chip_ident;
 #if IS_ENABLED(CONFIG_INPUT)
 	cam_int_pkt_op int_pkt_scan;
 	/* other_input makes the gspca core create gspca_dev->input even when
diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index 6008c8d..a915096 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -93,7 +93,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/input.h>
-#include <media/v4l2-chip-ident.h>
 #include "gspca.h"
 /* Include pac common sof detection functions */
 #include "pac_common.h"
@@ -849,8 +848,7 @@ static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
 	 * reg->reg: bit0..15: reserved for register index (wIndex is 16bit
 	 *		       long on the USB bus)
 	 */
-	if (reg->match.type == V4L2_CHIP_MATCH_HOST &&
-	    reg->match.addr == 0 &&
+	if (reg->match.addr == 0 &&
 	    (reg->reg < 0x000000ff) &&
 	    (reg->val <= 0x000000ff)
 	) {
@@ -871,20 +869,6 @@ static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
 	}
 	return gspca_dev->usb_err;
 }
-
-static int sd_chip_ident(struct gspca_dev *gspca_dev,
-			struct v4l2_dbg_chip_ident *chip)
-{
-	int ret = -EINVAL;
-
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST &&
-	    chip->match.addr == 0) {
-		chip->revision = 0;
-		chip->ident = V4L2_IDENT_UNKNOWN;
-		ret = 0;
-	}
-	return ret;
-}
 #endif
 
 #if IS_ENABLED(CONFIG_INPUT)
@@ -931,7 +915,6 @@ static const struct sd_desc sd_desc = {
 	.dq_callback = do_autogain,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.set_register = sd_dbg_s_register,
-	.get_chip_ident = sd_chip_ident,
 #endif
 #if IS_ENABLED(CONFIG_INPUT)
 	.int_pkt_scan = sd_int_pkt_scan,
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index ead9a1f..23b71f9 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -27,7 +27,6 @@
 #include "gspca.h"
 #include "jpeg.h"
 
-#include <media/v4l2-chip-ident.h>
 #include <linux/dmi.h>
 
 MODULE_AUTHOR("Brian Johnson <brijohn@gmail.com>, "
@@ -582,22 +581,6 @@ static const s16 hsv_blue_y[] = {
 	4,   2,   0,  -1,  -3,  -5,  -7,  -9, -11
 };
 
-static const u16 i2c_ident[] = {
-	V4L2_IDENT_OV9650,
-	V4L2_IDENT_OV9655,
-	V4L2_IDENT_SOI968,
-	V4L2_IDENT_OV7660,
-	V4L2_IDENT_OV7670,
-	V4L2_IDENT_MT9V011,
-	V4L2_IDENT_MT9V111,
-	V4L2_IDENT_MT9V112,
-	V4L2_IDENT_MT9M001C12ST,
-	V4L2_IDENT_MT9M111,
-	V4L2_IDENT_MT9M112,
-	V4L2_IDENT_HV7131R,
-[SENSOR_MT9VPRB] = V4L2_IDENT_UNKNOWN,
-};
-
 static const u16 bridge_init[][2] = {
 	{0x1000, 0x78}, {0x1001, 0x40}, {0x1002, 0x1c},
 	{0x1020, 0x80}, {0x1061, 0x01}, {0x1067, 0x40},
@@ -1574,18 +1557,14 @@ static int sd_dbg_g_register(struct gspca_dev *gspca_dev,
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
-		if (reg->match.addr != 0)
-			return -EINVAL;
+	switch (reg->match.addr) {
+	case 0:
 		if (reg->reg < 0x1000 || reg->reg > 0x11ff)
 			return -EINVAL;
 		reg_r(gspca_dev, reg->reg, 1);
 		reg->val = gspca_dev->usb_buf[0];
 		return gspca_dev->usb_err;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		if (reg->match.addr != sd->i2c_addr)
-			return -EINVAL;
+	case 1:
 		if (sd->sensor >= SENSOR_MT9V011 &&
 		    sd->sensor <= SENSOR_MT9M112) {
 			i2c_r2(gspca_dev, reg->reg, (u16 *) &reg->val);
@@ -1602,17 +1581,13 @@ static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
-		if (reg->match.addr != 0)
-			return -EINVAL;
+	switch (reg->match.addr) {
+	case 0:
 		if (reg->reg < 0x1000 || reg->reg > 0x11ff)
 			return -EINVAL;
 		reg_w1(gspca_dev, reg->reg, reg->val);
 		return gspca_dev->usb_err;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		if (reg->match.addr != sd->i2c_addr)
-			return -EINVAL;
+	case 1:
 		if (sd->sensor >= SENSOR_MT9V011 &&
 		    sd->sensor <= SENSOR_MT9M112) {
 			i2c_w2(gspca_dev, reg->reg, reg->val);
@@ -1623,29 +1598,17 @@ static int sd_dbg_s_register(struct gspca_dev *gspca_dev,
 	}
 	return -EINVAL;
 }
-#endif
 
-static int sd_chip_ident(struct gspca_dev *gspca_dev,
-			struct v4l2_dbg_chip_ident *chip)
+static int sd_chip_info(struct gspca_dev *gspca_dev,
+			struct v4l2_dbg_chip_info *chip)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	switch (chip->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
-		if (chip->match.addr != 0)
-			return -EINVAL;
-		chip->revision = 0;
-		chip->ident = V4L2_IDENT_SN9C20X;
-		return 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		if (chip->match.addr != sd->i2c_addr)
-			return -EINVAL;
-		chip->revision = 0;
-		chip->ident = i2c_ident[sd->sensor];
-		return 0;
-	}
-	return -EINVAL;
+	if (chip->match.addr > 1)
+		return -EINVAL;
+	if (chip->match.addr == 1)
+		strlcpy(chip->name, "sensor", sizeof(chip->name));
+	return 0;
 }
+#endif
 
 static int sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
@@ -2356,8 +2319,8 @@ static const struct sd_desc sd_desc = {
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.set_register = sd_dbg_s_register,
 	.get_register = sd_dbg_g_register,
+	.get_chip_info = sd_chip_info,
 #endif
-	.get_chip_ident = sd_chip_ident,
 };
 
 #define SN9C20X(sensor, i2c_addr, flags) \
-- 
1.7.10.4


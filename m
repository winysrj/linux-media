Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54899 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1BSQg2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Feb 2011 11:36:28 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so2314919eye.19
        for <linux-media@vger.kernel.org>; Sat, 19 Feb 2011 08:36:27 -0800 (PST)
From: David Cohen <dacohen@gmail.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi, hverkuil@xs4all.nl
Subject: [RFC/PATCH 1/1] tcm825x: convert driver to V4L2 sub device interface
Date: Sat, 19 Feb 2011 18:35:47 +0200
Message-Id: <1298133347-26796-2-git-send-email-dacohen@gmail.com>
In-Reply-To: <1298133347-26796-1-git-send-email-dacohen@gmail.com>
References: <1298133347-26796-1-git-send-email-dacohen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch converts Toshiba TCM825X VGA camera sersor driver to V4L2 sub
device interface.

Signed-off-by: David Cohen <dacohen@gmail.com>
---
 drivers/media/video/tcm825x.c |  369 ++++++++++++-----------------------------
 drivers/media/video/tcm825x.h |    6 +-
 2 files changed, 109 insertions(+), 266 deletions(-)

diff --git a/drivers/media/video/tcm825x.c b/drivers/media/video/tcm825x.c
index 54681a5..36080f1 100644
--- a/drivers/media/video/tcm825x.c
+++ b/drivers/media/video/tcm825x.c
@@ -7,7 +7,7 @@
  *
  * Contact: Sakari Ailus <sakari.ailus@nokia.com>
  *
- * Based on code from David Cohen <david.cohen@indt.org.br>
+ * Based on code from David Cohen <dacohen@gmail.com>
  *
  * This driver was based on ov9640 sensor driver from MontaVista
  *
@@ -27,7 +27,8 @@
  */
 
 #include <linux/i2c.h>
-#include <media/v4l2-int-device.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
 
 #include "tcm825x.h"
 
@@ -41,37 +42,21 @@
 #define HIGH_FPS_MODE_LOWER_LIMIT 14
 #define DEFAULT_FPS MAX_HALF_FPS
 
+#define to_tcm825x_sensor(sd)	container_of(sd, struct tcm825x_sensor, subdev)
+
 struct tcm825x_sensor {
 	const struct tcm825x_platform_data *platform_data;
-	struct v4l2_int_device *v4l2_int_device;
-	struct i2c_client *i2c_client;
-	struct v4l2_pix_format pix;
+	struct v4l2_subdev subdev;
+	struct v4l2_mbus_framefmt mf;
 	struct v4l2_fract timeperframe;
 };
 
 /* list of image formats supported by TCM825X sensor */
-static const struct v4l2_fmtdesc tcm825x_formats[] = {
-	{
-		.description = "YUYV (YUV 4:2:2), packed",
-		.pixelformat = V4L2_PIX_FMT_UYVY,
-	}, {
-		/* Note:  V4L2 defines RGB565 as:
-		 *
-		 *      Byte 0                    Byte 1
-		 *      g2 g1 g0 r4 r3 r2 r1 r0   b4 b3 b2 b1 b0 g5 g4 g3
-		 *
-		 * We interpret RGB565 as:
-		 *
-		 *      Byte 0                    Byte 1
-		 *      g2 g1 g0 b4 b3 b2 b1 b0   r4 r3 r2 r1 r0 g5 g4 g3
-		 */
-		.description = "RGB565, le",
-		.pixelformat = V4L2_PIX_FMT_RGB565,
-	},
+static const enum v4l2_mbus_pixelcode tcm825x_codes[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_RGB565_2X8_LE,
 };
 
-#define TCM825X_NUM_CAPTURE_FORMATS	ARRAY_SIZE(tcm825x_formats)
-
 /*
  * TCM825X register configuration for all combinations of pixel format and
  * image size
@@ -382,24 +367,24 @@ static struct vcontrol *find_vctrl(int id)
  * as the requested size, or the smallest image size if the requested size
  * has fewer pixels than the smallest image.
  */
-static enum image_size tcm825x_find_size(struct v4l2_int_device *s,
+static enum image_size tcm825x_find_size(struct v4l2_subdev *sd,
 					 unsigned int width,
 					 unsigned int height)
 {
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	enum image_size isize;
 	unsigned long pixels = width * height;
-	struct tcm825x_sensor *sensor = s->priv;
 
 	for (isize = subQCIF; isize < VGA; isize++) {
 		if (tcm825x_sizes[isize + 1].height
 		    * tcm825x_sizes[isize + 1].width > pixels) {
-			dev_dbg(&sensor->i2c_client->dev, "size %d\n", isize);
+			dev_dbg(&client->dev, "size %d\n", isize);
 
 			return isize;
 		}
 	}
 
-	dev_dbg(&sensor->i2c_client->dev, "format default VGA\n");
+	dev_dbg(&client->dev, "format default VGA\n");
 
 	return VGA;
 }
@@ -410,11 +395,12 @@ static enum image_size tcm825x_find_size(struct v4l2_int_device *s,
  * fraction. Returns zero if successful, or non-zero otherwise. The
  * actual frame period is returned in fper.
  */
-static int tcm825x_configure(struct v4l2_int_device *s)
+static int tcm825x_configure(struct v4l2_subdev *sd)
 {
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_pix_format *pix = &sensor->pix;
-	enum image_size isize = tcm825x_find_size(s, pix->width, pix->height);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
+	struct v4l2_mbus_framefmt *mf = &sensor->mf;
+	enum image_size isize = tcm825x_find_size(sd, mf->width, mf->height);
 	struct v4l2_fract *fper = &sensor->timeperframe;
 	enum pixel_format pfmt;
 	int err;
@@ -422,37 +408,32 @@ static int tcm825x_configure(struct v4l2_int_device *s)
 	u8 val;
 
 	/* common register initialization */
-	err = tcm825x_write_default_regs(
-		sensor->i2c_client, sensor->platform_data->default_regs());
+	err = tcm825x_write_default_regs(client,
+					 sensor->platform_data->default_regs());
 	if (err)
 		return err;
 
 	/* configure image size */
 	val = tcm825x_siz_reg[isize]->val;
-	dev_dbg(&sensor->i2c_client->dev,
-		"configuring image size %d\n", isize);
-	err = tcm825x_write_reg_mask(sensor->i2c_client,
-				     tcm825x_siz_reg[isize]->reg, val);
+	dev_dbg(&client->dev, "configuring image size %d\n", isize);
+	err = tcm825x_write_reg_mask(client, tcm825x_siz_reg[isize]->reg, val);
 	if (err)
 		return err;
 
 	/* configure pixel format */
-	switch (pix->pixelformat) {
-	default:
-	case V4L2_PIX_FMT_RGB565:
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_RGB565_2X8_LE:
 		pfmt = RGB565;
 		break;
-	case V4L2_PIX_FMT_UYVY:
+	default:
 		pfmt = YUV422;
 		break;
 	}
 
-	dev_dbg(&sensor->i2c_client->dev,
-		"configuring pixel format %d\n", pfmt);
+	dev_dbg(&client->dev, "configuring pixel format %d\n", pfmt);
 	val = tcm825x_fmt_reg[pfmt]->val;
 
-	err = tcm825x_write_reg_mask(sensor->i2c_client,
-				     tcm825x_fmt_reg[pfmt]->reg, val);
+	err = tcm825x_write_reg_mask(client, tcm825x_fmt_reg[pfmt]->reg, val);
 	if (err)
 		return err;
 
@@ -462,16 +443,15 @@ static int tcm825x_configure(struct v4l2_int_device *s)
 	 */
 	tgt_fps = fper->denominator / fper->numerator;
 	if (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) {
-		val = tcm825x_read_reg(sensor->i2c_client, 0x02);
+		val = tcm825x_read_reg(client, 0x02);
 		val |= 0x80;
-		tcm825x_write_reg(sensor->i2c_client, 0x02, val);
+		tcm825x_write_reg(client, 0x02, val);
 	}
 
 	return 0;
 }
 
-static int ioctl_queryctrl(struct v4l2_int_device *s,
-				struct v4l2_queryctrl *qc)
+static int tcm825x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
 {
 	struct vcontrol *control;
 
@@ -485,11 +465,10 @@ static int ioctl_queryctrl(struct v4l2_int_device *s,
 	return 0;
 }
 
-static int ioctl_g_ctrl(struct v4l2_int_device *s,
-			     struct v4l2_control *vc)
+static int tcm825x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *vc)
 {
-	struct tcm825x_sensor *sensor = s->priv;
-	struct i2c_client *client = sensor->i2c_client;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 	int val, r;
 	struct vcontrol *lvc;
 
@@ -530,11 +509,10 @@ static int ioctl_g_ctrl(struct v4l2_int_device *s,
 	return 0;
 }
 
-static int ioctl_s_ctrl(struct v4l2_int_device *s,
-			     struct v4l2_control *vc)
+static int tcm825x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *vc)
 {
-	struct tcm825x_sensor *sensor = s->priv;
-	struct i2c_client *client = sensor->i2c_client;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 	struct vcontrol *lvc;
 	int val = vc->value;
 
@@ -569,104 +547,79 @@ static int ioctl_s_ctrl(struct v4l2_int_device *s,
 	return 0;
 }
 
-static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
-				   struct v4l2_fmtdesc *fmt)
+static int tcm825x_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
+			    enum v4l2_mbus_pixelcode *code)
 {
-	int index = fmt->index;
-
-	switch (fmt->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (index >= TCM825X_NUM_CAPTURE_FORMATS)
-			return -EINVAL;
-		break;
-
-	default:
+	if (index >= ARRAY_SIZE(tcm825x_codes))
 		return -EINVAL;
-	}
 
-	fmt->flags = tcm825x_formats[index].flags;
-	strlcpy(fmt->description, tcm825x_formats[index].description,
-		sizeof(fmt->description));
-	fmt->pixelformat = tcm825x_formats[index].pixelformat;
+	*code = tcm825x_codes[index];
 
 	return 0;
 }
 
-static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
-			     struct v4l2_format *f)
+static int tcm825x_try_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_mbus_framefmt *mf)
 {
-	struct tcm825x_sensor *sensor = s->priv;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	enum image_size isize;
 	int ifmt;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	isize = tcm825x_find_size(s, pix->width, pix->height);
-	dev_dbg(&sensor->i2c_client->dev, "isize = %d num_capture = %lu\n",
-		isize, (unsigned long)TCM825X_NUM_CAPTURE_FORMATS);
+	isize = tcm825x_find_size(sd, mf->width, mf->height);
+	dev_dbg(&client->dev, "isize = %d num_capture = %d\n",
+		isize, ARRAY_SIZE(tcm825x_codes));
 
-	pix->width = tcm825x_sizes[isize].width;
-	pix->height = tcm825x_sizes[isize].height;
+	mf->width = tcm825x_sizes[isize].width;
+	mf->height = tcm825x_sizes[isize].height;
 
-	for (ifmt = 0; ifmt < TCM825X_NUM_CAPTURE_FORMATS; ifmt++)
-		if (pix->pixelformat == tcm825x_formats[ifmt].pixelformat)
+	for (ifmt = 0; ifmt < ARRAY_SIZE(tcm825x_codes); ifmt++)
+		if (mf->code == tcm825x_codes[ifmt])
 			break;
 
-	if (ifmt == TCM825X_NUM_CAPTURE_FORMATS)
+	if (ifmt == ARRAY_SIZE(tcm825x_codes))
 		ifmt = 0;	/* Default = YUV 4:2:2 */
 
-	pix->pixelformat = tcm825x_formats[ifmt].pixelformat;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = pix->width * TCM825X_BYTES_PER_PIXEL;
-	pix->sizeimage = pix->bytesperline * pix->height;
-	pix->priv = 0;
-	dev_dbg(&sensor->i2c_client->dev, "format = 0x%08x\n",
-		pix->pixelformat);
+	mf->code = tcm825x_codes[ifmt];
+	mf->field = V4L2_FIELD_NONE;
+	dev_dbg(&client->dev, "format = 0x%08x\n", mf->code);
 
-	switch (pix->pixelformat) {
-	case V4L2_PIX_FMT_UYVY:
-	default:
-		pix->colorspace = V4L2_COLORSPACE_JPEG;
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_RGB565_2X8_LE:
+		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
-	case V4L2_PIX_FMT_RGB565:
-		pix->colorspace = V4L2_COLORSPACE_SRGB;
+	default: /* YUV */
+		mf->colorspace = V4L2_COLORSPACE_JPEG;
 		break;
 	}
 
 	return 0;
 }
 
-static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
-				struct v4l2_format *f)
+static int tcm825x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 	int rval;
 
-	rval = ioctl_try_fmt_cap(s, f);
+	rval = tcm825x_try_fmt(sd, mf);
 	if (rval)
 		return rval;
+	sensor->mf = *mf;
 
-	rval = tcm825x_configure(s);
-
-	sensor->pix = *pix;
-
-	return rval;
+	return tcm825x_configure(sd);
 }
 
-static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
-				struct v4l2_format *f)
+static int tcm825x_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 {
-	struct tcm825x_sensor *sensor = s->priv;
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 
-	f->fmt.pix = sensor->pix;
+	*mf = sensor->mf;
 
 	return 0;
 }
 
-static int ioctl_g_parm(struct v4l2_int_device *s,
-			     struct v4l2_streamparm *a)
+static int tcm825x_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 {
-	struct tcm825x_sensor *sensor = s->priv;
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 	struct v4l2_captureparm *cparm = &a->parm.capture;
 
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -681,10 +634,9 @@ static int ioctl_g_parm(struct v4l2_int_device *s,
 	return 0;
 }
 
-static int ioctl_s_parm(struct v4l2_int_device *s,
-			     struct v4l2_streamparm *a)
+static int tcm825x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
 {
-	struct tcm825x_sensor *sensor = s->priv;
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 	struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
 	u32 tgt_fps;	/* target frames per secound */
 	int rval;
@@ -710,147 +662,52 @@ static int ioctl_s_parm(struct v4l2_int_device *s,
 
 	sensor->timeperframe = *timeperframe;
 
-	rval = tcm825x_configure(s);
+	rval = tcm825x_configure(sd);
 
 	return rval;
 }
 
-static int ioctl_s_power(struct v4l2_int_device *s, int on)
+static int tcm825x_s_power(struct v4l2_subdev *sd, int on)
 {
-	struct tcm825x_sensor *sensor = s->priv;
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 
 	return sensor->platform_data->power_set(on);
 }
 
-/*
- * Given the image capture format in pix, the nominal frame period in
- * timeperframe, calculate the required xclk frequency.
- *
- * TCM825X input frequency characteristics are:
- *     Minimum 11.9 MHz, Typical 24.57 MHz and maximum 25/27 MHz
- */
-
-static int ioctl_g_ifparm(struct v4l2_int_device *s, struct v4l2_ifparm *p)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	struct v4l2_fract *timeperframe = &sensor->timeperframe;
-	u32 tgt_xclk;	/* target xclk */
-	u32 tgt_fps;	/* target frames per secound */
-	int rval;
-
-	rval = sensor->platform_data->ifparm(p);
-	if (rval)
-		return rval;
-
-	tgt_fps = timeperframe->denominator / timeperframe->numerator;
-
-	tgt_xclk = (tgt_fps <= HIGH_FPS_MODE_LOWER_LIMIT) ?
-		(2457 * tgt_fps) / MAX_HALF_FPS :
-		(2457 * tgt_fps) / MAX_FPS;
-	tgt_xclk *= 10000;
-
-	tgt_xclk = min(tgt_xclk, (u32)TCM825X_XCLK_MAX);
-	tgt_xclk = max(tgt_xclk, (u32)TCM825X_XCLK_MIN);
-
-	p->u.bt656.clock_curr = tgt_xclk;
-
-	return 0;
-}
-
-static int ioctl_g_needs_reset(struct v4l2_int_device *s, void *buf)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-
-	return sensor->platform_data->needs_reset(s, buf, &sensor->pix);
-}
-
-static int ioctl_reset(struct v4l2_int_device *s)
+static int tcm825x_s_stream(struct v4l2_subdev *sd, int enable)
 {
-	return -EBUSY;
+	return tcm825x_configure(sd);
 }
 
-static int ioctl_init(struct v4l2_int_device *s)
-{
-	return tcm825x_configure(s);
-}
-
-static int ioctl_dev_exit(struct v4l2_int_device *s)
-{
-	return 0;
-}
-
-static int ioctl_dev_init(struct v4l2_int_device *s)
-{
-	struct tcm825x_sensor *sensor = s->priv;
-	int r;
-
-	r = tcm825x_read_reg(sensor->i2c_client, 0x01);
-	if (r < 0)
-		return r;
-	if (r == 0) {
-		dev_err(&sensor->i2c_client->dev, "device not detected\n");
-		return -EIO;
-	}
-	return 0;
-}
-
-static struct v4l2_int_ioctl_desc tcm825x_ioctl_desc[] = {
-	{ vidioc_int_dev_init_num,
-	  (v4l2_int_ioctl_func *)ioctl_dev_init },
-	{ vidioc_int_dev_exit_num,
-	  (v4l2_int_ioctl_func *)ioctl_dev_exit },
-	{ vidioc_int_s_power_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_power },
-	{ vidioc_int_g_ifparm_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_ifparm },
-	{ vidioc_int_g_needs_reset_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_needs_reset },
-	{ vidioc_int_reset_num,
-	  (v4l2_int_ioctl_func *)ioctl_reset },
-	{ vidioc_int_init_num,
-	  (v4l2_int_ioctl_func *)ioctl_init },
-	{ vidioc_int_enum_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_enum_fmt_cap },
-	{ vidioc_int_try_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_try_fmt_cap },
-	{ vidioc_int_g_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_fmt_cap },
-	{ vidioc_int_s_fmt_cap_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_fmt_cap },
-	{ vidioc_int_g_parm_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_parm },
-	{ vidioc_int_s_parm_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_parm },
-	{ vidioc_int_queryctrl_num,
-	  (v4l2_int_ioctl_func *)ioctl_queryctrl },
-	{ vidioc_int_g_ctrl_num,
-	  (v4l2_int_ioctl_func *)ioctl_g_ctrl },
-	{ vidioc_int_s_ctrl_num,
-	  (v4l2_int_ioctl_func *)ioctl_s_ctrl },
+static struct v4l2_subdev_core_ops tcm825x_subdev_core_ops = {
+	.queryctrl	= tcm825x_queryctrl,
+	.g_ctrl		= tcm825x_g_ctrl,
+	.s_ctrl		= tcm825x_s_ctrl,
+	.s_power	= tcm825x_s_power,
 };
 
-static struct v4l2_int_slave tcm825x_slave = {
-	.ioctls = tcm825x_ioctl_desc,
-	.num_ioctls = ARRAY_SIZE(tcm825x_ioctl_desc),
+static struct v4l2_subdev_video_ops tcm825x_subdev_video_ops = {
+	.g_parm		= tcm825x_g_parm,
+	.s_parm		= tcm825x_s_parm,
+	.enum_mbus_fmt	= tcm825x_enum_fmt,
+	.g_mbus_fmt	= tcm825x_g_fmt,
+	.try_mbus_fmt	= tcm825x_try_fmt,
+	.s_mbus_fmt	= tcm825x_s_fmt,
+	.s_stream	= tcm825x_s_stream,
 };
 
-static struct tcm825x_sensor tcm825x;
-
-static struct v4l2_int_device tcm825x_int_device = {
-	.module = THIS_MODULE,
-	.name = TCM825X_NAME,
-	.priv = &tcm825x,
-	.type = v4l2_int_type_slave,
-	.u = {
-		.slave = &tcm825x_slave,
-	},
+static struct v4l2_subdev_ops tcm825x_subdev_ops = {
+	.core	= &tcm825x_subdev_core_ops,
+	.video	= &tcm825x_subdev_video_ops,
 };
 
 static int tcm825x_probe(struct i2c_client *client,
 			 const struct i2c_device_id *did)
 {
-	struct tcm825x_sensor *sensor = &tcm825x;
+	struct tcm825x_sensor *sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
 
+	if (!sensor)
+		return -ENOMEM;
 	if (i2c_get_clientdata(client))
 		return -EBUSY;
 
@@ -860,28 +717,25 @@ static int tcm825x_probe(struct i2c_client *client,
 	    || !sensor->platform_data->is_okay())
 		return -ENODEV;
 
-	sensor->v4l2_int_device = &tcm825x_int_device;
-
-	sensor->i2c_client = client;
-	i2c_set_clientdata(client, sensor);
-
 	/* Make the default capture format QVGA RGB565 */
-	sensor->pix.width = tcm825x_sizes[QVGA].width;
-	sensor->pix.height = tcm825x_sizes[QVGA].height;
-	sensor->pix.pixelformat = V4L2_PIX_FMT_RGB565;
+	sensor->mf.width = tcm825x_sizes[QVGA].width;
+	sensor->mf.height = tcm825x_sizes[QVGA].height;
+	sensor->mf.code = V4L2_MBUS_FMT_UYVY8_2X8;
+	sensor->mf.colorspace = V4L2_COLORSPACE_JPEG;
+	sensor->timeperframe.numerator = 1;
+	sensor->timeperframe.denominator = DEFAULT_FPS,
 
-	return v4l2_int_device_register(sensor->v4l2_int_device);
+	v4l2_i2c_subdev_init(&sensor->subdev, client, &tcm825x_subdev_ops);
+
+	return 0;
 }
 
 static int tcm825x_remove(struct i2c_client *client)
 {
-	struct tcm825x_sensor *sensor = i2c_get_clientdata(client);
-
-	if (!client->adapter)
-		return -ENODEV;	/* our client isn't attached */
-
-	v4l2_int_device_unregister(sensor->v4l2_int_device);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tcm825x_sensor *sensor = to_tcm825x_sensor(sd);
 
+	kfree(sensor);
 	return 0;
 }
 
@@ -900,13 +754,6 @@ static struct i2c_driver tcm825x_i2c_driver = {
 	.id_table = tcm825x_id,
 };
 
-static struct tcm825x_sensor tcm825x = {
-	.timeperframe = {
-		.numerator   = 1,
-		.denominator = DEFAULT_FPS,
-	},
-};
-
 static int __init tcm825x_init(void)
 {
 	int rval;
diff --git a/drivers/media/video/tcm825x.h b/drivers/media/video/tcm825x.h
index 5b7e696..fd15332 100644
--- a/drivers/media/video/tcm825x.h
+++ b/drivers/media/video/tcm825x.h
@@ -16,8 +16,7 @@
 #define TCM825X_H
 
 #include <linux/videodev2.h>
-
-#include <media/v4l2-int-device.h>
+#include <media/v4l2-device.h>
 
 #define TCM825X_NAME "tcm825x"
 
@@ -179,9 +178,6 @@ struct tcm825x_platform_data {
 	int (*power_set)(int power);
 	/* Default registers written after power-on or reset. */
 	const struct tcm825x_reg *(*default_regs)(void);
-	int (*needs_reset)(struct v4l2_int_device *s, void *buf,
-			   struct v4l2_pix_format *fmt);
-	int (*ifparm)(struct v4l2_ifparm *p);
 	int (*is_upside_down)(void);
 };
 
-- 
1.7.1


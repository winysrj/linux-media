Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49309 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbaDIOad (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 10:30:33 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so2584356pad.21
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 07:30:32 -0700 (PDT)
Date: Thu, 10 Apr 2014 00:30:07 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, driverdev-devel@linuxdriverproject.org
Subject: [PATCH] staging: media: omap24xx: fix up some checkpatch.pl issues
Message-ID: <20140409143000.GA8271@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tcm825x.c:

ERROR: Macros with complex values should be enclosed in parenthesis
WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

tcm825x.h:

ERROR: Macros with complex values should be enclosed in parenthesis

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/media/omap24xx/tcm825x.c |   40 +++++++++++++++---------------
 drivers/staging/media/omap24xx/tcm825x.h |    4 +--
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/omap24xx/tcm825x.c b/drivers/staging/media/omap24xx/tcm825x.c
index f4dd32d..48186a4 100644
--- a/drivers/staging/media/omap24xx/tcm825x.c
+++ b/drivers/staging/media/omap24xx/tcm825x.c
@@ -89,10 +89,10 @@ static const struct tcm825x_reg rgb565	=	{ 0x02, TCM825X_PICFMT };
 
 /* Our own specific controls */
 #define V4L2_CID_ALC				V4L2_CID_PRIVATE_BASE
-#define V4L2_CID_H_EDGE_EN			V4L2_CID_PRIVATE_BASE + 1
-#define V4L2_CID_V_EDGE_EN			V4L2_CID_PRIVATE_BASE + 2
-#define V4L2_CID_LENS				V4L2_CID_PRIVATE_BASE + 3
-#define V4L2_CID_MAX_EXPOSURE_TIME		V4L2_CID_PRIVATE_BASE + 4
+#define V4L2_CID_H_EDGE_EN			(V4L2_CID_PRIVATE_BASE + 1)
+#define V4L2_CID_V_EDGE_EN			(V4L2_CID_PRIVATE_BASE + 2)
+#define V4L2_CID_LENS				(V4L2_CID_PRIVATE_BASE + 3)
+#define V4L2_CID_MAX_EXPOSURE_TIME		(V4L2_CID_PRIVATE_BASE + 4)
 #define V4L2_CID_LAST_PRIV			V4L2_CID_MAX_EXPOSURE_TIME
 
 /*  Video controls  */
@@ -350,8 +350,8 @@ static int tcm825x_write_default_regs(struct i2c_client *client,
 	int err;
 	const struct tcm825x_reg *next = reglist;
 
-	while (!((next->reg == TCM825X_REG_TERM)
-		 && (next->val == TCM825X_VAL_TERM))) {
+	while (!((next->reg == TCM825X_REG_TERM) &&
+		 (next->val == TCM825X_VAL_TERM))) {
 		err = tcm825x_write_reg(client, next->reg, next->val);
 		if (err) {
 			dev_err(&client->dev, "register writing failed\n");
@@ -472,7 +472,7 @@ static int tcm825x_configure(struct v4l2_int_device *s)
 }
 
 static int ioctl_queryctrl(struct v4l2_int_device *s,
-				struct v4l2_queryctrl *qc)
+			   struct v4l2_queryctrl *qc)
 {
 	struct vcontrol *control;
 
@@ -487,7 +487,7 @@ static int ioctl_queryctrl(struct v4l2_int_device *s,
 }
 
 static int ioctl_g_ctrl(struct v4l2_int_device *s,
-			     struct v4l2_control *vc)
+			struct v4l2_control *vc)
 {
 	struct tcm825x_sensor *sensor = s->priv;
 	struct i2c_client *client = sensor->i2c_client;
@@ -532,7 +532,7 @@ static int ioctl_g_ctrl(struct v4l2_int_device *s,
 }
 
 static int ioctl_s_ctrl(struct v4l2_int_device *s,
-			     struct v4l2_control *vc)
+			struct v4l2_control *vc)
 {
 	struct tcm825x_sensor *sensor = s->priv;
 	struct i2c_client *client = sensor->i2c_client;
@@ -571,7 +571,7 @@ static int ioctl_s_ctrl(struct v4l2_int_device *s,
 }
 
 static int ioctl_enum_fmt_cap(struct v4l2_int_device *s,
-				   struct v4l2_fmtdesc *fmt)
+			      struct v4l2_fmtdesc *fmt)
 {
 	int index = fmt->index;
 
@@ -637,7 +637,7 @@ static int ioctl_try_fmt_cap(struct v4l2_int_device *s,
 }
 
 static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
-				struct v4l2_format *f)
+			   struct v4l2_format *f)
 {
 	struct tcm825x_sensor *sensor = s->priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
@@ -655,7 +655,7 @@ static int ioctl_s_fmt_cap(struct v4l2_int_device *s,
 }
 
 static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
-				struct v4l2_format *f)
+			   struct v4l2_format *f)
 {
 	struct tcm825x_sensor *sensor = s->priv;
 
@@ -665,7 +665,7 @@ static int ioctl_g_fmt_cap(struct v4l2_int_device *s,
 }
 
 static int ioctl_g_parm(struct v4l2_int_device *s,
-			     struct v4l2_streamparm *a)
+			struct v4l2_streamparm *a)
 {
 	struct tcm825x_sensor *sensor = s->priv;
 	struct v4l2_captureparm *cparm = &a->parm.capture;
@@ -683,7 +683,7 @@ static int ioctl_g_parm(struct v4l2_int_device *s,
 }
 
 static int ioctl_s_parm(struct v4l2_int_device *s,
-			     struct v4l2_streamparm *a)
+			struct v4l2_streamparm *a)
 {
 	struct tcm825x_sensor *sensor = s->priv;
 	struct v4l2_fract *timeperframe = &a->parm.capture.timeperframe;
@@ -693,8 +693,8 @@ static int ioctl_s_parm(struct v4l2_int_device *s,
 	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if ((timeperframe->numerator == 0)
-	    || (timeperframe->denominator == 0)) {
+	if ((timeperframe->numerator == 0) ||
+	    (timeperframe->denominator == 0)) {
 		timeperframe->denominator = DEFAULT_FPS;
 		timeperframe->numerator = 1;
 	}
@@ -857,8 +857,8 @@ static int tcm825x_probe(struct i2c_client *client,
 
 	sensor->platform_data = client->dev.platform_data;
 
-	if (sensor->platform_data == NULL
-	    || !sensor->platform_data->is_okay())
+	if (sensor->platform_data == NULL ||
+	    !sensor->platform_data->is_okay())
 		return -ENODEV;
 
 	sensor->v4l2_int_device = &tcm825x_int_device;
@@ -914,8 +914,8 @@ static int __init tcm825x_init(void)
 
 	rval = i2c_add_driver(&tcm825x_i2c_driver);
 	if (rval)
-		printk(KERN_INFO "%s: failed registering " TCM825X_NAME "\n",
-		       __func__);
+		pr_info("%s: failed registering " TCM825X_NAME "\n",
+			__func__);
 
 	return rval;
 }
diff --git a/drivers/staging/media/omap24xx/tcm825x.h b/drivers/staging/media/omap24xx/tcm825x.h
index 9970fb1..4a41127 100644
--- a/drivers/staging/media/omap24xx/tcm825x.h
+++ b/drivers/staging/media/omap24xx/tcm825x.h
@@ -21,8 +21,8 @@
 
 #define TCM825X_NAME "tcm825x"
 
-#define TCM825X_MASK(x)  x & 0x00ff
-#define TCM825X_ADDR(x) (x & 0xff00) >> 8
+#define TCM825X_MASK(x)  (x & 0x00ff)
+#define TCM825X_ADDR(x) ((x & 0xff00) >> 8)
 
 /* The TCM825X I2C sensor chip has a fixed slave address of 0x3d. */
 #define TCM825X_I2C_ADDR	0x3d
-- 
1.7.9.5


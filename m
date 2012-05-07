Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757697Ab2EGTUj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:39 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 22/23] gspca-mars: convert to the control framework.
Date: Mon,  7 May 2012 21:01:33 +0200
Message-Id: <1336417294-4566-23-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/mars.c |  293 +++++++++++++++++---------------------
 1 file changed, 127 insertions(+), 166 deletions(-)

diff --git a/drivers/media/video/gspca/mars.c b/drivers/media/video/gspca/mars.c
index b023146..f9c4df2 100644
--- a/drivers/media/video/gspca/mars.c
+++ b/drivers/media/video/gspca/mars.c
@@ -25,27 +25,26 @@
 
 #include "gspca.h"
 #include "jpeg.h"
+#include <media/v4l2-ctrls.h>
 
 MODULE_AUTHOR("Michel Xhaard <mxhaard@users.sourceforge.net>");
 MODULE_DESCRIPTION("GSPCA/Mars USB Camera Driver");
 MODULE_LICENSE("GPL");
 
-/* controls */
-enum e_ctrl {
-	BRIGHTNESS,
-	COLORS,
-	GAMMA,
-	SHARPNESS,
-	ILLUM_TOP,
-	ILLUM_BOT,
-	NCTRLS		/* number of controls */
-};
-
 /* specific webcam descriptor */
 struct sd {
 	struct gspca_dev gspca_dev;	/* !! must be the first item */
 
-	struct gspca_ctrl ctrls[NCTRLS];
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *brightness;
+	struct v4l2_ctrl *saturation;
+	struct v4l2_ctrl *sharpness;
+	struct v4l2_ctrl *gamma;
+	struct { /* illuminator control cluster */
+		struct v4l2_ctrl *illum_top;
+		struct v4l2_ctrl *illum_bottom;
+	};
+	struct v4l2_ctrl *jpegqual;
 
 	u8 quality;
 #define QUALITY_MIN 40
@@ -56,89 +55,10 @@ struct sd {
 };
 
 /* V4L2 controls supported by the driver */
-static void setbrightness(struct gspca_dev *gspca_dev);
-static void setcolors(struct gspca_dev *gspca_dev);
-static void setgamma(struct gspca_dev *gspca_dev);
-static void setsharpness(struct gspca_dev *gspca_dev);
-static int sd_setilluminator1(struct gspca_dev *gspca_dev, __s32 val);
-static int sd_setilluminator2(struct gspca_dev *gspca_dev, __s32 val);
-
-static const struct ctrl sd_ctrls[NCTRLS] = {
-[BRIGHTNESS] = {
-	    {
-		.id      = V4L2_CID_BRIGHTNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Brightness",
-		.minimum = 0,
-		.maximum = 30,
-		.step    = 1,
-		.default_value = 15,
-	    },
-	    .set_control = setbrightness
-	},
-[COLORS] = {
-	    {
-		.id      = V4L2_CID_SATURATION,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Color",
-		.minimum = 1,
-		.maximum = 255,
-		.step    = 1,
-		.default_value = 200,
-	    },
-	    .set_control = setcolors
-	},
-[GAMMA] = {
-	    {
-		.id      = V4L2_CID_GAMMA,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Gamma",
-		.minimum = 0,
-		.maximum = 3,
-		.step    = 1,
-		.default_value = 1,
-	    },
-	    .set_control = setgamma
-	},
-[SHARPNESS] = {
-	    {
-		.id	 = V4L2_CID_SHARPNESS,
-		.type    = V4L2_CTRL_TYPE_INTEGER,
-		.name    = "Sharpness",
-		.minimum = 0,
-		.maximum = 2,
-		.step    = 1,
-		.default_value = 1,
-	    },
-	    .set_control = setsharpness
-	},
-[ILLUM_TOP] = {
-	    {
-		.id	 = V4L2_CID_ILLUMINATORS_1,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Top illuminator",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = 0,
-		.flags = V4L2_CTRL_FLAG_UPDATE,
-	    },
-	    .set = sd_setilluminator1
-	},
-[ILLUM_BOT] = {
-	    {
-		.id	 = V4L2_CID_ILLUMINATORS_2,
-		.type    = V4L2_CTRL_TYPE_BOOLEAN,
-		.name    = "Bottom illuminator",
-		.minimum = 0,
-		.maximum = 1,
-		.step    = 1,
-		.default_value = 0,
-		.flags = V4L2_CTRL_FLAG_UPDATE,
-	    },
-	    .set = sd_setilluminator2
-	},
-};
+static void setbrightness(struct gspca_dev *gspca_dev, s32 val);
+static void setcolors(struct gspca_dev *gspca_dev, s32 val);
+static void setgamma(struct gspca_dev *gspca_dev, s32 val);
+static void setsharpness(struct gspca_dev *gspca_dev, s32 val);
 
 static const struct v4l2_pix_format vga_mode[] = {
 	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
@@ -198,59 +118,129 @@ static void mi_w(struct gspca_dev *gspca_dev,
 	reg_w(gspca_dev, 4);
 }
 
-static void setbrightness(struct gspca_dev *gspca_dev)
+static void setbrightness(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
 	gspca_dev->usb_buf[0] = 0x61;
-	gspca_dev->usb_buf[1] = sd->ctrls[BRIGHTNESS].val;
+	gspca_dev->usb_buf[1] = val;
 	reg_w(gspca_dev, 2);
 }
 
-static void setcolors(struct gspca_dev *gspca_dev)
+static void setcolors(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-	s16 val;
-
-	val = sd->ctrls[COLORS].val;
 	gspca_dev->usb_buf[0] = 0x5f;
 	gspca_dev->usb_buf[1] = val << 3;
 	gspca_dev->usb_buf[2] = ((val >> 2) & 0xf8) | 0x04;
 	reg_w(gspca_dev, 3);
 }
 
-static void setgamma(struct gspca_dev *gspca_dev)
+static void setgamma(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
 	gspca_dev->usb_buf[0] = 0x06;
-	gspca_dev->usb_buf[1] = sd->ctrls[GAMMA].val * 0x40;
+	gspca_dev->usb_buf[1] = val * 0x40;
 	reg_w(gspca_dev, 2);
 }
 
-static void setsharpness(struct gspca_dev *gspca_dev)
+static void setsharpness(struct gspca_dev *gspca_dev, s32 val)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
 	gspca_dev->usb_buf[0] = 0x67;
-	gspca_dev->usb_buf[1] = sd->ctrls[SHARPNESS].val * 4 + 3;
+	gspca_dev->usb_buf[1] = val * 4 + 3;
 	reg_w(gspca_dev, 2);
 }
 
-static void setilluminators(struct gspca_dev *gspca_dev)
+static void setilluminators(struct gspca_dev *gspca_dev, bool top, bool bottom)
 {
-	struct sd *sd = (struct sd *) gspca_dev;
-
+	/* both are off if not streaming */
 	gspca_dev->usb_buf[0] = 0x22;
-	if (sd->ctrls[ILLUM_TOP].val)
+	if (top)
 		gspca_dev->usb_buf[1] = 0x76;
-	else if (sd->ctrls[ILLUM_BOT].val)
+	else if (bottom)
 		gspca_dev->usb_buf[1] = 0x7a;
 	else
 		gspca_dev->usb_buf[1] = 0x7e;
 	reg_w(gspca_dev, 2);
 }
 
+static int mars_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct sd *sd = container_of(ctrl->handler, struct sd, ctrl_handler);
+	struct gspca_dev *gspca_dev = &sd->gspca_dev;
+
+	gspca_dev->usb_err = 0;
+
+	if (ctrl->id == V4L2_CID_ILLUMINATORS_1) {
+		/* only one can be on at a time */
+		if (ctrl->is_new && ctrl->val)
+			sd->illum_bottom->val = 0;
+		if (sd->illum_bottom->is_new && sd->illum_bottom->val)
+			sd->illum_top->val = 0;
+	}
+
+	if (!gspca_dev->streaming)
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		setbrightness(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		setcolors(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_GAMMA:
+		setgamma(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_ILLUMINATORS_1:
+		setilluminators(&sd->gspca_dev, sd->illum_top->val,
+						sd->illum_bottom->val);
+		break;
+	case V4L2_CID_SHARPNESS:
+		setsharpness(&sd->gspca_dev, ctrl->val);
+		break;
+	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
+		jpeg_set_qual(sd->jpeg_hdr, ctrl->val);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return gspca_dev->usb_err;
+}
+
+static const struct v4l2_ctrl_ops mars_ctrl_ops = {
+	.s_ctrl = mars_s_ctrl,
+};
+
+/* this function is called at probe time */
+static int sd_init_controls(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	struct v4l2_ctrl_handler *hdl = &sd->ctrl_handler;
+
+	gspca_dev->vdev.ctrl_handler = hdl;
+	v4l2_ctrl_handler_init(hdl, 7);
+	sd->brightness = v4l2_ctrl_new_std(hdl, &mars_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 30, 1, 15);
+	sd->saturation = v4l2_ctrl_new_std(hdl, &mars_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 200);
+	sd->gamma = v4l2_ctrl_new_std(hdl, &mars_ctrl_ops,
+			V4L2_CID_GAMMA, 0, 3, 1, 1);
+	sd->sharpness = v4l2_ctrl_new_std(hdl, &mars_ctrl_ops,
+			V4L2_CID_SHARPNESS, 0, 2, 1, 1);
+	sd->illum_top = v4l2_ctrl_new_std(hdl, &mars_ctrl_ops,
+			V4L2_CID_ILLUMINATORS_1, 0, 1, 1, 0);
+	sd->illum_top->flags |= V4L2_CTRL_FLAG_UPDATE;
+	sd->illum_bottom = v4l2_ctrl_new_std(hdl, &mars_ctrl_ops,
+			V4L2_CID_ILLUMINATORS_2, 0, 1, 1, 0);
+	sd->illum_bottom->flags |= V4L2_CTRL_FLAG_UPDATE;
+	sd->jpegqual = v4l2_ctrl_new_std(hdl, &mars_ctrl_ops,
+			V4L2_CID_JPEG_COMPRESSION_QUALITY,
+			QUALITY_MIN, QUALITY_MAX, 1, QUALITY_DEF);
+	if (hdl->error) {
+		pr_err("Could not initialize controls\n");
+		return hdl->error;
+	}
+	v4l2_ctrl_cluster(2, &sd->illum_top);
+	return 0;
+}
+
 /* this function is called at probe time */
 static int sd_config(struct gspca_dev *gspca_dev,
 			const struct usb_device_id *id)
@@ -261,7 +251,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	cam = &gspca_dev->cam;
 	cam->cam_mode = vga_mode;
 	cam->nmodes = ARRAY_SIZE(vga_mode);
-	cam->ctrls = sd->ctrls;
 	sd->quality = QUALITY_DEF;
 	return 0;
 }
@@ -269,7 +258,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 /* this function is called at probe and resume time */
 static int sd_init(struct gspca_dev *gspca_dev)
 {
-	gspca_dev->ctrl_inac = (1 << ILLUM_TOP) | (1 << ILLUM_BOT);
 	return 0;
 }
 
@@ -282,7 +270,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* create the JPEG header */
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);		/* JPEG 422 */
-	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+	jpeg_set_qual(sd->jpeg_hdr, v4l2_ctrl_g_ctrl(sd->jpegqual));
 
 	data = gspca_dev->usb_buf;
 
@@ -301,7 +289,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	data[5] = 0x30;		/* reg 4, MI, PAS5101 :
 				 *	0x30 for 24mhz , 0x28 for 12mhz */
 	data[6] = 0x02;		/* reg 5, H start - was 0x04 */
-	data[7] = sd->ctrls[GAMMA].val * 0x40;	/* reg 0x06: gamma */
+	data[7] = v4l2_ctrl_g_ctrl(sd->gamma) * 0x40;	/* reg 0x06: gamma */
 	data[8] = 0x01;		/* reg 7, V start - was 0x03 */
 /*	if (h_size == 320 ) */
 /*		data[9]= 0x56;	 * reg 8, 24MHz, 2:1 scale down */
@@ -333,16 +321,16 @@ static int sd_start(struct gspca_dev *gspca_dev)
 				/* reg 0x5f/0x60 (LE) = saturation */
 				/* h (60): xxxx x100
 				 * l (5f): xxxx x000 */
-	data[2] = sd->ctrls[COLORS].val << 3;
-	data[3] = ((sd->ctrls[COLORS].val >> 2) & 0xf8) | 0x04;
-	data[4] = sd->ctrls[BRIGHTNESS].val; /* reg 0x61 = brightness */
+	data[2] = v4l2_ctrl_g_ctrl(sd->saturation) << 3;
+	data[3] = ((v4l2_ctrl_g_ctrl(sd->saturation) >> 2) & 0xf8) | 0x04;
+	data[4] = v4l2_ctrl_g_ctrl(sd->brightness); /* reg 0x61 = brightness */
 	data[5] = 0x00;
 
 	reg_w(gspca_dev, 6);
 
 	data[0] = 0x67;
 /*jfm: from win trace*/
-	data[1] = sd->ctrls[SHARPNESS].val * 4 + 3;
+	data[1] = v4l2_ctrl_g_ctrl(sd->sharpness) * 4 + 3;
 	data[2] = 0x14;
 	reg_w(gspca_dev, 3);
 
@@ -365,7 +353,9 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	data[1] = 0x4d;		/* ISOC transferring enable... */
 	reg_w(gspca_dev, 2);
 
-	gspca_dev->ctrl_inac = 0; /* activate the illuminator controls */
+	setilluminators(gspca_dev, v4l2_ctrl_g_ctrl(sd->illum_top),
+				   v4l2_ctrl_g_ctrl(sd->illum_bottom));
+
 	return gspca_dev->usb_err;
 }
 
@@ -373,11 +363,9 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	gspca_dev->ctrl_inac = (1 << ILLUM_TOP) | (1 << ILLUM_BOT);
-	if (sd->ctrls[ILLUM_TOP].val || sd->ctrls[ILLUM_BOT].val) {
-		sd->ctrls[ILLUM_TOP].val = 0;
-		sd->ctrls[ILLUM_BOT].val = 0;
-		setilluminators(gspca_dev);
+	if (v4l2_ctrl_g_ctrl(sd->illum_top) ||
+	    v4l2_ctrl_g_ctrl(sd->illum_bottom)) {
+		setilluminators(gspca_dev, false, false);
 		msleep(20);
 	}
 
@@ -424,43 +412,16 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	gspca_frame_add(gspca_dev, INTER_PACKET, data, len);
 }
 
-static int sd_setilluminator1(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	/* only one illuminator may be on */
-	sd->ctrls[ILLUM_TOP].val = val;
-	if (val)
-		sd->ctrls[ILLUM_BOT].val = 0;
-	setilluminators(gspca_dev);
-	return gspca_dev->usb_err;
-}
-
-static int sd_setilluminator2(struct gspca_dev *gspca_dev, __s32 val)
-{
-	struct sd *sd = (struct sd *) gspca_dev;
-
-	/* only one illuminator may be on */
-	sd->ctrls[ILLUM_BOT].val = val;
-	if (val)
-		sd->ctrls[ILLUM_TOP].val = 0;
-	setilluminators(gspca_dev);
-	return gspca_dev->usb_err;
-}
-
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
 			struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
+	int ret;
 
-	if (jcomp->quality < QUALITY_MIN)
-		sd->quality = QUALITY_MIN;
-	else if (jcomp->quality > QUALITY_MAX)
-		sd->quality = QUALITY_MAX;
-	else
-		sd->quality = jcomp->quality;
-	if (gspca_dev->streaming)
-		jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+	ret = v4l2_ctrl_s_ctrl(sd->jpegqual, jcomp->quality);
+	if (ret)
+		return ret;
+	jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
 	return 0;
 }
 
@@ -470,7 +431,7 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	memset(jcomp, 0, sizeof *jcomp);
-	jcomp->quality = sd->quality;
+	jcomp->quality = v4l2_ctrl_g_ctrl(sd->jpegqual);
 	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
 			| V4L2_JPEG_MARKER_DQT;
 	return 0;
@@ -479,10 +440,9 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
-	.ctrls = sd_ctrls,
-	.nctrls = NCTRLS,
 	.config = sd_config,
 	.init = sd_init,
+	.init_controls = sd_init_controls,
 	.start = sd_start,
 	.stopN = sd_stopN,
 	.pkt_scan = sd_pkt_scan,
@@ -513,6 +473,7 @@ static struct usb_driver sd_driver = {
 #ifdef CONFIG_PM
 	.suspend = gspca_suspend,
 	.resume = gspca_resume,
+	.reset_resume = gspca_resume,
 #endif
 };
 
-- 
1.7.10


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54330 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab2ANTf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 14:35:29 -0500
Received: by mail-ey0-f174.google.com with SMTP id l12so562456eaa.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 11:35:29 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH/RFC v3 3/3] gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
Date: Sat, 14 Jan 2012 20:35:05 +0100
Message-Id: <1326569705-20261-4-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1326569705-20261-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <20120114192414.05ad2e83@tele>
 <1326569705-20261-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The JPEG compression quality control is currently done by means of the
VIDIOC_S/G_JPEGCOMP ioctls. As the quality field of struct v4l2_jpgecomp
is being deprecated, we add the V4L2_CID_JPEG_COMPRESSION_QUALITY control,
so after the deprecation period VIDIOC_S/G_JPEGCOMP ioctl handlers can be
removed, leaving the control the only user interface for compression
quality configuration.

Cc: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/video/gspca/zc3xx.c |   45 ++++++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index f22e02f..b6a18c8 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -46,6 +46,7 @@ enum e_ctrl {
 	AUTOGAIN,
 	LIGHTFREQ,
 	SHARPNESS,
+	QUALITY,
 	NCTRLS		/* number of controls */
 };

@@ -57,11 +58,6 @@ struct sd {

 	struct gspca_ctrl ctrls[NCTRLS];

-	u8 quality;			/* image quality */
-#define QUALITY_MIN 50
-#define QUALITY_MAX 80
-#define QUALITY_DEF 70
-
 	u8 bridge;
 	u8 sensor;		/* Type of image sensor chip */
 	u16 chip_revision;
@@ -101,6 +97,12 @@ static void setexposure(struct gspca_dev *gspca_dev);
 static int sd_setautogain(struct gspca_dev *gspca_dev, __s32 val);
 static void setlightfreq(struct gspca_dev *gspca_dev);
 static void setsharpness(struct gspca_dev *gspca_dev);
+static void set_quality(struct gspca_dev *gspca_dev);
+
+/* JPEG image quality */
+#define QUALITY_MIN 50
+#define QUALITY_MAX 80
+#define QUALITY_DEF 70

 static const struct ctrl sd_ctrls[NCTRLS] = {
 [BRIGHTNESS] = {
@@ -188,6 +190,18 @@ static const struct ctrl sd_ctrls[NCTRLS] = {
 	    },
 	    .set_control = setsharpness
 	},
+[QUALITY] = {
+	    {
+		.id	 = V4L2_CID_JPEG_COMPRESSION_QUALITY,
+		.type    = V4L2_CTRL_TYPE_INTEGER,
+		.name    = "Compression Quality",
+		.minimum = QUALITY_MIN,
+		.maximum = QUALITY_MAX,
+		.step    = 1,
+		.default_value = QUALITY_DEF,
+	    },
+	    .set_control = set_quality
+	},
 };

 static const struct v4l2_pix_format vga_mode[] = {
@@ -6411,7 +6425,6 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	sd->sensor = id->driver_info;

 	gspca_dev->cam.ctrls = sd->ctrls;
-	sd->quality = QUALITY_DEF;

 	return 0;
 }
@@ -6685,7 +6698,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* create the JPEG header */
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);		/* JPEG 422 */
-	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+	jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);

 	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
 	switch (sd->sensor) {
@@ -6893,19 +6906,21 @@ static int sd_querymenu(struct gspca_dev *gspca_dev,
 	return -EINVAL;
 }

+static void set_quality(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);
+}
+
 static int sd_set_jcomp(struct gspca_dev *gspca_dev,
 			struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;

-	if (jcomp->quality < QUALITY_MIN)
-		sd->quality = QUALITY_MIN;
-	else if (jcomp->quality > QUALITY_MAX)
-		sd->quality = QUALITY_MAX;
-	else
-		sd->quality = jcomp->quality;
+	sd->ctrls[QUALITY].val = clamp_t(u8, jcomp->quality,
+					 QUALITY_MIN, QUALITY_MAX);
 	if (gspca_dev->streaming)
-		jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+		set_quality(gspca_dev);
 	return gspca_dev->usb_err;
 }

@@ -6915,7 +6930,7 @@ static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 	struct sd *sd = (struct sd *) gspca_dev;

 	memset(jcomp, 0, sizeof *jcomp);
-	jcomp->quality = sd->quality;
+	jcomp->quality = sd->ctrls[QUALITY].val;
 	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
 			| V4L2_JPEG_MARKER_DQT;
 	return 0;
--
1.7.4.1


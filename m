Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46880 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030476Ab2AFSPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 13:15:05 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so1234158eek.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 10:15:04 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Hans de Goede <hdegoede@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH/RFC v2 4/4] gspca: zc3xx: Add V4L2_CID_JPEG_COMPRESSION_QUALITY control support
Date: Fri,  6 Jan 2012 19:14:42 +0100
Message-Id: <1325873682-3754-5-git-send-email-snjw23@gmail.com>
In-Reply-To: <4EBECD11.8090709@gmail.com>
References: <4EBECD11.8090709@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The JPEG compression quality control is currently done by means of the
VIDIOC_S/G_JPEGCOMP ioctls. As the quality field of struct v4l2_jpgecomp
is being deprecated, we add the V4L2_CID_JPEG_COMPRESSION_QUALITY control,
so after the deprecation period VIDIOC_S/G_JPEGCOMP ioctl handlers can be
removed, leaving the control the only user interface for compression
quality configuration.

Cc: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
For completeness V4L2_CID_JPEG_ACTIVE_MARKER control might be also added.
---
 drivers/media/video/gspca/zc3xx.c |   54 +++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/video/gspca/zc3xx.c
index f22e02f..019a93b 100644
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
+static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val);
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
+	    .set = sd_setquality
+	},
 };
 
 static const struct v4l2_pix_format vga_mode[] = {
@@ -6411,7 +6425,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	sd->sensor = id->driver_info;
 
 	gspca_dev->cam.ctrls = sd->ctrls;
-	sd->quality = QUALITY_DEF;
+	sd->ctrls[QUALITY].val = QUALITY_DEF;
 
 	return 0;
 }
@@ -6685,7 +6699,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 	/* create the JPEG header */
 	jpeg_define(sd->jpeg_hdr, gspca_dev->height, gspca_dev->width,
 			0x21);		/* JPEG 422 */
-	jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+	jpeg_set_qual(sd->jpeg_hdr, sd->ctrls[QUALITY].val);
 
 	mode = gspca_dev->cam.cam_mode[gspca_dev->curr_mode].priv;
 	switch (sd->sensor) {
@@ -6893,29 +6907,35 @@ static int sd_querymenu(struct gspca_dev *gspca_dev,
 	return -EINVAL;
 }
 
-static int sd_set_jcomp(struct gspca_dev *gspca_dev,
-			struct v4l2_jpegcompression *jcomp)
+static int sd_setquality(struct gspca_dev *gspca_dev, __s32 val)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (jcomp->quality < QUALITY_MIN)
-		sd->quality = QUALITY_MIN;
-	else if (jcomp->quality > QUALITY_MAX)
-		sd->quality = QUALITY_MAX;
-	else
-		sd->quality = jcomp->quality;
+	sd->ctrls[QUALITY].val = val;
+
 	if (gspca_dev->streaming)
-		jpeg_set_qual(sd->jpeg_hdr, sd->quality);
+		jpeg_set_qual(sd->jpeg_hdr, val);
+
 	return gspca_dev->usb_err;
 }
 
+static int sd_set_jcomp(struct gspca_dev *gspca_dev,
+			struct v4l2_jpegcompression *jcomp)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	sd->ctrls[QUALITY].val = clamp_t(u8, jcomp->quality,
+					QUALITY_MIN, QUALITY_MAX);
+	return sd_setquality(gspca_dev, sd->ctrls[QUALITY].val);
+}
+
 static int sd_get_jcomp(struct gspca_dev *gspca_dev,
 			struct v4l2_jpegcompression *jcomp)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	memset(jcomp, 0, sizeof *jcomp);
-	jcomp->quality = sd->quality;
+	jcomp->quality = sd->ctrls[QUALITY].val;
 	jcomp->jpeg_markers = V4L2_JPEG_MARKER_DHT
 			| V4L2_JPEG_MARKER_DQT;
 	return 0;
-- 
1.7.1


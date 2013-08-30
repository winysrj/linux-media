Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:57458 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3H3Uyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 16:54:35 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/3] gspca: Support variable resolution
Date: Fri, 30 Aug 2013 22:54:24 +0200
Message-Id: <1377896065-29392-2-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1377896065-29392-1-git-send-email-linux@rainbow-software.org>
References: <1377896065-29392-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add variable resolution support to gspca by allowing subdrivers to
specify try_fmt and enum_framesizes functions.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/usb/gspca/gspca.c |   20 ++++++++++++++------
 drivers/media/usb/gspca/gspca.h |    6 ++++++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 9ffcce6..423c7c8 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1133,6 +1133,12 @@ static int try_fmt_vid_cap(struct gspca_dev *gspca_dev,
 			mode = mode2;
 	}
 	fmt->fmt.pix = gspca_dev->cam.cam_mode[mode];
+	if (gspca_dev->sd_desc->try_fmt) {
+		/* pass original resolution to subdriver try_fmt */
+		fmt->fmt.pix.width = w;
+		fmt->fmt.pix.height = h;
+		gspca_dev->sd_desc->try_fmt(gspca_dev, fmt);
+	}
 	/* some drivers use priv internally, zero it before giving it to
 	   userspace */
 	fmt->fmt.pix.priv = 0;
@@ -1171,17 +1177,16 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		goto out;
 	}
 
-	if (ret == gspca_dev->curr_mode) {
-		ret = 0;
-		goto out;			/* same mode */
-	}
-
 	if (gspca_dev->streaming) {
 		ret = -EBUSY;
 		goto out;
 	}
 	gspca_dev->curr_mode = ret;
-	gspca_dev->pixfmt = gspca_dev->cam.cam_mode[ret];
+	if (gspca_dev->sd_desc->try_fmt)
+		/* subdriver try_fmt can modify format parameters */
+		gspca_dev->pixfmt = fmt->fmt.pix;
+	else
+		gspca_dev->pixfmt = gspca_dev->cam.cam_mode[ret];
 
 	ret = 0;
 out:
@@ -1196,6 +1201,9 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 	int i;
 	__u32 index = 0;
 
+	if (gspca_dev->sd_desc->enum_framesizes)
+		return gspca_dev->sd_desc->enum_framesizes(gspca_dev, fsize);
+
 	for (i = 0; i < gspca_dev->cam.nmodes; i++) {
 		if (fsize->pixel_format !=
 				gspca_dev->cam.cam_mode[i].pixelformat)
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index 0f3d150..300642d 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -88,6 +88,10 @@ typedef void (*cam_pkt_op) (struct gspca_dev *gspca_dev,
 typedef int (*cam_int_pkt_op) (struct gspca_dev *gspca_dev,
 				u8 *data,
 				int len);
+typedef void (*cam_format_op) (struct gspca_dev *gspca_dev,
+				struct v4l2_format *fmt);
+typedef int (*cam_frmsize_op) (struct gspca_dev *gspca_dev,
+				struct v4l2_frmsizeenum *fsize);
 
 /* subdriver description */
 struct sd_desc {
@@ -109,6 +113,8 @@ struct sd_desc {
 	cam_set_jpg_op set_jcomp;
 	cam_streamparm_op get_streamparm;
 	cam_streamparm_op set_streamparm;
+	cam_format_op try_fmt;
+	cam_frmsize_op enum_framesizes;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	cam_set_reg_op set_register;
 	cam_get_reg_op get_register;
-- 
Ondrej Zary


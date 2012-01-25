Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:56730 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab2AYPFl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:05:41 -0500
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id q0PF5dDG032720
	for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 09:05:40 -0600
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH 2/4] davinci: vpif: make generic changes to re-use the vpif drivers on da850/omap-l138 soc
Date: Wed, 25 Jan 2012 20:35:32 +0530
Message-ID: <1327503934-28186-3-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
References: <1327503934-28186-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

change the dm646x specific strings in the driver to make
them generic across platforms. In this case change all the
strings which have a dm646x connotation to vpif which is a
platform independent ip.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpif.c         |    2 +-
 drivers/media/video/davinci/vpif_capture.c |    9 ++++-----
 drivers/media/video/davinci/vpif_display.c |   14 +++++++-------
 drivers/media/video/davinci/vpif_display.h |    2 +-
 4 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index af96802..774bcd3 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -1,5 +1,5 @@
 /*
- * vpif - DM646x Video Port Interface driver
+ * vpif - Video Port Interface driver
  * VPIF is a receiver and transmitter for video data. It has two channels(0, 1)
  * that receiveing video byte stream and two channels(2, 3) for video output.
  * The hardware supports SDTV, HDTV formats, raw data capture.
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 33d865d..010cce4 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -1684,7 +1684,7 @@ static int vpif_querycap(struct file *file, void  *priv,
 
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	strlcpy(cap->driver, "vpif capture", sizeof(cap->driver));
-	strlcpy(cap->bus_info, "DM646x Platform", sizeof(cap->bus_info));
+	strlcpy(cap->bus_info, "VPIF Platform", sizeof(cap->bus_info));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
 
 	return 0;
@@ -2192,7 +2192,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
 			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
-					"DM646x_Capture",
+					"VPIF_Capture",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
 				err = -EBUSY;
 				i--;
@@ -2221,7 +2221,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
 		vfd->release = video_device_release;
 		snprintf(vfd->name, sizeof(vfd->name),
-			 "DM646x_VPIFCapture_DRIVER_V%s",
+			 "VPIF_Capture_DRIVER_V%s",
 			 VPIF_CAPTURE_VERSION);
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
@@ -2276,8 +2276,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 			vpif_obj.sd[i]->grp_id = 1 << i;
 	}
 
-	v4l2_info(&vpif_obj.v4l2_dev,
-			"DM646x VPIF capture driver initialized\n");
+	v4l2_info(&vpif_obj.v4l2_dev, "VPIF capture driver initialized\n");
 	return 0;
 
 probe_subdev_out:
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index b315ccf..6f3eabb 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -48,7 +48,7 @@ MODULE_DESCRIPTION("TI DaVinci VPIF Display driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(VPIF_DISPLAY_VERSION);
 
-#define DM646X_V4L2_STD (V4L2_STD_525_60 | V4L2_STD_625_50)
+#define VPIF_V4L2_STD (V4L2_STD_525_60 | V4L2_STD_625_50)
 
 #define vpif_err(fmt, arg...)	v4l2_err(&vpif_obj.v4l2_dev, fmt, ## arg)
 #define vpif_dbg(level, debug, fmt, arg...)	\
@@ -976,7 +976,7 @@ static int vpif_s_std(struct file *file, void *priv, v4l2_std_id *std_id)
 	struct common_obj *common = &ch->common[VPIF_VIDEO_INDEX];
 	int ret = 0;
 
-	if (!(*std_id & DM646X_V4L2_STD))
+	if (!(*std_id & VPIF_V4L2_STD))
 		return -EINVAL;
 
 	if (common->started) {
@@ -1227,7 +1227,7 @@ static int vpif_enum_output(struct file *file, void *fh,
 
 	strcpy(output->name, config->output[output->index]);
 	output->type = V4L2_OUTPUT_TYPE_ANALOG;
-	output->std = DM646X_V4L2_STD;
+	output->std = VPIF_V4L2_STD;
 
 	return 0;
 }
@@ -1612,7 +1612,7 @@ static struct video_device vpif_video_template = {
 	.name		= "vpif",
 	.fops		= &vpif_fops,
 	.ioctl_ops	= &vpif_ioctl_ops,
-	.tvnorms	= DM646X_V4L2_STD,
+	.tvnorms	= VPIF_V4L2_STD,
 	.current_norm	= V4L2_STD_625_50,
 
 };
@@ -1714,7 +1714,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, k))) {
 		for (i = res->start; i <= res->end; i++) {
 			if (request_irq(i, vpif_channel_isr, IRQF_DISABLED,
-					"DM646x_Display",
+					"VPIF_Display",
 				(void *)(&vpif_obj.dev[k]->channel_id))) {
 				err = -EBUSY;
 				goto vpif_int_err;
@@ -1744,7 +1744,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
 		vfd->release = video_device_release;
 		snprintf(vfd->name, sizeof(vfd->name),
-			 "DM646x_VPIFDisplay_DRIVER_V%s",
+			 "VPIF_Display_DRIVER_V%s",
 			 VPIF_DISPLAY_VERSION);
 
 		/* Set video_dev to the video device */
@@ -1826,7 +1826,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	}
 
 	v4l2_info(&vpif_obj.v4l2_dev,
-			"DM646x VPIF display driver initialized\n");
+			" VPIF display driver initialized\n");
 	return 0;
 
 probe_subdev_out:
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index 56879d1..dd4887c 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -1,5 +1,5 @@
 /*
- * DM646x display header file
+ * VPIF display header file
  *
  * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
  *
-- 
1.6.2.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50504 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbZFZWFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 18:05:14 -0400
From: m-karicheri2@ti.com
To: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/3 - v0] V4L: ccdc driver - adding support for camera capture
Date: Fri, 26 Jun 2009 18:05:10 -0400
Message-Id: <1246053910-8337-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

Following updates to ccdc driver :-
 	1) Adding support for camera capture using mt9t031
	2) Changed default resolution for ycbcr capture to NTSC to match
	   with tvp514x driver.
	3) Returns proper error code from ccdc_init (comments against previous patch
	   version v3)

Mandatory Reviewers: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/davinci/dm355_ccdc.c  |   21 +++++++++++++--------
 drivers/media/video/davinci/dm644x_ccdc.c |   13 +++++++++----
 include/media/davinci/dm355_ccdc.h        |    2 +-
 include/media/davinci/dm644x_ccdc.h       |    2 +-
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index 69e38d0..6c6e77c 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -28,10 +28,9 @@
  * files. The setparams() API is called by vpfe_capture driver
  * to configure module parameters
  *
- * TODO: 1) Raw bayer parameter settings and bayer capture
- * 	 2) Split module parameter structure to module specific ioctl structs
- *	 3) add support for lense shading correction
- *	 4) investigate if enum used for user space type definition
+ * TODO: 1) Split module parameter structure to module specific ioctl structs
+ *	 2) add support for lense shading correction
+ *	 3) investigate if enum used for user space type definition
  * 	    to be replaced by #defines or integer
  */
 #include <linux/platform_device.h>
@@ -92,7 +91,7 @@ static struct ccdc_params_raw ccdc_hw_params_raw = {
 
 /* Object for CCDC ycbcr mode */
 static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
-	.win = CCDC_WIN_PAL,
+	.win = CCDC_WIN_NTSC,
 	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
 	.frm_fmt = CCDC_FRMFMT_INTERLACED,
 	.fid_pol = VPFE_PINPOL_POSITIVE,
@@ -1107,8 +1106,11 @@ static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
 		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
 		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
 		break;
+	case VPFE_RAW_BAYER:
+		ccdc_hw_params_raw.vd_pol = params->vdpol;
+		ccdc_hw_params_raw.hd_pol = params->hdpol;
+		break;
 	default:
-		/* TODO add support for raw bayer here */
 		return -EINVAL;
 	}
 	return 0;
@@ -1146,9 +1148,12 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 
 static int dm355_ccdc_init(void)
 {
+	int ret;
+
 	printk(KERN_NOTICE "dm355_ccdc_init\n");
-	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
-		return -1;
+	ret = vpfe_register_ccdc_device(&ccdc_hw_dev);
+	if (ret < 0)
+		return ret;
 	printk(KERN_NOTICE "%s is registered with vpfe.\n",
 		ccdc_hw_dev.name);
 	return 0;
diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
index 2f19a91..5dff8d9 100644
--- a/drivers/media/video/davinci/dm644x_ccdc.c
+++ b/drivers/media/video/davinci/dm644x_ccdc.c
@@ -65,7 +65,7 @@ static struct ccdc_params_raw ccdc_hw_params_raw = {
 static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
 	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
 	.frm_fmt = CCDC_FRMFMT_INTERLACED,
-	.win = CCDC_WIN_PAL,
+	.win = CCDC_WIN_NTSC,
 	.fid_pol = VPFE_PINPOL_POSITIVE,
 	.vd_pol = VPFE_PINPOL_POSITIVE,
 	.hd_pol = VPFE_PINPOL_POSITIVE,
@@ -825,8 +825,10 @@ static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
 		ccdc_hw_params_ycbcr.vd_pol = params->vdpol;
 		ccdc_hw_params_ycbcr.hd_pol = params->hdpol;
 		break;
+	case VPFE_RAW_BAYER:
+		ccdc_hw_params_raw.vd_pol = params->vdpol;
+		ccdc_hw_params_raw.hd_pol = params->hdpol;
 	default:
-		/* TODO add support for raw bayer here */
 		return -EINVAL;
 	}
 	return 0;
@@ -861,9 +863,12 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 
 static int dm644x_ccdc_init(void)
 {
+	int ret;
+
 	printk(KERN_NOTICE "dm644x_ccdc_init\n");
-	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
-		return -1;
+	ret = vpfe_register_ccdc_device(&ccdc_hw_dev);
+	if (ret < 0)
+		return ret;
 	printk(KERN_NOTICE "%s is registered with vpfe.\n",
 		ccdc_hw_dev.name);
 	return 0;
diff --git a/include/media/davinci/dm355_ccdc.h b/include/media/davinci/dm355_ccdc.h
index b0ce1af..3526920 100644
--- a/include/media/davinci/dm355_ccdc.h
+++ b/include/media/davinci/dm355_ccdc.h
@@ -254,7 +254,7 @@ struct ccdc_config_params_raw {
 #ifdef __KERNEL__
 #include <linux/io.h>
 
-#define CCDC_WIN_PAL	{0, 0, 720, 576}
+#define CCDC_WIN_NTSC	{0, 0, 720, 480}
 #define CCDC_WIN_VGA	{0, 0, 640, 480}
 
 /*
diff --git a/include/media/davinci/dm644x_ccdc.h b/include/media/davinci/dm644x_ccdc.h
index 3e178eb..e34a54a 100644
--- a/include/media/davinci/dm644x_ccdc.h
+++ b/include/media/davinci/dm644x_ccdc.h
@@ -131,7 +131,7 @@ struct ccdc_config_params_raw {
 #define NUM_EXTRALINES		8
 
 /* settings for commonly used video formats */
-#define CCDC_WIN_PAL     {0, 0, 720, 576}
+#define CCDC_WIN_NTSC     {0, 0, 720, 480}
 /* ntsc square pixel */
 #define CCDC_WIN_VGA	{0, 0, (640 + NUM_EXTRAPIXELS), (480 + NUM_EXTRALINES)}
 
-- 
1.6.0.4


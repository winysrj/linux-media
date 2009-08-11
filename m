Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57996 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbZHKVBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 17:01:45 -0400
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com, hverkuil@xs4all.nl,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/4 - v2] V4L: ccdc driver - adding support for camera capture
Date: Tue, 11 Aug 2009 17:01:39 -0400
Message-Id: <1250024499-5087-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <m-karicheri2@ti.com>

There was no comment against v1 of the patch. So no change in this file

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to V4L-DVB linux-next repository
 drivers/media/video/davinci/dm355_ccdc.c  |   16 +++++++++++-----
 drivers/media/video/davinci/dm644x_ccdc.c |   13 +++++++++----
 include/media/davinci/dm355_ccdc.h        |    2 +-
 include/media/davinci/dm644x_ccdc.h       |    2 +-
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
index 4629cab..4efffc2 100644
--- a/drivers/media/video/davinci/dm355_ccdc.c
+++ b/drivers/media/video/davinci/dm355_ccdc.c
@@ -92,7 +92,7 @@ static struct ccdc_params_raw ccdc_hw_params_raw = {
 
 /* Object for CCDC ycbcr mode */
 static struct ccdc_params_ycbcr ccdc_hw_params_ycbcr = {
-	.win = CCDC_WIN_PAL,
+	.win = CCDC_WIN_NTSC,
 	.pix_fmt = CCDC_PIXFMT_YCBCR_8BIT,
 	.frm_fmt = CCDC_FRMFMT_INTERLACED,
 	.fid_pol = VPFE_PINPOL_POSITIVE,
@@ -548,7 +548,7 @@ static int ccdc_config_vdfc(struct ccdc_vertical_dft *dfc)
  */
 static void ccdc_config_csc(struct ccdc_csc *csc)
 {
-	u32 val1, val2;
+	u32 val1 = 0, val2;
 	int i;
 
 	if (!csc->enable)
@@ -925,8 +925,11 @@ static int ccdc_set_hw_if_params(struct vpfe_hw_if_param *params)
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
@@ -961,9 +964,12 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 
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
index df8a7b1..9395900 100644
--- a/include/media/davinci/dm355_ccdc.h
+++ b/include/media/davinci/dm355_ccdc.h
@@ -254,7 +254,7 @@ struct ccdc_config_params_raw {
 #ifdef __KERNEL__
 #include <linux/io.h>
 
-#define CCDC_WIN_PAL	{0, 0, 720, 576}
+#define CCDC_WIN_NTSC	{0, 0, 720, 480}
 #define CCDC_WIN_VGA	{0, 0, 640, 480}
 
 struct ccdc_params_ycbcr {
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


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40498 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab2GKLAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 07:00:33 -0400
Received: by weyx8 with SMTP id x8so784429wey.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jul 2012 04:00:31 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: fabio.estevam@freescale.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v6] media: mx2_camera: Fix mbus format handling
Date: Wed, 11 Jul 2012 13:00:19 +0200
Message-Id: <1342004419-24929-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not use MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags.
The driver must negotiate with the attached sensor whether the
mbus format is UYUV or YUYV and set CSICR1 configuration
accordingly.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 11a9353..0f01e7b 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -118,6 +118,8 @@
 #define CSISR_ECC_INT		(1 << 1)
 #define CSISR_DRDY		(1 << 0)
 
+#define CSICR1_FMT_MASK	 (CSICR1_PACK_DIR | CSICR1_SWAP16_EN)
+
 #define CSICR1			0x00
 #define CSICR2			0x04
 #define CSISR			(cpu_is_mx27() ? 0x08 : 0x18)
@@ -230,6 +232,7 @@ struct mx2_prp_cfg {
 	u32 src_pixel;
 	u32 ch1_pixel;
 	u32 irq_flags;
+	u32 csicr1;
 };
 
 /* prp resizing parameters */
@@ -330,6 +333,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 			.ch1_pixel	= 0x2ca00565, /* RGB565 */
 			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH1WERR |
 						PRP_INTR_CH1FC | PRP_INTR_LBOVF,
+			.csicr1		= 0,
 		}
 	},
 	{
@@ -343,6 +347,21 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH2WERR |
 					PRP_INTR_CH2FC | PRP_INTR_LBOVF |
 					PRP_INTR_CH2OVF,
+			.csicr1		= CSICR1_PACK_DIR,
+		}
+	},
+	{
+		.in_fmt		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.out_fmt	= V4L2_PIX_FMT_YUV420,
+		.cfg		= {
+			.channel	= 2,
+			.in_fmt		= PRP_CNTL_DATA_IN_YUV422,
+			.out_fmt	= PRP_CNTL_CH2_OUT_YUV420,
+			.src_pixel	= 0x22000888, /* YUV422 (YUYV) */
+			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH2WERR |
+					PRP_INTR_CH2FC | PRP_INTR_LBOVF |
+					PRP_INTR_CH2OVF,
+			.csicr1		= CSICR1_SWAP16_EN,
 		}
 	},
 };
@@ -1018,14 +1037,14 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 		return ret;
 	}
 
+	csicr1 = (csicr1 & ~CSICR1_FMT_MASK) | pcdev->emma_prp->cfg.csicr1;
+
 	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		csicr1 |= CSICR1_REDGE;
 	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_SOF_POL;
 	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_HSYNC_POL;
-	if (pcdev->platform_flags & MX2_CAMERA_SWAP16)
-		csicr1 |= CSICR1_SWAP16_EN;
 	if (pcdev->platform_flags & MX2_CAMERA_EXT_VSYNC)
 		csicr1 |= CSICR1_EXT_VSYNC;
 	if (pcdev->platform_flags & MX2_CAMERA_CCIR)
@@ -1036,8 +1055,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 		csicr1 |= CSICR1_GCLK_MODE;
 	if (pcdev->platform_flags & MX2_CAMERA_INV_DATA)
 		csicr1 |= CSICR1_INV_DATA;
-	if (pcdev->platform_flags & MX2_CAMERA_PACK_DIR_MSB)
-		csicr1 |= CSICR1_PACK_DIR;
 
 	pcdev->csicr1 = csicr1;
 
@@ -1112,7 +1129,8 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 		return 0;
 	}
 
-	if (code == V4L2_MBUS_FMT_YUYV8_2X8) {
+	if (code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+	    code == V4L2_MBUS_FMT_UYVY8_2X8) {
 		formats++;
 		if (xlate) {
 			/*
-- 
1.7.9.5


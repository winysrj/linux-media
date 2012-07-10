Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36868 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab2GJL4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 07:56:25 -0400
Received: by wgbdr13 with SMTP id dr13so12431525wgb.1
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 04:56:24 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: fabio.estevam@freescale.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v4] media: mx2_camera: Fix mbus format handling
Date: Tue, 10 Jul 2012 13:56:13 +0200
Message-Id: <1341921373-14570-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags
so that the driver can negotiate with the attached sensor
whether the mbus format needs convertion from UYUV to YUYV
or not.
---
Changes since v3:
 - Remove conversion from UYVY to YUYV.
 - Add 'csicr1' to emma-PrP format structure.

---
 arch/arm/plat-mxc/include/mach/mx2_cam.h |    2 --
 drivers/media/video/mx2_camera.c         |   27 ++++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/mx2_cam.h b/arch/arm/plat-mxc/include/mach/mx2_cam.h
index 3c080a3..7ded6f1 100644
--- a/arch/arm/plat-mxc/include/mach/mx2_cam.h
+++ b/arch/arm/plat-mxc/include/mach/mx2_cam.h
@@ -23,7 +23,6 @@
 #ifndef __MACH_MX2_CAM_H_
 #define __MACH_MX2_CAM_H_
 
-#define MX2_CAMERA_SWAP16		(1 << 0)
 #define MX2_CAMERA_EXT_VSYNC		(1 << 1)
 #define MX2_CAMERA_CCIR			(1 << 2)
 #define MX2_CAMERA_CCIR_INTERLACE	(1 << 3)
@@ -31,7 +30,6 @@
 #define MX2_CAMERA_GATED_CLOCK		(1 << 5)
 #define MX2_CAMERA_INV_DATA		(1 << 6)
 #define MX2_CAMERA_PCLK_SAMPLE_RISING	(1 << 7)
-#define MX2_CAMERA_PACK_DIR_MSB		(1 << 8)
 
 /**
  * struct mx2_camera_platform_data - optional platform data for mx2_camera
diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 11a9353..8adef0f 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -119,6 +119,7 @@
 #define CSISR_DRDY		(1 << 0)
 
 #define CSICR1			0x00
+#define 	CSICR1_FMT_MASK	 (CSICR1_PACK_DIR | CSICR1_SWAP16_EN)
 #define CSICR2			0x04
 #define CSISR			(cpu_is_mx27() ? 0x08 : 0x18)
 #define CSISTATFIFO		0x0c
@@ -230,6 +231,7 @@ struct mx2_prp_cfg {
 	u32 src_pixel;
 	u32 ch1_pixel;
 	u32 irq_flags;
+	u32 csicr1;
 };
 
 /* prp resizing parameters */
@@ -330,6 +332,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 			.ch1_pixel	= 0x2ca00565, /* RGB565 */
 			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH1WERR |
 						PRP_INTR_CH1FC | PRP_INTR_LBOVF,
+			.csicr1		= 0,
 		}
 	},
 	{
@@ -343,6 +346,21 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
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
@@ -1018,14 +1036,14 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
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
@@ -1036,8 +1054,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 		csicr1 |= CSICR1_GCLK_MODE;
 	if (pcdev->platform_flags & MX2_CAMERA_INV_DATA)
 		csicr1 |= CSICR1_INV_DATA;
-	if (pcdev->platform_flags & MX2_CAMERA_PACK_DIR_MSB)
-		csicr1 |= CSICR1_PACK_DIR;
 
 	pcdev->csicr1 = csicr1;
 
@@ -1112,7 +1128,8 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
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


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46323 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794Ab2FAJb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2012 05:31:56 -0400
Received: by wgbdr13 with SMTP id dr13so1755522wgb.1
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2012 02:31:55 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3][for_v3.5] media: mx2_camera: Fix mbus format handling
Date: Fri,  1 Jun 2012 11:31:45 +0200
Message-Id: <1338543105-20322-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags
so that the driver can negotiate with the attached sensor
whether the mbus format needs convertion from UYUV to YUYV
or not.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
Fix pass-through mode as requested by Guennadi.
Also a merge conflict has been addressed.

This patch should be applied to for_v3.5 since Guennadi
has requested Mauro to remove the old version:

[PATCH] Revert "[media] media: mx2_camera: Fix mbus format handling"

This patch is part of the following series:

media: tvp5150: Fix mbus format.
i.MX27: visstrim_m10: Remove use of MX2_CAMERA_SWAP16.
media: mx2_camera: Fix mbus format handling.
---
 arch/arm/plat-mxc/include/mach/mx2_cam.h |    2 -
 drivers/media/video/mx2_camera.c         |   50 +++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 7 deletions(-)

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
index 18afaee..b30ebe5 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -344,6 +344,19 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 					PRP_INTR_CH2OVF,
 		}
 	},
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
+		}
+	},
 };
 
 static struct mx2_fmt_cfg *mx27_emma_prp_get_format(
@@ -980,6 +993,8 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
+	const struct soc_camera_format_xlate *xlate;
+	u32 pixfmt = icd->current_fmt->host_fmt->fourcc;
 	unsigned long common_flags;
 	int ret;
 	int bytesperline;
@@ -1024,14 +1039,28 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 		return ret;
 	}
 
+	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
+	if (!xlate) {
+		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
+		return -EINVAL;
+	}
+
+	if (xlate->code == V4L2_MBUS_FMT_YUYV8_2X8) {
+		csicr1 |= CSICR1_PACK_DIR;
+		csicr1 &= ~CSICR1_SWAP16_EN;
+		dev_dbg(icd->parent, "already yuyv format, don't convert\n");
+	} else if (xlate->code == V4L2_MBUS_FMT_UYVY8_2X8) {
+		csicr1 &= ~CSICR1_PACK_DIR;
+		csicr1 |= CSICR1_SWAP16_EN;
+		dev_dbg(icd->parent, "convert uyvy mbus format into yuyv\n");
+	}
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
@@ -1042,8 +1071,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 		csicr1 |= CSICR1_GCLK_MODE;
 	if (pcdev->platform_flags & MX2_CAMERA_INV_DATA)
 		csicr1 |= CSICR1_INV_DATA;
-	if (pcdev->platform_flags & MX2_CAMERA_PACK_DIR_MSB)
-		csicr1 |= CSICR1_PACK_DIR;
 
 	pcdev->csicr1 = csicr1;
 
@@ -1118,7 +1145,8 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 		return 0;
 	}
 
-	if (code == V4L2_MBUS_FMT_YUYV8_2X8) {
+	if (code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+	    code == V4L2_MBUS_FMT_UYVY8_2X8) {
 		formats++;
 		if (xlate) {
 			/*
@@ -1134,6 +1162,18 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 		}
 	}
 
+	if (code == V4L2_MBUS_FMT_UYVY8_2X8) {
+		formats++;
+		if (xlate) {
+			xlate->host_fmt =
+				soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_YUYV8_2X8);
+			xlate->code	= code;
+			dev_dbg(dev, "Providing host format %s for sensor code %d\n",
+				xlate->host_fmt->name, code);
+			xlate++;
+		}
+	}
+
 	/* Generic pass-trough */
 	formats++;
 	if (xlate) {
-- 
1.7.0.4


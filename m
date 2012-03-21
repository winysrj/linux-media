Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57775 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab2CULDP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 07:03:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 4/9] soc-camera: Add plane layout information to struct soc_mbus_pixelfmt
Date: Wed, 21 Mar 2012 12:03:23 +0100
Message-Id: <1332327808-6056-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1332327808-6056-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To compute the value of the v4l2_pix_format::bytesperline field, we need
information about planes layout for planar formats. The new enum
soc_mbus_layout conveys that information.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/atmel-isi.c            |    1 +
 drivers/media/video/mx3_camera.c           |    2 +
 drivers/media/video/omap1_camera.c         |    8 ++++++
 drivers/media/video/pxa_camera.c           |    1 +
 drivers/media/video/sh_mobile_ceu_camera.c |    4 +++
 drivers/media/video/soc_mediabus.c         |   33 ++++++++++++++++++++++++++++
 include/media/soc_mediabus.h               |   19 ++++++++++++++++
 7 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index d58491b..6274a91 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -627,6 +627,7 @@ static const struct soc_mbus_pixelfmt isi_camera_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 };
 
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 66d9a24..84579b6 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -637,12 +637,14 @@ static const struct soc_mbus_pixelfmt mx3_camera_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	}, {
 		.fourcc			= V4L2_PIX_FMT_GREY,
 		.name			= "Monochrome 8 bit",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 };
 
diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index addab76..c7e4114 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -989,6 +989,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_VYUY8_2X8,
@@ -998,6 +999,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_YUYV8_2X8,
@@ -1007,6 +1009,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_YVYU8_2X8,
@@ -1016,6 +1019,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
@@ -1025,6 +1029,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
@@ -1034,6 +1039,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
@@ -1043,6 +1049,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB565_2X8_LE,
@@ -1052,6 +1059,7 @@ static const struct soc_mbus_lookup omap1_cam_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 },
 };
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 26013df..d1b43d1 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1234,6 +1234,7 @@ static const struct soc_mbus_pixelfmt pxa_camera_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PLANAR_2Y_U_V,
 	},
 };
 
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 932ed5e..0cc04d9 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -951,24 +951,28 @@ static const struct soc_mbus_pixelfmt sh_mobile_ceu_formats[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PLANAR_2Y_C,
 	}, {
 		.fourcc			= V4L2_PIX_FMT_NV21,
 		.name			= "NV21",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PLANAR_2Y_C,
 	}, {
 		.fourcc			= V4L2_PIX_FMT_NV16,
 		.name			= "NV16",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PLANAR_Y_C,
 	}, {
 		.fourcc			= V4L2_PIX_FMT_NV61,
 		.name			= "NV61",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PLANAR_Y_C,
 	},
 };
 
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index cf7f219..44dba6c 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -24,6 +24,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_YVYU8_2X8,
@@ -33,6 +34,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_UYVY8_2X8,
@@ -42,6 +44,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_VYUY8_2X8,
@@ -51,6 +54,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
@@ -60,6 +64,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
@@ -69,6 +74,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB565_2X8_LE,
@@ -78,6 +84,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
@@ -87,6 +94,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SBGGR8_1X8,
@@ -96,6 +104,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SBGGR10_1X10,
@@ -105,6 +114,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_Y8_1X8,
@@ -114,6 +124,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_Y10_1X10,
@@ -123,6 +134,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
@@ -132,6 +144,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
@@ -141,6 +154,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
@@ -150,6 +164,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
@@ -159,6 +174,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADLO,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_JPEG_1X8,
@@ -168,6 +184,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample        = 8,
 		.packing                = SOC_MBUS_PACKING_VARIABLE,
 		.order                  = SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE,
@@ -177,6 +194,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_YUYV8_1_5X8,
@@ -186,6 +204,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_YVYU8_1_5X8,
@@ -195,6 +214,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_1_5X8,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_UYVY8_1X16,
@@ -204,6 +224,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 16,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_VYUY8_1X16,
@@ -213,6 +234,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 16,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_YUYV8_1X16,
@@ -222,6 +244,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 16,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_YVYU8_1X16,
@@ -231,6 +254,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 16,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SGRBG8_1X8,
@@ -240,6 +264,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
@@ -249,6 +274,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_NONE,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SGBRG10_1X10,
@@ -258,6 +284,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SGRBG10_1X10,
@@ -267,6 +294,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SRGGB10_1X10,
@@ -276,6 +304,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 10,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SBGGR12_1X12,
@@ -285,6 +314,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 12,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SGBRG12_1X12,
@@ -294,6 +324,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 12,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SGRBG12_1X12,
@@ -303,6 +334,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 12,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
 	.code = V4L2_MBUS_FMT_SRGGB12_1X12,
@@ -312,6 +344,7 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.bits_per_sample	= 12,
 		.packing		= SOC_MBUS_PACKING_EXTEND16,
 		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 },
 };
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index 73f1e7e..e18eed4 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -47,6 +47,24 @@ enum soc_mbus_order {
 };
 
 /**
+ * enum soc_mbus_layout - planes layout in memory
+ * @SOC_MBUS_LAYOUT_PACKED:		color components packed
+ * @SOC_MBUS_LAYOUT_PLANAR_2Y_U_V:	YUV components stored in 3 planes (4:2:2)
+ * @SOC_MBUS_LAYOUT_PLANAR_2Y_C:	YUV components stored in a luma and a
+ *					chroma plane (C plane is half the size
+ *					of Y plane)
+ * @SOC_MBUS_LAYOUT_PLANAR_Y_C:		YUV components stored in a luma and a
+ *					chroma plane (C plane is the same size
+ *					as Y plane)
+ */
+enum soc_mbus_layout {
+	SOC_MBUS_LAYOUT_PACKED = 0,
+	SOC_MBUS_LAYOUT_PLANAR_2Y_U_V,
+	SOC_MBUS_LAYOUT_PLANAR_2Y_C,
+	SOC_MBUS_LAYOUT_PLANAR_Y_C,
+};
+
+/**
  * struct soc_mbus_pixelfmt - Data format on the media bus
  * @name:		Name of the format
  * @fourcc:		Fourcc code, that will be obtained if the data is
@@ -60,6 +78,7 @@ struct soc_mbus_pixelfmt {
 	u32			fourcc;
 	enum soc_mbus_packing	packing;
 	enum soc_mbus_order	order;
+	enum soc_mbus_layout	layout;
 	u8			bits_per_sample;
 };
 
-- 
1.7.3.4


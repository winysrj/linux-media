Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:49190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab1EROLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 10:11:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id C1297189B66
	for <linux-media@vger.kernel.org>; Wed, 18 May 2011 16:11:30 +0200 (CEST)
Date: Wed, 18 May 2011 16:11:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/5] V4L: omap1-camera: fix huge lookup array
In-Reply-To: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
Message-ID: <Pine.LNX.4.64.1105181607510.16324@axis700.grange>
References: <Pine.LNX.4.64.1105181558440.16324@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Since V4L2_MBUS_FMT_* codes have become large and sparse, they cannot
be used as array indices anymore.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/omap1_camera.c |   41 ++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/omap1_camera.c b/drivers/media/video/omap1_camera.c
index 5954b93..fe577a9 100644
--- a/drivers/media/video/omap1_camera.c
+++ b/drivers/media/video/omap1_camera.c
@@ -990,63 +990,80 @@ static void omap1_cam_remove_device(struct soc_camera_device *icd)
 }
 
 /* Duplicate standard formats based on host capability of byte swapping */
-static const struct soc_mbus_pixelfmt omap1_cam_formats[] = {
-	[V4L2_MBUS_FMT_UYVY8_2X8] = {
+static const struct soc_mbus_lookup omap1_cam_formats[] = {
+{
+	.code = V4L2_MBUS_FMT_UYVY8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YUYV,
 		.name			= "YUYV",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[V4L2_MBUS_FMT_VYUY8_2X8] = {
+}, {
+	.code = V4L2_MBUS_FMT_VYUY8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_YVYU,
 		.name			= "YVYU",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[V4L2_MBUS_FMT_YUYV8_2X8] = {
+}, {
+	.code = V4L2_MBUS_FMT_YUYV8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_UYVY,
 		.name			= "UYVY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[V4L2_MBUS_FMT_YVYU8_2X8] = {
+}, {
+	.code = V4L2_MBUS_FMT_YVYU8_2X8,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_VYUY,
 		.name			= "VYUY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555,
 		.name			= "RGB555",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555X,
 		.name			= "RGB555X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[V4L2_MBUS_FMT_RGB565_2X8_BE] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB565_2X8_BE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565,
 		.name			= "RGB565",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
-	[V4L2_MBUS_FMT_RGB565_2X8_LE] = {
+}, {
+	.code = V4L2_MBUS_FMT_RGB565_2X8_LE,
+	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB565X,
 		.name			= "RGB565X",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_BE,
 	},
+},
 };
 
 static int omap1_cam_get_formats(struct soc_camera_device *icd,
@@ -1085,12 +1102,14 @@ static int omap1_cam_get_formats(struct soc_camera_device *icd,
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
 		formats++;
 		if (xlate) {
-			xlate->host_fmt	= &omap1_cam_formats[code];
+			xlate->host_fmt	= soc_mbus_find_fmtdesc(code,
+						omap1_cam_formats,
+						ARRAY_SIZE(omap1_cam_formats));
 			xlate->code	= code;
 			xlate++;
 			dev_dbg(dev,
 				"%s: providing format %s as byte swapped code #%d\n",
-				__func__, omap1_cam_formats[code].name, code);
+				__func__, xlate->host_fmt->name, code);
 		}
 	default:
 		if (xlate)
-- 
1.7.2.5


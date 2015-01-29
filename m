Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55508 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753784AbbA2QTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:52 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5/8] media: rcar_vin: Add RGB888_1X24 input format support
Date: Thu, 29 Jan 2015 16:19:45 +0000
Message-Id: <1422548388-28861-6-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds V4L2_MBUS_FMT_RGB888_1X24 input format support
which is used by the ADV7612 chip.

Signed-off-by: Valentine Barshak <valentine.barshak@cogentembedded.com>
---
URL:    http://marc.info/?l=linux-sh&m=138002993417489&q=raw
FIXMEs required:
- "From:" as per URL
- adapted for lx3.18 by William Towle -> add S-o-b **
---
 drivers/media/platform/soc_camera/rcar_vin.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index c4f88c3..e4f60d3 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -74,6 +74,7 @@
 #define VNMC_INF_YUV10_BT656	(2 << 16)
 #define VNMC_INF_YUV10_BT601	(3 << 16)
 #define VNMC_INF_YUV16		(5 << 16)
+#define VNMC_INF_RGB888		(6 << 16)
 #define VNMC_VUP		(1 << 10)
 #define VNMC_IM_ODD		(0 << 3)
 #define VNMC_IM_ODD_EVEN	(1 << 3)
@@ -241,7 +242,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	struct soc_camera_device *icd = priv->ici.icd;
 	struct rcar_vin_cam *cam = icd->host_priv;
 	u32 vnmc, dmr, interrupts;
-	bool progressive = false, output_is_yuv = false;
+	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
 
 	switch (priv->field) {
 	case V4L2_FIELD_TOP:
@@ -275,11 +276,16 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
+		input_is_yuv = true;
 		break;
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
 		vnmc |= priv->pdata_flags & RCAR_VIN_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
+		input_is_yuv = true;
+		break;
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		vnmc |= VNMC_INF_RGB888;
 		break;
 	case MEDIA_BUS_FMT_YUYV10_2X10:
 		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
@@ -328,7 +334,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	vnmc |= VNMC_VUP;
 
 	/* If input and output use the same colorspace, use bypass mode */
-	if (output_is_yuv)
+	if (input_is_yuv == output_is_yuv)
 		vnmc |= VNMC_BPS;
 
 	/* progressive or interlaced mode */
@@ -1015,6 +1021,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_RGB888_1X24:
 		if (cam->extra_fmt)
 			break;
 
-- 
1.7.10.4


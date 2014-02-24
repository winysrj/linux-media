Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:25445 "EHLO
	relmlie3.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752545AbaBXPzE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 10:55:04 -0500
From: Phil Edworthy <phil.edworthy@renesas.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org,
	Valentine Barshak <valentine.barshak@cogentembedded.com>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Phil Edworthy <phil.edworthy@renesas.com>
Message-ID: <1393256945-12781-1-git-send-email-phil.edworthy@renesas.com>
Date: Mon, 24 Feb 2014 15:49:05 +0000
Subject: [PATCH] media: soc_camera: rcar_vin: Add support for 10-bit YUV cameras
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 3b1c05a..9929375 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -68,6 +68,8 @@
 #define VNMC_YCAL		(1 << 19)
 #define VNMC_INF_YUV8_BT656	(0 << 16)
 #define VNMC_INF_YUV8_BT601	(1 << 16)
+#define VNMC_INF_YUV10_BT656	(2 << 16)
+#define VNMC_INF_YUV10_BT601	(3 << 16)
 #define VNMC_INF_YUV16		(5 << 16)
 #define VNMC_VUP		(1 << 10)
 #define VNMC_IM_ODD		(0 << 3)
@@ -275,6 +277,10 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
 		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
 			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
+	case V4L2_MBUS_FMT_YUYV10_2X10:
+		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
+		vnmc |= priv->pdata->flags & RCAR_VIN_BT656 ?
+			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
 	default:
 		break;
 	}
@@ -1003,6 +1009,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	switch (code) {
 	case V4L2_MBUS_FMT_YUYV8_1X16:
 	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_YUYV10_2X10:
 		if (cam->extra_fmt)
 			break;
 
-- 
1.7.9.5


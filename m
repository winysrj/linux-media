Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36776 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934275AbcAKTKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 14:10:35 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 3/3 v2] media: soc_camera: rcar_vin: Add ARGB8888 caputre format support
Date: Tue, 12 Jan 2016 04:10:18 +0900
Message-Id: <1452539418-28480-4-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1452539418-28480-1-git-send-email-ykaneko0929@gmail.com>
References: <1452539418-28480-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

This patch adds ARGB8888 capture format support for R-Car Gen3.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

v2 [Yoshihiro Kaneko]
* As suggested by Sergei Shtylyov
  - fix the coding style of the braces.

 drivers/media/platform/soc_camera/rcar_vin.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index f72de0b..9883629 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -124,7 +124,7 @@
 #define VNDMR_EXRGB		(1 << 8)
 #define VNDMR_BPSM		(1 << 4)
 #define VNDMR_DTMD_YCSEP	(1 << 1)
-#define VNDMR_DTMD_ARGB1555	(1 << 0)
+#define VNDMR_DTMD_ARGB		(1 << 0)
 
 /* Video n Data Mode Register 2 bits */
 #define VNDMR2_VPS		(1 << 30)
@@ -643,7 +643,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 		output_is_yuv = true;
 		break;
 	case V4L2_PIX_FMT_RGB555X:
-		dmr = VNDMR_DTMD_ARGB1555;
+		dmr = VNDMR_DTMD_ARGB;
 		break;
 	case V4L2_PIX_FMT_RGB565:
 		dmr = 0;
@@ -654,6 +654,14 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 			dmr = VNDMR_EXRGB;
 			break;
 		}
+	case V4L2_PIX_FMT_ARGB32:
+		if (priv->chip == RCAR_GEN3) {
+			dmr = VNDMR_EXRGB | VNDMR_DTMD_ARGB;
+		} else {
+			dev_err(icd->parent, "Not support format\n");
+			return -EINVAL;
+		}
+		break;
 	default:
 		dev_warn(icd->parent, "Invalid fourcc format (0x%x)\n",
 			 icd->current_fmt->host_fmt->fourcc);
@@ -1304,6 +1312,14 @@ static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
 		.order			= SOC_MBUS_ORDER_LE,
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
+	{
+		.fourcc			= V4L2_PIX_FMT_ARGB32,
+		.name			= "ARGB8888",
+		.bits_per_sample	= 32,
+		.packing		= SOC_MBUS_PACKING_NONE,
+		.order			= SOC_MBUS_ORDER_LE,
+		.layout			= SOC_MBUS_LAYOUT_PACKED,
+	},
 };
 
 static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
@@ -1611,6 +1627,7 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	case V4L2_PIX_FMT_RGB32:
 		can_scale = priv->chip != RCAR_E1;
 		break;
+	case V4L2_PIX_FMT_ARGB32:
 	case V4L2_PIX_FMT_UYVY:
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_RGB565:
-- 
1.9.1


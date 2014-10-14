Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54255 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaJNG1Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 02:27:16 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 3/3] media: soc_camera: rcar_vin: Add NV16 horizontal scaling-up support
Date: Tue, 14 Oct 2014 15:26:53 +0900
Message-Id: <1413268013-8437-4-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413268013-8437-1-git-send-email-ykaneko0929@gmail.com>
References: <1413268013-8437-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

The scaling function had been forbidden for the capture format of
NV16 until now. With this patch, a horizontal scaling-up function
is supported to the capture format of NV16. a vertical scaling-up
by the capture format of NV16 is forbidden for the H/W specification.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 00bc98d..bf3588f 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -648,7 +648,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	/* output format */
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV16:
-		iowrite32(ALIGN(ALIGN(cam->width, 0x20) * cam->height, 0x80),
+		iowrite32(ALIGN((cam->out_width * cam->out_height), 0x80),
 			  priv->base + VNUVAOF_REG);
 		dmr = VNDMR_DTMD_YCSEP;
 		output_is_yuv = true;
@@ -1622,9 +1622,19 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	if (priv->error_flag == false)
 		priv->error_flag = true;
 	else {
-		if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
-			dev_err(icd->parent, "Specified width error in NV16 format.\n");
-			return -EINVAL;
+		if (pixfmt == V4L2_PIX_FMT_NV16) {
+			if (pix->width & 0x1F) {
+				dev_err(icd->parent,
+				"Specified width error in NV16 format. "
+				"Please specify the multiple of 32.\n");
+				return -EINVAL;
+			}
+			if (pix->height != cam->height) {
+				dev_err(icd->parent,
+				"Vertical scaling-up error in NV16 format. "
+				"Please specify input height size.\n");
+				return -EINVAL;
+			}
 		}
 	}
 
@@ -1670,6 +1680,7 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB555X:
+	case V4L2_PIX_FMT_NV16: /* horizontal scaling-up only is supported */
 		can_scale = true;
 		break;
 	default:
-- 
1.9.1


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36697 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbcB2NOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 08:14:12 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 4/4] media: soc_camera: rcar_vin: Add NV16 scaling support
Date: Mon, 29 Feb 2016 22:12:43 +0900
Message-Id: <1456751563-21246-5-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

The scaling function had been forbidden for the capture format of NV16
until now. With this patch, a horizontal scaling-up function is
supported to the capture format of NV16.
This patch adds the check of the capture width for NV16 format, too.
At the time of NV16 capture format, the user has to specify the capture
output width of the multiple of 32 for H/W specification. At the time of
using ioctl of VIDIOC_S_FMT, this patch adds the error handling to forbid
specification of the capture output width which is not a multiple of 32.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 36 +++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 96f3c8a..979b28c 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -504,6 +504,7 @@ struct rcar_vin_priv {
 	bool				request_to_stop;
 	struct completion		capture_stop;
 	enum chip_id			chip;
+	bool				error_check_flag;
 };
 
 #define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)
@@ -649,7 +650,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	/* output format */
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV16:
-		iowrite32(ALIGN(cam->width * cam->height, 0x80),
+		iowrite32(ALIGN(cam->out_width * cam->out_height, 0x80),
 			  priv->base + VNUVAOF_REG);
 		dmr = VNDMR_DTMD_YCSEP;
 		output_is_yuv = true;
@@ -961,6 +962,8 @@ static int rcar_vin_add_device(struct soc_camera_device *icd)
 	dev_dbg(icd->parent, "R-Car VIN driver attached to camera %d\n",
 		icd->devnum);
 
+	priv->error_check_flag = false;
+
 	return 0;
 }
 
@@ -978,6 +981,7 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 
 	priv->state = STOPPED;
 	priv->request_to_stop = false;
+	priv->error_check_flag = false;
 
 	/* make sure active buffer is cancelled */
 	spin_lock_irq(&priv->lock);
@@ -1166,11 +1170,19 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 		break;
 	}
 
-	if (priv->chip == RCAR_GEN3 && is_scaling(cam) {
-		ret = rcar_vin_uds_set(priv, cam);
-		if (ret < 0)
-			return ret;
-		iowrite32(ALIGN(cam->out_width, 0x20), priv->base + VNIS_REG);
+	if (priv->chip == RCAR_GEN3) {
+		if (is_scaling(cam)) {
+			ret = rcar_vin_uds_set(priv, cam);
+			if (ret < 0)
+				return ret;
+		}
+		if (is_scaling(cam) ||
+		    icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV16)
+			iowrite32(ALIGN(cam->out_width, 0x20),
+				  priv->base + VNIS_REG);
+		else
+			iowrite32(ALIGN(cam->out_width, 0x10),
+				  priv->base + VNIS_REG);
 	} else {
 		/* Set scaling coefficient */
 		value = 0;
@@ -1674,6 +1686,17 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
 		pixfmt, pix->width, pix->height);
 
+	/*
+	 * At the time of NV16 capture format, the user has to specify the
+	 * width of the multiple of 32 for H/W specification.
+	 */
+	if (priv->error_check_flag == false) {
+		priv->error_check_flag = true;
+	} else if (pixfmt == V4L2_PIX_FMT_NV16 && (pix->width & 0x1F)) {
+		dev_dbg(icd->parent, "specified width error in NV16 format.\n");
+		return -EINVAL;
+	}
+
 	switch (pix->field) {
 	default:
 		pix->field = V4L2_FIELD_NONE;
@@ -1720,6 +1743,7 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	case V4L2_PIX_FMT_YUYV:
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB555X:
+	case V4L2_PIX_FMT_NV16:
 		can_scale = true;
 		break;
 	default:
-- 
1.9.1


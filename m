Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41174 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaJPGNU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 02:13:20 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2 2/3] media: soc_camera: rcar_vin: Add capture width check for NV16 format
Date: Thu, 16 Oct 2014 15:12:47 +0900
Message-Id: <1413439968-6349-3-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413439968-6349-1-git-send-email-ykaneko0929@gmail.com>
References: <1413439968-6349-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

At the time of NV16 capture format, the user has to specify the
capture output width of the multiple of 32 for H/W specification.
At the time of using NV16 format by ioctl of VIDIOC_S_FMT,
this patch adds align check and the error handling to forbid
specification of the capture output width which is not a multiple of 32.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

v2 [Yoshihiro Kaneko]
* use u32 instead of unsigned long

 drivers/media/platform/soc_camera/rcar_vin.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 34d5b80..ff5f80a 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -486,6 +486,7 @@ struct rcar_vin_priv {
 	bool				request_to_stop;
 	struct completion		capture_stop;
 	enum chip_id			chip;
+	bool				error_flag;
 };
 
 #define is_continuous_transfer(priv)	(priv->vb_count > MAX_BUFFER_NUM)
@@ -645,7 +646,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	/* output format */
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV16:
-		iowrite32(ALIGN(cam->width * cam->height, 0x80),
+		iowrite32(ALIGN(ALIGN(cam->width, 0x20) * cam->height, 0x80),
 			  priv->base + VNUVAOF_REG);
 		dmr = VNDMR_DTMD_YCSEP;
 		output_is_yuv = true;
@@ -974,6 +975,8 @@ static int rcar_vin_add_device(struct soc_camera_device *icd)
 	dev_dbg(icd->parent, "R-Car VIN driver attached to camera %d\n",
 		icd->devnum);
 
+	priv->error_flag = false;
+
 	return 0;
 }
 
@@ -991,6 +994,7 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 
 	priv->state = STOPPED;
 	priv->request_to_stop = false;
+	priv->error_flag = false;
 
 	/* make sure active buffer is cancelled */
 	spin_lock_irq(&priv->lock);
@@ -1087,6 +1091,7 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 	unsigned char dsize = 0;
 	struct v4l2_rect *cam_subrect = &cam->subrect;
 	u32 value;
+	u32 imgstr;
 
 	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
 		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
@@ -1164,7 +1169,11 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 		break;
 	}
 
-	iowrite32(ALIGN(cam->out_width, 0x10), priv->base + VNIS_REG);
+	if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV16)
+		imgstr = ALIGN(cam->out_width, 0x20);
+	else
+		imgstr = ALIGN(cam->out_width, 0x10);
+	iowrite32(imgstr, priv->base + VNIS_REG);
 
 	return 0;
 }
@@ -1606,6 +1615,17 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
 		pixfmt, pix->width, pix->height);
 
+	/* At the time of NV16 capture format, the user has to specify the
+	   width of the multiple of 32 for H/W specification. */
+	if (priv->error_flag == false)
+		priv->error_flag = true;
+	else {
+		if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
+			dev_err(icd->parent, "Specified width error in NV16 format.\n");
+			return -EINVAL;
+		}
+	}
+
 	switch (pix->field) {
 	default:
 		pix->field = V4L2_FIELD_NONE;
-- 
1.9.1


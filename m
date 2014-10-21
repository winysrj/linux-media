Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41169 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaJUFKn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 01:10:43 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v3 2/3] media: soc_camera: rcar_vin: Add capture width check for NV16 format
Date: Tue, 21 Oct 2014 14:10:28 +0900
Message-Id: <1413868229-22205-3-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1413868229-22205-1-git-send-email-ykaneko0929@gmail.com>
References: <1413868229-22205-1-git-send-email-ykaneko0929@gmail.com>
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

v3 [Yoshihiro Kaneko]
* fixes some code-style and remove useless error flag as suggested by
  Sergei Shtylyov

v2 [Yoshihiro Kaneko]
* use u32 instead of unsigned long

 drivers/media/platform/soc_camera/rcar_vin.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index dd6daab..ecdbd48 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -644,7 +644,7 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	/* output format */
 	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV16:
-		iowrite32(ALIGN(cam->width * cam->height, 0x80),
+		iowrite32(ALIGN(ALIGN(cam->width, 0x20) * cam->height, 0x80),
 			  priv->base + VNUVAOF_REG);
 		dmr = VNDMR_DTMD_YCSEP;
 		output_is_yuv = true;
@@ -1086,6 +1086,7 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 	unsigned char dsize = 0;
 	struct v4l2_rect *cam_subrect = &cam->subrect;
 	u32 value;
+	u32 vnis;
 
 	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
 		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
@@ -1163,7 +1164,11 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 		break;
 	}
 
-	iowrite32(ALIGN(cam->out_width, 0x10), priv->base + VNIS_REG);
+	if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV16)
+		vnis = ALIGN(cam->out_width, 0x20);
+	else
+		vnis = ALIGN(cam->out_width, 0x10);
+	iowrite32(vnis, priv->base + VNIS_REG);
 
 	return 0;
 }
@@ -1605,6 +1610,15 @@ static int rcar_vin_set_fmt(struct soc_camera_device *icd,
 	dev_dbg(dev, "S_FMT(pix=0x%x, %ux%u)\n",
 		pixfmt, pix->width, pix->height);
 
+	/*
+	 * At the time of NV16 capture format, the user has to specify the
+	 * width of the multiple of 32 for H/W specification.
+	 */
+	if ((pixfmt == V4L2_PIX_FMT_NV16) && (pix->width & 0x1F)) {
+		dev_err(icd->parent, "Specified width error in NV16 format.\n");
+		return -EINVAL;
+	}
+
 	switch (pix->field) {
 	default:
 		pix->field = V4L2_FIELD_NONE;
-- 
1.9.1


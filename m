Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:34117 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbcB2NN7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 08:13:59 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 1/4] media: soc_camera: rcar_vin: Add UDS support
Date: Mon, 29 Feb 2016 22:12:40 +0900
Message-Id: <1456751563-21246-2-git-send-email-ykaneko0929@gmail.com>
In-Reply-To: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>

Add UDS control for R-Car Gen3. Up down scaler can be vertical and
horizontal scaling.

Signed-off-by: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 175 +++++++++++++++++++++------
 1 file changed, 140 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index dc75a80..a22141b 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -90,6 +90,7 @@
 
 /* Register bit fields for R-Car VIN */
 /* Video n Main Control Register bits */
+#define VNMC_SCLE		(1 << 26)
 #define VNMC_FOC		(1 << 21)
 #define VNMC_YCAL		(1 << 19)
 #define VNMC_INF_YUV8_BT656	(0 << 16)
@@ -132,6 +133,17 @@
 #define VNDMR2_FTEV		(1 << 17)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)
 
+/* UDS */
+#define VNUDS_CTRL_REG		0x80	/* Scaling Control Registers */
+#define VNUDS_CTRL_AMD		(1 << 30)
+#define VNUDS_CTRL_BC		(1 << 20)
+#define VNUDS_CTRL_TDIPC	(1 << 1)
+
+#define VNUDS_SCALE_REG		0x84	/* Scaling Factor Register */
+#define VNUDS_PASS_BWIDTH_REG	0x90	/* Passband Registers */
+#define VNUDS_IPC_REG		0x98	/* 2D IPC Setting Register */
+#define VNUDS_CLIP_SIZE_REG	0xA4	/* UDS Output Size Clipping Register */
+
 #define VIN_MAX_WIDTH		2048
 #define VIN_MAX_HEIGHT		2048
 
@@ -526,6 +538,14 @@ struct rcar_vin_cam {
 	const struct soc_mbus_pixelfmt	*extra_fmt;
 };
 
+static inline int is_scaling(struct rcar_vin_cam *cam)
+{
+	if (cam->width != cam->out_width || cam->height != cam->out_height)
+		return 1;
+
+	return 0;
+}
+
 /*
  * .queue_setup() is called to check whether the driver can accept the requested
  * number of buffers and to fill in plane sizes for the current frame format if
@@ -667,6 +687,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	if (input_is_yuv == output_is_yuv)
 		vnmc |= VNMC_BPS;
 
+	if (priv->chip == RCAR_GEN3 && is_scaling(cam))
+		vnmc |= VNMC_SCLE;
+
 	/* progressive or interlaced mode */
 	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
 
@@ -973,6 +996,75 @@ static void rcar_vin_remove_device(struct soc_camera_device *icd)
 		icd->devnum);
 }
 
+struct rcar_vin_uds_regs {
+	unsigned long ctrl;
+	unsigned long scale;
+	unsigned long pass_bwidth;
+	unsigned long clip_size;
+};
+
+static unsigned long rcar_vin_get_bwidth(unsigned long ratio)
+{
+	unsigned long bwidth;
+	unsigned long mant, frac;
+
+	mant = (ratio & 0xF000) >> 12;
+	frac = ratio & 0x0FFF;
+	if (mant)
+		bwidth = 64 * 4096 * mant / (4096 * mant + frac);
+	else
+		bwidth = 64;
+
+	return bwidth;
+}
+
+static unsigned long rcar_vin_compute_ratio(unsigned int input,
+		unsigned int output)
+{
+#ifdef DISABLE_UDS_CTRL_AMD
+	return (input - 1) * 4096 / (output - 1);
+#else
+	if (output > input)
+		return input * 4096 / output;
+	else
+		return (input - 1) * 4096 / (output - 1);
+#endif
+}
+
+int rcar_vin_uds_set(struct rcar_vin_priv *priv, struct rcar_vin_cam *cam)
+{
+	struct rcar_vin_uds_regs regs;
+	unsigned long ratio_h, ratio_v;
+	unsigned long bwidth_h, bwidth_v;
+	unsigned long ctrl;
+	unsigned long clip_size;
+	struct v4l2_rect *cam_subrect = &cam->subrect;
+	u32 vnmc;
+
+	ratio_h = rcar_vin_compute_ratio(cam_subrect->width, cam->out_width);
+	ratio_v = rcar_vin_compute_ratio(cam_subrect->height, cam->out_height);
+
+	bwidth_h = rcar_vin_get_bwidth(ratio_h);
+	bwidth_v = rcar_vin_get_bwidth(ratio_v);
+
+	ctrl = VNUDS_CTRL_AMD;
+	clip_size = (cam->out_width << 16) | cam->out_height;
+
+	regs.ctrl = ctrl;
+	regs.scale = (ratio_h << 16) | ratio_v;
+	regs.pass_bwidth = (bwidth_h << 16) | bwidth_v;
+	regs.clip_size = clip_size;
+
+	vnmc = ioread32(priv->base + VNMC_REG);
+	iowrite32(vnmc | VNMC_SCLE, priv->base + VNMC_REG);
+	iowrite32(regs.ctrl, priv->base + VNUDS_CTRL_REG);
+	iowrite32(regs.scale, priv->base + VNUDS_SCALE_REG);
+	iowrite32(regs.pass_bwidth, priv->base + VNUDS_PASS_BWIDTH_REG);
+	iowrite32(regs.clip_size, priv->base + VNUDS_CLIP_SIZE_REG);
+
+	return 0;
+}
+
 static void set_coeff(struct rcar_vin_priv *priv, unsigned short xs)
 {
 	int i;
@@ -1037,6 +1129,7 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 	unsigned char dsize = 0;
 	struct v4l2_rect *cam_subrect = &cam->subrect;
 	u32 value;
+	int ret;
 
 	dev_dbg(icd->parent, "Crop %ux%u@%u:%u\n",
 		icd->user_width, icd->user_height, cam->vin_left, cam->vin_top);
@@ -1073,48 +1166,60 @@ static int rcar_vin_set_rect(struct soc_camera_device *icd)
 		break;
 	}
 
-	/* Set scaling coefficient */
-	value = 0;
-	if (cam_subrect->height != cam->out_height)
-		value = (4096 * cam_subrect->height) / cam->out_height;
-	dev_dbg(icd->parent, "YS Value: %x\n", value);
-	iowrite32(value, priv->base + VNYS_REG);
-
-	value = 0;
-	if (cam_subrect->width != cam->out_width)
-		value = (4096 * cam_subrect->width) / cam->out_width;
+	if (priv->chip == RCAR_GEN3 && is_scaling(cam) {
+		ret = rcar_vin_uds_set(priv, cam);
+		if (ret < 0)
+			return ret;
+		iowrite32(ALIGN(cam->out_width, 0x20), priv->base + VNIS_REG);
+	} else {
+		/* Set scaling coefficient */
+		value = 0;
+		if (cam_subrect->height != cam->out_height)
+			value = (4096 * cam_subrect->height) / cam->out_height;
+		dev_dbg(icd->parent, "YS Value: %x\n", value);
+		iowrite32(value, priv->base + VNYS_REG);
 
-	/* Horizontal upscaling is up to double size */
-	if (0 < value && value < 2048)
-		value = 2048;
+		value = 0;
+		if (cam_subrect->width != cam->out_width)
+			value = (4096 * cam_subrect->width) / cam->out_width;
 
-	dev_dbg(icd->parent, "XS Value: %x\n", value);
-	iowrite32(value, priv->base + VNXS_REG);
+		/* Horizontal upscaling is up to double size */
+		if (value > 0 && value < 2048)
+			value = 2048;
 
-	/* Horizontal upscaling is carried out by scaling down from double size */
-	if (value < 4096)
-		value *= 2;
+		dev_dbg(icd->parent, "XS Value: %x\n", value);
+		iowrite32(value, priv->base + VNXS_REG);
 
-	set_coeff(priv, value);
+		/*
+		 * Horizontal upscaling is carried out
+		 * by scaling down from double size
+		 */
+		if (value < 4096)
+			value *= 2;
+
+		set_coeff(priv, value);
+
+		/* Set Start/End Pixel/Line Post-Clip */
+		iowrite32(0, priv->base + VNSPPOC_REG);
+		iowrite32(0, priv->base + VNSLPOC_REG);
+		iowrite32((cam->out_width - 1) << dsize,
+			priv->base + VNEPPOC_REG);
+		switch (priv->field) {
+		case V4L2_FIELD_INTERLACED:
+		case V4L2_FIELD_INTERLACED_TB:
+		case V4L2_FIELD_INTERLACED_BT:
+			iowrite32(cam->out_height / 2 - 1,
+				  priv->base + VNELPOC_REG);
+			break;
+		default:
+			iowrite32(cam->out_height - 1,
+				priv->base + VNELPOC_REG);
+			break;
+		}
 
-	/* Set Start/End Pixel/Line Post-Clip */
-	iowrite32(0, priv->base + VNSPPOC_REG);
-	iowrite32(0, priv->base + VNSLPOC_REG);
-	iowrite32((cam->out_width - 1) << dsize, priv->base + VNEPPOC_REG);
-	switch (priv->field) {
-	case V4L2_FIELD_INTERLACED:
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_INTERLACED_BT:
-		iowrite32(cam->out_height / 2 - 1,
-			  priv->base + VNELPOC_REG);
-		break;
-	default:
-		iowrite32(cam->out_height - 1, priv->base + VNELPOC_REG);
-		break;
+		iowrite32(ALIGN(cam->out_width, 0x10), priv->base + VNIS_REG);
 	}
 
-	iowrite32(ALIGN(cam->out_width, 0x10), priv->base + VNIS_REG);
-
 	return 0;
 }
 
-- 
1.9.1


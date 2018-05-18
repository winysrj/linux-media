Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60013 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752588AbeERN4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 09:56:45 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, slongerbeam@gmail.com,
        p.zabel@pengutronix.de, kernel@pengutronix.de,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 2/2] media: imx: add support for RGB565_2X8 on parallel bus
Date: Fri, 18 May 2018 15:56:39 +0200
Message-Id: <20180518135639.19889-3-jlu@pengutronix.de>
In-Reply-To: <20180518135639.19889-1-jlu@pengutronix.de>
References: <20180518135639.19889-1-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IPU can only capture RGB565 with two 8-bit cycles in bayer/generic
mode on the parallel bus, compared to a specific mode on MIPI CSI-2.
To handle this, we extend imx_media_pixfmt with a cycles per pixel
field, which is used for generic formats on the parallel bus.

Based on the selected format and bus, we then update the width to
account for the multiple cycles per pixel.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-media-csi.c   | 101 +++++++++++++-------
 drivers/staging/media/imx/imx-media-utils.c |   1 +
 drivers/staging/media/imx/imx-media.h       |   2 +
 3 files changed, 71 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 08b636084286..64e795b0bdae 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -121,10 +121,32 @@ static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
 	return container_of(sdev, struct csi_priv, sd);
 }
 
+static inline bool is_parallel_bus(struct v4l2_fwnode_endpoint *ep)
+{
+	return ep->bus_type != V4L2_MBUS_CSI2;
+}
+
 static inline bool is_parallel_16bit_bus(struct v4l2_fwnode_endpoint *ep)
 {
-	return ep->bus_type != V4L2_MBUS_CSI2 &&
-		ep->bus.parallel.bus_width >= 16;
+	return is_parallel_bus(ep) && ep->bus.parallel.bus_width >= 16;
+}
+
+/*
+ * Check for conditions that require the IPU to handle the
+ * data internally as generic data, aka passthrough mode:
+ * - raw bayer media bus formats, or
+ * - the CSI is receiving from a 16-bit parallel bus, or
+ * - the CSI is receiving from an 8-bit parallel bus and the incoming
+ *   media bus format is other than UYVY8_2X8/YUYV8_2X8.
+ */
+static inline bool requires_passthrough(struct v4l2_fwnode_endpoint *ep,
+					struct v4l2_mbus_framefmt *infmt,
+					const struct imx_media_pixfmt *incc)
+{
+	return incc->bayer || is_parallel_16bit_bus(ep) ||
+		(is_parallel_bus(ep) &&
+		 infmt->code != MEDIA_BUS_FMT_UYVY8_2X8 &&
+		 infmt->code != MEDIA_BUS_FMT_YUYV8_2X8);
 }
 
 /*
@@ -367,15 +389,18 @@ static void csi_idmac_unsetup_vb2_buf(struct csi_priv *priv,
 static int csi_idmac_setup_channel(struct csi_priv *priv)
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
+	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_framefmt *infmt;
 	struct ipu_image image;
 	u32 passthrough_bits;
+	u32 passthrough_cycles;
 	dma_addr_t phys[2];
 	bool passthrough;
 	u32 burst_size;
 	int ret;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
+	incc = priv->cc[CSI_SINK_PAD];
 
 	ipu_cpmem_zero(priv->idmac_ch);
 
@@ -389,12 +414,9 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	image.phys0 = phys[0];
 	image.phys1 = phys[1];
 
-	/*
-	 * Check for conditions that require the IPU to handle the
-	 * data internally as generic data, aka passthrough mode:
-	 * - raw bayer formats
-	 * - the CSI is receiving from a 16-bit parallel bus
-	 */
+	passthrough = requires_passthrough(&priv->upstream_ep, infmt, incc);
+	passthrough_cycles = 1;
+
 	switch (image.pix.pixelformat) {
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SGBRG8:
@@ -402,7 +424,6 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_SRGGB8:
 	case V4L2_PIX_FMT_GREY:
 		burst_size = 16;
-		passthrough = true;
 		passthrough_bits = 8;
 		break;
 	case V4L2_PIX_FMT_SBGGR16:
@@ -411,7 +432,6 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_SRGGB16:
 	case V4L2_PIX_FMT_Y16:
 		burst_size = 8;
-		passthrough = true;
 		passthrough_bits = 16;
 		break;
 	case V4L2_PIX_FMT_YUV420:
@@ -419,7 +439,6 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 		burst_size = (image.pix.width & 0x3f) ?
 			     ((image.pix.width & 0x1f) ?
 			      ((image.pix.width & 0xf) ? 8 : 16) : 32) : 64;
-		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
 		passthrough_bits = 16;
 		/* Skip writing U and V components to odd rows */
 		ipu_cpmem_skip_odd_chroma_rows(priv->idmac_ch);
@@ -428,18 +447,25 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	case V4L2_PIX_FMT_UYVY:
 		burst_size = (image.pix.width & 0x1f) ?
 			     ((image.pix.width & 0xf) ? 8 : 16) : 32;
-		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
 		passthrough_bits = 16;
 		break;
+	case V4L2_PIX_FMT_RGB565:
+		if (passthrough) {
+			burst_size = 16;
+			passthrough_bits = 8;
+			passthrough_cycles = incc->cycles;
+			break;
+		}
+		/* fallthrough for non-passthrough RGB565 (CSI-2 bus) */
 	default:
 		burst_size = (image.pix.width & 0xf) ? 8 : 16;
-		passthrough = is_parallel_16bit_bus(&priv->upstream_ep);
 		passthrough_bits = 16;
 		break;
 	}
 
 	if (passthrough) {
-		ipu_cpmem_set_resolution(priv->idmac_ch, image.rect.width,
+		ipu_cpmem_set_resolution(priv->idmac_ch,
+					 image.rect.width * passthrough_cycles,
 					 image.rect.height);
 		ipu_cpmem_set_stride(priv->idmac_ch, image.pix.bytesperline);
 		ipu_cpmem_set_buffer(priv->idmac_ch, 0, image.phys0);
@@ -630,17 +656,20 @@ static void csi_idmac_stop(struct csi_priv *priv)
 static int csi_setup(struct csi_priv *priv)
 {
 	struct v4l2_mbus_framefmt *infmt, *outfmt;
+	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_config mbus_cfg;
 	struct v4l2_mbus_framefmt if_fmt;
+	struct v4l2_rect crop;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
+	incc = priv->cc[CSI_SINK_PAD];
 	outfmt = &priv->format_mbus[priv->active_output_pad];
 
 	/* compose mbus_config from the upstream endpoint */
 	mbus_cfg.type = priv->upstream_ep.bus_type;
-	mbus_cfg.flags = (priv->upstream_ep.bus_type == V4L2_MBUS_CSI2) ?
-		priv->upstream_ep.bus.mipi_csi2.flags :
-		priv->upstream_ep.bus.parallel.flags;
+	mbus_cfg.flags = is_parallel_bus(&priv->upstream_ep) ?
+		priv->upstream_ep.bus.parallel.flags :
+		priv->upstream_ep.bus.mipi_csi2.flags;
 
 	/*
 	 * we need to pass input frame to CSI interface, but
@@ -648,8 +677,18 @@ static int csi_setup(struct csi_priv *priv)
 	 */
 	if_fmt = *infmt;
 	if_fmt.field = outfmt->field;
+	crop = priv->crop;
 
-	ipu_csi_set_window(priv->csi, &priv->crop);
+	/*
+	 * if cycles is set, we need to handle this over multiple cycles as
+	 * generic/bayer data
+	 */
+	if (is_parallel_bus(&priv->upstream_ep) && incc->cycles) {
+		if_fmt.width *= incc->cycles;
+		crop.width *= incc->cycles;
+	}
+
+	ipu_csi_set_window(priv->csi, &crop);
 
 	ipu_csi_set_downsize(priv->csi,
 			     priv->crop.width == 2 * priv->compose.width,
@@ -1007,7 +1046,6 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct v4l2_fwnode_endpoint upstream_ep = {};
-	const struct imx_media_pixfmt *incc;
 	bool is_csi2;
 	int ret;
 
@@ -1025,17 +1063,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 	mutex_lock(&priv->lock);
 
 	priv->upstream_ep = upstream_ep;
-	is_csi2 = (upstream_ep.bus_type == V4L2_MBUS_CSI2);
-	incc = priv->cc[CSI_SINK_PAD];
-
-	if (priv->dest != IPU_CSI_DEST_IDMAC &&
-	    (incc->bayer || is_parallel_16bit_bus(&upstream_ep))) {
-		v4l2_err(&priv->sd,
-			 "bayer/16-bit parallel buses must go to IDMAC pad\n");
-		ret = -EINVAL;
-		goto out;
-	}
-
+	is_csi2 = !is_parallel_bus(&upstream_ep);
 	if (is_csi2) {
 		int vc_num = 0;
 		/*
@@ -1059,7 +1087,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
 
 	/* select either parallel or MIPI-CSI2 as input to CSI */
 	ipu_set_csi_src_mux(priv->ipu, priv->csi_id, is_csi2);
-out:
+
 	mutex_unlock(&priv->lock);
 	return ret;
 }
@@ -1131,6 +1159,7 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	struct v4l2_fwnode_endpoint upstream_ep;
 	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_framefmt *infmt;
 	int ret = 0;
@@ -1147,7 +1176,13 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 		break;
 	case CSI_SRC_PAD_DIRECT:
 	case CSI_SRC_PAD_IDMAC:
-		if (incc->bayer) {
+		ret = csi_get_upstream_endpoint(priv, &upstream_ep);
+		if (ret) {
+			v4l2_err(&priv->sd, "failed to find upstream endpoint\n");
+			goto out;
+		}
+
+		if (requires_passthrough(&upstream_ep, infmt, incc)) {
 			if (code->index != 0) {
 				ret = -EINVAL;
 				goto out;
@@ -1286,7 +1321,7 @@ static void csi_try_fmt(struct csi_priv *priv,
 		sdformat->format.width = compose->width;
 		sdformat->format.height = compose->height;
 
-		if (incc->bayer) {
+		if (requires_passthrough(upstream_ep, infmt, incc)) {
 			sdformat->format.code = infmt->code;
 			*cc = incc;
 		} else {
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 7ec2db84451c..8aa13403b09d 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -78,6 +78,7 @@ static const struct imx_media_pixfmt rgb_formats[] = {
 		.codes  = {MEDIA_BUS_FMT_RGB565_2X8_LE},
 		.cs     = IPUV3_COLORSPACE_RGB,
 		.bpp    = 16,
+		.cycles = 2,
 	}, {
 		.fourcc	= V4L2_PIX_FMT_RGB24,
 		.codes  = {
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index e945e0ed6dd6..57bd094cf765 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -62,6 +62,8 @@ struct imx_media_pixfmt {
 	u32     fourcc;
 	u32     codes[4];
 	int     bpp;     /* total bpp */
+	/* cycles per pixel for generic (bayer) formats for the parallel bus */
+	int	cycles;
 	enum ipu_color_space cs;
 	bool    planar;  /* is a planar format */
 	bool    bayer;   /* is a raw bayer format */
-- 
2.17.0

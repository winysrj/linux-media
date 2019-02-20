Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17ABFC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0A8E21738
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 00:06:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rk143/fO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfBTAFl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:05:41 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37741 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730054AbfBTAFi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 19:05:38 -0500
Received: by mail-pf1-f193.google.com with SMTP id s22so10994898pfh.4;
        Tue, 19 Feb 2019 16:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4muVVZQyIcLgGrth7Qy2InTRh/fMnpCHYAHULwqqIF0=;
        b=Rk143/fOn2mb+lJZjswSI2td31aWq93Mrib149wphL10KCrXmMAGMF/0m/DOVh9Xjg
         6wpVuK1HL5liZmiHphjRNRK1Xr6XKyZoYQjw0nL92S0GRTUgXYvpiM/PCscG3JDp/6q7
         qxHq+qtoLUwY/fMKV5PvWCJXVOfOhVSGyh+d1wZ89Qg/7c7QYGSgxvOt+0E4Ggecst9N
         vzJ6RwtVjCpVtvV42Idgh6wrVkHtxJ+sY6vI0Tsk0l/GqTIDXks58vI6SLylZz+MAFNU
         hSdwL4kr2l0aYEXnTNsEfC7iQztQIln0MdnHCZJil6jdsH3CZkLwKEmbhfKRoGJg7Kez
         VMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4muVVZQyIcLgGrth7Qy2InTRh/fMnpCHYAHULwqqIF0=;
        b=Y8rwY5sfk+yFYwq7xhl817v4d4SdLNJ79Xh+nXHHYtQ95SSxKCbHNm8ugfkxDFXfIW
         evjMLgzCk/mB9CSjMp2VDhYPz1xEQZi0QLQu8d9w8/GFuSRMwkDe/QcTaezvGJEup57/
         LcRB53uvOddZRFohiC92Ek3wgUJf4iMH23hko23waAz1FyNs0I2THCBVut8rCO7A1sL0
         ViMhW1OWM3YfvuQNPptJDoCSd4OkBOujlKTZ3CbWAUrwGc5QvUFJxkTbH12AUxW5Fo5t
         /x2IlMFlz3dfCEkiBLmW3wmJusyftOt4OlhkNNIE82gBn3I+dOaG9INuJbTHxplyeTKA
         sW0g==
X-Gm-Message-State: AHQUAuZF93OxqX9o2OCaAOa5waUYe3YAF7JyIcpCPA9kcP6Py/ekdXh6
        2EDYsNRCdsKsslojfsUnEUXDorb5
X-Google-Smtp-Source: AHgI3IaqfyYUPDxbKDhfj4oYK1OA8ioC2qCk5v8rz0tjFutME0QSIksFwE5GzpmwXSYflsc+V30epg==
X-Received: by 2002:a63:5207:: with SMTP id g7mr26715348pgb.253.1550621136869;
        Tue, 19 Feb 2019 16:05:36 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id f14sm19159083pgv.23.2019.02.19.16.05.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 16:05:36 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list),
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-fbdev@vger.kernel.org (open list:FRAMEBUFFER LAYER)
Subject: [PATCH v5 3/7] gpu: ipu-v3: ipu-ic: Fully describe colorspace conversions
Date:   Tue, 19 Feb 2019 16:05:17 -0800
Message-Id: <20190220000521.31130-4-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190220000521.31130-1-slongerbeam@gmail.com>
References: <20190220000521.31130-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Only providing the input and output RGB/YUV space to the IC task init
functions is not sufficient. To fully characterize a colorspace
conversion, the colorspace (chromaticities), Y'CbCr encoding standard,
and quantization also need to be specified.

Define a 'struct ipu_ic_colorspace' that includes all the above, and pass
the input and output ipu_ic_colorspace to the IC task init functions.

This allows to actually enforce the fact that the IC:

- can only encode to/from YUV full range (follow-up patch will remove
  this restriction).
- can only encode to/from RGB full range.
- can only encode using BT.601 standard (follow-up patch will add
  Rec.709 encoding support).
- cannot convert colorspaces from input to output, the
  input and output colorspace chromaticities must be the same.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/gpu/ipu-v3/ipu-ic.c                 | 101 ++++++++++++--------
 drivers/gpu/ipu-v3/ipu-image-convert.c      |  27 ++++--
 drivers/staging/media/imx/imx-ic-prpencvf.c |  22 +++--
 include/video/imx-ipu-v3.h                  |  37 +++++--
 4 files changed, 127 insertions(+), 60 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 71a0409093e6..02043f23f411 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -146,8 +146,10 @@ struct ipu_ic {
 	const struct ic_task_regoffs *reg;
 	const struct ic_task_bitfields *bit;
 
-	enum ipu_color_space in_cs, g_in_cs;
-	enum ipu_color_space out_cs;
+	struct ipu_ic_colorspace in_cs;
+	struct ipu_ic_colorspace g_in_cs;
+	struct ipu_ic_colorspace out_cs;
+
 	bool graphics;
 	bool rotation;
 	bool in_use;
@@ -236,8 +238,8 @@ static const struct ic_encode_coeff ic_encode_ycbcr2rgb_601 = {
 };
 
 static int init_csc(struct ipu_ic *ic,
-		    enum ipu_color_space inf,
-		    enum ipu_color_space outf,
+		    const struct ipu_ic_colorspace *in,
+		    const struct ipu_ic_colorspace *out,
 		    int csc_index)
 {
 	struct ipu_ic_priv *priv = ic->priv;
@@ -247,19 +249,41 @@ static int init_csc(struct ipu_ic *ic,
 	const u16 *a;
 	u32 param;
 
+	if (in->colorspace != out->colorspace) {
+		dev_err(priv->ipu->dev, "Cannot convert colorspaces\n");
+		return -ENOTSUPP;
+	}
+
+	if (out->enc != V4L2_YCBCR_ENC_601) {
+		dev_err(priv->ipu->dev, "Only BT.601 encoding supported\n");
+		return -ENOTSUPP;
+	}
+
+	if ((in->cs == IPUV3_COLORSPACE_YUV &&
+	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
+	    (out->cs == IPUV3_COLORSPACE_YUV &&
+	     out->quant != V4L2_QUANTIZATION_FULL_RANGE)) {
+		dev_err(priv->ipu->dev, "Limited range YUV not supported\n");
+		return -ENOTSUPP;
+	}
+
+	if ((in->cs == IPUV3_COLORSPACE_RGB &&
+	     in->quant != V4L2_QUANTIZATION_FULL_RANGE) ||
+	    (out->cs == IPUV3_COLORSPACE_RGB &&
+	     out->quant != V4L2_QUANTIZATION_FULL_RANGE)) {
+		dev_err(priv->ipu->dev, "Limited range RGB not supported\n");
+		return -ENOTSUPP;
+	}
+
 	base = (u32 __iomem *)
 		(priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
 
-	if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
+	if (in->cs == out->cs)
+		coeff = &ic_encode_identity;
+	else if (in->cs == IPUV3_COLORSPACE_YUV)
 		coeff = &ic_encode_ycbcr2rgb_601;
-	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
+	else
 		coeff = &ic_encode_rgb2ycbcr_601;
-	else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
-		coeff = &ic_encode_identity;
-	else {
-		dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
-		return -EINVAL;
-	}
 
 	/* Cast to unsigned */
 	c = (const u16 (*)[3])coeff->coeff;
@@ -357,14 +381,14 @@ void ipu_ic_task_enable(struct ipu_ic *ic)
 	if (ic->rotation)
 		ic_conf |= ic->bit->ic_conf_rot_en;
 
-	if (ic->in_cs != ic->out_cs)
+	if (ic->in_cs.cs != ic->out_cs.cs)
 		ic_conf |= ic->bit->ic_conf_csc1_en;
 
 	if (ic->graphics) {
 		ic_conf |= ic->bit->ic_conf_cmb_en;
 		ic_conf |= ic->bit->ic_conf_csc1_en;
 
-		if (ic->g_in_cs != ic->out_cs)
+		if (ic->g_in_cs.cs != ic->out_cs.cs)
 			ic_conf |= ic->bit->ic_conf_csc2_en;
 	}
 
@@ -399,7 +423,7 @@ void ipu_ic_task_disable(struct ipu_ic *ic)
 EXPORT_SYMBOL_GPL(ipu_ic_task_disable);
 
 int ipu_ic_task_graphics_init(struct ipu_ic *ic,
-			      enum ipu_color_space in_g_cs,
+			      const struct ipu_ic_colorspace *g_in_cs,
 			      bool galpha_en, u32 galpha,
 			      bool colorkey_en, u32 colorkey)
 {
@@ -416,20 +440,25 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 	ic_conf = ipu_ic_read(ic, IC_CONF);
 
 	if (!(ic_conf & ic->bit->ic_conf_csc1_en)) {
+		struct ipu_ic_colorspace rgb_cs;
+
+		ipu_ic_fill_colorspace(&rgb_cs,
+				       V4L2_COLORSPACE_SRGB,
+				       V4L2_YCBCR_ENC_601,
+				       V4L2_QUANTIZATION_FULL_RANGE,
+				       IPUV3_COLORSPACE_RGB);
+
 		/* need transparent CSC1 conversion */
-		ret = init_csc(ic, IPUV3_COLORSPACE_RGB,
-			       IPUV3_COLORSPACE_RGB, 0);
+		ret = init_csc(ic, &rgb_cs, &rgb_cs, 0);
 		if (ret)
 			goto unlock;
 	}
 
-	ic->g_in_cs = in_g_cs;
+	ic->g_in_cs = *g_in_cs;
 
-	if (ic->g_in_cs != ic->out_cs) {
-		ret = init_csc(ic, ic->g_in_cs, ic->out_cs, 1);
-		if (ret)
-			goto unlock;
-	}
+	ret = init_csc(ic, &ic->g_in_cs, &ic->out_cs, 1);
+	if (ret)
+		goto unlock;
 
 	if (galpha_en) {
 		ic_conf |= IC_CONF_IC_GLB_LOC_A;
@@ -456,10 +485,10 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 EXPORT_SYMBOL_GPL(ipu_ic_task_graphics_init);
 
 int ipu_ic_task_init_rsc(struct ipu_ic *ic,
+			 const struct ipu_ic_colorspace *in_cs,
+			 const struct ipu_ic_colorspace *out_cs,
 			 int in_width, int in_height,
 			 int out_width, int out_height,
-			 enum ipu_color_space in_cs,
-			 enum ipu_color_space out_cs,
 			 u32 rsc)
 {
 	struct ipu_ic_priv *priv = ic->priv;
@@ -491,28 +520,24 @@ int ipu_ic_task_init_rsc(struct ipu_ic *ic,
 	ipu_ic_write(ic, rsc, ic->reg->rsc);
 
 	/* Setup color space conversion */
-	ic->in_cs = in_cs;
-	ic->out_cs = out_cs;
+	ic->in_cs = *in_cs;
+	ic->out_cs = *out_cs;
 
-	if (ic->in_cs != ic->out_cs) {
-		ret = init_csc(ic, ic->in_cs, ic->out_cs, 0);
-		if (ret)
-			goto unlock;
-	}
+	ret = init_csc(ic, &ic->in_cs, &ic->out_cs, 0);
 
-unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
 	return ret;
 }
 
 int ipu_ic_task_init(struct ipu_ic *ic,
+		     const struct ipu_ic_colorspace *in_cs,
+		     const struct ipu_ic_colorspace *out_cs,
 		     int in_width, int in_height,
-		     int out_width, int out_height,
-		     enum ipu_color_space in_cs,
-		     enum ipu_color_space out_cs)
+		     int out_width, int out_height)
 {
-	return ipu_ic_task_init_rsc(ic, in_width, in_height, out_width,
-				    out_height, in_cs, out_cs, 0);
+	return ipu_ic_task_init_rsc(ic, in_cs, out_cs,
+				    in_width, in_height,
+				    out_width, out_height, 0);
 }
 EXPORT_SYMBOL_GPL(ipu_ic_task_init);
 
diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 13103ab86050..ccbc8f4d95d7 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1317,7 +1317,7 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 	struct ipu_image_convert_priv *priv = chan->priv;
 	struct ipu_image_convert_image *s_image = &ctx->in;
 	struct ipu_image_convert_image *d_image = &ctx->out;
-	enum ipu_color_space src_cs, dest_cs;
+	struct ipu_ic_colorspace src_cs, dest_cs;
 	unsigned int dst_tile = ctx->out_tile_map[tile];
 	unsigned int dest_width, dest_height;
 	unsigned int col, row;
@@ -1327,8 +1327,16 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 	dev_dbg(priv->ipu->dev, "%s: task %u: starting ctx %p run %p tile %u -> %u\n",
 		__func__, chan->ic_task, ctx, run, tile, dst_tile);
 
-	src_cs = ipu_pixelformat_to_colorspace(s_image->fmt->fourcc);
-	dest_cs = ipu_pixelformat_to_colorspace(d_image->fmt->fourcc);
+	ipu_ic_fill_colorspace(&src_cs,
+			s_image->base.pix.colorspace,
+			s_image->base.pix.ycbcr_enc,
+			s_image->base.pix.quantization,
+			ipu_pixelformat_to_colorspace(s_image->fmt->fourcc));
+	ipu_ic_fill_colorspace(&dest_cs,
+			d_image->base.pix.colorspace,
+			d_image->base.pix.ycbcr_enc,
+			d_image->base.pix.quantization,
+			ipu_pixelformat_to_colorspace(d_image->fmt->fourcc));
 
 	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
 		/* swap width/height for resizer */
@@ -1352,13 +1360,12 @@ static int convert_start(struct ipu_image_convert_run *run, unsigned int tile)
 		s_image->tile[tile].height, dest_width, dest_height, rsc);
 
 	/* setup the IC resizer and CSC */
-	ret = ipu_ic_task_init_rsc(chan->ic,
-			       s_image->tile[tile].width,
-			       s_image->tile[tile].height,
-			       dest_width,
-			       dest_height,
-			       src_cs, dest_cs,
-			       rsc);
+	ret = ipu_ic_task_init_rsc(chan->ic, &src_cs, &dest_cs,
+				   s_image->tile[tile].width,
+				   s_image->tile[tile].height,
+				   dest_width,
+				   dest_height,
+				   rsc);
 	if (ret) {
 		dev_err(priv->ipu->dev, "ipu_ic_task_init failed, %d\n", ret);
 		return ret;
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 5c8e6ad8c025..10f2c7684727 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -458,6 +458,7 @@ static int prp_setup_rotation(struct prp_priv *priv)
 	struct imx_media_video_dev *vdev = priv->vdev;
 	struct imx_ic_priv *ic_priv = priv->ic_priv;
 	const struct imx_media_pixfmt *outcc, *incc;
+	struct ipu_ic_colorspace in_cs, out_cs;
 	struct v4l2_mbus_framefmt *infmt;
 	struct v4l2_pix_format *outfmt;
 	dma_addr_t phys[2];
@@ -468,6 +469,11 @@ static int prp_setup_rotation(struct prp_priv *priv)
 	incc = priv->cc[PRPENCVF_SINK_PAD];
 	outcc = vdev->cc;
 
+	ipu_ic_fill_colorspace(&in_cs, infmt->colorspace, infmt->ycbcr_enc,
+			       infmt->quantization, incc->cs);
+	ipu_ic_fill_colorspace(&out_cs, outfmt->colorspace, outfmt->ycbcr_enc,
+			       outfmt->quantization, outcc->cs);
+
 	ret = imx_media_alloc_dma_buf(priv->md, &priv->rot_buf[0],
 				      outfmt->sizeimage);
 	if (ret) {
@@ -481,10 +487,9 @@ static int prp_setup_rotation(struct prp_priv *priv)
 		goto free_rot0;
 	}
 
-	ret = ipu_ic_task_init(priv->ic,
+	ret = ipu_ic_task_init(priv->ic, &in_cs, &out_cs,
 			       infmt->width, infmt->height,
-			       outfmt->height, outfmt->width,
-			       incc->cs, outcc->cs);
+			       outfmt->height, outfmt->width);
 	if (ret) {
 		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
 		goto free_rot1;
@@ -574,6 +579,7 @@ static int prp_setup_norotation(struct prp_priv *priv)
 	struct imx_media_video_dev *vdev = priv->vdev;
 	struct imx_ic_priv *ic_priv = priv->ic_priv;
 	const struct imx_media_pixfmt *outcc, *incc;
+	struct ipu_ic_colorspace in_cs, out_cs;
 	struct v4l2_mbus_framefmt *infmt;
 	struct v4l2_pix_format *outfmt;
 	dma_addr_t phys[2];
@@ -584,10 +590,14 @@ static int prp_setup_norotation(struct prp_priv *priv)
 	incc = priv->cc[PRPENCVF_SINK_PAD];
 	outcc = vdev->cc;
 
-	ret = ipu_ic_task_init(priv->ic,
+	ipu_ic_fill_colorspace(&in_cs, infmt->colorspace, infmt->ycbcr_enc,
+			       infmt->quantization, incc->cs);
+	ipu_ic_fill_colorspace(&out_cs, outfmt->colorspace, outfmt->ycbcr_enc,
+			       outfmt->quantization, outcc->cs);
+
+	ret = ipu_ic_task_init(priv->ic, &in_cs, &out_cs,
 			       infmt->width, infmt->height,
-			       outfmt->width, outfmt->height,
-			       incc->cs, outcc->cs);
+			       outfmt->width, outfmt->height);
 	if (ret) {
 		v4l2_err(&ic_priv->sd, "ipu_ic_task_init failed, %d\n", ret);
 		return ret;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index c887f4bee5f8..498f4ffc1819 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -386,20 +386,45 @@ enum ipu_ic_task {
 	IC_NUM_TASKS,
 };
 
+/*
+ * The parameters that describe a colorspace according to the
+ * Image Converter: colorspace (chromaticities), Y'CbCr encoding,
+ * quantization, and "colorspace" (RGB or YUV).
+ */
+struct ipu_ic_colorspace {
+	enum v4l2_colorspace colorspace;
+	enum v4l2_ycbcr_encoding enc;
+	enum v4l2_quantization quant;
+	enum ipu_color_space cs;
+};
+
+static inline void
+ipu_ic_fill_colorspace(struct ipu_ic_colorspace *ic_cs,
+		       enum v4l2_colorspace colorspace,
+		       enum v4l2_ycbcr_encoding enc,
+		       enum v4l2_quantization quant,
+		       enum ipu_color_space cs)
+{
+	ic_cs->colorspace = colorspace;
+	ic_cs->enc = enc;
+	ic_cs->quant = quant;
+	ic_cs->cs = cs;
+}
+
 struct ipu_ic;
 int ipu_ic_task_init(struct ipu_ic *ic,
+		     const struct ipu_ic_colorspace *in_cs,
+		     const struct ipu_ic_colorspace *out_cs,
 		     int in_width, int in_height,
-		     int out_width, int out_height,
-		     enum ipu_color_space in_cs,
-		     enum ipu_color_space out_cs);
+		     int out_width, int out_height);
 int ipu_ic_task_init_rsc(struct ipu_ic *ic,
+			 const struct ipu_ic_colorspace *in_cs,
+			 const struct ipu_ic_colorspace *out_cs,
 			 int in_width, int in_height,
 			 int out_width, int out_height,
-			 enum ipu_color_space in_cs,
-			 enum ipu_color_space out_cs,
 			 u32 rsc);
 int ipu_ic_task_graphics_init(struct ipu_ic *ic,
-			      enum ipu_color_space in_g_cs,
+			      const struct ipu_ic_colorspace *g_in_cs,
 			      bool galpha_en, u32 galpha,
 			      bool colorkey_en, u32 colorkey);
 void ipu_ic_task_enable(struct ipu_ic *ic);
-- 
2.17.1


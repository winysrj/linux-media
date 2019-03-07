Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5BCC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84B5F20675
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 23:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZFuM/zVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfCGXec (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 18:34:32 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33193 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfCGXeW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 18:34:22 -0500
Received: by mail-pg1-f193.google.com with SMTP id h11so12529350pgl.0;
        Thu, 07 Mar 2019 15:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MCRXi36yVo7k0lloMC2BZbkExKJ5Vx5y+atdUDoFkhY=;
        b=ZFuM/zVkEAMYxdPKrj8S8+QVZpmhw8pj6jJlHs2YRbZGqE8IunDL+yqjHSvTHjW4ME
         iQe6fjj3IiIXXhrito/0sGoh4ND1JlRcws2G6k0wNCABQ0ErzVfVEYp32ZWMM50qpfI5
         cR7tPmFPj8LVBeA8fA2TKCSXJB5JGpNp9+D2fWr80SOfnk+hy5nR0cjuJrwMEj9t0ivh
         SgOC1mTUGTubXTlj0fs/WUL0bH7WVqYtRbxXcUdzVmIOWJEQ2aQY8npNaFF/GfzxTxQa
         SJpemQewCXUBOmiA8pgcGMojbGKp0tnGxfu9wHnTvWQYDGBCGHGXwOd5v6CbvsI1OePl
         nATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MCRXi36yVo7k0lloMC2BZbkExKJ5Vx5y+atdUDoFkhY=;
        b=MLgcg8yO/bnBAEpVDPL/qgaKziv62NitVXDS9bwR2kaDUxv3GTszz028BtxXasf9sp
         6S/cCrM61Sbxrr/fc1862Ix/PtbSrQ/Y9TP2R/zduDWhnG7bGljrM5LdSRSpun9sDpj6
         2CWzbA0j0UQnlg+cq7jJjiJ6Lxsz1ERomgxU2qLA2DVBc0mrfZoZAGEkWR1Ge5OrUd8K
         /cqIQZ/R61a89MrZf0w09nOkVApLWp56AmfRuinWsStf8ClAjWShFUU40ipu5mTd84lO
         SuRZXAz04ukCT+wEwPKhVIkZv3XVsRiHHEy1yUwtFabS49Re27kBjAaMFMbKugeBzQMP
         oWRA==
X-Gm-Message-State: APjAAAX9U47IW3XqDmSpR6xtqmRrspS2SD1Kr7Ugp68X+u87dg568efV
        9KwwMwKNZ0rvDnGXrOsdV7XMzOIH
X-Google-Smtp-Source: APXvYqwo8jF+3UeWcvZFIWme1fy9jrhlRkP0xnv/aAXOJ18HR1f6MpkaRhTvnSLO9AK4OU5c/fvsCw==
X-Received: by 2002:aa7:918b:: with SMTP id x11mr16004027pfa.228.1552001661305;
        Thu, 07 Mar 2019 15:34:21 -0800 (PST)
Received: from localhost.localdomain ([2605:e000:d445:6a00:2097:f23b:3b8f:e255])
        by smtp.gmail.com with ESMTPSA id m21sm8684866pfa.14.2019.03.07.15.34.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 15:34:20 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 6/7] media: imx: Try colorimetry at both sink and source pads
Date:   Thu,  7 Mar 2019 15:33:55 -0800
Message-Id: <20190307233356.23748-7-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190307233356.23748-1-slongerbeam@gmail.com>
References: <20190307233356.23748-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The colorimetry parameters need to be tested at both sink and source
pads. Specifically, for prpencvf, the IC only supports RGB full-range
quantization at input and output.

Fix this by cleaning up imx_media_fill_default_mbus_fields(), renaming
to imx_media_try_colorimetry(), and call it at both sink and source
pad try_fmt's. The unrelated check for uninitialized field value is
moved out to appropriate places in each subdev try_fmt.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-ic-prp.c      |  6 +-
 drivers/staging/media/imx/imx-ic-prpencvf.c |  8 +--
 drivers/staging/media/imx/imx-media-csi.c   | 19 +++---
 drivers/staging/media/imx/imx-media-utils.c | 68 +++++++++++----------
 drivers/staging/media/imx/imx-media-vdic.c  |  5 +-
 drivers/staging/media/imx/imx-media.h       |  5 +-
 drivers/staging/media/imx/imx7-media-csi.c  |  8 +--
 7 files changed, 62 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index 3d43cdcb4bb9..8010ee706164 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -197,8 +197,8 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 			sdformat->format.code = cc->codes[0];
 		}
 
-		imx_media_fill_default_mbus_fields(&sdformat->format, infmt,
-						   true);
+		if (sdformat->format.field == V4L2_FIELD_ANY)
+			sdformat->format.field = V4L2_FIELD_NONE;
 		break;
 	case PRP_SRC_PAD_PRPENC:
 	case PRP_SRC_PAD_PRPVF:
@@ -207,6 +207,8 @@ static int prp_set_fmt(struct v4l2_subdev *sd,
 		break;
 	}
 
+	imx_media_try_colorimetry(&sdformat->format, true);
+
 	fmt = __prp_get_fmt(priv, cfg, sdformat->pad, sdformat->which);
 	*fmt = sdformat->format;
 out:
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 10f2c7684727..b1886a4e362e 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -899,8 +899,6 @@ static void prp_try_fmt(struct prp_priv *priv,
 		/* propagate colorimetry from sink */
 		sdformat->format.colorspace = infmt->colorspace;
 		sdformat->format.xfer_func = infmt->xfer_func;
-		sdformat->format.quantization = infmt->quantization;
-		sdformat->format.ycbcr_enc = infmt->ycbcr_enc;
 	} else {
 		v4l_bound_align_image(&sdformat->format.width,
 				      MIN_W_SINK, MAX_W_SINK, W_ALIGN_SINK,
@@ -908,9 +906,11 @@ static void prp_try_fmt(struct prp_priv *priv,
 				      MIN_H_SINK, MAX_H_SINK, H_ALIGN_SINK,
 				      S_ALIGN);
 
-		imx_media_fill_default_mbus_fields(&sdformat->format, infmt,
-						   true);
+		if (sdformat->format.field == V4L2_FIELD_ANY)
+			sdformat->format.field = V4L2_FIELD_NONE;
 	}
+
+	imx_media_try_colorimetry(&sdformat->format, true);
 }
 
 static int prp_set_fmt(struct v4l2_subdev *sd,
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 3b7517348666..cc3e0086b08a 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1369,9 +1369,15 @@ static void csi_try_field(struct csi_priv *priv,
 	struct v4l2_mbus_framefmt *infmt =
 		__csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which);
 
-	/* no restrictions on sink pad field type */
-	if (sdformat->pad == CSI_SINK_PAD)
+	/*
+	 * no restrictions on sink pad field type except must
+	 * be initialized.
+	 */
+	if (sdformat->pad == CSI_SINK_PAD) {
+		if (sdformat->format.field == V4L2_FIELD_ANY)
+			sdformat->format.field = V4L2_FIELD_NONE;
 		return;
+	}
 
 	switch (infmt->field) {
 	case V4L2_FIELD_SEQ_TB:
@@ -1449,8 +1455,6 @@ static void csi_try_fmt(struct csi_priv *priv,
 		/* propagate colorimetry from sink */
 		sdformat->format.colorspace = infmt->colorspace;
 		sdformat->format.xfer_func = infmt->xfer_func;
-		sdformat->format.quantization = infmt->quantization;
-		sdformat->format.ycbcr_enc = infmt->ycbcr_enc;
 
 		break;
 	case CSI_SINK_PAD:
@@ -1470,10 +1474,6 @@ static void csi_try_fmt(struct csi_priv *priv,
 
 		csi_try_field(priv, cfg, sdformat);
 
-		imx_media_fill_default_mbus_fields(
-			&sdformat->format, infmt,
-			priv->active_output_pad == CSI_SRC_PAD_DIRECT);
-
 		/* Reset crop and compose rectangles */
 		crop->left = 0;
 		crop->top = 0;
@@ -1489,6 +1489,9 @@ static void csi_try_fmt(struct csi_priv *priv,
 
 		break;
 	}
+
+	imx_media_try_colorimetry(&sdformat->format,
+			priv->active_output_pad == CSI_SRC_PAD_DIRECT);
 }
 
 static int csi_set_fmt(struct v4l2_subdev *sd,
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 1c63a2765a81..aa7d4be77a7e 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -515,21 +515,19 @@ int imx_media_init_cfg(struct v4l2_subdev *sd,
 EXPORT_SYMBOL_GPL(imx_media_init_cfg);
 
 /*
- * Check whether the field and colorimetry parameters in tryfmt are
- * uninitialized, and if so fill them with the values from fmt,
- * or if tryfmt->colorspace has been initialized, all the default
- * colorimetry params can be derived from tryfmt->colorspace.
+ * Default the colorspace in tryfmt to SRGB if set to an unsupported
+ * colorspace or not initialized. Then set the remaining colorimetry
+ * parameters based on the colorspace if they are uninitialized.
  *
  * tryfmt->code must be set on entry.
  *
  * If this format is destined to be routed through the Image Converter,
- * quantization and Y`CbCr encoding must be fixed. The IC expects and
- * produces fixed quantization and Y`CbCr encoding at its input and output
- * (full range for RGB, limited range for YUV, and V4L2_YCBCR_ENC_601).
+ * quantization and Y`CbCr encoding must be fixed. The IC supports only
+ * full-range quantization for RGB at its input and output, and only
+ * BT.601 Y`CbCr encoding.
  */
-void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
-					struct v4l2_mbus_framefmt *fmt,
-					bool ic_route)
+void imx_media_try_colorimetry(struct v4l2_mbus_framefmt *tryfmt,
+			       bool ic_route)
 {
 	const struct imx_media_pixfmt *cc;
 	bool is_rgb = false;
@@ -537,28 +535,41 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 	cc = imx_media_find_mbus_format(tryfmt->code, CS_SEL_ANY, true);
 	if (!cc)
 		cc = imx_media_find_ipu_format(tryfmt->code, CS_SEL_ANY);
-	if (cc && cc->cs != IPUV3_COLORSPACE_YUV)
+	if (cc && cc->cs == IPUV3_COLORSPACE_RGB)
 		is_rgb = true;
 
-	/* fill field if necessary */
-	if (tryfmt->field == V4L2_FIELD_ANY)
-		tryfmt->field = fmt->field;
+	switch (tryfmt->colorspace) {
+	case V4L2_COLORSPACE_SMPTE170M:
+	case V4L2_COLORSPACE_REC709:
+	case V4L2_COLORSPACE_JPEG:
+	case V4L2_COLORSPACE_SRGB:
+	case V4L2_COLORSPACE_BT2020:
+	case V4L2_COLORSPACE_OPRGB:
+	case V4L2_COLORSPACE_DCI_P3:
+	case V4L2_COLORSPACE_RAW:
+		break;
+	default:
+		tryfmt->colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	}
+
+	if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT) {
+		tryfmt->xfer_func =
+			V4L2_MAP_XFER_FUNC_DEFAULT(tryfmt->colorspace);
+	}
+
+	if (ic_route) {
+		if (is_rgb ||
+		    tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT)
+			tryfmt->quantization = V4L2_QUANTIZATION_FULL_RANGE;
 
-	/* fill colorimetry if necessary */
-	if (tryfmt->colorspace == V4L2_COLORSPACE_DEFAULT) {
-		tryfmt->colorspace = fmt->colorspace;
-		tryfmt->xfer_func = fmt->xfer_func;
-		tryfmt->ycbcr_enc = fmt->ycbcr_enc;
-		tryfmt->quantization = fmt->quantization;
+		tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
 	} else {
-		if (tryfmt->xfer_func == V4L2_XFER_FUNC_DEFAULT) {
-			tryfmt->xfer_func =
-				V4L2_MAP_XFER_FUNC_DEFAULT(tryfmt->colorspace);
-		}
 		if (tryfmt->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
 			tryfmt->ycbcr_enc =
 				V4L2_MAP_YCBCR_ENC_DEFAULT(tryfmt->colorspace);
 		}
+
 		if (tryfmt->quantization == V4L2_QUANTIZATION_DEFAULT) {
 			tryfmt->quantization =
 				V4L2_MAP_QUANTIZATION_DEFAULT(
@@ -566,15 +577,8 @@ void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
 					tryfmt->ycbcr_enc);
 		}
 	}
-
-	if (ic_route) {
-		tryfmt->quantization = is_rgb ?
-			V4L2_QUANTIZATION_FULL_RANGE :
-			V4L2_QUANTIZATION_LIM_RANGE;
-		tryfmt->ycbcr_enc = V4L2_YCBCR_ENC_601;
-	}
 }
-EXPORT_SYMBOL_GPL(imx_media_fill_default_mbus_fields);
+EXPORT_SYMBOL_GPL(imx_media_try_colorimetry);
 
 int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 				  struct v4l2_rect *compose,
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 2808662e2597..a285619afa0f 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -615,14 +615,13 @@ static void vdic_try_fmt(struct vdic_priv *priv,
 				      &sdformat->format.height,
 				      MIN_H, MAX_H_VDIC, H_ALIGN, S_ALIGN);
 
-		imx_media_fill_default_mbus_fields(&sdformat->format, infmt,
-						   true);
-
 		/* input must be interlaced! Choose SEQ_TB if not */
 		if (!V4L2_FIELD_HAS_BOTH(sdformat->format.field))
 			sdformat->format.field = V4L2_FIELD_SEQ_TB;
 		break;
 	}
+
+	imx_media_try_colorimetry(&sdformat->format, true);
 }
 
 static int vdic_set_fmt(struct v4l2_subdev *sd,
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index ae964c8d5be1..48c8996d394c 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -176,9 +176,8 @@ int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
 			    const struct imx_media_pixfmt **cc);
 int imx_media_init_cfg(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_pad_config *cfg);
-void imx_media_fill_default_mbus_fields(struct v4l2_mbus_framefmt *tryfmt,
-					struct v4l2_mbus_framefmt *fmt,
-					bool ic_route);
+void imx_media_try_colorimetry(struct v4l2_mbus_framefmt *tryfmt,
+			       bool ic_route);
 int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
 				  struct v4l2_rect *compose,
 				  const struct v4l2_mbus_framefmt *mbus,
diff --git a/drivers/staging/media/imx/imx7-media-csi.c b/drivers/staging/media/imx/imx7-media-csi.c
index 3fba7c27c0ec..6e626c10a5f1 100644
--- a/drivers/staging/media/imx/imx7-media-csi.c
+++ b/drivers/staging/media/imx/imx7-media-csi.c
@@ -1003,8 +1003,6 @@ static int imx7_csi_try_fmt(struct imx7_csi *csi,
 
 		sdformat->format.colorspace = in_fmt->colorspace;
 		sdformat->format.xfer_func = in_fmt->xfer_func;
-		sdformat->format.quantization = in_fmt->quantization;
-		sdformat->format.ycbcr_enc = in_fmt->ycbcr_enc;
 		break;
 	case IMX7_CSI_PAD_SINK:
 		*cc = imx_media_find_mbus_format(sdformat->format.code,
@@ -1015,14 +1013,14 @@ static int imx7_csi_try_fmt(struct imx7_csi *csi,
 							 false);
 			sdformat->format.code = (*cc)->codes[0];
 		}
-
-		imx_media_fill_default_mbus_fields(&sdformat->format, in_fmt,
-						   false);
 		break;
 	default:
 		return -EINVAL;
 		break;
 	}
+
+	imx_media_try_colorimetry(&sdformat->format, false);
+
 	return 0;
 }
 
-- 
2.17.1


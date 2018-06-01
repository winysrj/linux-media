Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36686 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750985AbeFAAbL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 20:31:11 -0400
Received: by mail-pf0-f193.google.com with SMTP id w129-v6so11605915pfd.3
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 17:31:11 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 06/10] media: imx: Fix field setting logic in try_fmt
Date: Thu, 31 May 2018 17:30:45 -0700
Message-Id: <1527813049-3231-7-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic for setting field type in try_fmt at CSI and PRPENCVF
entities wasn't quite right. The behavior should be:

- No restrictions on field type at sink pads (except ANY, which is filled
  with current sink pad field by imx_media_fill_default_mbus_fields()).

- At IDMAC output pads, if the caller asks for an interlaced output, and
  the input is sequential fields, the IDMAC output channel can accommodate
  by interweaving. The CSI can also interweave if input is alternate
  fields.

- If final source pad field type is alternate, translate to seq_bt or
  seq_tb. But the field order translation was backwards, SD NTSC is BT
  order, SD PAL is TB.

Move this logic to new functions csi_try_field() and prp_try_field().

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 22 +++++++++++--
 drivers/staging/media/imx/imx-media-csi.c   | 50 +++++++++++++++++++++--------
 2 files changed, 56 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 7e1e0c3..1002eb1 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -833,6 +833,21 @@ static int prp_get_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static void prp_try_field(struct prp_priv *priv,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *sdformat)
+{
+	struct v4l2_mbus_framefmt *infmt =
+		__prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
+
+	/* no restrictions on sink pad field type */
+	if (sdformat->pad == PRPENCVF_SINK_PAD)
+		return;
+
+	if (!idmac_interweave(sdformat->format.field, infmt->field))
+		sdformat->format.field = infmt->field;
+}
+
 static void prp_try_fmt(struct prp_priv *priv,
 			struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_format *sdformat,
@@ -852,12 +867,11 @@ static void prp_try_fmt(struct prp_priv *priv,
 	infmt = __prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
 
 	if (sdformat->pad == PRPENCVF_SRC_PAD) {
-		if (!V4L2_FIELD_IS_INTERLACED(sdformat->format.field))
-			sdformat->format.field = infmt->field;
-
 		prp_bound_align_output(&sdformat->format, infmt,
 				       priv->rot_mode);
 
+		prp_try_field(priv, cfg, sdformat);
+
 		/* propagate colorimetry from sink */
 		sdformat->format.colorspace = infmt->colorspace;
 		sdformat->format.xfer_func = infmt->xfer_func;
@@ -870,6 +884,8 @@ static void prp_try_fmt(struct prp_priv *priv,
 				      MIN_H_SINK, MAX_H_SINK, H_ALIGN_SINK,
 				      S_ALIGN);
 
+		prp_try_field(priv, cfg, sdformat);
+
 		imx_media_fill_default_mbus_fields(&sdformat->format, infmt,
 						   true);
 	}
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6a2a47c..6101e2ed 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1272,6 +1272,38 @@ static int csi_get_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static void csi_try_field(struct csi_priv *priv,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *sdformat)
+{
+	struct v4l2_mbus_framefmt *infmt =
+		__csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which);
+
+	switch (sdformat->pad) {
+	case CSI_SRC_PAD_DIRECT:
+		sdformat->format.field = infmt->field;
+		break;
+	case CSI_SRC_PAD_IDMAC:
+		if (!idmac_interweave(sdformat->format.field, infmt->field))
+			sdformat->format.field = infmt->field;
+		break;
+	case CSI_SINK_PAD:
+		/* no restrictions on sink pad field type */
+		return;
+	}
+
+	/*
+	 * This driver does not support alternate field mode, and the
+	 * CSI captures a whole frame, so translate ALTERNATE at either
+	 * source pad to SEQ_TB or SEQ_BT depending on input height
+	 * (assume NTSC bt order if 480 lines, otherwise PAL tb order).
+	 */
+	if (sdformat->format.field == V4L2_FIELD_ALTERNATE) {
+		sdformat->format.field = (infmt->height == 480) ?
+			V4L2_FIELD_SEQ_BT : V4L2_FIELD_SEQ_TB;
+	}
+}
+
 static void csi_try_fmt(struct csi_priv *priv,
 			struct v4l2_fwnode_endpoint *upstream_ep,
 			struct v4l2_subdev_pad_config *cfg,
@@ -1311,25 +1343,14 @@ static void csi_try_fmt(struct csi_priv *priv,
 			}
 		}
 
-		if (sdformat->pad == CSI_SRC_PAD_DIRECT ||
-		    !V4L2_FIELD_IS_INTERLACED(sdformat->format.field))
-			sdformat->format.field = infmt->field;
-
-		/*
-		 * translate V4L2_FIELD_ALTERNATE to SEQ_TB or SEQ_BT
-		 * depending on input height (assume NTSC top-bottom
-		 * order if 480 lines, otherwise PAL bottom-top order).
-		 */
-		if (sdformat->format.field == V4L2_FIELD_ALTERNATE) {
-			sdformat->format.field =  (infmt->height == 480) ?
-				V4L2_FIELD_SEQ_TB : V4L2_FIELD_SEQ_BT;
-		}
+		csi_try_field(priv, cfg, sdformat);
 
 		/* propagate colorimetry from sink */
 		sdformat->format.colorspace = infmt->colorspace;
 		sdformat->format.xfer_func = infmt->xfer_func;
 		sdformat->format.quantization = infmt->quantization;
 		sdformat->format.ycbcr_enc = infmt->ycbcr_enc;
+
 		break;
 	case CSI_SINK_PAD:
 		v4l_bound_align_image(&sdformat->format.width, MIN_W, MAX_W,
@@ -1357,9 +1378,12 @@ static void csi_try_fmt(struct csi_priv *priv,
 			sdformat->format.code = (*cc)->codes[0];
 		}
 
+		csi_try_field(priv, cfg, sdformat);
+
 		imx_media_fill_default_mbus_fields(
 			&sdformat->format, infmt,
 			priv->active_output_pad == CSI_SRC_PAD_DIRECT);
+
 		break;
 	}
 }
-- 
2.7.4

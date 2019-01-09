Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A71CC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E8F20883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 00:16:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p75WepIH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfAIAQJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 19:16:09 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41104 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729375AbfAIAQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 19:16:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id b7so2721851pfi.8;
        Tue, 08 Jan 2019 16:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4LfVC7K9jhQHp0MEPczGn12glxH+9AGZnYjQefJqoZo=;
        b=p75WepIHXQavcdpCJJCTxgn2sXQPffAyRTJOmz78K01wOkMQvjcfJ7T1tMd9xDJXB8
         nAlBPztaLwk30Ur6RuCmr/O0JtSUP6t2+OXouPOPi9XLjYoZg0VRSZ6mtkbCUbWyAGW7
         XfeLa+Omr1slvpul6R42AF6ut4cOT9CmMmBL4ybnhhr1sQ4P7EpdkEqvGc4SN7fO+9qA
         OEnJJaxEGyEposTmlxPAalBrccd6vZHDBW3u5CgLjB2VNKRvRDgoG0v+KHgaxH2ZGX5Y
         aT2g59ZRBMABXK00gL8Qwwh6Yvin1gZgTuHuiufvfzqesoVoFyH4Jyy9xz+KTxVas0J4
         7NJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4LfVC7K9jhQHp0MEPczGn12glxH+9AGZnYjQefJqoZo=;
        b=R6U3XLeaEXHAyFcFp2l/EwyovPJFQMEBRqYDEfHbxvKWZWED3Zs91FRkKfGcWRfqC1
         v0QRA+P8EUTT5O1iHtMNgsUTse4gja+fZgs2JyAF/OIjwN3VHtblVe+RHGIirAsrKEIl
         3I3K1IeU5OZBhOhUScYWBqRm+XeVkjIoc3iRjX+2zKCHpx0WBSecScpU+YEdFGk5AI5j
         kx3Chhkz1OcXjXiQQLLUnFXdeQOeH6nJB+Aoagnp0pMCqgso2s/XDVPFQQAnjiGyLkNT
         3bwxVX6lO0/m91z9qw4f0SM+FUDmekH2WG+Px33fAsILOMKWqbCjwFobsR8wCHBMl6Vp
         s0hg==
X-Gm-Message-State: AJcUukd6BMB9fG6vFT8jeQ1Caob6vTJuQAhVCjuEc6xTFGUIijzdf54g
        XxlOnYx0Fd5onLi2XkG8ke7dAnu2
X-Google-Smtp-Source: ALg8bN45nfUzowkegMz4SroTrHd77YHuoMLFfCYygt6S16YDf2P2EFjTSVgtmqFszH4phuXNOah3PQ==
X-Received: by 2002:a62:178f:: with SMTP id 137mr3775151pfx.226.1546992965662;
        Tue, 08 Jan 2019 16:16:05 -0800 (PST)
Received: from majic.sklembedded.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.googlemail.com with ESMTPSA id 134sm83978490pgb.78.2019.01.08.16.16.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 16:16:05 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 04/12] media: imx: Fix field negotiation
Date:   Tue,  8 Jan 2019 16:15:43 -0800
Message-Id: <20190109001551.16113-5-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190109001551.16113-1-slongerbeam@gmail.com>
References: <20190109001551.16113-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

IDMAC interlaced scan, a.k.a. interweave, should be enabled in the
IDMAC output channels only if the IDMAC output pad field type is
'seq-bt' or 'seq-tb', and field type at the capture interface is
'interlaced*'.

V4L2_FIELD_HAS_BOTH() macro should not be used on the input to determine
enabling interlaced/interweave scan. That macro includes the 'interlaced'
field types, and in those cases the data is already interweaved with
top/bottom field lines.

The CSI will capture whole frames when the source specifies alternate
field mode. So the CSI also enables interweave for alternate input
field type and the field type at capture interface is interlaced.

Fix the logic for setting field type in try_fmt in CSI entity.
The behavior should be:

- No restrictions on field type at sink pad.

- At the output pads, allow sequential fields in TB order, if the sink pad
  field type is sequential or alternate. Otherwise passthrough the field
  type from sink to source pad.

Move this logic to new function csi_try_field().

These changes result in the following allowed field transformations
from CSI sink -> source pads (all other field types at sink are passed
through to source):

seq-tb -> seq-tb
seq-bt -> seq-tb
alternate -> seq-tb

In a future patch, the CSI sink -> source will allow:

seq-tb -> seq-bt
seq-bt -> seq-bt
alternate -> seq-bt

This will require supporting interweave with top/bottom line swapping.
Until then seq-bt is not allowed at the CSI source pad because there is
no way to swap top/bottom lines when interweaving to INTERLACED_BT --
note that despite the name, INTERLACED_BT is top-bottom order in memory.
The BT in this case refers to field dominance: the bottom lines are
older in time than the top lines.

The capture interface device allows selecting IDMAC interweave by
choosing INTERLACED_TB if the CSI/PRPENCVF source pad is seq-tb and
INTERLACED_BT if the source pad is seq-bt (for future support of seq-bt).

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c   | 21 ++++--
 drivers/staging/media/imx/imx-media-capture.c | 14 ++++
 drivers/staging/media/imx/imx-media-csi.c     | 64 ++++++++++++++-----
 3 files changed, 76 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index af7224846bd5..1a03d4c9d7b8 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -354,12 +354,13 @@ static int prp_setup_channel(struct prp_priv *priv,
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
 	const struct imx_media_pixfmt *outcc;
-	struct v4l2_mbus_framefmt *infmt;
+	struct v4l2_mbus_framefmt *outfmt;
 	unsigned int burst_size;
 	struct ipu_image image;
+	bool interweave;
 	int ret;
 
-	infmt = &priv->format_mbus[PRPENCVF_SINK_PAD];
+	outfmt = &priv->format_mbus[PRPENCVF_SRC_PAD];
 	outcc = vdev->cc;
 
 	ipu_cpmem_zero(channel);
@@ -369,6 +370,15 @@ static int prp_setup_channel(struct prp_priv *priv,
 	image.rect.width = image.pix.width;
 	image.rect.height = image.pix.height;
 
+	/*
+	 * If the field type at capture interface is interlaced, and
+	 * the output IDMAC pad is sequential, enable interweave at
+	 * the IDMAC output channel.
+	 */
+	interweave = V4L2_FIELD_IS_INTERLACED(image.pix.field) &&
+		V4L2_FIELD_IS_SEQUENTIAL(outfmt->field) &&
+		channel == priv->out_ch;
+
 	if (rot_swap_width_height) {
 		swap(image.pix.width, image.pix.height);
 		swap(image.rect.width, image.rect.height);
@@ -409,9 +419,7 @@ static int prp_setup_channel(struct prp_priv *priv,
 	if (rot_mode)
 		ipu_cpmem_set_rotation(channel, rot_mode);
 
-	if (image.pix.field == V4L2_FIELD_NONE &&
-	    V4L2_FIELD_HAS_BOTH(infmt->field) &&
-	    channel == priv->out_ch)
+	if (interweave)
 		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline,
 					  image.pix.pixelformat);
 
@@ -839,8 +847,7 @@ static void prp_try_fmt(struct prp_priv *priv,
 	infmt = __prp_get_fmt(priv, cfg, PRPENCVF_SINK_PAD, sdformat->which);
 
 	if (sdformat->pad == PRPENCVF_SRC_PAD) {
-		if (sdformat->format.field != V4L2_FIELD_NONE)
-			sdformat->format.field = infmt->field;
+		sdformat->format.field = infmt->field;
 
 		prp_bound_align_output(&sdformat->format, infmt,
 				       priv->rot_mode);
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index b37e1186eb2f..01ec9443de55 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -239,6 +239,20 @@ static int capture_try_fmt_vid_cap(struct file *file, void *fh,
 		cc = cc_src;
 	}
 
+	/* allow IDMAC interweave but enforce field order from source */
+	if (V4L2_FIELD_IS_INTERLACED(f->fmt.pix.field)) {
+		switch (fmt_src.format.field) {
+		case V4L2_FIELD_SEQ_TB:
+			fmt_src.format.field = V4L2_FIELD_INTERLACED_TB;
+			break;
+		case V4L2_FIELD_SEQ_BT:
+			fmt_src.format.field = V4L2_FIELD_INTERLACED_BT;
+			break;
+		default:
+			break;
+		}
+	}
+
 	imx_media_mbus_fmt_to_pix_fmt(&f->fmt.pix, &fmt_src.format, cc);
 
 	return 0;
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index da4808348845..e3a4f39dbf73 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -398,16 +398,18 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	struct imx_media_video_dev *vdev = priv->vdev;
 	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_framefmt *infmt;
+	struct v4l2_mbus_framefmt *outfmt;
+	bool passthrough, interweave;
 	struct ipu_image image;
 	u32 passthrough_bits;
 	u32 passthrough_cycles;
 	dma_addr_t phys[2];
-	bool passthrough;
 	u32 burst_size;
 	int ret;
 
 	infmt = &priv->format_mbus[CSI_SINK_PAD];
 	incc = priv->cc[CSI_SINK_PAD];
+	outfmt = &priv->format_mbus[CSI_SRC_PAD_IDMAC];
 
 	ipu_cpmem_zero(priv->idmac_ch);
 
@@ -424,6 +426,14 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	passthrough = requires_passthrough(&priv->upstream_ep, infmt, incc);
 	passthrough_cycles = 1;
 
+	/*
+	 * If the field type at capture interface is interlaced, and
+	 * the output IDMAC pad is sequential, enable interweave at
+	 * the IDMAC output channel.
+	 */
+	interweave = V4L2_FIELD_IS_INTERLACED(image.pix.field) &&
+		V4L2_FIELD_IS_SEQUENTIAL(outfmt->field);
+
 	switch (image.pix.pixelformat) {
 	case V4L2_PIX_FMT_SBGGR8:
 	case V4L2_PIX_FMT_SGBRG8:
@@ -509,8 +519,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 
 	ipu_smfc_set_burstsize(priv->smfc, burst_size);
 
-	if (image.pix.field == V4L2_FIELD_NONE &&
-	    V4L2_FIELD_HAS_BOTH(infmt->field))
+	if (interweave)
 		ipu_cpmem_interlaced_scan(priv->idmac_ch,
 					  image.pix.bytesperline,
 					  image.pix.pixelformat);
@@ -1304,6 +1313,38 @@ static int csi_get_fmt(struct v4l2_subdev *sd,
 	return ret;
 }
 
+static void csi_try_field(struct csi_priv *priv,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *sdformat)
+{
+	struct v4l2_mbus_framefmt *infmt =
+		__csi_get_fmt(priv, cfg, CSI_SINK_PAD, sdformat->which);
+
+	/* no restrictions on sink pad field type */
+	if (sdformat->pad == CSI_SINK_PAD)
+		return;
+
+	switch (infmt->field) {
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
+	case V4L2_FIELD_ALTERNATE:
+		/*
+		 * If the sink is sequential or alternating fields,
+		 * allow only SEQ_TB at the source.
+		 *
+		 * This driver does not support alternate field mode, and
+		 * the CSI captures a whole frame, so the CSI never presents
+		 * alternate mode at its source pads.
+		 */
+		sdformat->format.field = V4L2_FIELD_SEQ_TB;
+		break;
+	default:
+		/* Passthrough for all other input field types */
+		sdformat->format.field = infmt->field;
+		break;
+	}
+}
+
 static void csi_try_fmt(struct csi_priv *priv,
 			struct v4l2_fwnode_endpoint *upstream_ep,
 			struct v4l2_subdev_pad_config *cfg,
@@ -1343,25 +1384,14 @@ static void csi_try_fmt(struct csi_priv *priv,
 			}
 		}
 
-		if (sdformat->pad == CSI_SRC_PAD_DIRECT ||
-		    sdformat->format.field != V4L2_FIELD_NONE)
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
@@ -1389,6 +1419,8 @@ static void csi_try_fmt(struct csi_priv *priv,
 			sdformat->format.code = (*cc)->codes[0];
 		}
 
+		csi_try_field(priv, cfg, sdformat);
+
 		imx_media_fill_default_mbus_fields(
 			&sdformat->format, infmt,
 			priv->active_output_pad == CSI_SRC_PAD_DIRECT);
-- 
2.17.1


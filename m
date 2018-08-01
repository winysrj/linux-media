Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33051 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387714AbeHAVAN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 17:00:13 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 13/14] media: imx: Allow interweave with top/bottom lines swapped
Date: Wed,  1 Aug 2018 12:12:26 -0700
Message-Id: <1533150747-30677-14-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow sequential->interlaced interweaving but with top/bottom
lines swapped to the output buffer.

This can be accomplished by adding one line length to IDMAC output
channel address, with a negative line length for the interlace offset.

This is to allow the seq-bt -> interlaced-bt transformation, where
bottom lines are still dominant (older in time) but with top lines
first in the interweaved output buffer.

With this support, the CSI can now allow seq-bt at its source pads,
e.g. the following transformations are allowed in CSI from sink to
source:

seq-tb -> seq-bt
seq-bt -> seq-bt
alternate -> seq-bt

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c | 17 ++++++++++-
 drivers/staging/media/imx/imx-media-csi.c   | 46 +++++++++++++++++++++++------
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index cf76b04..1499b0c 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -106,6 +106,8 @@ struct prp_priv {
 	u32 frame_sequence; /* frame sequence counter */
 	bool last_eof;  /* waiting for last EOF at stream off */
 	bool nfb4eof;    /* NFB4EOF encountered during streaming */
+	u32 interweave_offset; /* interweave line offset to swap
+				  top/bottom lines */
 	struct completion last_eof_comp;
 };
 
@@ -235,6 +237,9 @@ static void prp_vb2_buf_done(struct prp_priv *priv, struct ipuv3_channel *ch)
 	if (ipu_idmac_buffer_is_ready(ch, priv->ipu_buf_num))
 		ipu_idmac_clear_buffer(ch, priv->ipu_buf_num);
 
+	if (ch == priv->out_ch)
+		phys += priv->interweave_offset;
+
 	ipu_cpmem_set_buffer(ch, priv->ipu_buf_num, phys);
 }
 
@@ -388,6 +393,13 @@ static int prp_setup_channel(struct prp_priv *priv,
 			(image.pix.width * outcc->bpp) >> 3;
 	}
 
+	priv->interweave_offset = 0;
+
+	if (interweave && image.pix.field == V4L2_FIELD_INTERLACED_BT) {
+		image.rect.top = 1;
+		priv->interweave_offset = image.pix.bytesperline;
+	}
+
 	image.phys0 = addr0;
 	image.phys1 = addr1;
 
@@ -425,7 +437,10 @@ static int prp_setup_channel(struct prp_priv *priv,
 		ipu_cpmem_set_rotation(channel, rot_mode);
 
 	if (interweave)
-		ipu_cpmem_interlaced_scan(channel, image.pix.bytesperline,
+		ipu_cpmem_interlaced_scan(channel,
+					  priv->interweave_offset ?
+					  -image.pix.bytesperline :
+					  image.pix.bytesperline,
 					  image.pix.pixelformat);
 
 	ret = ipu_ic_task_idma_init(priv->ic, channel,
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 6f24b3b..a5f88ae 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -114,6 +114,8 @@ struct csi_priv {
 	u32 frame_sequence; /* frame sequence counter */
 	bool last_eof;   /* waiting for last EOF at stream off */
 	bool nfb4eof;    /* NFB4EOF encountered during streaming */
+	u32 interweave_offset; /* interweave line offset to swap
+				  top/bottom lines */
 	struct completion last_eof_comp;
 };
 
@@ -283,7 +285,8 @@ static void csi_vb2_buf_done(struct csi_priv *priv)
 	if (ipu_idmac_buffer_is_ready(priv->idmac_ch, priv->ipu_buf_num))
 		ipu_idmac_clear_buffer(priv->idmac_ch, priv->ipu_buf_num);
 
-	ipu_cpmem_set_buffer(priv->idmac_ch, priv->ipu_buf_num, phys);
+	ipu_cpmem_set_buffer(priv->idmac_ch, priv->ipu_buf_num,
+			     phys + priv->interweave_offset);
 }
 
 static irqreturn_t csi_idmac_eof_interrupt(int irq, void *dev_id)
@@ -393,10 +396,10 @@ static void csi_idmac_unsetup_vb2_buf(struct csi_priv *priv,
 static int csi_idmac_setup_channel(struct csi_priv *priv)
 {
 	struct imx_media_video_dev *vdev = priv->vdev;
+	bool passthrough, interweave, interweave_swap;
 	const struct imx_media_pixfmt *incc;
 	struct v4l2_mbus_framefmt *infmt;
 	struct v4l2_mbus_framefmt *outfmt;
-	bool passthrough, interweave;
 	struct ipu_image image;
 	u32 passthrough_bits;
 	u32 passthrough_cycles;
@@ -430,6 +433,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	 */
 	interweave = V4L2_FIELD_IS_INTERLACED(image.pix.field) &&
 		V4L2_FIELD_IS_SEQUENTIAL(outfmt->field);
+	interweave_swap = interweave &&
+		image.pix.field == V4L2_FIELD_INTERLACED_BT;
 
 	switch (image.pix.pixelformat) {
 	case V4L2_PIX_FMT_SBGGR8:
@@ -483,15 +488,25 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 	}
 
 	if (passthrough) {
+		priv->interweave_offset = interweave_swap ?
+			image.pix.bytesperline : 0;
 		ipu_cpmem_set_resolution(priv->idmac_ch,
 					 image.rect.width * passthrough_cycles,
 					 image.rect.height);
 		ipu_cpmem_set_stride(priv->idmac_ch, image.pix.bytesperline);
-		ipu_cpmem_set_buffer(priv->idmac_ch, 0, image.phys0);
-		ipu_cpmem_set_buffer(priv->idmac_ch, 1, image.phys1);
+		ipu_cpmem_set_buffer(priv->idmac_ch, 0,
+				     image.phys0 + priv->interweave_offset);
+		ipu_cpmem_set_buffer(priv->idmac_ch, 1,
+				     image.phys1 + priv->interweave_offset);
 		ipu_cpmem_set_format_passthrough(priv->idmac_ch,
 						 passthrough_bits);
 	} else {
+		priv->interweave_offset = 0;
+		if (interweave_swap) {
+			image.rect.top = 1;
+			priv->interweave_offset = image.pix.bytesperline;
+		}
+
 		ret = ipu_cpmem_set_image(priv->idmac_ch, &image);
 		if (ret)
 			goto unsetup_vb2;
@@ -523,6 +538,8 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 
 	if (interweave)
 		ipu_cpmem_interlaced_scan(priv->idmac_ch,
+					  priv->interweave_offset ?
+					  -image.pix.bytesperline :
 					  image.pix.bytesperline,
 					  image.pix.pixelformat);
 
@@ -1331,16 +1348,27 @@ static void csi_try_field(struct csi_priv *priv,
 	switch (infmt->field) {
 	case V4L2_FIELD_SEQ_TB:
 	case V4L2_FIELD_SEQ_BT:
+		/*
+		 * If the user requests sequential at the source pad,
+		 * allow it (along with possibly inverting field order).
+		 * Otherwise passthrough the field type.
+		 */
+		if (!V4L2_FIELD_IS_SEQUENTIAL(sdformat->format.field))
+			sdformat->format.field = infmt->field;
+		break;
 	case V4L2_FIELD_ALTERNATE:
 		/*
-		 * If the sink is sequential or alternating fields,
-		 * allow only SEQ_TB at the source.
-		 *
 		 * This driver does not support alternate field mode, and
 		 * the CSI captures a whole frame, so the CSI never presents
-		 * alternate mode at its source pads.
+		 * alternate mode at its source pads. If user has not
+		 * already requested sequential, translate ALTERNATE at
+		 * sink pad to SEQ_TB or SEQ_BT at the source pad depending
+		 * on input height (assume NTSC BT order if 480 total active
+		 * frame lines, otherwise PAL TB order).
 		 */
-		sdformat->format.field = V4L2_FIELD_SEQ_TB;
+		if (!V4L2_FIELD_IS_SEQUENTIAL(sdformat->format.field))
+			sdformat->format.field = (infmt->height == 480 / 2) ?
+				V4L2_FIELD_SEQ_BT : V4L2_FIELD_SEQ_TB;
 		break;
 	default:
 		/* Passthrough for all other input field types */
-- 
2.7.4

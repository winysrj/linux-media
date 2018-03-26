Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:40818 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752364AbeCZVqk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:40 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 12/33] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Mon, 26 Mar 2018 23:44:35 +0200
Message-Id: <20180326214456.6655-13-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was never proper support in the VIN driver to deliver ALTERNATING
field format to user-space, remove this field option. The problem is
that ALTERNATING field order requires the sequence numbers of buffers
returned to userspace to reflect if fields were dropped or not,
something which is not possible with the VIN drivers capture logic.

The VIN driver can still capture from a video source which delivers
frames in ALTERNATING field order, but needs to combine them using the
VIN hardware into INTERLACED field order. Before this change if a source
was delivering fields using ALTERNATE the driver would default to
combining them using this hardware feature. Only if the user explicitly
requested ALTERNATE field order would incorrect frames be delivered.

The height should not be cut in half for the format for TOP or BOTTOM
fields settings. This was a mistake and it was made visible by the
scaling refactoring. Correct behavior is that the user should request a
frame size that fits the half height frame reflected in the field
setting. If not the VIN will do its best to scale the top or bottom to
the requested format and cropping and scaling do not work as expected.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

---

* Changes since v12
- Spelling where -> were.
- Add review tag from Hans.
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +----------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 40 +++++++----------------------
 2 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 4f48575f2008fe34..9233924e5b52de5f 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -617,7 +617,6 @@ static int rvin_setup(struct rvin_dev *vin)
 	case V4L2_FIELD_INTERLACED_BT:
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
 		break;
-	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_NONE:
 		vnmc = VNMC_IM_ODD_EVEN;
 		progressive = true;
@@ -745,18 +744,6 @@ static bool rvin_capture_active(struct rvin_dev *vin)
 	return rvin_read(vin, VNMS_REG) & VNMS_CA;
 }
 
-static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32 vnms)
-{
-	if (vin->format.field == V4L2_FIELD_ALTERNATE) {
-		/* If FS is set it's a Even field */
-		if (vnms & VNMS_FS)
-			return V4L2_FIELD_BOTTOM;
-		return V4L2_FIELD_TOP;
-	}
-
-	return vin->format.field;
-}
-
 static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
 {
 	const struct rvin_video_format *fmt;
@@ -892,7 +879,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
 
 	/* Capture frame */
 	if (vin->queue_buf[slot]) {
-		vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
+		vin->queue_buf[slot]->field = vin->format.field;
 		vin->queue_buf[slot]->sequence = vin->sequence;
 		vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
 		vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf,
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 16e895657c3f51c5..e956a385cc13f5f3 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -121,33 +121,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
 	vin->format.colorspace	= mf->colorspace;
 	vin->format.field	= mf->field;
 
-	/*
-	 * If the subdevice uses ALTERNATE field mode and G_STD is
-	 * implemented use the VIN HW to combine the two fields to
-	 * one INTERLACED frame. The ALTERNATE field mode can still
-	 * be requested in S_FMT and be respected, this is just the
-	 * default which is applied at probing or when S_STD is called.
-	 */
-	if (vin->format.field == V4L2_FIELD_ALTERNATE &&
-	    v4l2_subdev_has_op(vin_to_source(vin), video, g_std))
-		vin->format.field = V4L2_FIELD_INTERLACED;
-
-	switch (vin->format.field) {
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-	case V4L2_FIELD_ALTERNATE:
-		vin->format.height /= 2;
-		break;
-	case V4L2_FIELD_NONE:
-	case V4L2_FIELD_INTERLACED_TB:
-	case V4L2_FIELD_INTERLACED_BT:
-	case V4L2_FIELD_INTERLACED:
-		break;
-	default:
-		vin->format.field = RVIN_DEFAULT_FIELD;
-		break;
-	}
-
 	rvin_reset_crop_compose(vin);
 
 	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
@@ -235,15 +208,20 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	switch (pix->field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
-	case V4L2_FIELD_ALTERNATE:
-		pix->height /= 2;
-		source->height /= 2;
-		break;
 	case V4L2_FIELD_NONE:
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
 	case V4L2_FIELD_INTERLACED:
 		break;
+	case V4L2_FIELD_ALTERNATE:
+		/*
+		 * Driver dose not (yet) support outputting ALTERNATE to a
+		 * userspace. It does support outputting INTERLACED so use
+		 * the VIN hardware to combine the two fields.
+		 */
+		pix->field = V4L2_FIELD_INTERLACED;
+		pix->height *= 2;
+		break;
 	default:
 		pix->field = RVIN_DEFAULT_FIELD;
 		break;
-- 
2.16.2

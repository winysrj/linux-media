Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:44865 "EHLO
        bin-vsp-out-03.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751391AbeA2Qf1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 11:35:27 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v10 10/30] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Mon, 29 Jan 2018 17:34:15 +0100
Message-Id: <20180129163435.24936-11-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180129163435.24936-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was never proper support in the VIN driver to deliver ALTERNATING
field format to user-space, remove this field option. The problem is
that ALTERNATING filed order requires the sequence numbers of buffers
returned to userspace to reflect if fields where dropped or not,
something which is not possible with the VIN drivers capture logic.

The VIN driver can still capture from a video source which delivers
frames in ALTERNATING field order, but needs to combine them using the
VIN hardware into INTERLACED field order. Before this change if a source
was delivering fields using ALTERNATE the driver would default to
combining them using this hardware feature. Only if the user explicitly
requested ALTERNATE filed order would incorrect frames be delivered.

The height should not be cut in half for the format for TOP or BOTTOM
fields settings. This was a mistake and it was made visible by the
scaling refactoring. Correct behavior is that the user should request a
frame size that fits the half height frame reflected in the field
setting. If not the VIN will do its best to scale the top or bottom to
the requested format and cropping and scaling do not work as expected.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +-------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 53 +++++++++++++----------------
 2 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index fd14be20a6604d7a..c8831e189d362c8b 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -617,7 +617,6 @@ static int rvin_setup(struct rvin_dev *vin)
 	case V4L2_FIELD_INTERLACED_BT:
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
 		break;
-	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_NONE:
 		if (vin->continuous) {
 			vnmc = VNMC_IM_ODD_EVEN;
@@ -757,18 +756,6 @@ static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
 	return 0;
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
@@ -941,7 +928,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
 		goto done;
 
 	/* Capture frame */
-	vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
+	vin->queue_buf[slot]->field = vin->format.field;
 	vin->queue_buf[slot]->sequence = sequence;
 	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 4d5be2d0c79c9c9a..9f7902d29c62e205 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -103,6 +103,28 @@ static int rvin_get_source_format(struct rvin_dev *vin,
 	if (ret)
 		return ret;
 
+	switch (fmt.format.field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_INTERLACED_TB:
+	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
+		break;
+	case V4L2_FIELD_ALTERNATE:
+		/*
+		 * Driver do not (yet) support outputting ALTERNATE to a
+		 * userspace. It dose support outputting INTERLACED so use
+		 * the VIN hardware to combine the two fields.
+		 */
+		fmt.format.field = V4L2_FIELD_INTERLACED;
+		fmt.format.height *= 2;
+		break;
+	default:
+		vin->format.field = V4L2_FIELD_NONE;
+		break;
+	}
+
 	memcpy(mbus_fmt, &fmt.format, sizeof(*mbus_fmt));
 
 	return 0;
@@ -139,33 +161,6 @@ static int rvin_reset_format(struct rvin_dev *vin)
 
 	v4l2_fill_pix_format(&vin->format, &source_fmt);
 
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
-		vin->format.field = V4L2_FIELD_NONE;
-		break;
-	}
-
 	ret = rvin_reset_crop_compose(vin);
 	if (ret)
 		return ret;
@@ -243,12 +238,10 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	if (ret)
 		return ret;
 
+	/* Reject ALTERNATE  until support is added to the driver */
 	switch (pix->field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
-	case V4L2_FIELD_ALTERNATE:
-		pix->height /= 2;
-		break;
 	case V4L2_FIELD_NONE:
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
-- 
2.16.1

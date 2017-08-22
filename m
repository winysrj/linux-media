Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:56074 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752555AbdHVX2p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:45 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v6 11/25] rcar-vin: fix handling of single field frames (top, bottom and alternate fields)
Date: Wed, 23 Aug 2017 01:26:26 +0200
Message-Id: <20170822232640.26147-12-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It was never proper support in the VIN driver to deliver ALTERNATING
field format to user-space, remove this field option. For sources using
this field format instead use the VIN hardware feature of combining the
fields to an interlaced format. This mode of operation was previously
the default behavior and ALTERNATING was only delivered to user-space if
explicitly requested. Allowing this to be explicitly requested was a
mistake and was never properly tested and never worked due to the
constrains put on the field format when it comes to sequence numbers and
timestamps etc.

The height should not be cut in half for the format for TOP or BOTTOM
fields settings. This was a mistake and it was made visible by the
scaling refactoring. Correct behavior is that the user should request a
frame size that fits the half height frame reflected in the field
setting. If not the VIN will do it's best to scale the top or bottom to
the requested format and cropping and scaling do not work as expected.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 15 +--------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 48 +++++++++++------------------
 2 files changed, 19 insertions(+), 44 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 6cc880e5ef7e0718..f22bec062db31772 100644
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
index c8c764188b85a926..9f0aac9c3398d613 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -102,6 +102,24 @@ static int rvin_get_sd_format(struct rvin_dev *vin, struct v4l2_pix_format *pix)
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
+		/* Use VIN hardware to combine the two fields */
+		fmt.format.field = V4L2_FIELD_INTERLACED;
+		fmt.format.height *= 2;
+		break;
+	default:
+		vin->format.field = V4L2_FIELD_NONE;
+		break;
+	}
+
 	v4l2_fill_pix_format(pix, &fmt.format);
 
 	return 0;
@@ -115,33 +133,6 @@ int rvin_reset_format(struct rvin_dev *vin)
 	if (ret)
 		return ret;
 
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
 	vin->crop.top = vin->crop.left = 0;
 	vin->crop.width = vin->format.width;
 	vin->crop.height = vin->format.height;
@@ -226,9 +217,6 @@ static int __rvin_try_format(struct rvin_dev *vin,
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
2.14.0

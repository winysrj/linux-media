Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:53046 "EHLO
	smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965216AbcHBOvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 10:51:42 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCHv2 5/7] media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
Date: Tue,  2 Aug 2016 16:51:05 +0200
Message-Id: <20160802145107.24829-6-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HW can capture both ODD and EVEN fields in separate buffers so it's
possible to support V4L2_FIELD_ALTERNATE. This patch add support for
this mode.

At probe time and when S_STD is called the driver will default to use
V4L2_FIELD_INTERLACED if the subdevice reports V4L2_FIELD_ALTERNATE. The
driver will only change the field type if the subdevice implements
G_STD, if not it will keep the default at V4L2_FIELD_ALTERNATE.

The user can always explicitly ask for V4L2_FIELD_ALTERNATE in S_FTM and
the driver will use that field format.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 26 ++++++++++++++++++++------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 13 +++++++++++++
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 4063775..80139ad 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -95,6 +95,7 @@
 /* Video n Module Status Register bits */
 #define VNMS_FBS_MASK		(3 << 3)
 #define VNMS_FBS_SHIFT		3
+#define VNMS_FS			(1 << 2)
 #define VNMS_AV			(1 << 1)
 #define VNMS_CA			(1 << 0)
 
@@ -155,6 +156,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	case V4L2_FIELD_INTERLACED_BT:
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
 		break;
+	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_NONE:
 		if (vin->continuous) {
 			vnmc = VNMC_IM_ODD_EVEN;
@@ -330,15 +332,26 @@ static bool rvin_capture_active(struct rvin_dev *vin)
 	return rvin_read(vin, VNMS_REG) & VNMS_CA;
 }
 
-static int rvin_get_active_slot(struct rvin_dev *vin)
+static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
 {
 	if (vin->continuous)
-		return (rvin_read(vin, VNMS_REG) & VNMS_FBS_MASK)
-			>> VNMS_FBS_SHIFT;
+		return (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
 
 	return 0;
 }
 
+static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32 vnms)
+{
+	if (vin->format.field == V4L2_FIELD_ALTERNATE) {
+		/* If FS is set it's a Even field */
+		if (vnms & VNMS_FS)
+			return V4L2_FIELD_BOTTOM;
+		return V4L2_FIELD_TOP;
+	}
+
+	return vin->format.field;
+}
+
 static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
 {
 	const struct rvin_video_format *fmt;
@@ -879,7 +892,7 @@ static bool rvin_fill_hw(struct rvin_dev *vin)
 static irqreturn_t rvin_irq(int irq, void *data)
 {
 	struct rvin_dev *vin = data;
-	u32 int_status;
+	u32 int_status, vnms;
 	int slot;
 	unsigned int sequence, handled = 0;
 	unsigned long flags;
@@ -906,7 +919,8 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	}
 
 	/* Prepare for capture and update state */
-	slot = rvin_get_active_slot(vin);
+	vnms = rvin_read(vin, VNMS_REG);
+	slot = rvin_get_active_slot(vin, vnms);
 	sequence = vin->sequence++;
 
 	vin_dbg(vin, "IRQ %02d: %d\tbuf0: %c buf1: %c buf2: %c\tmore: %d\n",
@@ -921,7 +935,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
 		goto done;
 
 	/* Capture frame */
-	vin->queue_buf[slot]->field = vin->format.field;
+	vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
 	vin->queue_buf[slot]->sequence = sequence;
 	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index c31ac73..125f87e 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -122,9 +122,21 @@ static int rvin_reset_format(struct rvin_dev *vin)
 	vin->format.colorspace	= mf->colorspace;
 	vin->format.field	= mf->field;
 
+	/*
+	 * If the subdevice uses ALTERNATE field mode and G_STD is
+	 * implemented use the VIN HW to combine the two fields to
+	 * one INTERLACED frame. The ALTERNATE field mode can still
+	 * be requested in S_FMT and be respected, this is just the
+	 * default which is applied at probing or when S_STD is called.
+	 */
+	if (vin->format.field == V4L2_FIELD_ALTERNATE &&
+	    v4l2_subdev_has_op(vin_to_source(vin), video, g_std))
+		vin->format.field = V4L2_FIELD_INTERLACED;
+
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_ALTERNATE:
 		vin->format.height /= 2;
 		break;
 	case V4L2_FIELD_NONE:
@@ -226,6 +238,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	switch (pix->field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_ALTERNATE:
 		pix->height /= 2;
 		source->height /= 2;
 		break;
-- 
2.9.0


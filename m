Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:41725 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbcG2Rkh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2016 13:40:37 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, slongerbeam@gmail.com
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 4/6] media: rcar-vin: add support for V4L2_FIELD_ALTERNATE
Date: Fri, 29 Jul 2016 19:40:10 +0200
Message-Id: <20160729174012.14331-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
References: <20160729174012.14331-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HW can capture both ODD and EVEN fields in separate buffers so it's
possible to support this field mode.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c  | 26 ++++++++++++++++++++------
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 12 ++++++++++++
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index dad3b03..bcdec46 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -95,6 +95,7 @@
 /* Video n Module Status Register bits */
 #define VNMS_FBS_MASK		(3 << 3)
 #define VNMS_FBS_SHIFT		3
+#define VNMS_FS			(1 << 2)
 #define VNMS_AV			(1 << 1)
 #define VNMS_CA			(1 << 0)
 
@@ -147,6 +148,7 @@ static int rvin_setup(struct rvin_dev *vin)
 	case V4L2_FIELD_INTERLACED_BT:
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
 		break;
+	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_NONE:
 		if (vin->continuous) {
 			vnmc = VNMC_IM_ODD_EVEN;
@@ -322,15 +324,26 @@ static bool rvin_capture_active(struct rvin_dev *vin)
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
@@ -871,7 +884,7 @@ static bool rvin_fill_hw(struct rvin_dev *vin)
 static irqreturn_t rvin_irq(int irq, void *data)
 {
 	struct rvin_dev *vin = data;
-	u32 int_status;
+	u32 int_status, vnms;
 	int slot;
 	unsigned int sequence, handled = 0;
 	unsigned long flags;
@@ -898,7 +911,8 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	}
 
 	/* Prepare for capture and update state */
-	slot = rvin_get_active_slot(vin);
+	vnms = rvin_read(vin, VNMS_REG);
+	slot = rvin_get_active_slot(vin, vnms);
 	sequence = vin->sequence++;
 
 	vin_dbg(vin, "IRQ %02d: %d\tbuf0: %c buf1: %c buf2: %c\tmore: %d\n",
@@ -913,7 +927,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
 		goto done;
 
 	/* Capture frame */
-	vin->queue_buf[slot]->field = vin->format.field;
+	vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
 	vin->queue_buf[slot]->sequence = sequence;
 	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index b6e40ea..00ac2b6 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -109,6 +109,7 @@ static int rvin_reset_format(struct rvin_dev *vin)
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
 	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	v4l2_std_id std;
 	int ret;
 
 	fmt.pad = vin->src_pad_idx;
@@ -122,9 +123,19 @@ static int rvin_reset_format(struct rvin_dev *vin)
 	vin->format.colorspace	= mf->colorspace;
 	vin->format.field	= mf->field;
 
+	/* If we have a video standard use HW to deinterlace */
+	if (vin->format.field == V4L2_FIELD_ALTERNATE &&
+	    !v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
+		if (std & V4L2_STD_625_50)
+			vin->format.field = V4L2_FIELD_INTERLACED_TB;
+		else
+			vin->format.field = V4L2_FIELD_INTERLACED_BT;
+	}
+
 	switch (vin->format.field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_ALTERNATE:
 		vin->format.height /= 2;
 		break;
 	case V4L2_FIELD_NONE:
@@ -222,6 +233,7 @@ static int __rvin_try_format(struct rvin_dev *vin,
 	switch (pix->field) {
 	case V4L2_FIELD_TOP:
 	case V4L2_FIELD_BOTTOM:
+	case V4L2_FIELD_ALTERNATE:
 		pix->height /= 2;
 		source->height /= 2;
 		break;
-- 
2.9.0


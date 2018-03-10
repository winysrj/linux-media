Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:23822 "EHLO
        bin-vsp-out-02.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932857AbeCJAK6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 19:10:58 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 3/3] rcar-vin: use scratch buffer and always run in continuous mode
Date: Sat, 10 Mar 2018 01:09:53 +0100
Message-Id: <20180310000953.25366-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of switching capture mode depending on how many buffers are
available use a scratch buffer and always run in continuous mode. By
using a scratch buffer the responsiveness of the capture loop is
increased as it can keep running even if there are no buffers available
from userspace.

As soon as a userspace queues a buffer it is inserted into the capture
loop and returned as soon as it is filled. This is a improvement on the
previous logic where the whole capture loop was stopped and switched to
single capture mode if userspace did not feed the VIN driver buffers at
the same time it consumed them. To make matters worse it was difficult
for the driver to reenter continues mode if it entered single mode even
if userspace started to queue buffers faster. This resulted in
suboptimal performance where if userspace where delayed for a short
period the ongoing capture would be slowed down and run in single mode
until the capturing process where restarted.

An additional effect of this change is that the capture logic can be
made much simple as we know that continues mode will always be used.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 187 ++++++++---------------------
 drivers/media/platform/rcar-vin/rcar-vin.h |   6 +-
 2 files changed, 52 insertions(+), 141 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 8ea73cdc9a720abe..208cf8a0ea77002d 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -168,12 +168,8 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_NONE:
-		if (vin->continuous) {
-			vnmc = VNMC_IM_ODD_EVEN;
-			progressive = true;
-		} else {
-			vnmc = VNMC_IM_ODD;
-		}
+		vnmc = VNMC_IM_ODD_EVEN;
+		progressive = true;
 		break;
 	default:
 		vnmc = VNMC_IM_ODD;
@@ -298,14 +294,6 @@ static bool rvin_capture_active(struct rvin_dev *vin)
 	return rvin_read(vin, VNMS_REG) & VNMS_CA;
 }
 
-static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
-{
-	if (vin->continuous)
-		return (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
-
-	return 0;
-}
-
 static enum v4l2_field rvin_get_active_field(struct rvin_dev *vin, u32 vnms)
 {
 	if (vin->format.field == V4L2_FIELD_ALTERNATE) {
@@ -344,76 +332,47 @@ static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
 	rvin_write(vin, offset, VNMB_REG(slot));
 }
 
-/* Moves a buffer from the queue to the HW slots */
-static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
+/*
+ * Moves a buffer from the queue to the HW slot. If no buffer is
+ * available use the scratch buffer. The scratch buffer is never
+ * returned to userspace, its only function is to enable the capture
+ * loop to keep running.
+ */
+static void rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
 {
 	struct rvin_buffer *buf;
 	struct vb2_v4l2_buffer *vbuf;
-	dma_addr_t phys_addr_top;
-
-	if (vin->queue_buf[slot] != NULL)
-		return true;
+	dma_addr_t phys_addr;
 
-	if (list_empty(&vin->buf_list))
-		return false;
+	/* A already populated slot shall never be overwritten. */
+	if (WARN_ON(vin->queue_buf[slot] != NULL))
+		return;
 
 	vin_dbg(vin, "Filling HW slot: %d\n", slot);
 
-	/* Keep track of buffer we give to HW */
-	buf = list_entry(vin->buf_list.next, struct rvin_buffer, list);
-	vbuf = &buf->vb;
-	list_del_init(to_buf_list(vbuf));
-	vin->queue_buf[slot] = vbuf;
-
-	/* Setup DMA */
-	phys_addr_top = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
-	rvin_set_slot_addr(vin, slot, phys_addr_top);
-
-	return true;
-}
-
-static bool rvin_fill_hw(struct rvin_dev *vin)
-{
-	int slot, limit;
-
-	limit = vin->continuous ? HW_BUFFER_NUM : 1;
-
-	for (slot = 0; slot < limit; slot++)
-		if (!rvin_fill_hw_slot(vin, slot))
-			return false;
-	return true;
-}
-
-static void rvin_capture_on(struct rvin_dev *vin)
-{
-	vin_dbg(vin, "Capture on in %s mode\n",
-		vin->continuous ? "continuous" : "single");
+	if (list_empty(&vin->buf_list)) {
+		vin->queue_buf[slot] = NULL;
+		phys_addr = vin->scratch_phys;
+	} else {
+		/* Keep track of buffer we give to HW */
+		buf = list_entry(vin->buf_list.next, struct rvin_buffer, list);
+		vbuf = &buf->vb;
+		list_del_init(to_buf_list(vbuf));
+		vin->queue_buf[slot] = vbuf;
+
+		/* Setup DMA */
+		phys_addr = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
+	}
 
-	if (vin->continuous)
-		/* Continuous Frame Capture Mode */
-		rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
-	else
-		/* Single Frame Capture Mode */
-		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
+	rvin_set_slot_addr(vin, slot, phys_addr);
 }
 
 static int rvin_capture_start(struct rvin_dev *vin)
 {
-	struct rvin_buffer *buf, *node;
-	int bufs, ret;
+	int slot, ret;
 
-	/* Count number of free buffers */
-	bufs = 0;
-	list_for_each_entry_safe(buf, node, &vin->buf_list, list)
-		bufs++;
-
-	/* Continuous capture requires more buffers then there are HW slots */
-	vin->continuous = bufs > HW_BUFFER_NUM;
-
-	if (!rvin_fill_hw(vin)) {
-		vin_err(vin, "HW not ready to start, not enough buffers available\n");
-		return -EINVAL;
-	}
+	for (slot = 0; slot < HW_BUFFER_NUM; slot++)
+		rvin_fill_hw_slot(vin, slot);
 
 	rvin_crop_scale_comp(vin);
 
@@ -421,7 +380,10 @@ static int rvin_capture_start(struct rvin_dev *vin)
 	if (ret)
 		return ret;
 
-	rvin_capture_on(vin);
+	vin_dbg(vin, "Starting to capture\n");
+
+	/* Continuous Frame Capture Mode */
+	rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
 
 	vin->state = RUNNING;
 
@@ -904,7 +866,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	struct rvin_dev *vin = data;
 	u32 int_status, vnms;
 	int slot;
-	unsigned int i, sequence, handled = 0;
+	unsigned int handled = 0;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vin->qlock, flags);
@@ -924,65 +886,25 @@ static irqreturn_t rvin_irq(int irq, void *data)
 
 	/* Prepare for capture and update state */
 	vnms = rvin_read(vin, VNMS_REG);
-	slot = rvin_get_active_slot(vin, vnms);
-	sequence = vin->sequence++;
-
-	vin_dbg(vin, "IRQ %02d: %d\tbuf0: %c buf1: %c buf2: %c\tmore: %d\n",
-		sequence, slot,
-		slot == 0 ? 'x' : vin->queue_buf[0] != NULL ? '1' : '0',
-		slot == 1 ? 'x' : vin->queue_buf[1] != NULL ? '1' : '0',
-		slot == 2 ? 'x' : vin->queue_buf[2] != NULL ? '1' : '0',
-		!list_empty(&vin->buf_list));
-
-	/* HW have written to a slot that is not prepared we are in trouble */
-	if (WARN_ON((vin->queue_buf[slot] == NULL)))
-		goto done;
+	slot = (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
 
 	/* Capture frame */
-	vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
-	vin->queue_buf[slot]->sequence = sequence;
-	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
-	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
-	vin->queue_buf[slot] = NULL;
-
-	/* Prepare for next frame */
-	if (!rvin_fill_hw(vin)) {
-
-		/*
-		 * Can't supply HW with new buffers fast enough. Halt
-		 * capture until more buffers are available.
-		 */
-		vin->state = STALLED;
-
-		/*
-		 * The continuous capturing requires an explicit stop
-		 * operation when there is no buffer to be set into
-		 * the VnMBm registers.
-		 */
-		if (vin->continuous) {
-			rvin_capture_stop(vin);
-			vin_dbg(vin, "IRQ %02d: hw not ready stop\n", sequence);
-
-			/* Maybe we can continue in single capture mode */
-			for (i = 0; i < HW_BUFFER_NUM; i++) {
-				if (vin->queue_buf[i]) {
-					list_add(to_buf_list(vin->queue_buf[i]),
-						 &vin->buf_list);
-					vin->queue_buf[i] = NULL;
-				}
-			}
-
-			if (!list_empty(&vin->buf_list))
-				rvin_capture_start(vin);
-		}
+	if (vin->queue_buf[slot]) {
+		vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
+		vin->queue_buf[slot]->sequence = vin->sequence;
+		vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
+		vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf,
+				VB2_BUF_STATE_DONE);
+		vin->queue_buf[slot] = NULL;
 	} else {
-		/*
-		 * The single capturing requires an explicit capture
-		 * operation to fetch the next frame.
-		 */
-		if (!vin->continuous)
-			rvin_capture_on(vin);
+		/* Scratch buffer was used, dropping frame. */
+		vin_dbg(vin, "Dropping frame %u\n", vin->sequence);
 	}
+
+	vin->sequence++;
+
+	/* Prepare for next frame */
+	rvin_fill_hw_slot(vin, slot);
 done:
 	spin_unlock_irqrestore(&vin->qlock, flags);
 
@@ -1053,13 +975,6 @@ static void rvin_buffer_queue(struct vb2_buffer *vb)
 
 	list_add_tail(to_buf_list(vbuf), &vin->buf_list);
 
-	/*
-	 * If capture is stalled add buffer to HW and restart
-	 * capturing if HW is ready to continue.
-	 */
-	if (vin->state == STALLED)
-		rvin_capture_start(vin);
-
 	spin_unlock_irqrestore(&vin->qlock, flags);
 }
 
@@ -1202,7 +1117,7 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
 	q->ops = &rvin_qops;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_buffers_needed = 1;
+	q->min_buffers_needed = 4;
 	q->dev = vin->dev;
 
 	ret = vb2_queue_init(q);
diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
index 11a981d707c7ca47..1adc1b809f761e71 100644
--- a/drivers/media/platform/rcar-vin/rcar-vin.h
+++ b/drivers/media/platform/rcar-vin/rcar-vin.h
@@ -38,13 +38,11 @@ enum chip_id {
 /**
  * STOPPED  - No operation in progress
  * RUNNING  - Operation in progress have buffers
- * STALLED  - No operation in progress have no buffers
  * STOPPING - Stopping operation
  */
 enum rvin_dma_state {
 	STOPPED = 0,
 	RUNNING,
-	STALLED,
 	STOPPING,
 };
 
@@ -105,11 +103,10 @@ struct rvin_graph_entity {
  * @scratch:		cpu address for scratch buffer
  * @scratch_phys:	pysical address of the scratch buffer
  *
- * @qlock:		protects @queue_buf, @buf_list, @continuous, @sequence
+ * @qlock:		protects @queue_buf, @buf_list, @sequence
  *			@state
  * @queue_buf:		Keeps track of buffers given to HW slot
  * @buf_list:		list of queued buffers
- * @continuous:		tracks if active operation is continuous or single mode
  * @sequence:		V4L2 buffers sequence number
  * @state:		keeps track of operation state
  *
@@ -138,7 +135,6 @@ struct rvin_dev {
 	spinlock_t qlock;
 	struct vb2_v4l2_buffer *queue_buf[HW_BUFFER_NUM];
 	struct list_head buf_list;
-	bool continuous;
 	unsigned int sequence;
 	enum rvin_dma_state state;
 
-- 
2.16.2

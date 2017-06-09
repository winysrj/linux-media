Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:39429 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdFINLb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 09:11:31 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: add support for V4L2_FIELD_SEQ_{TB,BT}
Date: Fri,  9 Jun 2017 15:10:17 +0200
Message-Id: <20170609131017.31721-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hardware do not support capturing the field types V4L2_FIELD_SEQ_TB
and V4L2_FIELD_SEQ_BT. To capture in these formats the driver needs to
change what field (top or bottom) is to be captured next and for every
other capture adjust the offset of the capture buffer.

This patch adds support for these sequential fields with the limitation
that continues capture mode is not supported. This limitation have no
visibility for user-space and the driver can already be running in
single capture mode for all other field types if the driver is not feed
buffers quickly enough.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---

Based on top of '[PATCH v4 00/27] rcar-vin: Add Gen3 with media 
controller support'. Tested on Gen2 M2 Koelsch and Gen3 Salvator-X H3 
and M3.

Test procedure documented on http://elinux.org/R-Car/Tests:rcar-vin

 drivers/media/platform/rcar-vin/rcar-dma.c  | 67 +++++++++++++++++++++++++++-
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 68 ++++++++++++++++++++++++-----
 2 files changed, 124 insertions(+), 11 deletions(-)


diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index a4764907d2bdbfbc..3a2eeaf120414069 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -96,6 +96,7 @@
 #define VNMC_IM_ODD_EVEN	(1 << 3)
 #define VNMC_IM_EVEN		(2 << 3)
 #define VNMC_IM_FULL		(3 << 3)
+#define VNMC_IM_MASK		0x18
 #define VNMC_BPS		(1 << 1)
 #define VNMC_ME			(1 << 0)
 
@@ -640,6 +641,12 @@ static int rvin_setup(struct rvin_dev *vin)
 	case V4L2_FIELD_INTERLACED_BT:
 		vnmc = VNMC_IM_FULL | VNMC_FOC;
 		break;
+	case V4L2_FIELD_SEQ_TB:
+		vnmc = VNMC_IM_ODD;
+		break;
+	case V4L2_FIELD_SEQ_BT:
+		vnmc = VNMC_IM_EVEN;
+		break;
 	case V4L2_FIELD_ALTERNATE:
 	case V4L2_FIELD_NONE:
 		if (vin->continuous) {
@@ -895,6 +902,11 @@ static int rvin_capture_start(struct rvin_dev *vin)
 	/* Continuous capture requires more buffers then there are HW slots */
 	vin->continuous = bufs > HW_BUFFER_NUM;
 
+	/* We can't support continues mode for sequential field formats */
+	if (vin->format.field == V4L2_FIELD_SEQ_TB ||
+	    vin->format.field == V4L2_FIELD_SEQ_BT)
+		vin->continuous = false;
+
 	if (!rvin_fill_hw(vin)) {
 		vin_err(vin, "HW not ready to start, not enough buffers available\n");
 		return -EINVAL;
@@ -930,6 +942,55 @@ static void rvin_capture_stop(struct rvin_dev *vin)
 #define RVIN_TIMEOUT_MS 100
 #define RVIN_RETRIES 10
 
+static bool rvin_seq_field_done(struct rvin_dev *vin)
+{
+	dma_addr_t phys_addr;
+	u32 vnmc, next;
+
+	/* Only handle sequential formats */
+	if (vin->format.field != V4L2_FIELD_SEQ_TB &&
+	    vin->format.field != V4L2_FIELD_SEQ_BT)
+		return true;
+
+	/* Update field for next capture */
+	vnmc = rvin_read(vin, VNMC_REG);
+	next = (vnmc & VNMC_IM_MASK) == VNMC_IM_ODD ?
+		VNMC_IM_EVEN : VNMC_IM_ODD;
+
+	vin_dbg(vin, "SEQ Mode: %s Cap: %s Next: %s\n",
+		vin->format.field == V4L2_FIELD_SEQ_TB ? "TB" : "BT",
+		(vnmc & VNMC_IM_MASK) == VNMC_IM_ODD ? "T" : "B",
+		next == VNMC_IM_ODD ? "T" : "B");
+
+	vnmc = (vnmc & ~VNMC_IM_MASK) | next;
+	rvin_write(vin, vnmc, VNMC_REG);
+
+	/* If capture is second part of frame signal frame done */
+	if ((vin->format.field == V4L2_FIELD_SEQ_TB && next == VNMC_IM_ODD) ||
+	    (vin->format.field == V4L2_FIELD_SEQ_BT && next == VNMC_IM_EVEN)) {
+		vin_dbg(vin, "SEQ frame done\n");
+		return true;
+	}
+
+	/*
+	 * Need to capture second half of the frame. Increment the
+	 * offset for the capture buffer so it appends to the already
+	 * captured first field. Start one new capture (in single mode)
+	 * and signal that frame is not complete.
+	 */
+
+	vin_dbg(vin, "SEQ frame need to capture other half, frame not done\n");
+
+	phys_addr =
+		vb2_dma_contig_plane_dma_addr(&vin->queue_buf[0]->vb2_buf, 0) +
+		vin->format.sizeimage / 2;
+	rvin_set_slot_addr(vin, 0, phys_addr);
+
+	rvin_capture_on(vin);
+
+	return false;
+}
+
 static irqreturn_t rvin_irq(int irq, void *data)
 {
 	struct rvin_dev *vin = data;
@@ -962,7 +1023,7 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	/* Prepare for capture and update state */
 	vnms = rvin_read(vin, VNMS_REG);
 	slot = rvin_get_active_slot(vin, vnms);
-	sequence = vin->sequence++;
+	sequence = vin->sequence;
 
 	vin_dbg(vin, "IRQ %02d: %d\tbuf0: %c buf1: %c buf2: %c\tmore: %d\n",
 		sequence, slot,
@@ -975,12 +1036,16 @@ static irqreturn_t rvin_irq(int irq, void *data)
 	if (WARN_ON((vin->queue_buf[slot] == NULL)))
 		goto done;
 
+	if (!rvin_seq_field_done(vin))
+		goto done;
+
 	/* Capture frame */
 	vin->queue_buf[slot]->field = rvin_get_active_field(vin, vnms);
 	vin->queue_buf[slot]->sequence = sequence;
 	vin->queue_buf[slot]->vb2_buf.timestamp = ktime_get_ns();
 	vb2_buffer_done(&vin->queue_buf[slot]->vb2_buf, VB2_BUF_STATE_DONE);
 	vin->queue_buf[slot] = NULL;
+	vin->sequence++;
 
 	/* Prepare for next frame */
 	if (!rvin_fill_hw(vin)) {
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 236bf10c3dfac5a6..df2a1a7a6455cafc 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -89,10 +89,26 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format *pix)
 	return pix->bytesperline * pix->height;
 }
 
-static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
+static void __rvin_format_aling_update(struct rvin_dev *vin,
+				       struct v4l2_pix_format *pix)
 {
 	u32 walign;
 
+	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
+	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
+
+	/* Limit to VIN capabilities */
+	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
+			      &pix->height, 4, vin->info->max_height, 2, 0);
+
+	pix->bytesperline = rvin_format_bytesperline(pix);
+	pix->sizeimage = rvin_format_sizeimage(pix);
+}
+
+static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
+{
+	int width;
+
 	/* If requested format is not supported fallback to the default */
 	if (!rvin_format_from_pixel(pix->pixelformat)) {
 		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
@@ -109,6 +125,44 @@ static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
 	case V4L2_FIELD_INTERLACED_BT:
 	case V4L2_FIELD_INTERLACED:
 		break;
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
+		/*
+		 * Due to extra hardware alignment restrictions on
+		 * buffer addresses for multi plane formats they
+		 * are not (yet) supported. This would be much simpler
+		 * once support for the UDS scaler is added.
+		 *
+		 * Support for multi plane formats could be supported
+		 * by having a different partitioning strategy when
+		 * capturing the second field (start capturing one
+		 * quarter in to the buffer instead of one half).
+		 */
+
+		if (pix->pixelformat == V4L2_PIX_FMT_NV16)
+			pix->pixelformat = RVIN_DEFAULT_FORMAT;
+
+		/*
+		 * For sequential formats it's needed to write to
+		 * the same buffer two times to capture both the top
+		 * and bottom field. The second time it is written
+		 * an offset is needed as to not overwrite the
+		 * previous captured field. Due to hardware limitations
+		 * the offsets must be a multiple of 128. Try to
+		 * increase the width of the image until a size is
+		 * found which can satisfy this constraint.
+		 */
+
+		width = pix->width;
+		while (width < vin->info->max_width) {
+			pix->width = width++;
+
+			__rvin_format_aling_update(vin, pix);
+
+			if (((pix->sizeimage / 2) & HW_BUFFER_MASK) == 0)
+				break;
+		}
+		break;
 	default:
 		pix->field = V4L2_FIELD_NONE;
 		break;
@@ -118,15 +172,7 @@ static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
 	if (!pix->colorspace || pix->colorspace >= 0xff)
 		pix->colorspace = vin->format.colorspace;
 
-	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
-	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
-
-	/* Limit to VIN capabilities */
-	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
-			      &pix->height, 4, vin->info->max_height, 2, 0);
-
-	pix->bytesperline = rvin_format_bytesperline(pix);
-	pix->sizeimage = rvin_format_sizeimage(pix);
+	__rvin_format_aling_update(vin, pix);
 
 	if (vin->info->chip == RCAR_M1 &&
 	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
@@ -199,6 +245,8 @@ int rvin_reset_format(struct rvin_dev *vin)
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
 	case V4L2_FIELD_INTERLACED:
+	case V4L2_FIELD_SEQ_TB:
+	case V4L2_FIELD_SEQ_BT:
 		break;
 	default:
 		vin->format.field = V4L2_FIELD_NONE;
-- 
2.13.1

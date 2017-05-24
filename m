Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:46785 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937858AbdEXARD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:17:03 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 10/17] rcar-vin: move functions which acts on hardware
Date: Wed, 24 May 2017 02:15:33 +0200
Message-Id: <20170524001540.13613-11-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

This only moves whole structs, defines and functions around, no code is
changed inside any function. The reason for moving this code around is
to prepare for refactoring and fixing of a start/stop stream bug without
having to use forward declarations.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 182 ++++++++++++++---------------
 1 file changed, 91 insertions(+), 91 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index c37f7a2993fb5565..11e9799564299fca 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -119,6 +119,15 @@
 #define VNDMR2_FTEV		(1 << 17)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)
 
+struct rvin_buffer {
+	struct vb2_v4l2_buffer vb;
+	struct list_head list;
+};
+
+#define to_buf_list(vb2_buffer) (&container_of(vb2_buffer, \
+					       struct rvin_buffer, \
+					       vb)->list)
+
 static void rvin_write(struct rvin_dev *vin, u32 value, u32 offset)
 {
 	iowrite32(value, vin->base + offset);
@@ -269,48 +278,6 @@ static int rvin_setup(struct rvin_dev *vin)
 	return 0;
 }
 
-static void rvin_capture_on(struct rvin_dev *vin)
-{
-	vin_dbg(vin, "Capture on in %s mode\n",
-		vin->continuous ? "continuous" : "single");
-
-	if (vin->continuous)
-		/* Continuous Frame Capture Mode */
-		rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
-	else
-		/* Single Frame Capture Mode */
-		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
-}
-
-static void rvin_capture_off(struct rvin_dev *vin)
-{
-	/* Set continuous & single transfer off */
-	rvin_write(vin, 0, VNFC_REG);
-}
-
-static int rvin_capture_start(struct rvin_dev *vin)
-{
-	int ret;
-
-	rvin_crop_scale_comp(vin);
-
-	ret = rvin_setup(vin);
-	if (ret)
-		return ret;
-
-	rvin_capture_on(vin);
-
-	return 0;
-}
-
-static void rvin_capture_stop(struct rvin_dev *vin)
-{
-	rvin_capture_off(vin);
-
-	/* Disable module */
-	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
-}
-
 static void rvin_disable_interrupts(struct rvin_dev *vin)
 {
 	rvin_write(vin, 0, VNIE_REG);
@@ -377,6 +344,88 @@ static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
 	rvin_write(vin, offset, VNMB_REG(slot));
 }
 
+/* Moves a buffer from the queue to the HW slots */
+static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
+{
+	struct rvin_buffer *buf;
+	struct vb2_v4l2_buffer *vbuf;
+	dma_addr_t phys_addr_top;
+
+	if (vin->queue_buf[slot] != NULL)
+		return true;
+
+	if (list_empty(&vin->buf_list))
+		return false;
+
+	vin_dbg(vin, "Filling HW slot: %d\n", slot);
+
+	/* Keep track of buffer we give to HW */
+	buf = list_entry(vin->buf_list.next, struct rvin_buffer, list);
+	vbuf = &buf->vb;
+	list_del_init(to_buf_list(vbuf));
+	vin->queue_buf[slot] = vbuf;
+
+	/* Setup DMA */
+	phys_addr_top = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
+	rvin_set_slot_addr(vin, slot, phys_addr_top);
+
+	return true;
+}
+
+static bool rvin_fill_hw(struct rvin_dev *vin)
+{
+	int slot, limit;
+
+	limit = vin->continuous ? HW_BUFFER_NUM : 1;
+
+	for (slot = 0; slot < limit; slot++)
+		if (!rvin_fill_hw_slot(vin, slot))
+			return false;
+	return true;
+}
+
+static void rvin_capture_on(struct rvin_dev *vin)
+{
+	vin_dbg(vin, "Capture on in %s mode\n",
+		vin->continuous ? "continuous" : "single");
+
+	if (vin->continuous)
+		/* Continuous Frame Capture Mode */
+		rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
+	else
+		/* Single Frame Capture Mode */
+		rvin_write(vin, VNFC_S_FRAME, VNFC_REG);
+}
+
+static void rvin_capture_off(struct rvin_dev *vin)
+{
+	/* Set continuous & single transfer off */
+	rvin_write(vin, 0, VNFC_REG);
+}
+
+static int rvin_capture_start(struct rvin_dev *vin)
+{
+	int ret;
+
+	rvin_crop_scale_comp(vin);
+
+	ret = rvin_setup(vin);
+	if (ret)
+		return ret;
+
+	rvin_capture_on(vin);
+
+	return 0;
+}
+
+static void rvin_capture_stop(struct rvin_dev *vin)
+{
+	rvin_capture_off(vin);
+
+	/* Disable module */
+	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
+}
+
 /* -----------------------------------------------------------------------------
  * Crop and Scaling Gen2
  */
@@ -839,55 +888,6 @@ void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
 #define RVIN_TIMEOUT_MS 100
 #define RVIN_RETRIES 10
 
-struct rvin_buffer {
-	struct vb2_v4l2_buffer vb;
-	struct list_head list;
-};
-
-#define to_buf_list(vb2_buffer) (&container_of(vb2_buffer, \
-					       struct rvin_buffer, \
-					       vb)->list)
-
-/* Moves a buffer from the queue to the HW slots */
-static bool rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
-{
-	struct rvin_buffer *buf;
-	struct vb2_v4l2_buffer *vbuf;
-	dma_addr_t phys_addr_top;
-
-	if (vin->queue_buf[slot] != NULL)
-		return true;
-
-	if (list_empty(&vin->buf_list))
-		return false;
-
-	vin_dbg(vin, "Filling HW slot: %d\n", slot);
-
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
 static irqreturn_t rvin_irq(int irq, void *data)
 {
 	struct rvin_dev *vin = data;
-- 
2.13.0

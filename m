Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:24869 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752362AbeCZVqf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:35 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 09/33] rcar-vin: move functions regarding scaling
Date: Mon, 26 Mar 2018 23:44:32 +0200
Message-Id: <20180326214456.6655-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation of refactoring the scaling code move the code regarding
scaling to to the top of the file to avoid the need to add forward
declarations. No code is changed in this commit only whole functions
moved inside the same file.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 526 +++++++++++++++--------------
 1 file changed, 265 insertions(+), 261 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 2aae3ca54eabac01..23120901b0a062ed 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -138,267 +138,6 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
 	return ioread32(vin->base + offset);
 }
 
-static int rvin_setup(struct rvin_dev *vin)
-{
-	u32 vnmc, dmr, dmr2, interrupts;
-	v4l2_std_id std;
-	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
-
-	switch (vin->format.field) {
-	case V4L2_FIELD_TOP:
-		vnmc = VNMC_IM_ODD;
-		break;
-	case V4L2_FIELD_BOTTOM:
-		vnmc = VNMC_IM_EVEN;
-		break;
-	case V4L2_FIELD_INTERLACED:
-		/* Default to TB */
-		vnmc = VNMC_IM_FULL;
-		/* Use BT if video standard can be read and is 60 Hz format */
-		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
-			if (std & V4L2_STD_525_60)
-				vnmc = VNMC_IM_FULL | VNMC_FOC;
-		}
-		break;
-	case V4L2_FIELD_INTERLACED_TB:
-		vnmc = VNMC_IM_FULL;
-		break;
-	case V4L2_FIELD_INTERLACED_BT:
-		vnmc = VNMC_IM_FULL | VNMC_FOC;
-		break;
-	case V4L2_FIELD_ALTERNATE:
-	case V4L2_FIELD_NONE:
-		vnmc = VNMC_IM_ODD_EVEN;
-		progressive = true;
-		break;
-	default:
-		vnmc = VNMC_IM_ODD;
-		break;
-	}
-
-	/*
-	 * Input interface
-	 */
-	switch (vin->digital->code) {
-	case MEDIA_BUS_FMT_YUYV8_1X16:
-		/* BT.601/BT.1358 16bit YCbCr422 */
-		vnmc |= VNMC_INF_YUV16;
-		input_is_yuv = true;
-		break;
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
-		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
-			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
-		input_is_yuv = true;
-		break;
-	case MEDIA_BUS_FMT_RGB888_1X24:
-		vnmc |= VNMC_INF_RGB888;
-		break;
-	case MEDIA_BUS_FMT_UYVY10_2X10:
-		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
-		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
-			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
-		input_is_yuv = true;
-		break;
-	default:
-		break;
-	}
-
-	/* Enable VSYNC Field Toogle mode after one VSYNC input */
-	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
-
-	/* Hsync Signal Polarity Select */
-	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
-		dmr2 |= VNDMR2_HPS;
-
-	/* Vsync Signal Polarity Select */
-	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
-		dmr2 |= VNDMR2_VPS;
-
-	/*
-	 * Output format
-	 */
-	switch (vin->format.pixelformat) {
-	case V4L2_PIX_FMT_NV16:
-		rvin_write(vin,
-			   ALIGN(vin->format.width * vin->format.height, 0x80),
-			   VNUVAOF_REG);
-		dmr = VNDMR_DTMD_YCSEP;
-		output_is_yuv = true;
-		break;
-	case V4L2_PIX_FMT_YUYV:
-		dmr = VNDMR_BPSM;
-		output_is_yuv = true;
-		break;
-	case V4L2_PIX_FMT_UYVY:
-		dmr = 0;
-		output_is_yuv = true;
-		break;
-	case V4L2_PIX_FMT_XRGB555:
-		dmr = VNDMR_DTMD_ARGB1555;
-		break;
-	case V4L2_PIX_FMT_RGB565:
-		dmr = 0;
-		break;
-	case V4L2_PIX_FMT_XBGR32:
-		/* Note: not supported on M1 */
-		dmr = VNDMR_EXRGB;
-		break;
-	default:
-		vin_err(vin, "Invalid pixelformat (0x%x)\n",
-			vin->format.pixelformat);
-		return -EINVAL;
-	}
-
-	/* Always update on field change */
-	vnmc |= VNMC_VUP;
-
-	/* If input and output use the same colorspace, use bypass mode */
-	if (input_is_yuv == output_is_yuv)
-		vnmc |= VNMC_BPS;
-
-	/* Progressive or interlaced mode */
-	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
-
-	/* Ack interrupts */
-	rvin_write(vin, interrupts, VNINTS_REG);
-	/* Enable interrupts */
-	rvin_write(vin, interrupts, VNIE_REG);
-	/* Start capturing */
-	rvin_write(vin, dmr, VNDMR_REG);
-	rvin_write(vin, dmr2, VNDMR2_REG);
-
-	/* Enable module */
-	rvin_write(vin, vnmc | VNMC_ME, VNMC_REG);
-
-	return 0;
-}
-
-static void rvin_disable_interrupts(struct rvin_dev *vin)
-{
-	rvin_write(vin, 0, VNIE_REG);
-}
-
-static u32 rvin_get_interrupt_status(struct rvin_dev *vin)
-{
-	return rvin_read(vin, VNINTS_REG);
-}
-
-static void rvin_ack_interrupt(struct rvin_dev *vin)
-{
-	rvin_write(vin, rvin_read(vin, VNINTS_REG), VNINTS_REG);
-}
-
-static bool rvin_capture_active(struct rvin_dev *vin)
-{
-	return rvin_read(vin, VNMS_REG) & VNMS_CA;
-}
-
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
-static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
-{
-	const struct rvin_video_format *fmt;
-	int offsetx, offsety;
-	dma_addr_t offset;
-
-	fmt = rvin_format_from_pixel(vin->format.pixelformat);
-
-	/*
-	 * There is no HW support for composition do the beast we can
-	 * by modifying the buffer offset
-	 */
-	offsetx = vin->compose.left * fmt->bpp;
-	offsety = vin->compose.top * vin->format.bytesperline;
-	offset = addr + offsetx + offsety;
-
-	/*
-	 * The address needs to be 128 bytes aligned. Driver should never accept
-	 * settings that do not satisfy this in the first place...
-	 */
-	if (WARN_ON((offsetx | offsety | offset) & HW_BUFFER_MASK))
-		return;
-
-	rvin_write(vin, offset, VNMB_REG(slot));
-}
-
-/*
- * Moves a buffer from the queue to the HW slot. If no buffer is
- * available use the scratch buffer. The scratch buffer is never
- * returned to userspace, its only function is to enable the capture
- * loop to keep running.
- */
-static void rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
-{
-	struct rvin_buffer *buf;
-	struct vb2_v4l2_buffer *vbuf;
-	dma_addr_t phys_addr;
-
-	/* A already populated slot shall never be overwritten. */
-	if (WARN_ON(vin->queue_buf[slot] != NULL))
-		return;
-
-	vin_dbg(vin, "Filling HW slot: %d\n", slot);
-
-	if (list_empty(&vin->buf_list)) {
-		vin->queue_buf[slot] = NULL;
-		phys_addr = vin->scratch_phys;
-	} else {
-		/* Keep track of buffer we give to HW */
-		buf = list_entry(vin->buf_list.next, struct rvin_buffer, list);
-		vbuf = &buf->vb;
-		list_del_init(to_buf_list(vbuf));
-		vin->queue_buf[slot] = vbuf;
-
-		/* Setup DMA */
-		phys_addr = vb2_dma_contig_plane_dma_addr(&vbuf->vb2_buf, 0);
-	}
-
-	rvin_set_slot_addr(vin, slot, phys_addr);
-}
-
-static int rvin_capture_start(struct rvin_dev *vin)
-{
-	int slot, ret;
-
-	for (slot = 0; slot < HW_BUFFER_NUM; slot++)
-		rvin_fill_hw_slot(vin, slot);
-
-	rvin_crop_scale_comp(vin);
-
-	ret = rvin_setup(vin);
-	if (ret)
-		return ret;
-
-	vin_dbg(vin, "Starting to capture\n");
-
-	/* Continuous Frame Capture Mode */
-	rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
-
-	vin->state = RUNNING;
-
-	return 0;
-}
-
-static void rvin_capture_stop(struct rvin_dev *vin)
-{
-	/* Set continuous & single transfer off */
-	rvin_write(vin, 0, VNFC_REG);
-
-	/* Disable module */
-	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
-}
-
 /* -----------------------------------------------------------------------------
  * Crop and Scaling Gen2
  */
@@ -854,6 +593,271 @@ void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
 	pix->height = height;
 }
 
+/* -----------------------------------------------------------------------------
+ * Hardware setup
+ */
+
+static int rvin_setup(struct rvin_dev *vin)
+{
+	u32 vnmc, dmr, dmr2, interrupts;
+	v4l2_std_id std;
+	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
+
+	switch (vin->format.field) {
+	case V4L2_FIELD_TOP:
+		vnmc = VNMC_IM_ODD;
+		break;
+	case V4L2_FIELD_BOTTOM:
+		vnmc = VNMC_IM_EVEN;
+		break;
+	case V4L2_FIELD_INTERLACED:
+		/* Default to TB */
+		vnmc = VNMC_IM_FULL;
+		/* Use BT if video standard can be read and is 60 Hz format */
+		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std)) {
+			if (std & V4L2_STD_525_60)
+				vnmc = VNMC_IM_FULL | VNMC_FOC;
+		}
+		break;
+	case V4L2_FIELD_INTERLACED_TB:
+		vnmc = VNMC_IM_FULL;
+		break;
+	case V4L2_FIELD_INTERLACED_BT:
+		vnmc = VNMC_IM_FULL | VNMC_FOC;
+		break;
+	case V4L2_FIELD_ALTERNATE:
+	case V4L2_FIELD_NONE:
+		vnmc = VNMC_IM_ODD_EVEN;
+		progressive = true;
+		break;
+	default:
+		vnmc = VNMC_IM_ODD;
+		break;
+	}
+
+	/*
+	 * Input interface
+	 */
+	switch (vin->digital->code) {
+	case MEDIA_BUS_FMT_YUYV8_1X16:
+		/* BT.601/BT.1358 16bit YCbCr422 */
+		vnmc |= VNMC_INF_YUV16;
+		input_is_yuv = true;
+		break;
+	case MEDIA_BUS_FMT_UYVY8_2X8:
+		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
+		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
+			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
+		input_is_yuv = true;
+		break;
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		vnmc |= VNMC_INF_RGB888;
+		break;
+	case MEDIA_BUS_FMT_UYVY10_2X10:
+		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
+		vnmc |= vin->digital->mbus_cfg.type == V4L2_MBUS_BT656 ?
+			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
+		input_is_yuv = true;
+		break;
+	default:
+		break;
+	}
+
+	/* Enable VSYNC Field Toogle mode after one VSYNC input */
+	dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
+
+	/* Hsync Signal Polarity Select */
+	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
+		dmr2 |= VNDMR2_HPS;
+
+	/* Vsync Signal Polarity Select */
+	if (!(vin->digital->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
+		dmr2 |= VNDMR2_VPS;
+
+	/*
+	 * Output format
+	 */
+	switch (vin->format.pixelformat) {
+	case V4L2_PIX_FMT_NV16:
+		rvin_write(vin,
+			   ALIGN(vin->format.width * vin->format.height, 0x80),
+			   VNUVAOF_REG);
+		dmr = VNDMR_DTMD_YCSEP;
+		output_is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		dmr = VNDMR_BPSM;
+		output_is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		dmr = 0;
+		output_is_yuv = true;
+		break;
+	case V4L2_PIX_FMT_XRGB555:
+		dmr = VNDMR_DTMD_ARGB1555;
+		break;
+	case V4L2_PIX_FMT_RGB565:
+		dmr = 0;
+		break;
+	case V4L2_PIX_FMT_XBGR32:
+		/* Note: not supported on M1 */
+		dmr = VNDMR_EXRGB;
+		break;
+	default:
+		vin_err(vin, "Invalid pixelformat (0x%x)\n",
+			vin->format.pixelformat);
+		return -EINVAL;
+	}
+
+	/* Always update on field change */
+	vnmc |= VNMC_VUP;
+
+	/* If input and output use the same colorspace, use bypass mode */
+	if (input_is_yuv == output_is_yuv)
+		vnmc |= VNMC_BPS;
+
+	/* Progressive or interlaced mode */
+	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
+
+	/* Ack interrupts */
+	rvin_write(vin, interrupts, VNINTS_REG);
+	/* Enable interrupts */
+	rvin_write(vin, interrupts, VNIE_REG);
+	/* Start capturing */
+	rvin_write(vin, dmr, VNDMR_REG);
+	rvin_write(vin, dmr2, VNDMR2_REG);
+
+	/* Enable module */
+	rvin_write(vin, vnmc | VNMC_ME, VNMC_REG);
+
+	return 0;
+}
+
+static void rvin_disable_interrupts(struct rvin_dev *vin)
+{
+	rvin_write(vin, 0, VNIE_REG);
+}
+
+static u32 rvin_get_interrupt_status(struct rvin_dev *vin)
+{
+	return rvin_read(vin, VNINTS_REG);
+}
+
+static void rvin_ack_interrupt(struct rvin_dev *vin)
+{
+	rvin_write(vin, rvin_read(vin, VNINTS_REG), VNINTS_REG);
+}
+
+static bool rvin_capture_active(struct rvin_dev *vin)
+{
+	return rvin_read(vin, VNMS_REG) & VNMS_CA;
+}
+
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
+static void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t addr)
+{
+	const struct rvin_video_format *fmt;
+	int offsetx, offsety;
+	dma_addr_t offset;
+
+	fmt = rvin_format_from_pixel(vin->format.pixelformat);
+
+	/*
+	 * There is no HW support for composition do the beast we can
+	 * by modifying the buffer offset
+	 */
+	offsetx = vin->compose.left * fmt->bpp;
+	offsety = vin->compose.top * vin->format.bytesperline;
+	offset = addr + offsetx + offsety;
+
+	/*
+	 * The address needs to be 128 bytes aligned. Driver should never accept
+	 * settings that do not satisfy this in the first place...
+	 */
+	if (WARN_ON((offsetx | offsety | offset) & HW_BUFFER_MASK))
+		return;
+
+	rvin_write(vin, offset, VNMB_REG(slot));
+}
+
+/*
+ * Moves a buffer from the queue to the HW slot. If no buffer is
+ * available use the scratch buffer. The scratch buffer is never
+ * returned to userspace, its only function is to enable the capture
+ * loop to keep running.
+ */
+static void rvin_fill_hw_slot(struct rvin_dev *vin, int slot)
+{
+	struct rvin_buffer *buf;
+	struct vb2_v4l2_buffer *vbuf;
+	dma_addr_t phys_addr;
+
+	/* A already populated slot shall never be overwritten. */
+	if (WARN_ON(vin->queue_buf[slot] != NULL))
+		return;
+
+	vin_dbg(vin, "Filling HW slot: %d\n", slot);
+
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
+
+	rvin_set_slot_addr(vin, slot, phys_addr);
+}
+
+static int rvin_capture_start(struct rvin_dev *vin)
+{
+	int slot, ret;
+
+	for (slot = 0; slot < HW_BUFFER_NUM; slot++)
+		rvin_fill_hw_slot(vin, slot);
+
+	rvin_crop_scale_comp(vin);
+
+	ret = rvin_setup(vin);
+	if (ret)
+		return ret;
+
+	vin_dbg(vin, "Starting to capture\n");
+
+	/* Continuous Frame Capture Mode */
+	rvin_write(vin, VNFC_C_FRAME, VNFC_REG);
+
+	vin->state = RUNNING;
+
+	return 0;
+}
+
+static void rvin_capture_stop(struct rvin_dev *vin)
+{
+	/* Set continuous & single transfer off */
+	rvin_write(vin, 0, VNFC_REG);
+
+	/* Disable module */
+	rvin_write(vin, rvin_read(vin, VNMC_REG) & ~VNMC_ME, VNMC_REG);
+}
+
 /* -----------------------------------------------------------------------------
  * DMA Functions
  */
-- 
2.16.2

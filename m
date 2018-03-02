Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:20935 "EHLO
        bin-vsp-out-01.atm.binero.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1163606AbeCBB7B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Mar 2018 20:59:01 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v11 09/32] rcar-vin: move functions regarding scaling
Date: Fri,  2 Mar 2018 02:57:28 +0100
Message-Id: <20180302015751.25596-10-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/platform/rcar-vin/rcar-dma.c | 602 +++++++++++++++--------------
 1 file changed, 303 insertions(+), 299 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index d701b52d198243b5..a7cda3922cb74baa 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -138,305 +138,6 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
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
-		if (vin->continuous) {
-			vnmc = VNMC_IM_ODD_EVEN;
-			progressive = true;
-		} else {
-			vnmc = VNMC_IM_ODD;
-		}
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
-static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
-{
-	if (vin->continuous)
-		return (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
-
-	return 0;
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
-static int rvin_capture_start(struct rvin_dev *vin)
-{
-	struct rvin_buffer *buf, *node;
-	int bufs, ret;
-
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
-
-	rvin_crop_scale_comp(vin);
-
-	ret = rvin_setup(vin);
-	if (ret)
-		return ret;
-
-	rvin_capture_on(vin);
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
@@ -892,6 +593,309 @@ void rvin_scale_try(struct rvin_dev *vin, struct v4l2_pix_format *pix,
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
+		if (vin->continuous) {
+			vnmc = VNMC_IM_ODD_EVEN;
+			progressive = true;
+		} else {
+			vnmc = VNMC_IM_ODD;
+		}
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
+static int rvin_get_active_slot(struct rvin_dev *vin, u32 vnms)
+{
+	if (vin->continuous)
+		return (vnms & VNMS_FBS_MASK) >> VNMS_FBS_SHIFT;
+
+	return 0;
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
+static int rvin_capture_start(struct rvin_dev *vin)
+{
+	struct rvin_buffer *buf, *node;
+	int bufs, ret;
+
+	/* Count number of free buffers */
+	bufs = 0;
+	list_for_each_entry_safe(buf, node, &vin->buf_list, list)
+		bufs++;
+
+	/* Continuous capture requires more buffers then there are HW slots */
+	vin->continuous = bufs > HW_BUFFER_NUM;
+
+	if (!rvin_fill_hw(vin)) {
+		vin_err(vin, "HW not ready to start, not enough buffers available\n");
+		return -EINVAL;
+	}
+
+	rvin_crop_scale_comp(vin);
+
+	ret = rvin_setup(vin);
+	if (ret)
+		return ret;
+
+	rvin_capture_on(vin);
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

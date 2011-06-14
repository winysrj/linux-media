Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35110 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1FNGrw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 02:47:52 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5E6lq5W008917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:52 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep34.itg.ti.com (8.13.7/8.13.8) with ESMTP id p5E6lp5n009125
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:51 -0500 (CDT)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p5E6lp9G022237
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:51 -0500 (CDT)
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 3/3] OMAP_VOUT: Create separate file for VRFB related API's
Date: Tue, 14 Jun 2011 12:24:47 +0530
Message-ID: <1308034487-11852-4-git-send-email-archit@ti.com>
In-Reply-To: <1308034487-11852-1-git-send-email-archit@ti.com>
References: <1308034487-11852-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Introduce omap_vout_vrfb.c and omap_vout_vrfb.h, for all VRFB related API's,
making OMAP_VOUT driver independent from VRFB. This is required for OMAP4 DSS,
since OMAP4 doesn't have VRFB block.

Added new enum vout_rotation_type and "rotation_type" member to omapvideo_info,
this is initialized based on the arch type in omap_vout_probe. The rotation_type
var is now used to choose between vrfb and non-vrfb calls.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/Kconfig          |    7 +-
 drivers/media/video/omap/Makefile         |    1 +
 drivers/media/video/omap/omap_vout.c      |  453 ++++++-----------------------
 drivers/media/video/omap/omap_vout_vrfb.c |  390 +++++++++++++++++++++++++
 drivers/media/video/omap/omap_vout_vrfb.h |   40 +++
 drivers/media/video/omap/omap_voutdef.h   |   16 +
 6 files changed, 536 insertions(+), 371 deletions(-)
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.c
 create mode 100644 drivers/media/video/omap/omap_vout_vrfb.h

diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/video/omap/Kconfig
index e63233f..390ab09 100644
--- a/drivers/media/video/omap/Kconfig
+++ b/drivers/media/video/omap/Kconfig
@@ -1,11 +1,14 @@
+config VIDEO_OMAP2_VOUT_VRFB
+	bool
+
 config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
 	depends on ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEOBUF_GEN
 	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_DSS
-	select OMAP2_VRAM
-	select OMAP2_VRFB
+	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3
+	select VIDEO_OMAP2_VOUT_VRFB if VIDEO_OMAP2_VOUT && OMAP2_VRFB
 	default n
 	---help---
 	  V4L2 Display driver support for OMAP2/3 based boards.
diff --git a/drivers/media/video/omap/Makefile b/drivers/media/video/omap/Makefile
index b287880..fc410b4 100644
--- a/drivers/media/video/omap/Makefile
+++ b/drivers/media/video/omap/Makefile
@@ -4,4 +4,5 @@
 
 # OMAP2/3 Display driver
 omap-vout-y := omap_vout.o omap_voutlib.o
+omap-vout-$(CONFIG_VIDEO_OMAP2_VOUT_VRFB) += omap_vout_vrfb.o
 obj-$(CONFIG_VIDEO_OMAP2_VOUT) += omap-vout.o
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index c29d1cb..0bc776c 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -48,6 +48,7 @@
 
 #include "omap_voutlib.h"
 #include "omap_voutdef.h"
+#include "omap_vout_vrfb.h"
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
@@ -143,41 +144,6 @@ const static struct v4l2_fmtdesc omap_formats[] = {
 #define NUM_OUTPUT_FORMATS (ARRAY_SIZE(omap_formats))
 
 /*
- * Function for allocating video buffers
- */
-static int omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
-		unsigned int *count, int startindex)
-{
-	int i, j;
-
-	for (i = 0; i < *count; i++) {
-		if (!vout->smsshado_virt_addr[i]) {
-			vout->smsshado_virt_addr[i] =
-				omap_vout_alloc_buffer(vout->smsshado_size,
-						&vout->smsshado_phy_addr[i]);
-		}
-		if (!vout->smsshado_virt_addr[i] && startindex != -1) {
-			if (V4L2_MEMORY_MMAP == vout->memory && i >= startindex)
-				break;
-		}
-		if (!vout->smsshado_virt_addr[i]) {
-			for (j = 0; j < i; j++) {
-				omap_vout_free_buffer(
-						vout->smsshado_virt_addr[j],
-						vout->smsshado_size);
-				vout->smsshado_virt_addr[j] = 0;
-				vout->smsshado_phy_addr[j] = 0;
-			}
-			*count = 0;
-			return -ENOMEM;
-		}
-		memset((void *) vout->smsshado_virt_addr[i], 0,
-				vout->smsshado_size);
-	}
-	return 0;
-}
-
-/*
  * Try format
  */
 static int omap_vout_try_format(struct v4l2_pix_format *pix)
@@ -270,36 +236,9 @@ static u32 omap_vout_uservirt_to_phys(u32 virtp)
 }
 
 /*
- * Wakes up the application once the DMA transfer to VRFB space is completed.
- */
-static void omap_vout_vrfb_dma_tx_callback(int lch, u16 ch_status, void *data)
-{
-	struct vid_vrfb_dma *t = (struct vid_vrfb_dma *) data;
-
-	t->tx_status = 1;
-	wake_up_interruptible(&t->wait);
-}
-
-/*
- * Release the VRFB context once the module exits
- */
-static void omap_vout_release_vrfb(struct omap_vout_device *vout)
-{
-	int i;
-
-	for (i = 0; i < VRFB_NUM_BUFS; i++)
-		omap_vrfb_release_ctx(&vout->vrfb_context[i]);
-
-	if (vout->vrfb_dma_tx.req_status == DMA_CHAN_ALLOTED) {
-		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
-		omap_free_dma(vout->vrfb_dma_tx.dma_ch);
-	}
-}
-
-/*
  * Free the V4L2 buffers
  */
-static void omap_vout_free_buffers(struct omap_vout_device *vout)
+void omap_vout_free_buffers(struct omap_vout_device *vout)
 {
 	int i, numbuffers;
 
@@ -316,52 +255,6 @@ static void omap_vout_free_buffers(struct omap_vout_device *vout)
 }
 
 /*
- * Free VRFB buffers
- */
-static void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout)
-{
-	int j;
-
-	for (j = 0; j < VRFB_NUM_BUFS; j++) {
-		omap_vout_free_buffer(vout->smsshado_virt_addr[j],
-				vout->smsshado_size);
-		vout->smsshado_virt_addr[j] = 0;
-		vout->smsshado_phy_addr[j] = 0;
-	}
-}
-
-/*
- * Allocate the buffers for the VRFB space.  Data is copied from V4L2
- * buffers to the VRFB buffers using the DMA engine.
- */
-static int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
-			  unsigned int *count, unsigned int startindex)
-{
-	int i;
-	bool yuv_mode;
-
-	/* Allocate the VRFB buffers only if the buffers are not
-	 * allocated during init time.
-	 */
-	if ((is_rotation_enabled(vout)) && !vout->vrfb_static_allocation)
-		if (omap_vout_allocate_vrfb_buffers(vout, count, startindex))
-			return -ENOMEM;
-
-	if (vout->dss_mode == OMAP_DSS_COLOR_YUV2 ||
-			vout->dss_mode == OMAP_DSS_COLOR_UYVY)
-		yuv_mode = true;
-	else
-		yuv_mode = false;
-
-	for (i = 0; i < *count; i++)
-		omap_vrfb_setup(&vout->vrfb_context[i],
-				vout->smsshado_phy_addr[i], vout->pix.width,
-				vout->pix.height, vout->bpp, yuv_mode);
-
-	return 0;
-}
-
-/*
  * Convert V4L2 rotation to DSS rotation
  *	V4L2 understand 0, 90, 180, 270.
  *	Convert to 0, 1, 2 and 3 respectively for DSS
@@ -390,124 +283,38 @@ static int v4l2_rot_to_dss_rot(int v4l2_rotation,
 	return ret;
 }
 
-/*
- * Calculate the buffer offsets from which the streaming should
- * start. This offset calculation is mainly required because of
- * the VRFB 32 pixels alignment with rotation.
- */
 static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 {
-	struct omap_overlay *ovl;
-	enum dss_rotation rotation;
 	struct omapvideo_info *ovid;
-	bool mirroring = vout->mirror;
-	struct omap_dss_device *cur_display;
 	struct v4l2_rect *crop = &vout->crop;
 	struct v4l2_pix_format *pix = &vout->pix;
 	int *cropped_offset = &vout->cropped_offset;
-	int vr_ps = 1, ps = 2, temp_ps = 2;
-	int offset = 0, ctop = 0, cleft = 0, line_length = 0;
+	int ps = 2, line_length = 0;
 
 	ovid = &vout->vid_info;
-	ovl = ovid->overlays[0];
-	/* get the display device attached to the overlay */
-	if (!ovl->manager || !ovl->manager->device)
-		return -1;
 
-	cur_display = ovl->manager->device;
-	rotation = calc_rotation(vout);
+	if (ovid->rotation_type == VOUT_ROT_VRFB) {
+		omap_vout_calculate_vrfb_offset(vout);
+	} else {
+		vout->line_length = line_length = pix->width;
 
-	if (V4L2_PIX_FMT_YUYV == pix->pixelformat ||
-			V4L2_PIX_FMT_UYVY == pix->pixelformat) {
-		if (is_rotation_enabled(vout)) {
-			/*
-			 * ps    - Actual pixel size for YUYV/UYVY for
-			 *         VRFB/Mirroring is 4 bytes
-			 * vr_ps - Virtually pixel size for YUYV/UYVY is
-			 *         2 bytes
-			 */
+		if (V4L2_PIX_FMT_YUYV == pix->pixelformat ||
+			V4L2_PIX_FMT_UYVY == pix->pixelformat)
+			ps = 2;
+		else if (V4L2_PIX_FMT_RGB32 == pix->pixelformat)
 			ps = 4;
-			vr_ps = 2;
-		} else {
-			ps = 2;	/* otherwise the pixel size is 2 byte */
-		}
-	} else if (V4L2_PIX_FMT_RGB32 == pix->pixelformat) {
-		ps = 4;
-	} else if (V4L2_PIX_FMT_RGB24 == pix->pixelformat) {
-		ps = 3;
-	}
-	vout->ps = ps;
-	vout->vr_ps = vr_ps;
-
-	if (is_rotation_enabled(vout)) {
-		line_length = MAX_PIXELS_PER_LINE;
-		ctop = (pix->height - crop->height) - crop->top;
-		cleft = (pix->width - crop->width) - crop->left;
-	} else {
-		line_length = pix->width;
-	}
-	vout->line_length = line_length;
-	switch (rotation) {
-	case dss_rotation_90_degree:
-		offset = vout->vrfb_context[0].yoffset *
-			vout->vrfb_context[0].bytespp;
-		temp_ps = ps / vr_ps;
-		if (mirroring == 0) {
-			*cropped_offset = offset + line_length *
-				temp_ps * cleft + crop->top * temp_ps;
-		} else {
-			*cropped_offset = offset + line_length * temp_ps *
-				cleft + crop->top * temp_ps + (line_length *
-				((crop->width / (vr_ps)) - 1) * ps);
-		}
-		break;
-	case dss_rotation_180_degree:
-		offset = ((MAX_PIXELS_PER_LINE * vout->vrfb_context[0].yoffset *
-			vout->vrfb_context[0].bytespp) +
-			(vout->vrfb_context[0].xoffset *
-			vout->vrfb_context[0].bytespp));
-		if (mirroring == 0) {
-			*cropped_offset = offset + (line_length * ps * ctop) +
-				(cleft / vr_ps) * ps;
+		else if (V4L2_PIX_FMT_RGB24 == pix->pixelformat)
+			ps = 3;
 
-		} else {
-			*cropped_offset = offset + (line_length * ps * ctop) +
-				(cleft / vr_ps) * ps + (line_length *
-				(crop->height - 1) * ps);
-		}
-		break;
-	case dss_rotation_270_degree:
-		offset = MAX_PIXELS_PER_LINE * vout->vrfb_context[0].xoffset *
-			vout->vrfb_context[0].bytespp;
-		temp_ps = ps / vr_ps;
-		if (mirroring == 0) {
-			*cropped_offset = offset + line_length *
-			    temp_ps * crop->left + ctop * ps;
-		} else {
-			*cropped_offset = offset + line_length *
-				temp_ps * crop->left + ctop * ps +
-				(line_length * ((crop->width / vr_ps) - 1) *
-				 ps);
-		}
-		break;
-	case dss_rotation_0_degree:
-		if (mirroring == 0) {
-			*cropped_offset = (line_length * ps) *
-				crop->top + (crop->left / vr_ps) * ps;
-		} else {
-			*cropped_offset = (line_length * ps) *
-				crop->top + (crop->left / vr_ps) * ps +
-				(line_length * (crop->height - 1) * ps);
-		}
-		break;
-	default:
-		*cropped_offset = (line_length * ps * crop->top) /
-			vr_ps + (crop->left * ps) / vr_ps +
-			((crop->width / vr_ps) - 1) * ps;
-		break;
+		vout->ps = ps;
+
+		*cropped_offset = (line_length * ps) *
+			crop->top + crop->left * ps;
 	}
+
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "%s Offset:%x\n",
-			__func__, *cropped_offset);
+			__func__, vout->cropped_offset);
+
 	return 0;
 }
 
@@ -845,6 +652,7 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	int startindex = 0, i, j;
 	u32 phy_addr = 0, virt_addr = 0;
 	struct omap_vout_device *vout = q->priv_data;
+	struct omapvideo_info *ovid = &vout->vid_info;
 
 	if (!vout)
 		return -EINVAL;
@@ -857,13 +665,10 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	if (V4L2_MEMORY_MMAP == vout->memory && *count < startindex)
 		*count = startindex;
 
-	if ((is_rotation_enabled(vout)) && *count > VRFB_NUM_BUFS)
-		*count = VRFB_NUM_BUFS;
-
-	/* If rotation is enabled, allocate memory for VRFB space also */
-	if (is_rotation_enabled(vout))
+	if (ovid->rotation_type == VOUT_ROT_VRFB) {
 		if (omap_vout_vrfb_buffer_setup(vout, count, startindex))
 			return -ENOMEM;
+	}
 
 	if (V4L2_MEMORY_MMAP != vout->memory)
 		return 0;
@@ -879,8 +684,11 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		virt_addr = omap_vout_alloc_buffer(vout->buffer_size,
 				&phy_addr);
 		if (!virt_addr) {
-			if (!is_rotation_enabled(vout))
+			if (ovid->rotation_type == VOUT_ROT_NONE) {
 				break;
+			} else {
+				if (!is_rotation_enabled(vout))
+					break;
 			/* Free the VRFB buffers if no space for V4L2 buffers */
 			for (j = i; j < *count; j++) {
 				omap_vout_free_buffer(
@@ -888,6 +696,7 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 						vout->smsshado_size);
 				vout->smsshado_virt_addr[j] = 0;
 				vout->smsshado_phy_addr[j] = 0;
+				}
 			}
 		}
 		vout->buf_virt_addr[i] = virt_addr;
@@ -900,9 +709,9 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 
 /*
  * Free the V4L2 buffers additionally allocated than default
- * number of buffers and free all the VRFB buffers
+ * number of buffers
  */
-static void omap_vout_free_allbuffers(struct omap_vout_device *vout)
+static void omap_vout_free_extra_buffers(struct omap_vout_device *vout)
 {
 	int num_buffers = 0, i;
 
@@ -917,20 +726,6 @@ static void omap_vout_free_allbuffers(struct omap_vout_device *vout)
 		vout->buf_virt_addr[i] = 0;
 		vout->buf_phy_addr[i] = 0;
 	}
-	/* Free the VRFB buffers only if they are allocated
-	 * during reqbufs.  Don't free if init time allocated
-	 */
-	if (!vout->vrfb_static_allocation) {
-		for (i = 0; i < VRFB_NUM_BUFS; i++) {
-			if (vout->smsshado_virt_addr[i]) {
-				omap_vout_free_buffer(
-						vout->smsshado_virt_addr[i],
-						vout->smsshado_size);
-				vout->smsshado_virt_addr[i] = 0;
-				vout->smsshado_phy_addr[i] = 0;
-			}
-		}
-	}
 	vout->buffer_allocated = num_buffers;
 }
 
@@ -942,16 +737,11 @@ static void omap_vout_free_allbuffers(struct omap_vout_device *vout)
  * buffer into VRFB memory space before giving it to the DSS.
  */
 static int omap_vout_buffer_prepare(struct videobuf_queue *q,
-			    struct videobuf_buffer *vb,
-			    enum v4l2_field field)
+			struct videobuf_buffer *vb,
+			enum v4l2_field field)
 {
-	dma_addr_t dmabuf;
-	struct vid_vrfb_dma *tx;
-	enum dss_rotation rotation;
 	struct omap_vout_device *vout = q->priv_data;
-	u32 dest_frame_index = 0, src_element_index = 0;
-	u32 dest_element_index = 0, src_frame_index = 0;
-	u32 elem_count = 0, frame_count = 0, pixsize = 2;
+	struct omapvideo_info *ovid = &vout->vid_info;
 
 	if (VIDEOBUF_NEEDS_INIT == vb->state) {
 		vb->width = vout->pix.width;
@@ -973,63 +763,10 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
 	}
 
-	if (!is_rotation_enabled(vout))
+	if (ovid->rotation_type == VOUT_ROT_VRFB)
+		return omap_vout_prepare_vrfb(vout, vb);
+	else
 		return 0;
-
-	dmabuf = vout->buf_phy_addr[vb->i];
-	/* If rotation is enabled, copy input buffer into VRFB
-	 * memory space using DMA. We are copying input buffer
-	 * into VRFB memory space of desired angle and DSS will
-	 * read image VRFB memory for 0 degree angle
-	 */
-	pixsize = vout->bpp * vout->vrfb_bpp;
-	/*
-	 * DMA transfer in double index mode
-	 */
-
-	/* Frame index */
-	dest_frame_index = ((MAX_PIXELS_PER_LINE * pixsize) -
-			(vout->pix.width * vout->bpp)) + 1;
-
-	/* Source and destination parameters */
-	src_element_index = 0;
-	src_frame_index = 0;
-	dest_element_index = 1;
-	/* Number of elements per frame */
-	elem_count = vout->pix.width * vout->bpp;
-	frame_count = vout->pix.height;
-	tx = &vout->vrfb_dma_tx;
-	tx->tx_status = 0;
-	omap_set_dma_transfer_params(tx->dma_ch, OMAP_DMA_DATA_TYPE_S32,
-			(elem_count / 4), frame_count, OMAP_DMA_SYNC_ELEMENT,
-			tx->dev_id, 0x0);
-	/* src_port required only for OMAP1 */
-	omap_set_dma_src_params(tx->dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
-			dmabuf, src_element_index, src_frame_index);
-	/*set dma source burst mode for VRFB */
-	omap_set_dma_src_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
-	rotation = calc_rotation(vout);
-
-	/* dest_port required only for OMAP1 */
-	omap_set_dma_dest_params(tx->dma_ch, 0, OMAP_DMA_AMODE_DOUBLE_IDX,
-			vout->vrfb_context[vb->i].paddr[0], dest_element_index,
-			dest_frame_index);
-	/*set dma dest burst mode for VRFB */
-	omap_set_dma_dest_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
-	omap_dma_set_global_params(DMA_DEFAULT_ARB_RATE, 0x20, 0);
-
-	omap_start_dma(tx->dma_ch);
-	interruptible_sleep_on_timeout(&tx->wait, VRFB_TX_TIMEOUT);
-
-	if (tx->tx_status == 0) {
-		omap_stop_dma(tx->dma_ch);
-		return -EINVAL;
-	}
-	/* Store buffers physical address into an array. Addresses
-	 * from this array will be used to configure DSS */
-	vout->queued_buf_addr[vb->i] = (u8 *)
-		vout->vrfb_context[vb->i].paddr[rotation];
-	return 0;
 }
 
 /*
@@ -1173,7 +910,15 @@ static int omap_vout_release(struct file *file)
 				"Unable to apply changes\n");
 
 	/* Free all buffers */
-	omap_vout_free_allbuffers(vout);
+	omap_vout_free_extra_buffers(vout);
+
+	/* Free the VRFB buffers only if they are allocated
+	 * during reqbufs.  Don't free if init time allocated
+	 */
+	if (ovid->rotation_type == VOUT_ROT_VRFB) {
+		if (!vout->vrfb_static_allocation)
+			omap_vout_free_vrfb_buffers(vout);
+	}
 	videobuf_mmap_free(q);
 
 	/* Even if apply changes fails we should continue
@@ -1600,9 +1345,17 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 	switch (a->id) {
 	case V4L2_CID_ROTATE:
 	{
+		struct omapvideo_info *ovid;
 		int rotation = a->value;
 
+		ovid = &vout->vid_info;
+
 		mutex_lock(&vout->lock);
+		if (rotation && ovid->rotation_type == VOUT_ROT_NONE) {
+			mutex_unlock(&vout->lock);
+			ret = -ERANGE;
+			break;
+		}
 
 		if (rotation && vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
 			mutex_unlock(&vout->lock);
@@ -1658,6 +1411,11 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 		ovl = ovid->overlays[0];
 
 		mutex_lock(&vout->lock);
+		if (mirror && ovid->rotation_type == VOUT_ROT_NONE) {
+			mutex_unlock(&vout->lock);
+			ret = -ERANGE;
+			break;
+		}
 
 		if (mirror  && vout->pix.pixelformat == V4L2_PIX_FMT_RGB24) {
 			mutex_unlock(&vout->lock);
@@ -2103,7 +1861,8 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	vout->mirror = 0;
 	vout->control[2].id = V4L2_CID_HFLIP;
 	vout->control[2].value = 0;
-	vout->vrfb_bpp = 2;
+	if (vout->vid_info.rotation_type == VOUT_ROT_VRFB)
+		vout->vrfb_bpp = 2;
 
 	control[1].id = V4L2_CID_BG_COLOR;
 	control[1].value = 0;
@@ -2135,17 +1894,15 @@ static int __init omap_vout_setup_video_bufs(struct platform_device *pdev,
 		int vid_num)
 {
 	u32 numbuffers;
-	int ret = 0, i, j;
-	int image_width, image_height;
-	struct video_device *vfd;
+	int ret = 0, i;
+	struct omapvideo_info *ovid;
 	struct omap_vout_device *vout;
-	int static_vrfb_allocation = 0, vrfb_num_bufs = VRFB_NUM_BUFS;
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
 	struct omap2video_device *vid_dev =
 		container_of(v4l2_dev, struct omap2video_device, v4l2_dev);
 
 	vout = vid_dev->vouts[vid_num];
-	vfd = vout->vfd;
+	ovid = &vout->vid_info;
 
 	numbuffers = (vid_num == 0) ? video1_numbuffers : video2_numbuffers;
 	vout->buffer_size = (vid_num == 0) ? video1_bufsize : video2_bufsize;
@@ -2162,66 +1919,16 @@ static int __init omap_vout_setup_video_bufs(struct platform_device *pdev,
 		}
 	}
 
-	for (i = 0; i < VRFB_NUM_BUFS; i++) {
-		if (omap_vrfb_request_ctx(&vout->vrfb_context[i])) {
-			dev_info(&pdev->dev, ": VRFB allocation failed\n");
-			for (j = 0; j < i; j++)
-				omap_vrfb_release_ctx(&vout->vrfb_context[j]);
-			ret = -ENOMEM;
-			goto free_buffers;
-		}
-	}
 	vout->cropped_offset = 0;
 
-	/* Calculate VRFB memory size */
-	/* allocate for worst case size */
-	image_width = VID_MAX_WIDTH / TILE_SIZE;
-	if (VID_MAX_WIDTH % TILE_SIZE)
-		image_width++;
-
-	image_width = image_width * TILE_SIZE;
-	image_height = VID_MAX_HEIGHT / TILE_SIZE;
-
-	if (VID_MAX_HEIGHT % TILE_SIZE)
-		image_height++;
-
-	image_height = image_height * TILE_SIZE;
-	vout->smsshado_size = PAGE_ALIGN(image_width * image_height * 2 * 2);
-
-	/*
-	 * Request and Initialize DMA, for DMA based VRFB transfer
-	 */
-	vout->vrfb_dma_tx.dev_id = OMAP_DMA_NO_DEVICE;
-	vout->vrfb_dma_tx.dma_ch = -1;
-	vout->vrfb_dma_tx.req_status = DMA_CHAN_ALLOTED;
-	ret = omap_request_dma(vout->vrfb_dma_tx.dev_id, "VRFB DMA TX",
-			omap_vout_vrfb_dma_tx_callback,
-			(void *) &vout->vrfb_dma_tx, &vout->vrfb_dma_tx.dma_ch);
-	if (ret < 0) {
-		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
-		dev_info(&pdev->dev, ": failed to allocate DMA Channel for"
-				" video%d\n", vfd->minor);
-	}
-	init_waitqueue_head(&vout->vrfb_dma_tx.wait);
-
-	/* Allocate VRFB buffers if selected through bootargs */
-	static_vrfb_allocation = (vid_num == 0) ?
-		vid1_static_vrfb_alloc : vid2_static_vrfb_alloc;
-
-	/* statically allocated the VRFB buffer is done through
-	   commands line aruments */
-	if (static_vrfb_allocation) {
-		if (omap_vout_allocate_vrfb_buffers(vout, &vrfb_num_bufs, -1)) {
-			ret =  -ENOMEM;
-			goto release_vrfb_ctx;
-		}
-		vout->vrfb_static_allocation = 1;
+	if (ovid->rotation_type == VOUT_ROT_VRFB) {
+		int static_vrfb_allocation = (vid_num == 0) ?
+			vid1_static_vrfb_alloc : vid2_static_vrfb_alloc;
+		ret = omap_vout_setup_vrfb_bufs(pdev, vid_num,
+				static_vrfb_allocation);
 	}
-	return 0;
 
-release_vrfb_ctx:
-	for (j = 0; j < VRFB_NUM_BUFS; j++)
-		omap_vrfb_release_ctx(&vout->vrfb_context[j]);
+	return ret;
 
 free_buffers:
 	for (i = 0; i < numbuffers; i++) {
@@ -2264,6 +1971,10 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		vout->vid_info.num_overlays = 1;
 		vout->vid_info.id = k + 1;
 
+		/* Set VRFB as rotation_type for omap2 and omap3 */
+		if (cpu_is_omap24xx() || cpu_is_omap34xx())
+			vout->vid_info.rotation_type = VOUT_ROT_VRFB;
+
 		/* Setup the default configuration for the video devices
 		 */
 		if (omap_vout_setup_video_data(vout) != 0) {
@@ -2297,7 +2008,8 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 			goto success;
 
 error2:
-		omap_vout_release_vrfb(vout);
+		if (vout->vid_info.rotation_type == VOUT_ROT_VRFB)
+			omap_vout_release_vrfb(vout);
 		omap_vout_free_buffers(vout);
 error1:
 		video_device_release(vfd);
@@ -2318,11 +2030,13 @@ success:
 static void omap_vout_cleanup_device(struct omap_vout_device *vout)
 {
 	struct video_device *vfd;
+	struct omapvideo_info *ovid;
 
 	if (!vout)
 		return;
 
 	vfd = vout->vfd;
+	ovid = &vout->vid_info;
 	if (vfd) {
 		if (!video_is_registered(vfd)) {
 			/*
@@ -2338,14 +2052,15 @@ static void omap_vout_cleanup_device(struct omap_vout_device *vout)
 			video_unregister_device(vfd);
 		}
 	}
-
-	omap_vout_release_vrfb(vout);
+	if (ovid->rotation_type == VOUT_ROT_VRFB) {
+		omap_vout_release_vrfb(vout);
+		/* Free the VRFB buffer if allocated
+		 * init time
+		 */
+		if (vout->vrfb_static_allocation)
+			omap_vout_free_vrfb_buffers(vout);
+	}
 	omap_vout_free_buffers(vout);
-	/* Free the VRFB buffer if allocated
-	 * init time
-	 */
-	if (vout->vrfb_static_allocation)
-		omap_vout_free_vrfb_buffers(vout);
 
 	kfree(vout);
 }
diff --git a/drivers/media/video/omap/omap_vout_vrfb.c b/drivers/media/video/omap/omap_vout_vrfb.c
new file mode 100644
index 0000000..ebebcac
--- /dev/null
+++ b/drivers/media/video/omap/omap_vout_vrfb.c
@@ -0,0 +1,390 @@
+/*
+ * omap_vout_vrfb.c
+ *
+ * Copyright (C) 2010 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#include <linux/sched.h>
+#include <linux/platform_device.h>
+#include <linux/videodev2.h>
+
+#include <media/videobuf-dma-contig.h>
+#include <media/v4l2-device.h>
+
+#include <plat/dma.h>
+#include <plat/vrfb.h>
+
+#include "omap_voutdef.h"
+#include "omap_voutlib.h"
+
+/*
+ * Function for allocating video buffers
+ */
+static int omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
+		unsigned int *count, int startindex)
+{
+	int i, j;
+
+	for (i = 0; i < *count; i++) {
+		if (!vout->smsshado_virt_addr[i]) {
+			vout->smsshado_virt_addr[i] =
+				omap_vout_alloc_buffer(vout->smsshado_size,
+						&vout->smsshado_phy_addr[i]);
+		}
+		if (!vout->smsshado_virt_addr[i] && startindex != -1) {
+			if (V4L2_MEMORY_MMAP == vout->memory && i >= startindex)
+				break;
+		}
+		if (!vout->smsshado_virt_addr[i]) {
+			for (j = 0; j < i; j++) {
+				omap_vout_free_buffer(
+						vout->smsshado_virt_addr[j],
+						vout->smsshado_size);
+				vout->smsshado_virt_addr[j] = 0;
+				vout->smsshado_phy_addr[j] = 0;
+			}
+			*count = 0;
+			return -ENOMEM;
+		}
+		memset((void *) vout->smsshado_virt_addr[i], 0,
+				vout->smsshado_size);
+	}
+	return 0;
+}
+
+/*
+ * Wakes up the application once the DMA transfer to VRFB space is completed.
+ */
+static void omap_vout_vrfb_dma_tx_callback(int lch, u16 ch_status, void *data)
+{
+	struct vid_vrfb_dma *t = (struct vid_vrfb_dma *) data;
+
+	t->tx_status = 1;
+	wake_up_interruptible(&t->wait);
+}
+
+/*
+ * Free VRFB buffers
+ */
+void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout)
+{
+	int j;
+
+	for (j = 0; j < VRFB_NUM_BUFS; j++) {
+		omap_vout_free_buffer(vout->smsshado_virt_addr[j],
+				vout->smsshado_size);
+		vout->smsshado_virt_addr[j] = 0;
+		vout->smsshado_phy_addr[j] = 0;
+	}
+}
+
+int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
+			u32 static_vrfb_allocation)
+{
+	int ret = 0, i, j;
+	struct omap_vout_device *vout;
+	struct video_device *vfd;
+	int image_width, image_height;
+	int vrfb_num_bufs = VRFB_NUM_BUFS;
+	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
+	struct omap2video_device *vid_dev =
+		container_of(v4l2_dev, struct omap2video_device, v4l2_dev);
+
+	vout = vid_dev->vouts[vid_num];
+	vfd = vout->vfd;
+
+	for (i = 0; i < VRFB_NUM_BUFS; i++) {
+		if (omap_vrfb_request_ctx(&vout->vrfb_context[i])) {
+			dev_info(&pdev->dev, ": VRFB allocation failed\n");
+			for (j = 0; j < i; j++)
+				omap_vrfb_release_ctx(&vout->vrfb_context[j]);
+			ret = -ENOMEM;
+			goto free_buffers;
+		}
+	}
+
+	/* Calculate VRFB memory size */
+	/* allocate for worst case size */
+	image_width = VID_MAX_WIDTH / TILE_SIZE;
+	if (VID_MAX_WIDTH % TILE_SIZE)
+		image_width++;
+
+	image_width = image_width * TILE_SIZE;
+	image_height = VID_MAX_HEIGHT / TILE_SIZE;
+
+	if (VID_MAX_HEIGHT % TILE_SIZE)
+		image_height++;
+
+	image_height = image_height * TILE_SIZE;
+	vout->smsshado_size = PAGE_ALIGN(image_width * image_height * 2 * 2);
+
+	/*
+	 * Request and Initialize DMA, for DMA based VRFB transfer
+	 */
+	vout->vrfb_dma_tx.dev_id = OMAP_DMA_NO_DEVICE;
+	vout->vrfb_dma_tx.dma_ch = -1;
+	vout->vrfb_dma_tx.req_status = DMA_CHAN_ALLOTED;
+	ret = omap_request_dma(vout->vrfb_dma_tx.dev_id, "VRFB DMA TX",
+			omap_vout_vrfb_dma_tx_callback,
+			(void *) &vout->vrfb_dma_tx, &vout->vrfb_dma_tx.dma_ch);
+	if (ret < 0) {
+		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
+		dev_info(&pdev->dev, ": failed to allocate DMA Channel for"
+				" video%d\n", vfd->minor);
+	}
+	init_waitqueue_head(&vout->vrfb_dma_tx.wait);
+
+	/* statically allocated the VRFB buffer is done through
+	   commands line aruments */
+	if (static_vrfb_allocation) {
+		if (omap_vout_allocate_vrfb_buffers(vout, &vrfb_num_bufs, -1)) {
+			ret =  -ENOMEM;
+			goto release_vrfb_ctx;
+		}
+		vout->vrfb_static_allocation = 1;
+	}
+	return 0;
+
+release_vrfb_ctx:
+	for (j = 0; j < VRFB_NUM_BUFS; j++)
+		omap_vrfb_release_ctx(&vout->vrfb_context[j]);
+free_buffers:
+	omap_vout_free_buffers(vout);
+
+	return ret;
+}
+
+/*
+ * Release the VRFB context once the module exits
+ */
+void omap_vout_release_vrfb(struct omap_vout_device *vout)
+{
+	int i;
+
+	for (i = 0; i < VRFB_NUM_BUFS; i++)
+		omap_vrfb_release_ctx(&vout->vrfb_context[i]);
+
+	if (vout->vrfb_dma_tx.req_status == DMA_CHAN_ALLOTED) {
+		vout->vrfb_dma_tx.req_status = DMA_CHAN_NOT_ALLOTED;
+		omap_free_dma(vout->vrfb_dma_tx.dma_ch);
+	}
+}
+
+/*
+ * Allocate the buffers for the VRFB space.  Data is copied from V4L2
+ * buffers to the VRFB buffers using the DMA engine.
+ */
+int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
+			  unsigned int *count, unsigned int startindex)
+{
+	int i;
+	bool yuv_mode;
+
+	if (!is_rotation_enabled(vout))
+		return 0;
+
+	/* If rotation is enabled, allocate memory for VRFB space also */
+	*count = *count > VRFB_NUM_BUFS ? VRFB_NUM_BUFS : *count;
+
+	/* Allocate the VRFB buffers only if the buffers are not
+	 * allocated during init time.
+	 */
+	if (!vout->vrfb_static_allocation)
+		if (omap_vout_allocate_vrfb_buffers(vout, count, startindex))
+			return -ENOMEM;
+
+	if (vout->dss_mode == OMAP_DSS_COLOR_YUV2 ||
+			vout->dss_mode == OMAP_DSS_COLOR_UYVY)
+		yuv_mode = true;
+	else
+		yuv_mode = false;
+
+	for (i = 0; i < *count; i++)
+		omap_vrfb_setup(&vout->vrfb_context[i],
+				vout->smsshado_phy_addr[i], vout->pix.width,
+				vout->pix.height, vout->bpp, yuv_mode);
+
+	return 0;
+}
+
+int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
+				struct videobuf_buffer *vb)
+{
+	dma_addr_t dmabuf;
+	struct vid_vrfb_dma *tx;
+	enum dss_rotation rotation;
+	u32 dest_frame_index = 0, src_element_index = 0;
+	u32 dest_element_index = 0, src_frame_index = 0;
+	u32 elem_count = 0, frame_count = 0, pixsize = 2;
+
+	if (!is_rotation_enabled(vout))
+		return 0;
+
+	dmabuf = vout->buf_phy_addr[vb->i];
+	/* If rotation is enabled, copy input buffer into VRFB
+	 * memory space using DMA. We are copying input buffer
+	 * into VRFB memory space of desired angle and DSS will
+	 * read image VRFB memory for 0 degree angle
+	 */
+	pixsize = vout->bpp * vout->vrfb_bpp;
+	/*
+	 * DMA transfer in double index mode
+	 */
+
+	/* Frame index */
+	dest_frame_index = ((MAX_PIXELS_PER_LINE * pixsize) -
+			(vout->pix.width * vout->bpp)) + 1;
+
+	/* Source and destination parameters */
+	src_element_index = 0;
+	src_frame_index = 0;
+	dest_element_index = 1;
+	/* Number of elements per frame */
+	elem_count = vout->pix.width * vout->bpp;
+	frame_count = vout->pix.height;
+	tx = &vout->vrfb_dma_tx;
+	tx->tx_status = 0;
+	omap_set_dma_transfer_params(tx->dma_ch, OMAP_DMA_DATA_TYPE_S32,
+			(elem_count / 4), frame_count, OMAP_DMA_SYNC_ELEMENT,
+			tx->dev_id, 0x0);
+	/* src_port required only for OMAP1 */
+	omap_set_dma_src_params(tx->dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
+			dmabuf, src_element_index, src_frame_index);
+	/*set dma source burst mode for VRFB */
+	omap_set_dma_src_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
+	rotation = calc_rotation(vout);
+
+	/* dest_port required only for OMAP1 */
+	omap_set_dma_dest_params(tx->dma_ch, 0, OMAP_DMA_AMODE_DOUBLE_IDX,
+			vout->vrfb_context[vb->i].paddr[0], dest_element_index,
+			dest_frame_index);
+	/*set dma dest burst mode for VRFB */
+	omap_set_dma_dest_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
+	omap_dma_set_global_params(DMA_DEFAULT_ARB_RATE, 0x20, 0);
+
+	omap_start_dma(tx->dma_ch);
+	interruptible_sleep_on_timeout(&tx->wait, VRFB_TX_TIMEOUT);
+
+	if (tx->tx_status == 0) {
+		omap_stop_dma(tx->dma_ch);
+		return -EINVAL;
+	}
+	/* Store buffers physical address into an array. Addresses
+	 * from this array will be used to configure DSS */
+	vout->queued_buf_addr[vb->i] = (u8 *)
+		vout->vrfb_context[vb->i].paddr[rotation];
+	return 0;
+}
+
+/*
+ * Calculate the buffer offsets from which the streaming should
+ * start. This offset calculation is mainly required because of
+ * the VRFB 32 pixels alignment with rotation.
+ */
+void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout)
+{
+	enum dss_rotation rotation;
+	bool mirroring = vout->mirror;
+	struct v4l2_rect *crop = &vout->crop;
+	struct v4l2_pix_format *pix = &vout->pix;
+	int *cropped_offset = &vout->cropped_offset;
+	int vr_ps = 1, ps = 2, temp_ps = 2;
+	int offset = 0, ctop = 0, cleft = 0, line_length = 0;
+
+	rotation = calc_rotation(vout);
+
+	if (V4L2_PIX_FMT_YUYV == pix->pixelformat ||
+			V4L2_PIX_FMT_UYVY == pix->pixelformat) {
+		if (is_rotation_enabled(vout)) {
+			/*
+			 * ps    - Actual pixel size for YUYV/UYVY for
+			 *         VRFB/Mirroring is 4 bytes
+			 * vr_ps - Virtually pixel size for YUYV/UYVY is
+			 *         2 bytes
+			 */
+			ps = 4;
+			vr_ps = 2;
+		} else {
+			ps = 2;	/* otherwise the pixel size is 2 byte */
+		}
+	} else if (V4L2_PIX_FMT_RGB32 == pix->pixelformat) {
+		ps = 4;
+	} else if (V4L2_PIX_FMT_RGB24 == pix->pixelformat) {
+		ps = 3;
+	}
+	vout->ps = ps;
+	vout->vr_ps = vr_ps;
+
+	if (is_rotation_enabled(vout)) {
+		line_length = MAX_PIXELS_PER_LINE;
+		ctop = (pix->height - crop->height) - crop->top;
+		cleft = (pix->width - crop->width) - crop->left;
+	} else {
+		line_length = pix->width;
+	}
+	vout->line_length = line_length;
+	switch (rotation) {
+	case dss_rotation_90_degree:
+		offset = vout->vrfb_context[0].yoffset *
+			vout->vrfb_context[0].bytespp;
+		temp_ps = ps / vr_ps;
+		if (mirroring == 0) {
+			*cropped_offset = offset + line_length *
+				temp_ps * cleft + crop->top * temp_ps;
+		} else {
+			*cropped_offset = offset + line_length * temp_ps *
+				cleft + crop->top * temp_ps + (line_length *
+				((crop->width / (vr_ps)) - 1) * ps);
+		}
+		break;
+	case dss_rotation_180_degree:
+		offset = ((MAX_PIXELS_PER_LINE * vout->vrfb_context[0].yoffset *
+			vout->vrfb_context[0].bytespp) +
+			(vout->vrfb_context[0].xoffset *
+			vout->vrfb_context[0].bytespp));
+		if (mirroring == 0) {
+			*cropped_offset = offset + (line_length * ps * ctop) +
+				(cleft / vr_ps) * ps;
+
+		} else {
+			*cropped_offset = offset + (line_length * ps * ctop) +
+				(cleft / vr_ps) * ps + (line_length *
+				(crop->height - 1) * ps);
+		}
+		break;
+	case dss_rotation_270_degree:
+		offset = MAX_PIXELS_PER_LINE * vout->vrfb_context[0].xoffset *
+			vout->vrfb_context[0].bytespp;
+		temp_ps = ps / vr_ps;
+		if (mirroring == 0) {
+			*cropped_offset = offset + line_length *
+			    temp_ps * crop->left + ctop * ps;
+		} else {
+			*cropped_offset = offset + line_length *
+				temp_ps * crop->left + ctop * ps +
+				(line_length * ((crop->width / vr_ps) - 1) *
+				 ps);
+		}
+		break;
+	case dss_rotation_0_degree:
+		if (mirroring == 0) {
+			*cropped_offset = (line_length * ps) *
+				crop->top + (crop->left / vr_ps) * ps;
+		} else {
+			*cropped_offset = (line_length * ps) *
+				crop->top + (crop->left / vr_ps) * ps +
+				(line_length * (crop->height - 1) * ps);
+		}
+		break;
+	default:
+		*cropped_offset = (line_length * ps * crop->top) /
+			vr_ps + (crop->left * ps) / vr_ps +
+			((crop->width / vr_ps) - 1) * ps;
+		break;
+	}
+}
diff --git a/drivers/media/video/omap/omap_vout_vrfb.h b/drivers/media/video/omap/omap_vout_vrfb.h
new file mode 100644
index 0000000..ffde741
--- /dev/null
+++ b/drivers/media/video/omap/omap_vout_vrfb.h
@@ -0,0 +1,40 @@
+/*
+ * omap_vout_vrfb.h
+ *
+ * Copyright (C) 2010 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ */
+
+#ifndef OMAP_VOUT_VRFB_H
+#define OMAP_VOUT_VRFB_H
+
+#ifdef CONFIG_VIDEO_OMAP2_VOUT_VRFB
+void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout);
+int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
+			u32 static_vrfb_allocation);
+void omap_vout_release_vrfb(struct omap_vout_device *vout);
+int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
+			unsigned int *count, unsigned int startindex);
+int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
+			struct videobuf_buffer *vb);
+void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout);
+#else
+void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout) { }
+int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
+			u32 static_vrfb_allocation)
+		{ return 0; }
+void omap_vout_release_vrfb(struct omap_vout_device *vout) { }
+int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
+			unsigned int *count, unsigned int startindex)
+		{ return 0; }
+int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
+			struct videobuf_buffer *vb)
+		{ return 0; }
+void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout) { }
+#endif
+
+#endif
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index 1ef3ed2..d793501 100644
--- a/drivers/media/video/omap/omap_voutdef.h
+++ b/drivers/media/video/omap/omap_voutdef.h
@@ -12,6 +12,7 @@
 #define OMAP_VOUTDEF_H
 
 #include <video/omapdss.h>
+#include <plat/vrfb.h>
 
 #define YUYV_BPP        2
 #define RGB565_BPP      2
@@ -62,6 +63,18 @@ enum dss_rotation {
 	dss_rotation_180_degree	= 2,
 	dss_rotation_270_degree = 3,
 };
+
+/* Enum for choosing rotation type for vout
+ * DSS2 doesn't understand no rotation as an
+ * option while V4L2 driver doesn't support
+ * rotation in the case where VRFB is not built in
+ * the kernel
+ */
+enum vout_rotaion_type {
+	VOUT_ROT_NONE	= 0,
+	VOUT_ROT_VRFB	= 1,
+};
+
 /*
  * This structure is used to store the DMA transfer parameters
  * for VRFB hidden buffer
@@ -78,6 +91,7 @@ struct omapvideo_info {
 	int id;
 	int num_overlays;
 	struct omap_overlay *overlays[MAX_OVLS];
+	enum vout_rotaion_type rotation_type;
 };
 
 struct omap2video_device {
@@ -206,4 +220,6 @@ static inline int calc_rotation(const struct omap_vout_device *vout)
 		return dss_rotation_180_degree;
 	}
 }
+
+void omap_vout_free_buffers(struct omap_vout_device *vout);
 #endif	/* ifndef OMAP_VOUTDEF_H */
-- 
1.7.1


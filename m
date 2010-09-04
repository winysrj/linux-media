Return-path: <mchehab@localhost>
Received: from comal.ext.ti.com ([198.47.26.152]:41470 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0IDIl2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Sep 2010 04:41:28 -0400
From: Archit Taneja <archit@ti.com>
To: hvaibhav@ti.com
Cc: linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 2/2] V4L/DVB: OMAP_VOUT: Use rotation_type to choose between vrfb and sdram rotation
Date: Sat,  4 Sep 2010 14:11:45 +0530
Message-Id: <1283589705-6723-3-git-send-email-archit@ti.com>
In-Reply-To: <1283589705-6723-1-git-send-email-archit@ti.com>
References: <1283589705-6723-1-git-send-email-archit@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Add "rotation_type" member to omapvideo_info, this is initialized based on
the value "def_vrfb" bootarg parameter, vrfb rotation is chosen by default.
The rotation_type var is now used to choose between vrfb and non-vrfb calls.

vrfb specific code in omap_vout has been removed and is present in omap_vout_vrfb.c

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/Kconfig        |    1 -
 drivers/media/video/omap/Makefile       |    1 +
 drivers/media/video/omap/omap_vout.c    |  470 ++++++-------------------------
 drivers/media/video/omap/omap_voutdef.h |    1 +
 4 files changed, 92 insertions(+), 381 deletions(-)

diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/video/omap/Kconfig
index e63233f..d554bfd
--- a/drivers/media/video/omap/Kconfig
+++ b/drivers/media/video/omap/Kconfig
@@ -5,7 +5,6 @@ config VIDEO_OMAP2_VOUT
 	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_DSS
 	select OMAP2_VRAM
-	select OMAP2_VRFB
 	default n
 	---help---
 	  V4L2 Display driver support for OMAP2/3 based boards.
diff --git a/drivers/media/video/omap/Makefile b/drivers/media/video/omap/Makefile
index b287880..bc47569
--- a/drivers/media/video/omap/Makefile
+++ b/drivers/media/video/omap/Makefile
@@ -5,3 +5,4 @@
 # OMAP2/3 Display driver
 omap-vout-y := omap_vout.o omap_voutlib.o
 obj-$(CONFIG_VIDEO_OMAP2_VOUT) += omap-vout.o
+obj-$(CONFIG_OMAP2_VRFB) += omap_vout_vrfb.o
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 46bc642..a10d1c4
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -51,6 +51,7 @@
 
 #include "omap_voutlib.h"
 #include "omap_voutdef.h"
+#include "omap_vout_vrfb.h"
 
 MODULE_AUTHOR("Texas Instruments");
 MODULE_DESCRIPTION("OMAP Video for Linux Video out driver");
@@ -82,6 +83,7 @@ static u32 video1_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
 static u32 video2_bufsize = OMAP_VOUT_MAX_BUF_SIZE;
 u32 vid1_static_vrfb_alloc;
 u32 vid2_static_vrfb_alloc;
+static int def_vrfb = 1;
 static int debug;
 
 /* Module parameters */
@@ -109,6 +111,10 @@ module_param(vid2_static_vrfb_alloc, bool, S_IRUGO);
 MODULE_PARM_DESC(vid2_static_vrfb_alloc,
 	"Static allocation of the VRFB buffer for video2 device");
 
+module_param(def_vrfb, bool, S_IRUGO);
+MODULE_PARM_DESC(def_vrfb,
+		"decide if vrfb is used for rotation");
+
 module_param(debug, bool, S_IRUGO);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
@@ -199,41 +205,6 @@ void omap_vout_free_buffer(unsigned long virtaddr, u32 buf_size)
 }
 
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
@@ -326,33 +297,6 @@ static u32 omap_vout_uservirt_to_phys(u32 virtp)
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
  * Return true if rotation is 90 or 270
  */
 int rotate_90_or_270(const struct omap_vout_device *vout)
@@ -409,52 +353,6 @@ void omap_vout_free_buffers(struct omap_vout_device *vout)
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
-	if ((rotation_enabled(vout)) && !vout->vrfb_static_allocation)
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
  *	Convert to 0, 1, 2 and 3 repsectively for DSS
@@ -483,124 +381,38 @@ static int v4l2_rot_to_dss_rot(int v4l2_rotation,
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
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB) {
+		omap_vout_calculate_vrfb_offset(vout);
+	} else {
+		vout->line_length = line_length = pix->width;
 
-	if (V4L2_PIX_FMT_YUYV == pix->pixelformat ||
-			V4L2_PIX_FMT_UYVY == pix->pixelformat) {
-		if (rotation_enabled(vout)) {
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
-	if (rotation_enabled(vout)) {
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
 
@@ -654,6 +466,7 @@ int omapvid_setup_overlay(struct omap_vout_device *vout,
 {
 	int ret = 0;
 	struct omap_overlay_info info;
+	struct omapvideo_info *ovid = &vout->vid_info;
 	int cropheight, cropwidth, pixheight, pixwidth;
 
 	if ((ovl->caps & OMAP_DSS_OVL_CAP_SCALE) == 0 &&
@@ -671,7 +484,8 @@ int omapvid_setup_overlay(struct omap_vout_device *vout,
 	/* Setup the input plane parameters according to
 	 * rotation value selected.
 	 */
-	if (rotate_90_or_270(vout)) {
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB &&
+			rotate_90_or_270(vout)) {
 		cropheight = vout->crop.width;
 		cropwidth = vout->crop.height;
 		pixheight = vout->pix.width;
@@ -695,14 +509,16 @@ int omapvid_setup_overlay(struct omap_vout_device *vout,
 	info.out_width = outw;
 	info.out_height = outh;
 	info.global_alpha = vout->win.global_alpha;
-	if (!rotation_enabled(vout)) {
-		info.rotation = 0;
-		info.rotation_type = OMAP_DSS_ROT_DMA;
-		info.screen_width = pixwidth;
-	} else {
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB &&
+			rotation_enabled(vout)) {
 		info.rotation = vout->rotation;
-		info.rotation_type = OMAP_DSS_ROT_VRFB;
+		info.rotation_type = ovid->rotation_type;
 		info.screen_width = 2048;
+
+	} else {
+		info.rotation = vout->rotation;
+		info.rotation_type = ovid->rotation_type;
+		info.screen_width = pixwidth;
 	}
 
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
@@ -938,6 +754,7 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	int startindex = 0, i, j;
 	u32 phy_addr = 0, virt_addr = 0;
 	struct omap_vout_device *vout = q->priv_data;
+	struct omapvideo_info *ovid = &vout->vid_info;
 
 	if (!vout)
 		return -EINVAL;
@@ -950,13 +767,10 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	if (V4L2_MEMORY_MMAP == vout->memory && *count < startindex)
 		*count = startindex;
 
-	if ((rotation_enabled(vout)) && *count > VRFB_NUM_BUFS)
-		*count = VRFB_NUM_BUFS;
-
-	/* If rotation is enabled, allocate memory for VRFB space also */
-	if (rotation_enabled(vout))
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB) {
 		if (omap_vout_vrfb_buffer_setup(vout, count, startindex))
 			return -ENOMEM;
+	}
 
 	if (V4L2_MEMORY_MMAP != vout->memory)
 		return 0;
@@ -972,8 +786,11 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		virt_addr = omap_vout_alloc_buffer(vout->buffer_size,
 				&phy_addr);
 		if (!virt_addr) {
-			if (!rotation_enabled(vout))
+			if (ovid->rotation_type == OMAP_DSS_ROT_DMA) {
 				break;
+			} else {
+				if (!rotation_enabled(vout))
+					break;
 			/* Free the VRFB buffers if no space for V4L2 buffers */
 			for (j = i; j < *count; j++) {
 				omap_vout_free_buffer(
@@ -981,6 +798,7 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 						vout->smsshado_size);
 				vout->smsshado_virt_addr[j] = 0;
 				vout->smsshado_phy_addr[j] = 0;
+				}
 			}
 		}
 		vout->buf_virt_addr[i] = virt_addr;
@@ -993,9 +811,9 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 
 /*
  * Free the V4L2 buffers additionally allocated than default
- * number of buffers and free all the VRFB buffers
+ * number of buffers
  */
-static void omap_vout_free_allbuffers(struct omap_vout_device *vout)
+static void omap_vout_free_extra_buffers(struct omap_vout_device *vout)
 {
 	int num_buffers = 0, i;
 
@@ -1010,20 +828,6 @@ static void omap_vout_free_allbuffers(struct omap_vout_device *vout)
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
 
@@ -1035,16 +839,11 @@ static void omap_vout_free_allbuffers(struct omap_vout_device *vout)
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
@@ -1066,63 +865,10 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
 	}
 
-	if (!rotation_enabled(vout))
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB)
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
@@ -1266,7 +1012,9 @@ static int omap_vout_release(struct file *file)
 				"Unable to apply changes\n");
 
 	/* Free all buffers */
-	omap_vout_free_allbuffers(vout);
+	omap_vout_free_extra_buffers(vout);
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB)
+		omap_vout_free_extra_vrfb_buffers(vout);
 	videobuf_mmap_free(q);
 
 	/* Even if apply changes fails we should continue
@@ -1425,7 +1173,8 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
 
 	/* We dont support RGB24-packed mode if vrfb rotation
 	 * is enabled*/
-	if ((rotation_enabled(vout)) &&
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB &&
+			(rotation_enabled(vout)) &&
 			f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB24) {
 		ret = -EINVAL;
 		goto s_fmt_vid_out_exit;
@@ -1433,7 +1182,8 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
 
 	/* get the framebuffer parameters */
 
-	if (rotate_90_or_270(vout)) {
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB &&
+			rotate_90_or_270(vout)) {
 		vout->fbuf.fmt.height = timing->x_res;
 		vout->fbuf.fmt.width = timing->y_res;
 	} else {
@@ -1613,7 +1363,8 @@ static int vidioc_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	/* get the display device attached to the overlay */
 	timing = &ovl->manager->device->panel.timings;
 
-	if (rotate_90_or_270(vout)) {
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB &&
+			rotate_90_or_270(vout)) {
 		vout->fbuf.fmt.height = timing->x_res;
 		vout->fbuf.fmt.width = timing->y_res;
 	} else {
@@ -1847,6 +1598,7 @@ static int vidioc_qbuf(struct file *file, void *fh,
 			struct v4l2_buffer *buffer)
 {
 	struct omap_vout_device *vout = fh;
+	struct omapvideo_info *ovid = &vout->vid_info;
 	struct videobuf_queue *q = &vout->vbq;
 
 	if ((V4L2_BUF_TYPE_VIDEO_OUTPUT != buffer->type) ||
@@ -1861,7 +1613,8 @@ static int vidioc_qbuf(struct file *file, void *fh,
 		}
 	}
 
-	if ((rotation_enabled(vout)) &&
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB &&
+			(rotation_enabled(vout)) &&
 			vout->vrfb_dma_tx.req_status == DMA_CHAN_NOT_ALLOTED) {
 		v4l2_warn(&vout->vid_dev->v4l2_dev,
 				"DMA Channel not allocated for Rotation\n");
@@ -2196,7 +1949,8 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	vout->mirror = 0;
 	vout->control[2].id = V4L2_CID_HFLIP;
 	vout->control[2].value = 0;
-	vout->vrfb_bpp = 2;
+	if (vout->vid_info.rotation_type == OMAP_DSS_ROT_VRFB)
+		vout->vrfb_bpp = 2;
 
 	control[1].id = V4L2_CID_BG_COLOR;
 	control[1].value = 0;
@@ -2229,17 +1983,15 @@ static int __init omap_vout_setup_video_bufs(struct platform_device *pdev,
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
@@ -2256,67 +2008,13 @@ static int __init omap_vout_setup_video_bufs(struct platform_device *pdev,
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
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB)
+		return omap_vout_setup_vrfb_bufs(pdev, vid_num);
 
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
-	}
 	return 0;
 
-release_vrfb_ctx:
-	for (j = 0; j < VRFB_NUM_BUFS; j++)
-		omap_vrfb_release_ctx(&vout->vrfb_context[j]);
-
 free_buffers:
 	for (i = 0; i < numbuffers; i++) {
 		omap_vout_free_buffer(vout->buf_virt_addr[i],
@@ -2357,6 +2055,8 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 			vout->vid_info.overlays[0] = vid_dev->overlays[k + 1];
 		vout->vid_info.num_overlays = 1;
 		vout->vid_info.id = k + 1;
+		vout->vid_info.rotation_type = def_vrfb ? OMAP_DSS_ROT_VRFB :
+			OMAP_DSS_ROT_DMA;
 
 		/* Setup the default configuration for the video devices
 		 */
@@ -2391,7 +2091,8 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 			goto success;
 
 error2:
-		omap_vout_release_vrfb(vout);
+		if (vout->vid_info.rotation_type == OMAP_DSS_ROT_VRFB)
+			omap_vout_release_vrfb(vout);
 		omap_vout_free_buffers(vout);
 error1:
 		video_device_release(vfd);
@@ -2412,11 +2113,13 @@ success:
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
@@ -2432,14 +2135,15 @@ static void omap_vout_cleanup_device(struct omap_vout_device *vout)
 			video_unregister_device(vfd);
 		}
 	}
-
-	omap_vout_release_vrfb(vout);
+	if (ovid->rotation_type == OMAP_DSS_ROT_VRFB) {
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
@@ -2478,6 +2182,12 @@ static int __init omap_vout_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (def_vrfb && (!cpu_is_omap24xx()) && (!cpu_is_omap34xx())) {
+		def_vrfb = 0;
+		dev_warn(&pdev->dev, "VRFB is not in this device,"
+			"using DMA for rotation\n");
+	}
+
 	vid_dev = kzalloc(sizeof(struct omap2video_device), GFP_KERNEL);
 	if (vid_dev == NULL)
 		return -ENOMEM;
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index 7dae075..d6cfb0b
--- a/drivers/media/video/omap/omap_voutdef.h
+++ b/drivers/media/video/omap/omap_voutdef.h
@@ -71,6 +71,7 @@ struct omapvideo_info {
 	int id;
 	int num_overlays;
 	struct omap_overlay *overlays[MAX_OVLS];
+	enum omap_dss_rotation_type rotation_type;
 };
 
 struct omap2video_device {
-- 
1.7.0.4


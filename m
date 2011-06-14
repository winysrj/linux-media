Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:37112 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab1FNGrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 02:47:48 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id p5E6lmZA002382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:48 -0500
Received: from dlep26.itg.ti.com (smtp-le.itg.ti.com [157.170.170.27])
	by dlep35.itg.ti.com (8.13.7/8.13.8) with ESMTP id p5E6llQe008426
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:47 -0500 (CDT)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p5E6llQu022179
	for <linux-media@vger.kernel.org>; Tue, 14 Jun 2011 01:47:47 -0500 (CDT)
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>
Subject: [PATCH v2 2/3] OMAP_VOUT: CLEANUP: Make rotation related helper functions more descriptive
Date: Tue, 14 Jun 2011 12:24:46 +0530
Message-ID: <1308034487-11852-3-git-send-email-archit@ti.com>
In-Reply-To: <1308034487-11852-1-git-send-email-archit@ti.com>
References: <1308034487-11852-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Rename rotation_enabled() and rotate_90_or_270() to is_rotation_enabled()
and is_rotation_90_or_270() to make them more descriptive.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c    |   26 +++++++++++++-------------
 drivers/media/video/omap/omap_voutdef.h |    4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 1d4112b..c29d1cb 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -343,7 +343,7 @@ static int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
 	/* Allocate the VRFB buffers only if the buffers are not
 	 * allocated during init time.
 	 */
-	if ((rotation_enabled(vout)) && !vout->vrfb_static_allocation)
+	if ((is_rotation_enabled(vout)) && !vout->vrfb_static_allocation)
 		if (omap_vout_allocate_vrfb_buffers(vout, count, startindex))
 			return -ENOMEM;
 
@@ -419,7 +419,7 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 
 	if (V4L2_PIX_FMT_YUYV == pix->pixelformat ||
 			V4L2_PIX_FMT_UYVY == pix->pixelformat) {
-		if (rotation_enabled(vout)) {
+		if (is_rotation_enabled(vout)) {
 			/*
 			 * ps    - Actual pixel size for YUYV/UYVY for
 			 *         VRFB/Mirroring is 4 bytes
@@ -439,7 +439,7 @@ static int omap_vout_calculate_offset(struct omap_vout_device *vout)
 	vout->ps = ps;
 	vout->vr_ps = vr_ps;
 
-	if (rotation_enabled(vout)) {
+	if (is_rotation_enabled(vout)) {
 		line_length = MAX_PIXELS_PER_LINE;
 		ctop = (pix->height - crop->height) - crop->top;
 		cleft = (pix->width - crop->width) - crop->left;
@@ -578,7 +578,7 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
 	/* Setup the input plane parameters according to
 	 * rotation value selected.
 	 */
-	if (rotate_90_or_270(vout)) {
+	if (is_rotation_90_or_270(vout)) {
 		cropheight = vout->crop.width;
 		cropwidth = vout->crop.height;
 		pixheight = vout->pix.width;
@@ -602,7 +602,7 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
 	info.out_width = outw;
 	info.out_height = outh;
 	info.global_alpha = vout->win.global_alpha;
-	if (!rotation_enabled(vout)) {
+	if (!is_rotation_enabled(vout)) {
 		info.rotation = 0;
 		info.rotation_type = OMAP_DSS_ROT_DMA;
 		info.screen_width = pixwidth;
@@ -857,11 +857,11 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	if (V4L2_MEMORY_MMAP == vout->memory && *count < startindex)
 		*count = startindex;
 
-	if ((rotation_enabled(vout)) && *count > VRFB_NUM_BUFS)
+	if ((is_rotation_enabled(vout)) && *count > VRFB_NUM_BUFS)
 		*count = VRFB_NUM_BUFS;
 
 	/* If rotation is enabled, allocate memory for VRFB space also */
-	if (rotation_enabled(vout))
+	if (is_rotation_enabled(vout))
 		if (omap_vout_vrfb_buffer_setup(vout, count, startindex))
 			return -ENOMEM;
 
@@ -879,7 +879,7 @@ static int omap_vout_buffer_setup(struct videobuf_queue *q, unsigned int *count,
 		virt_addr = omap_vout_alloc_buffer(vout->buffer_size,
 				&phy_addr);
 		if (!virt_addr) {
-			if (!rotation_enabled(vout))
+			if (!is_rotation_enabled(vout))
 				break;
 			/* Free the VRFB buffers if no space for V4L2 buffers */
 			for (j = i; j < *count; j++) {
@@ -973,7 +973,7 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
 	}
 
-	if (!rotation_enabled(vout))
+	if (!is_rotation_enabled(vout))
 		return 0;
 
 	dmabuf = vout->buf_phy_addr[vb->i];
@@ -1332,7 +1332,7 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
 
 	/* We dont support RGB24-packed mode if vrfb rotation
 	 * is enabled*/
-	if ((rotation_enabled(vout)) &&
+	if ((is_rotation_enabled(vout)) &&
 			f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB24) {
 		ret = -EINVAL;
 		goto s_fmt_vid_out_exit;
@@ -1340,7 +1340,7 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
 
 	/* get the framebuffer parameters */
 
-	if (rotate_90_or_270(vout)) {
+	if (is_rotation_90_or_270(vout)) {
 		vout->fbuf.fmt.height = timing->x_res;
 		vout->fbuf.fmt.width = timing->y_res;
 	} else {
@@ -1520,7 +1520,7 @@ static int vidioc_s_crop(struct file *file, void *fh, struct v4l2_crop *crop)
 	/* get the display device attached to the overlay */
 	timing = &ovl->manager->device->panel.timings;
 
-	if (rotate_90_or_270(vout)) {
+	if (is_rotation_90_or_270(vout)) {
 		vout->fbuf.fmt.height = timing->x_res;
 		vout->fbuf.fmt.width = timing->y_res;
 	} else {
@@ -1768,7 +1768,7 @@ static int vidioc_qbuf(struct file *file, void *fh,
 		}
 	}
 
-	if ((rotation_enabled(vout)) &&
+	if ((is_rotation_enabled(vout)) &&
 			vout->vrfb_dma_tx.req_status == DMA_CHAN_NOT_ALLOTED) {
 		v4l2_warn(&vout->vid_dev->v4l2_dev,
 				"DMA Channel not allocated for Rotation\n");
diff --git a/drivers/media/video/omap/omap_voutdef.h b/drivers/media/video/omap/omap_voutdef.h
index 31e6261..1ef3ed2 100644
--- a/drivers/media/video/omap/omap_voutdef.h
+++ b/drivers/media/video/omap/omap_voutdef.h
@@ -173,7 +173,7 @@ struct omap_vout_device {
 /*
  * Return true if rotation is 90 or 270
  */
-static inline int rotate_90_or_270(const struct omap_vout_device *vout)
+static inline int is_rotation_90_or_270(const struct omap_vout_device *vout)
 {
 	return (vout->rotation == dss_rotation_90_degree ||
 			vout->rotation == dss_rotation_270_degree);
@@ -182,7 +182,7 @@ static inline int rotate_90_or_270(const struct omap_vout_device *vout)
 /*
  * Return true if rotation is enabled
  */
-static inline int rotation_enabled(const struct omap_vout_device *vout)
+static inline int is_rotation_enabled(const struct omap_vout_device *vout)
 {
 	return vout->rotation || vout->mirror;
 }
-- 
1.7.1


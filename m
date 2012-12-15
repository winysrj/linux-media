Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:38668 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319Ab2LOJ75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:57 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH V3 09/15] [media] marvell-ccic: add get_mcam function for marvell-ccic driver
Date: Sat, 15 Dec 2012 17:57:58 +0800
Message-Id: <1355565484-15791-10-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds get_mcam() inline function which is prepared for
adding soc_camera support in marvell-ccic driver

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   27 ++++++++++++++---------
 drivers/media/platform/marvell-ccic/mcam-core.h |    5 +++++
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index c3c8873..9b5a5e9 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1057,7 +1057,7 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		unsigned int *num_planes, unsigned int sizes[],
 		void *alloc_ctxs[])
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = get_mcam(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
 	sizes[0] = cam->pix_format.sizeimage;
@@ -1073,14 +1073,17 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 static void mcam_vb_buf_queue(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	struct v4l2_pix_format *fmt = &cam->pix_format;
 	unsigned long flags;
 	int start;
 	dma_addr_t dma_handle;
+	unsigned long size;
 	u32 pixel_count = fmt->width * fmt->height;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
+	size = vb2_plane_size(vb, 0);
+	vb2_set_plane_payload(vb, 0, size);
 	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
 	BUG_ON(!dma_handle);
 	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
@@ -1121,14 +1124,14 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
  */
 static void mcam_vb_wait_prepare(struct vb2_queue *vq)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = get_mcam(vq);
 
 	mutex_unlock(&cam->s_mutex);
 }
 
 static void mcam_vb_wait_finish(struct vb2_queue *vq)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = get_mcam(vq);
 
 	mutex_lock(&cam->s_mutex);
 }
@@ -1138,9 +1141,12 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
  */
 static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = get_mcam(vq);
 	unsigned int frame;
 
+	if (count < 2)
+		return -EINVAL;
+
 	if (cam->state != S_IDLE) {
 		INIT_LIST_HEAD(&cam->buffers);
 		return -EINVAL;
@@ -1170,7 +1176,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = get_mcam(vq);
 	unsigned long flags;
 
 	if (cam->state == S_BUFWAIT) {
@@ -1181,6 +1187,7 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	if (cam->state != S_STREAMING)
 		return -EINVAL;
 	mcam_ctlr_stop_dma(cam);
+	cam->state = S_IDLE;
 	/*
 	 * Reset the CCIC PHY after stopping streaming,
 	 * otherwise, the CCIC may be unstable.
@@ -1216,7 +1223,7 @@ static const struct vb2_ops mcam_vb2_ops = {
 static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
 	mvb->dma_desc = dma_alloc_coherent(cam->dev,
@@ -1232,7 +1239,7 @@ static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
 	struct mcam_dma_desc *desc = mvb->dma_desc;
 	struct scatterlist *sg;
@@ -1252,7 +1259,7 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 
 static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
 
 	dma_unmap_sg(cam->dev, sgd->sglist, sgd->num_pages, DMA_FROM_DEVICE);
@@ -1261,7 +1268,7 @@ static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 
 static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 7db638f..3ea25ed 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -216,6 +216,11 @@ static inline void mcam_reg_set_bit(struct mcam_camera *cam,
 	mcam_reg_write_mask(cam, reg, val, val);
 }
 
+static inline struct mcam_camera *get_mcam(struct vb2_queue *vq)
+{
+	return vb2_get_drv_priv(vq);
+}
+
 /*
  * Functions for use by platform code.
  */
-- 
1.7.9.5


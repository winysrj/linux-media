Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:60091 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab2KWNec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 08:34:32 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH 09/15] [media] marvell-ccic: refine vb2_ops for marvell-ccic driver
Date: Fri, 23 Nov 2012 21:34:04 +0800
Message-Id: <1353677645-24251-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds buf_init and buf_cleanup callback in vb2_ops.
Also adds get_mcam() which is prepared for adding soc_camera support.

Signed-off-by: Libin Yang <lbyang@marvell.com>
Signed-off-by: Albert Wang <twang13@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   55 ++++++++++++++++++-----
 drivers/media/platform/marvell-ccic/mcam-core.h |    5 +++
 2 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 16da8ae..9a935a2 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -213,6 +213,7 @@ struct mcam_vb_buffer {
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
 	struct yuv_pointer_t yuv_p;
+	int list_init_flag;
 };
 
 static inline struct mcam_vb_buffer *vb_to_mvb(struct vb2_buffer *vb)
@@ -1058,7 +1059,7 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		unsigned int *num_planes, unsigned int sizes[],
 		void *alloc_ctxs[])
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = get_mcam(vq);
 	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
 
 	sizes[0] = cam->pix_format.sizeimage;
@@ -1074,14 +1075,17 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
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
 	u32 base_size = fmt->width * fmt->height;
 
 	spin_lock_irqsave(&cam->dev_lock, flags);
+	size = vb2_plane_size(vb, 0);
+	vb2_set_plane_payload(vb, 0, size);
 	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
 	BUG_ON(!dma_handle);
 	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
@@ -1117,14 +1121,14 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
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
@@ -1134,9 +1138,12 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
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
@@ -1166,7 +1173,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vq);
+	struct mcam_camera *cam = get_mcam(vq);
 	unsigned long flags;
 
 	if (cam->state == S_BUFWAIT) {
@@ -1177,6 +1184,7 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	if (cam->state != S_STREAMING)
 		return -EINVAL;
 	mcam_ctlr_stop_dma(cam);
+	cam->state = S_IDLE;
 	/*
 	 * Reset the CCIC PHY after stopping streaming,
 	 * otherwise, the CCIC may be unstable.
@@ -1192,10 +1200,37 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	return 0;
 }
 
+static void mcam_videobuf_cleanup(struct vb2_buffer *vb)
+{
+	struct mcam_vb_buffer *buf =
+		container_of(vb, struct mcam_vb_buffer, vb_buf);
+
+	/*
+	 * queue list must be initialized before del
+	 */
+	if (buf->list_init_flag)
+		list_del_init(&buf->queue);
+	buf->list_init_flag = 0;
+}
+
+/*
+ * only the list that queued could be initialized
+ */
+static int mcam_videobuf_init(struct vb2_buffer *vb)
+{
+	struct mcam_vb_buffer *buf =
+		container_of(vb, struct mcam_vb_buffer, vb_buf);
+
+	INIT_LIST_HEAD(&buf->queue);
+	buf->list_init_flag = 1;
+	return 0;
+}
 
 static const struct vb2_ops mcam_vb2_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_queue		= mcam_vb_buf_queue,
+	.buf_cleanup		= mcam_videobuf_cleanup,
+	.buf_init		= mcam_videobuf_init,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
 	.wait_prepare		= mcam_vb_wait_prepare,
@@ -1211,7 +1246,7 @@ static const struct vb2_ops mcam_vb2_ops = {
 static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
 	mvb->dma_desc = dma_alloc_coherent(cam->dev,
@@ -1227,7 +1262,7 @@ static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
 	struct mcam_dma_desc *desc = mvb->dma_desc;
 	struct scatterlist *sg;
@@ -1247,7 +1282,7 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 
 static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	struct vb2_dma_sg_desc *sgd = vb2_dma_sg_plane_desc(vb, 0);
 
 	dma_unmap_sg(cam->dev, sgd->sglist, sgd->num_pages, DMA_FROM_DEVICE);
@@ -1256,7 +1291,7 @@ static int mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
 
 static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 {
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
 	int ndesc = cam->pix_format.sizeimage/PAGE_SIZE + 1;
 
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 3f75d7d..47392f6 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -215,6 +215,11 @@ static inline void mcam_reg_set_bit(struct mcam_camera *cam,
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


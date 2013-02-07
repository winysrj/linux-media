Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:39241 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756713Ab3BGMGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:06:16 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [REVIEW PATCH V4 08/12] [media] marvell-ccic: rename B_DMA* to avoid CamelCase warning
Date: Thu,  7 Feb 2013 20:04:43 +0800
Message-Id: <1360238687-15768-9-git-send-email-twang13@marvell.com>
In-Reply-To: <1360238687-15768-1-git-send-email-twang13@marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch renames the B_vmalloc/B_DMA_contig/B_DMA_sg to
B_VMALLOC/B_DMA_CONTIG/B_DMA_SG variables to avoid CamelCase warning
reported by the checkpatch.pl script.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c   |   38 ++++++++++-----------
 drivers/media/platform/marvell-ccic/mcam-core.h   |   12 +++----
 drivers/media/platform/marvell-ccic/mmp-driver.c  |    2 +-
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index d030f9b..f85f119 100755
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -486,7 +486,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 	 * We *might* be able to run DMA_contig, especially on a system
 	 * with CMA in it.
 	 */
-	mcam->buffer_mode = B_vmalloc;
+	mcam->buffer_mode = B_VMALLOC;
 	/*
 	 * Get set up on the PCI bus.
 	 */
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 29c68f1..939c430 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -554,7 +554,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 }
 
 /*
- * Initial B_DMA_contig setup.
+ * Initial B_DMA_CONTIG setup.
  */
 static void mcam_ctlr_dma_contig(struct mcam_camera *cam)
 {
@@ -611,7 +611,7 @@ static void mcam_sg_next_buffer(struct mcam_camera *cam)
 }
 
 /*
- * Initial B_DMA_sg setup
+ * Initial B_DMA_SG setup
  */
 static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
 {
@@ -1005,7 +1005,7 @@ static int mcam_read_setup(struct mcam_camera *cam)
 	 * Configuration.  If we still don't have DMA buffers,
 	 * make one last, desperate attempt.
 	 */
-	if (cam->buffer_mode == B_vmalloc && cam->nbufs == 0 &&
+	if (cam->buffer_mode == B_VMALLOC && cam->nbufs == 0 &&
 			mcam_alloc_dma_bufs(cam, 0))
 		return -ENOMEM;
 
@@ -1051,13 +1051,13 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
 		void *alloc_ctxs[])
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vq);
-	int minbufs = (cam->buffer_mode == B_DMA_contig) ? 3 : 2;
+	int minbufs = (cam->buffer_mode == B_DMA_CONTIG) ? 3 : 2;
 
 	sizes[0] = cam->pix_format.sizeimage;
 	*num_planes = 1; /* Someday we have to support planar formats... */
 	if (*nbufs < minbufs)
 		*nbufs = minbufs;
-	if (cam->buffer_mode == B_DMA_contig)
+	if (cam->buffer_mode == B_DMA_CONTIG)
 		alloc_ctxs[0] = cam->vb_alloc_ctx;
 	return 0;
 }
@@ -1144,7 +1144,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 * destination.  So go into a wait state and hope they
 	 * give us buffers soon.
 	 */
-	if (cam->buffer_mode != B_vmalloc && list_empty(&cam->buffers)) {
+	if (cam->buffer_mode != B_VMALLOC && list_empty(&cam->buffers)) {
 		cam->state = S_BUFWAIT;
 		return 0;
 	}
@@ -1285,7 +1285,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	vq->drv_priv = cam;
 	INIT_LIST_HEAD(&cam->buffers);
 	switch (cam->buffer_mode) {
-	case B_DMA_contig:
+	case B_DMA_CONTIG:
 #ifdef MCAM_MODE_DMA_CONTIG
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_dma_contig_memops;
@@ -1295,7 +1295,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		cam->frame_complete = mcam_dma_contig_done;
 #endif
 		break;
-	case B_DMA_sg:
+	case B_DMA_SG:
 #ifdef MCAM_MODE_DMA_SG
 		vq->ops = &mcam_vb2_sg_ops;
 		vq->mem_ops = &vb2_dma_sg_memops;
@@ -1304,7 +1304,7 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 		cam->frame_complete = mcam_dma_sg_done;
 #endif
 		break;
-	case B_vmalloc:
+	case B_VMALLOC:
 #ifdef MCAM_MODE_VMALLOC
 		tasklet_init(&cam->s_tasklet, mcam_frame_tasklet,
 				(unsigned long) cam);
@@ -1324,7 +1324,7 @@ static void mcam_cleanup_vb2(struct mcam_camera *cam)
 {
 	vb2_queue_release(&cam->vb_queue);
 #ifdef MCAM_MODE_DMA_CONTIG
-	if (cam->buffer_mode == B_DMA_contig)
+	if (cam->buffer_mode == B_DMA_CONTIG)
 		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
 #endif
 }
@@ -1536,7 +1536,7 @@ static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 	/*
 	 * Make sure we have appropriate DMA buffers.
 	 */
-	if (cam->buffer_mode == B_vmalloc) {
+	if (cam->buffer_mode == B_VMALLOC) {
 		ret = mcam_check_dma_buffers(cam);
 		if (ret)
 			goto out;
@@ -1774,7 +1774,7 @@ static int mcam_v4l_release(struct file *filp)
 		mcam_cleanup_vb2(cam);
 		mcam_config_mipi(cam, 0);
 		mcam_ctlr_power_down(cam);
-		if (cam->buffer_mode == B_vmalloc && alloc_bufs_at_read)
+		if (cam->buffer_mode == B_VMALLOC && alloc_bufs_at_read)
 			mcam_free_dma_bufs(cam);
 	}
 	if (cam->bus_type == V4L2_MBUS_CSI2) {
@@ -1902,7 +1902,7 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 			mcam_frame_complete(cam, frame);
 			handled = 1;
 			clear_bit(CF_FRAME_SOF0 + frame, &cam->flags);
-			if (cam->buffer_mode == B_DMA_sg)
+			if (cam->buffer_mode == B_DMA_SG)
 				break;
 		}
 	/*
@@ -1919,7 +1919,7 @@ int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
 
 	if (handled == IRQ_HANDLED) {
 		set_bit(CF_DMA_ACTIVE, &cam->flags);
-		if (cam->buffer_mode == B_DMA_sg)
+		if (cam->buffer_mode == B_DMA_SG)
 			mcam_ctlr_stop(cam);
 	}
 	return handled;
@@ -1953,11 +1953,11 @@ int mccic_register(struct mcam_camera *cam)
 	 */
 	if (buffer_mode >= 0)
 		cam->buffer_mode = buffer_mode;
-	if (cam->buffer_mode == B_DMA_sg &&
+	if (cam->buffer_mode == B_DMA_SG &&
 			cam->chip_id == V4L2_IDENT_CAFE) {
 		printk(KERN_ERR "marvell-cam: Cafe can't do S/G I/O, "
 			"attempting vmalloc mode instead\n");
-		cam->buffer_mode = B_vmalloc;
+		cam->buffer_mode = B_VMALLOC;
 	}
 	if (!mcam_buffer_mode_supported(cam->buffer_mode)) {
 		printk(KERN_ERR "marvell-cam: buffer mode %d unsupported\n",
@@ -2010,7 +2010,7 @@ int mccic_register(struct mcam_camera *cam)
 	/*
 	 * If so requested, try to get our DMA buffers now.
 	 */
-	if (cam->buffer_mode == B_vmalloc && !alloc_bufs_at_read) {
+	if (cam->buffer_mode == B_VMALLOC && !alloc_bufs_at_read) {
 		if (mcam_alloc_dma_bufs(cam, 1))
 			cam_warn(cam, "Unable to alloc DMA buffers at load"
 					" will try again later.");
@@ -2038,7 +2038,7 @@ void mccic_shutdown(struct mcam_camera *cam)
 		mcam_ctlr_power_down(cam);
 	}
 	vb2_queue_release(&cam->vb_queue);
-	if (cam->buffer_mode == B_vmalloc)
+	if (cam->buffer_mode == B_VMALLOC)
 		mcam_free_dma_bufs(cam);
 	video_unregister_device(&cam->vdev);
 	v4l2_device_unregister(&cam->v4l2_dev);
@@ -2081,7 +2081,7 @@ int mccic_resume(struct mcam_camera *cam)
 		 * If there was a buffer in the DMA engine at suspend
 		 * time, put it back on the queue or we'll forget about it.
 		 */
-		if (cam->buffer_mode == B_DMA_sg && cam->vb_bufs[0])
+		if (cam->buffer_mode == B_DMA_SG && cam->vb_bufs[0])
 			list_add(&cam->vb_bufs[0]->queue, &cam->buffers);
 		ret = mcam_read_setup(cam);
 	}
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 692727d..263767e 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -47,9 +47,9 @@ enum mcam_state {
  * let the platform pick.
  */
 enum mcam_buffer_mode {
-	B_vmalloc = 0,
-	B_DMA_contig = 1,
-	B_DMA_sg = 2
+	B_VMALLOC = 0,
+	B_DMA_CONTIG = 1,
+	B_DMA_SG = 2
 };
 
 /*
@@ -59,13 +59,13 @@ static inline int mcam_buffer_mode_supported(enum mcam_buffer_mode mode)
 {
 	switch (mode) {
 #ifdef MCAM_MODE_VMALLOC
-	case B_vmalloc:
+	case B_VMALLOC:
 #endif
 #ifdef MCAM_MODE_DMA_CONTIG
-	case B_DMA_contig:
+	case B_DMA_CONTIG:
 #endif
 #ifdef MCAM_MODE_DMA_SG
-	case B_DMA_sg:
+	case B_DMA_SG:
 #endif
 		return 1;
 	default:
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index d355840..89dd078 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -365,7 +365,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->mipi_enabled = 0;
 	mcam->lane = pdata->lane;
 	mcam->chip_id = V4L2_IDENT_ARMADA610;
-	mcam->buffer_mode = B_DMA_sg;
+	mcam->buffer_mode = B_DMA_SG;
 	spin_lock_init(&mcam->dev_lock);
 	/*
 	 * Get our I/O memory.
-- 
1.7.9.5


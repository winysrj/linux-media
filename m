Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34959 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1GNUfx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 16:35:53 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/2] marvell-cam: Convert contiguous DMA to non-coherent
Date: Thu, 14 Jul 2011 14:35:11 -0600
Message-Id: <1310675711-39744-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1310675711-39744-1-git-send-email-corbet@lwn.net>
References: <1310675711-39744-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to the new non-coherent contiguous DMA option.  Non-coherent memory
is far more reliable to allocate and performs vastly better on this
platform.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/Kconfig     |    1 +
 drivers/media/video/marvell-ccic/mcam-core.c |   62 ++++++++++++++++++++------
 drivers/media/video/marvell-ccic/mcam-core.h |    2 +-
 3 files changed, 50 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/Kconfig b/drivers/media/video/marvell-ccic/Kconfig
index bf739e3..97ac1c5 100644
--- a/drivers/media/video/marvell-ccic/Kconfig
+++ b/drivers/media/video/marvell-ccic/Kconfig
@@ -15,6 +15,7 @@ config VIDEO_MMP_CAMERA
 	select VIDEO_OV7670
 	select I2C_GPIO
 	select VIDEOBUF2_DMA_SG
+	select VIDEOBUF2_DMA_NC
 	---help---
 	  This is a Video4Linux2 driver for the integrated camera
 	  controller found on Marvell Armada 610 application
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 83c1451..3d21208 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -25,7 +25,7 @@
 #include <media/v4l2-chip-ident.h>
 #include <media/ov7670.h>
 #include <media/videobuf2-vmalloc.h>
-#include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-dma-nc.h>
 #include <media/videobuf2-dma-sg.h>
 
 #include "mcam-core.h"
@@ -88,7 +88,7 @@ module_param(buffer_mode, int, 0444);
 MODULE_PARM_DESC(buffer_mode,
 		"Set the buffer mode to be used; default is to go with what "
 		"the platform driver asks for.  Set to 0 for vmalloc, 1 for "
-		"DMA contiguous.");
+		"DMA contiguous, 2 for scatter/gather.");
 
 /*
  * Status flags.  Always manipulated with bit operations.
@@ -183,6 +183,7 @@ struct mcam_dma_desc {
 struct mcam_vb_buffer {
 	struct vb2_buffer vb_buf;
 	struct list_head queue;
+	dma_addr_t buffer_pa;		/* Buffer physical addr (NC) */
 	struct mcam_dma_desc *dma_desc;	/* Descriptor virtual address */
 	dma_addr_t dma_desc_pa;		/* Descriptor physical address */
 	int dma_desc_nent;		/* Number of mapped descriptors */
@@ -450,7 +451,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 		buf = cam->vb_bufs[frame ^ 0x1];
 		cam->vb_bufs[frame] = buf;
 		mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
-				vb2_dma_contig_plane_paddr(&buf->vb_buf, 0));
+				buf->buffer_pa);
 		set_bit(CF_SINGLE_BUFFER, &cam->flags);
 		singles++;
 		return;
@@ -460,8 +461,7 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	 */
 	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
 	list_del_init(&buf->queue);
-	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
-			vb2_dma_contig_plane_paddr(&buf->vb_buf, 0));
+	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR, buf->buffer_pa);
 	cam->vb_bufs[frame] = buf;
 	clear_bit(CF_SINGLE_BUFFER, &cam->flags);
 }
@@ -984,7 +984,6 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 	return 0;
 }
 
-
 static const struct vb2_ops mcam_vb2_ops = {
 	.queue_setup		= mcam_vb_queue_setup,
 	.buf_queue		= mcam_vb_buf_queue,
@@ -995,6 +994,46 @@ static const struct vb2_ops mcam_vb2_ops = {
 };
 
 
+#ifdef MCAM_MODE_DMA_CONTIG
+
+static int mcam_vb_nc_buf_prepare(struct vb2_buffer *vb)
+{
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+
+	mvb->buffer_pa = dma_map_single(cam->dev, vb2_plane_vaddr(vb, 0),
+			cam->pix_format.sizeimage, DMA_FROM_DEVICE);
+	if (!mvb->buffer_pa)
+		return -EIO;
+	return 0;
+}
+
+static int mcam_vb_nc_buf_finish(struct vb2_buffer *vb)
+{
+	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
+	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
+
+	dma_unmap_single(cam->dev, mvb->buffer_pa, cam->pix_format.sizeimage,
+			DMA_FROM_DEVICE);
+	return 0;
+}
+
+static const struct vb2_ops mcam_vb2_nc_ops = {
+	.queue_setup		= mcam_vb_queue_setup,
+	.buf_queue		= mcam_vb_buf_queue,
+	.buf_prepare		= mcam_vb_nc_buf_prepare,
+	.buf_finish		= mcam_vb_nc_buf_finish,
+	.start_streaming	= mcam_vb_start_streaming,
+	.stop_streaming		= mcam_vb_stop_streaming,
+	.wait_prepare		= mcam_vb_wait_prepare,
+	.wait_finish		= mcam_vb_wait_finish,
+};
+
+
+#endif /* MCAM_MODE_DMA_CONTIG */
+
+
+
 #ifdef MCAM_MODE_DMA_SG
 /*
  * Scatter/gather mode uses all of the above functions plus a
@@ -1083,10 +1122,9 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 	switch (cam->buffer_mode) {
 	case B_DMA_contig:
 #ifdef MCAM_MODE_DMA_CONTIG
-		vq->ops = &mcam_vb2_ops;
-		vq->mem_ops = &vb2_dma_contig_memops;
-		cam->vb_alloc_ctx = vb2_dma_contig_init_ctx(cam->dev);
-		vq->io_modes = VB2_MMAP | VB2_USERPTR;
+		vq->ops = &mcam_vb2_nc_ops;
+		vq->mem_ops = &vb2_dma_nc_memops;
+		vq->io_modes = VB2_MMAP;
 		cam->dma_setup = mcam_ctlr_dma_contig;
 		cam->frame_complete = mcam_dma_contig_done;
 #endif
@@ -1119,10 +1157,6 @@ static int mcam_setup_vb2(struct mcam_camera *cam)
 static void mcam_cleanup_vb2(struct mcam_camera *cam)
 {
 	vb2_queue_release(&cam->vb_queue);
-#ifdef MCAM_MODE_DMA_CONTIG
-	if (cam->buffer_mode == B_DMA_contig)
-		vb2_dma_contig_cleanup_ctx(cam->vb_alloc_ctx);
-#endif
 }
 
 
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
index 917200e..76e8ff5 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.h
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -19,7 +19,7 @@
 #define MCAM_MODE_VMALLOC 1
 #endif
 
-#if defined(CONFIG_VIDEOBUF2_DMA_CONTIG) || defined(CONFIG_VIDEOBUF2_DMA_CONTIG_MODULE)
+#if defined(CONFIG_VIDEOBUF2_DMA_NC) || defined(CONFIG_VIDEOBUF2_DMA_NC_MODULE)
 #define MCAM_MODE_DMA_CONTIG 1
 #endif
 
-- 
1.7.6


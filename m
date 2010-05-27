Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37624 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0E0LR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 07:17:26 -0400
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m-karicheri2@ti.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/3] OMAP_VOUT:FIX:Replaced dma-sg with dma-contig
Date: Thu, 27 May 2010 16:47:08 +0530
Message-Id: <1274959029-5866-3-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Actually OMAP doesn't support scatter-gather DMA for
Display subsystem but due to legacy coding it has been overlooked
till now.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap/Kconfig     |    2 +-
 drivers/media/video/omap/omap_vout.c |   46 +++++++++++-----------------------
 2 files changed, 16 insertions(+), 32 deletions(-)

diff --git a/drivers/media/video/omap/Kconfig b/drivers/media/video/omap/Kconfig
index c1d1933..e63233f 100644
--- a/drivers/media/video/omap/Kconfig
+++ b/drivers/media/video/omap/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_OMAP2_VOUT
 	tristate "OMAP2/OMAP3 V4L2-Display driver"
 	depends on ARCH_OMAP2 || ARCH_OMAP3
 	select VIDEOBUF_GEN
-	select VIDEOBUF_DMA_SG
+	select VIDEOBUF_DMA_CONTIG
 	select OMAP2_DSS
 	select OMAP2_VRAM
 	select OMAP2_VRFB
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 08b2fb8..6914221 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -40,7 +40,7 @@
 #include <linux/videodev2.h>
 #include <linux/slab.h>
 
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf-dma-contig.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 
@@ -1054,9 +1054,9 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 			    struct videobuf_buffer *vb,
 			    enum v4l2_field field)
 {
+	dma_addr_t dmabuf;
 	struct vid_vrfb_dma *tx;
 	enum dss_rotation rotation;
-	struct videobuf_dmabuf *dmabuf = NULL;
 	struct omap_vout_device *vout = q->priv_data;
 	u32 dest_frame_index = 0, src_element_index = 0;
 	u32 dest_element_index = 0, src_frame_index = 0;
@@ -1075,24 +1075,17 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 	if (V4L2_MEMORY_USERPTR == vb->memory) {
 		if (0 == vb->baddr)
 			return -EINVAL;
-		/* Virtual address */
-		/* priv points to struct videobuf_pci_sg_memory. But we went
-		 * pointer to videobuf_dmabuf, which is member of
-		 * videobuf_pci_sg_memory */
-		dmabuf = videobuf_to_dma(q->bufs[vb->i]);
-		dmabuf->vmalloc = (void *) vb->baddr;
-
 		/* Physical address */
-		dmabuf->bus_addr =
-			(dma_addr_t) omap_vout_uservirt_to_phys(vb->baddr);
+		vout->queued_buf_addr[vb->i] = (u8 *)
+			omap_vout_uservirt_to_phys(vb->baddr);
+	} else {
+		vout->queued_buf_addr[vb->i] = (u8 *)vout->buf_phy_addr[vb->i];
 	}
 
-	if (!rotation_enabled(vout)) {
-		dmabuf = videobuf_to_dma(q->bufs[vb->i]);
-		vout->queued_buf_addr[vb->i] = (u8 *) dmabuf->bus_addr;
+	if (!rotation_enabled(vout))
 		return 0;
-	}
-	dmabuf = videobuf_to_dma(q->bufs[vb->i]);
+
+	dmabuf = vout->buf_phy_addr[vb->i];
 	/* If rotation is enabled, copy input buffer into VRFB
 	 * memory space using DMA. We are copying input buffer
 	 * into VRFB memory space of desired angle and DSS will
@@ -1121,7 +1114,7 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 			tx->dev_id, 0x0);
 	/* src_port required only for OMAP1 */
 	omap_set_dma_src_params(tx->dma_ch, 0, OMAP_DMA_AMODE_POST_INC,
-			dmabuf->bus_addr, src_element_index, src_frame_index);
+			dmabuf, src_element_index, src_frame_index);
 	/*set dma source burst mode for VRFB */
 	omap_set_dma_src_burst_mode(tx->dma_ch, OMAP_DMA_DATA_BURST_16);
 	rotation = calc_rotation(vout);
@@ -1212,7 +1205,6 @@ static int omap_vout_mmap(struct file *file, struct vm_area_struct *vma)
 	void *pos;
 	unsigned long start = vma->vm_start;
 	unsigned long size = (vma->vm_end - vma->vm_start);
-	struct videobuf_dmabuf *dmabuf = NULL;
 	struct omap_vout_device *vout = file->private_data;
 	struct videobuf_queue *q = &vout->vbq;
 
@@ -1242,8 +1234,7 @@ static int omap_vout_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 	vma->vm_ops = &omap_vout_vm_ops;
 	vma->vm_private_data = (void *) vout;
-	dmabuf = videobuf_to_dma(q->bufs[i]);
-	pos = dmabuf->vmalloc;
+	pos = (void *)vout->buf_virt_addr[i];
 	vma->vm_pgoff = virt_to_phys((void *)pos) >> PAGE_SHIFT;
 	while (size > 0) {
 		unsigned long pfn;
@@ -1348,8 +1339,8 @@ static int omap_vout_open(struct file *file)
 	video_vbq_ops.buf_queue = omap_vout_buffer_queue;
 	spin_lock_init(&vout->vbq_lock);
 
-	videobuf_queue_sg_init(q, &video_vbq_ops, NULL, &vout->vbq_lock,
-			vout->type, V4L2_FIELD_NONE,
+	videobuf_queue_dma_contig_init(q, &video_vbq_ops, q->dev,
+			&vout->vbq_lock, vout->type, V4L2_FIELD_NONE,
 			sizeof(struct videobuf_buffer), vout);
 
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev, "Exiting %s\n", __func__);
@@ -1800,7 +1791,6 @@ static int vidioc_reqbufs(struct file *file, void *fh,
 	unsigned int i, num_buffers = 0;
 	struct omap_vout_device *vout = fh;
 	struct videobuf_queue *q = &vout->vbq;
-	struct videobuf_dmabuf *dmabuf = NULL;
 
 	if ((req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) || (req->count < 0))
 		return -EINVAL;
@@ -1826,8 +1816,7 @@ static int vidioc_reqbufs(struct file *file, void *fh,
 		num_buffers = (vout->vid == OMAP_VIDEO1) ?
 			video1_numbuffers : video2_numbuffers;
 		for (i = num_buffers; i < vout->buffer_allocated; i++) {
-			dmabuf = videobuf_to_dma(q->bufs[i]);
-			omap_vout_free_buffer((u32)dmabuf->vmalloc,
+			omap_vout_free_buffer(vout->buf_virt_addr[i],
 					vout->buffer_size);
 			vout->buf_virt_addr[i] = 0;
 			vout->buf_phy_addr[i] = 0;
@@ -1856,12 +1845,7 @@ static int vidioc_reqbufs(struct file *file, void *fh,
 		goto reqbuf_err;
 
 	vout->buffer_allocated = req->count;
-	for (i = 0; i < req->count; i++) {
-		dmabuf = videobuf_to_dma(q->bufs[i]);
-		dmabuf->vmalloc = (void *) vout->buf_virt_addr[i];
-		dmabuf->bus_addr = (dma_addr_t) vout->buf_phy_addr[i];
-		dmabuf->sglen = 1;
-	}
+
 reqbuf_err:
 	mutex_unlock(&vout->lock);
 	return ret;
-- 
1.6.2.4


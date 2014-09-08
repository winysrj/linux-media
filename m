Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2021 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbaIHOPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 10:15:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/12] vb2-dma-sg: add prepare/finish memops
Date: Mon,  8 Sep 2014 16:14:32 +0200
Message-Id: <1410185681-20111-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
References: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that vb2-dma-sg will sync the buffers for you in the prepare/finish
memops we can drop that from the drivers that use dma-sg.

For the solo6x10 driver that was a bit more involved because it needs to
copy JPEG or MPEG headers to the buffer before returning it to userspace,
and that cannot be done in the old place since the buffer there is still
setup for DMA access, not for CPU access. However, the buf_finish op is
the ideal place to do this. By the time buf_finish is called the buffer
is available for CPU access, so copying to the buffer is fine.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c     |  1 -
 drivers/media/pci/saa7134/saa7134-ts.c          | 16 --------
 drivers/media/pci/saa7134/saa7134-vbi.c         | 15 --------
 drivers/media/pci/saa7134/saa7134-video.c       | 15 --------
 drivers/media/pci/saa7134/saa7134.h             |  1 -
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  | 50 +++++++++++--------------
 drivers/media/platform/marvell-ccic/mcam-core.c | 18 +--------
 drivers/media/v4l2-core/videobuf2-dma-sg.c      | 18 +++++++++
 8 files changed, 41 insertions(+), 93 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index e4ea85f..b1cfd0e 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -96,7 +96,6 @@ static struct vb2_ops saa7134_empress_qops = {
 	.queue_setup	= saa7134_ts_queue_setup,
 	.buf_init	= saa7134_ts_buffer_init,
 	.buf_prepare	= saa7134_ts_buffer_prepare,
-	.buf_finish	= saa7134_ts_buffer_finish,
 	.buf_queue	= saa7134_vb2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 8eff4a7..2709b83 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -94,7 +94,6 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(vb2, 0);
 	unsigned int lines, llength, size;
-	int ret;
 
 	dprintk("buffer_prepare [%p]\n", buf);
 
@@ -108,25 +107,11 @@ int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2)
 	vb2_set_plane_payload(vb2, 0, size);
 	vb2->v4l2_buf.field = dev->field;
 
-	ret = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-	if (!ret)
-		return -EIO;
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
 }
 EXPORT_SYMBOL_GPL(saa7134_ts_buffer_prepare);
 
-void saa7134_ts_buffer_finish(struct vb2_buffer *vb2)
-{
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
-
-	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-}
-EXPORT_SYMBOL_GPL(saa7134_ts_buffer_finish);
-
 int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
@@ -188,7 +173,6 @@ struct vb2_ops saa7134_ts_qops = {
 	.queue_setup	= saa7134_ts_queue_setup,
 	.buf_init	= saa7134_ts_buffer_init,
 	.buf_prepare	= saa7134_ts_buffer_prepare,
-	.buf_finish	= saa7134_ts_buffer_finish,
 	.buf_queue	= saa7134_vb2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 803e7df..e188903 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -120,7 +120,6 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 	unsigned int size;
-	int ret;
 
 	if (dma->sgl->offset) {
 		pr_err("The buffer is not page-aligned\n");
@@ -132,9 +131,6 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 
 	vb2_set_plane_payload(vb2, 0, size);
 
-	ret = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-	if (!ret)
-		return -EIO;
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
 }
@@ -170,21 +166,10 @@ static int buffer_init(struct vb2_buffer *vb2)
 	return 0;
 }
 
-static void buffer_finish(struct vb2_buffer *vb2)
-{
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
-
-	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-}
-
 struct vb2_ops saa7134_vbi_qops = {
 	.queue_setup	= queue_setup,
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,
-	.buf_finish	= buffer_finish,
 	.buf_queue	= saa7134_vb2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 5e3c48d..15a686b 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -883,7 +883,6 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
 	unsigned int size;
-	int ret;
 
 	if (dma->sgl->offset) {
 		pr_err("The buffer is not page-aligned\n");
@@ -896,23 +895,10 @@ static int buffer_prepare(struct vb2_buffer *vb2)
 	vb2_set_plane_payload(vb2, 0, size);
 	vb2->v4l2_buf.field = dev->field;
 
-	ret = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-	if (!ret)
-		return -EIO;
 	return saa7134_pgtable_build(dev->pci, &dmaq->pt, dma->sgl, dma->nents,
 				    saa7134_buffer_startpage(buf));
 }
 
-static void buffer_finish(struct vb2_buffer *vb2)
-{
-	struct saa7134_dmaqueue *dmaq = vb2->vb2_queue->drv_priv;
-	struct saa7134_dev *dev = dmaq->dev;
-	struct saa7134_buf *buf = container_of(vb2, struct saa7134_buf, vb2);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(&buf->vb2, 0);
-
-	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-}
-
 static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[])
@@ -1005,7 +991,6 @@ static struct vb2_ops vb2_qops = {
 	.queue_setup	= queue_setup,
 	.buf_init	= buffer_init,
 	.buf_prepare	= buffer_prepare,
-	.buf_finish	= buffer_finish,
 	.buf_queue	= saa7134_vb2_buffer_queue,
 	.wait_prepare	= vb2_ops_wait_prepare,
 	.wait_finish	= vb2_ops_wait_finish,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 1c21c47..0395e35 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -810,7 +810,6 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
-void saa7134_ts_buffer_finish(struct vb2_buffer *vb2);
 int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 0517fc9..e2d819e 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
@@ -463,7 +463,6 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_size;
-	int ret;
 
 	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 
@@ -473,22 +472,10 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 	frame_size = ALIGN(vop_jpeg_size(vh) + solo_enc->jpeg_len, DMA_ALIGN);
 	vb2_set_plane_payload(vb, 0, vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
-	/* may discard all previous data in vbuf->sgl */
-	if (!dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE))
-		return -ENOMEM;
-	ret = solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
+	return solo_send_desc(solo_enc, solo_enc->jpeg_len, vbuf,
 			     vop_jpeg_offset(vh) - SOLO_JPEG_EXT_ADDR(solo_dev),
 			     frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
 			     SOLO_JPEG_EXT_SIZE(solo_dev));
-	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE);
-
-	/* add the header only after dma_unmap_sg() */
-	sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
-			    solo_enc->jpeg_header, solo_enc->jpeg_len);
-
-	return ret;
 }
 
 static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
@@ -498,7 +485,6 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_off, frame_size;
 	int skip = 0;
-	int ret;
 
 	if (vb2_plane_size(vb, 0) < vop_mpeg_size(vh))
 		return -EIO;
@@ -521,21 +507,9 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 		sizeof(*vh)) % SOLO_MP4E_EXT_SIZE(solo_dev);
 	frame_size = ALIGN(vop_mpeg_size(vh) + skip, DMA_ALIGN);
 
-	/* may discard all previous data in vbuf->sgl */
-	if (!dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE))
-		return -ENOMEM;
-	ret = solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
+	return solo_send_desc(solo_enc, skip, vbuf, frame_off, frame_size,
 			SOLO_MP4E_EXT_ADDR(solo_dev),
 			SOLO_MP4E_EXT_SIZE(solo_dev));
-	dma_unmap_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE);
-
-	/* add the header only after dma_unmap_sg() */
-	if (!vop_type(vh))
-		sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
-				    solo_enc->vop, solo_enc->vop_len);
-	return ret;
 }
 
 static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
@@ -790,9 +764,29 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
 	solo_ring_stop(solo_enc->solo_dev);
 }
 
+static void solo_enc_buf_finish_for_cpu(struct vb2_buffer *vb)
+{
+	struct solo_enc_dev *solo_enc = vb2_get_drv_priv(vb->vb2_queue);
+	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
+
+	switch (solo_enc->fmt) {
+	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_H264:
+		if (vb->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME)
+			sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
+					solo_enc->vop, solo_enc->vop_len);
+		break;
+	default: /* V4L2_PIX_FMT_MJPEG */
+		sg_copy_from_buffer(vbuf->sgl, vbuf->nents,
+				solo_enc->jpeg_header, solo_enc->jpeg_len);
+		break;
+	}
+}
+
 static struct vb2_ops solo_enc_video_qops = {
 	.queue_setup	= solo_enc_queue_setup,
 	.buf_queue	= solo_enc_buf_queue,
+	.buf_finish_for_cpu = solo_enc_buf_finish_for_cpu,
 	.start_streaming = solo_enc_start_streaming,
 	.stop_streaming = solo_enc_stop_streaming,
 	.wait_prepare	= vb2_ops_wait_prepare,
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 20d53b6..d48c3d4 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1221,17 +1221,12 @@ static int mcam_vb_sg_buf_init(struct vb2_buffer *vb)
 static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 {
 	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
 	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
 	struct mcam_dma_desc *desc = mvb->dma_desc;
 	struct scatterlist *sg;
 	int i;
 
-	mvb->dma_desc_nent = dma_map_sg(cam->dev, sg_table->sgl,
-			sg_table->nents, DMA_FROM_DEVICE);
-	if (mvb->dma_desc_nent <= 0)
-		return -EIO;  /* Not sure what's right here */
-	for_each_sg(sg_table->sgl, sg, mvb->dma_desc_nent, i) {
+	for_each_sg(sg_table->sgl, sg, sg_table->nents, i) {
 		desc->dma_addr = sg_dma_address(sg);
 		desc->segment_len = sg_dma_len(sg);
 		desc++;
@@ -1239,16 +1234,6 @@ static int mcam_vb_sg_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void mcam_vb_sg_buf_finish(struct vb2_buffer *vb)
-{
-	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
-	struct sg_table *sg_table = vb2_dma_sg_plane_desc(vb, 0);
-
-	if (sg_table)
-		dma_unmap_sg(cam->dev, sg_table->sgl,
-				sg_table->nents, DMA_FROM_DEVICE);
-}
-
 static void mcam_vb_sg_buf_cleanup(struct vb2_buffer *vb)
 {
 	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
@@ -1265,7 +1250,6 @@ static const struct vb2_ops mcam_vb2_sg_ops = {
 	.buf_init		= mcam_vb_sg_buf_init,
 	.buf_prepare		= mcam_vb_sg_buf_prepare,
 	.buf_queue		= mcam_vb_buf_queue,
-	.buf_finish		= mcam_vb_sg_buf_finish,
 	.buf_cleanup		= mcam_vb_sg_buf_cleanup,
 	.start_streaming	= mcam_vb_start_streaming,
 	.stop_streaming		= mcam_vb_stop_streaming,
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 9b7a041..f3bc01b 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -170,6 +170,22 @@ static void vb2_dma_sg_put(void *buf_priv)
 	}
 }
 
+static void vb2_dma_sg_prepare(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table *sgt = &buf->sg_table;
+
+	dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
+static void vb2_dma_sg_finish(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table *sgt = &buf->sg_table;
+
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
 static inline int vma_is_io(struct vm_area_struct *vma)
 {
 	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
@@ -366,6 +382,8 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 	.put		= vb2_dma_sg_put,
 	.get_userptr	= vb2_dma_sg_get_userptr,
 	.put_userptr	= vb2_dma_sg_put_userptr,
+	.prepare	= vb2_dma_sg_prepare,
+	.finish		= vb2_dma_sg_finish,
 	.vaddr		= vb2_dma_sg_vaddr,
 	.mmap		= vb2_dma_sg_mmap,
 	.num_users	= vb2_dma_sg_num_users,
-- 
2.1.0


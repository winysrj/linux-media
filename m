Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4547 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaBYKEs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 05/20] vb2-dma-sg: add prepare/finish memops
Date: Tue, 25 Feb 2014 11:04:10 +0100
Message-Id: <1393322665-29889-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
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
 drivers/media/platform/marvell-ccic/mcam-core.c    | 18 +-------
 drivers/media/v4l2-core/videobuf2-dma-sg.c         | 18 ++++++++
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 48 ++++++++++------------
 3 files changed, 41 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 99961bf..a21f291 100644
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
index 92b54fa..c7e0eca 100644
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
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index efa6772..0361f28 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -465,7 +465,6 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_size;
-	int ret;
 
 	vb->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
 
@@ -476,21 +475,10 @@ static int solo_fill_jpeg(struct solo_enc_dev *solo_enc,
 		& ~(DMA_ALIGN - 1);
 	vb2_set_plane_payload(vb, 0, vop_jpeg_size(vh) + solo_enc->jpeg_len);
 
-	/* may discard all previous data in vbuf->sgl */
-	dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE);
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
@@ -500,7 +488,6 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	struct sg_table *vbuf = vb2_dma_sg_plane_desc(vb, 0);
 	int frame_off, frame_size;
 	int skip = 0;
-	int ret;
 
 	if (vb2_plane_size(vb, 0) < vop_mpeg_size(vh))
 		return -EIO;
@@ -522,20 +509,9 @@ static int solo_fill_mpeg(struct solo_enc_dev *solo_enc,
 	frame_size = (vop_mpeg_size(vh) + skip + (DMA_ALIGN - 1))
 		& ~(DMA_ALIGN - 1);
 
-	/* may discard all previous data in vbuf->sgl */
-	dma_map_sg(&solo_dev->pdev->dev, vbuf->sgl, vbuf->nents,
-			DMA_FROM_DEVICE);
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
@@ -753,9 +729,29 @@ static void solo_enc_stop_streaming(struct vb2_queue *q)
 	solo_ring_stop(solo_enc->solo_dev);
 }
 
+static void solo_enc_buf_finish(struct vb2_buffer *vb)
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
+	.buf_finish     = solo_enc_buf_finish,
 	.start_streaming = solo_enc_start_streaming,
 	.stop_streaming = solo_enc_stop_streaming,
 	.wait_prepare	= vb2_ops_wait_prepare,
-- 
1.9.0


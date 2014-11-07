Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40350 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbaKGIum (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 03:50:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv5 PATCH 03/15] vb2-dma-sg: move dma_(un)map_sg here
Date: Fri,  7 Nov 2014 09:50:22 +0100
Message-Id: <1415350234-9826-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
References: <1415350234-9826-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This moves dma_(un)map_sg to the get_userptr/put_userptr and alloc/put
memops of videobuf2-dma-sg.c and adds dma_sync_sg_for_device/cpu to the
prepare/finish memops.

Now that vb2-dma-sg will sync the buffers for you in the prepare/finish
memops we can drop that from the drivers that use dma-sg.

For the solo6x10 driver that was a bit more involved because it needs to
copy JPEG or MPEG headers to the buffer before returning it to userspace,
and that cannot be done in the old place since the buffer there is still
setup for DMA access, not for CPU access. However, the buf_finish
op is the ideal place to do this. By the time buf_finish is called
the buffer is available for CPU access, so copying to the buffer is fine.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c         |  3 --
 drivers/media/pci/cx23885/cx23885-core.c        |  5 ---
 drivers/media/pci/cx23885/cx23885-dvb.c         |  3 --
 drivers/media/pci/cx23885/cx23885-vbi.c         |  9 -----
 drivers/media/pci/cx23885/cx23885-video.c       |  9 -----
 drivers/media/pci/saa7134/saa7134-empress.c     |  1 -
 drivers/media/pci/saa7134/saa7134-ts.c          | 16 --------
 drivers/media/pci/saa7134/saa7134-vbi.c         | 15 --------
 drivers/media/pci/saa7134/saa7134-video.c       | 15 --------
 drivers/media/pci/saa7134/saa7134.h             |  1 -
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  | 50 +++++++++++--------------
 drivers/media/pci/tw68/tw68-video.c             |  8 ----
 drivers/media/platform/marvell-ccic/mcam-core.c | 18 +--------
 drivers/media/v4l2-core/videobuf2-dma-sg.c      | 40 ++++++++++++++++++++
 14 files changed, 63 insertions(+), 130 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index d72a3ec..e4901a5 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1167,11 +1167,8 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
 	cx23885_free_buffer(dev, buf);
-
-	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 0451522..ff11dfd 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1453,17 +1453,12 @@ int cx23885_buf_prepare(struct cx23885_buffer *buf, struct cx23885_tsport *port)
 	struct cx23885_dev *dev = port->dev;
 	int size = port->ts_packet_size * port->ts_packet_count;
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
-	int rc;
 
 	dprintk(1, "%s: %p\n", __func__, buf);
 	if (vb2_plane_size(&buf->vb, 0) < size)
 		return -EINVAL;
 	vb2_set_plane_payload(&buf->vb, 0, size);
 
-	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
-	if (!rc)
-		return -EIO;
-
 	cx23885_risc_databuffer(dev->pci, &buf->risc,
 				sgt->sgl,
 				port->ts_packet_size, port->ts_packet_count, 0);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index e63759e..79239b1 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -123,11 +123,8 @@ static void buffer_finish(struct vb2_buffer *vb)
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
 	cx23885_free_buffer(dev, buf);
-
-	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
 static void buffer_queue(struct vb2_buffer *vb)
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 1d339a6..d362d38 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -143,7 +143,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		struct cx23885_buffer, vb);
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned lines = VBI_PAL_LINE_COUNT;
-	int ret;
 
 	if (dev->tvnorm & V4L2_STD_525_60)
 		lines = VBI_NTSC_LINE_COUNT;
@@ -152,10 +151,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, lines * VBI_LINE_LENGTH * 2);
 
-	ret = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
-	if (!ret)
-		return -EIO;
-
 	cx23885_risc_vbibuffer(dev->pci, &buf->risc,
 			 sgt->sgl,
 			 0, VBI_LINE_LENGTH * lines,
@@ -166,14 +161,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
 	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
-
-	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
 /*
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 1b04ab3..6f4fcd9 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -335,7 +335,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	u32 line0_offset, line1_offset;
 	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 	int field_tff;
-	int ret;
 
 	buf->bpl = (dev->width * dev->fmt->depth) >> 3;
 
@@ -343,10 +342,6 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, dev->height * buf->bpl);
 
-	ret = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
-	if (!ret)
-		return -EIO;
-
 	switch (dev->field) {
 	case V4L2_FIELD_TOP:
 		cx23885_risc_buffer(dev->pci, &buf->risc,
@@ -414,14 +409,10 @@ static int buffer_prepare(struct vb2_buffer *vb)
 
 static void buffer_finish(struct vb2_buffer *vb)
 {
-	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
-	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
 
 	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
-
-	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
 }
 
 /*
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
index e2cc684..5306e54 100644
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
index ba02995..701b52f 100644
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
index c644c7d..8bf0553 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -815,7 +815,6 @@ void saa7134_video_fini(struct saa7134_dev *dev);
 
 int saa7134_ts_buffer_init(struct vb2_buffer *vb2);
 int saa7134_ts_buffer_prepare(struct vb2_buffer *vb2);
-void saa7134_ts_buffer_finish(struct vb2_buffer *vb2);
 int saa7134_ts_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
 			   unsigned int *nbuffers, unsigned int *nplanes,
 			   unsigned int sizes[], void *alloc_ctxs[]);
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c b/drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c
index 0517fc9..c7b12d8 100644
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
+	.buf_finish	= solo_enc_buf_finish,
 	.start_streaming = solo_enc_start_streaming,
 	.stop_streaming = solo_enc_stop_streaming,
 	.wait_prepare	= vb2_ops_wait_prepare,
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 50dcce6..8355e55 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -462,17 +462,12 @@ static int tw68_buf_prepare(struct vb2_buffer *vb)
 	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
 	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
 	unsigned size, bpl;
-	int rc;
 
 	size = (dev->width * dev->height * dev->fmt->depth) >> 3;
 	if (vb2_plane_size(vb, 0) < size)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, size);
 
-	rc = dma_map_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-	if (!rc)
-		return -EIO;
-
 	bpl = (dev->width * dev->fmt->depth) >> 3;
 	switch (dev->field) {
 	case V4L2_FIELD_TOP:
@@ -506,11 +501,8 @@ static void tw68_buf_finish(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
-	struct sg_table *dma = vb2_dma_sg_plane_desc(vb, 0);
 	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
 
-	dma_unmap_sg(&dev->pci->dev, dma->sgl, dma->nents, DMA_FROM_DEVICE);
-
 	pci_free_consistent(dev->pci, buf->size, buf->cpu, buf->dma);
 }
 
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
index ff77be7..7375923 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -97,6 +97,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
 {
 	struct vb2_dma_sg_conf *conf = alloc_ctx;
 	struct vb2_dma_sg_buf *buf;
+	struct sg_table *sgt;
 	int ret;
 	int num_pages;
 
@@ -130,6 +131,12 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
 
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(conf->dev);
+
+	sgt = &buf->sg_table;
+	if (dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) == 0)
+		goto fail_map;
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+
 	buf->handler.refcount = &buf->refcount;
 	buf->handler.put = vb2_dma_sg_put;
 	buf->handler.arg = buf;
@@ -140,6 +147,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int write,
 		__func__, buf->num_pages);
 	return buf;
 
+fail_map:
+	put_device(buf->dev);
+	sg_free_table(buf->dma_sgt);
 fail_table_alloc:
 	num_pages = buf->num_pages;
 	while (num_pages--)
@@ -154,11 +164,13 @@ fail_pages_array_alloc:
 static void vb2_dma_sg_put(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table *sgt = &buf->sg_table;
 	int i = buf->num_pages;
 
 	if (atomic_dec_and_test(&buf->refcount)) {
 		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
 			buf->num_pages);
+		dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 		if (buf->vaddr)
 			vm_unmap_ram(buf->vaddr, buf->num_pages);
 		sg_free_table(&buf->sg_table);
@@ -170,6 +182,22 @@ static void vb2_dma_sg_put(void *buf_priv)
 	}
 }
 
+static void vb2_dma_sg_prepare(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table *sgt = &buf->sg_table;
+
+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
+static void vb2_dma_sg_finish(void *buf_priv)
+{
+	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table *sgt = &buf->sg_table;
+
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
+}
+
 static inline int vma_is_io(struct vm_area_struct *vma)
 {
 	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
@@ -183,6 +211,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	unsigned long first, last;
 	int num_pages_from_user;
 	struct vm_area_struct *vma;
+	struct sg_table *sgt;
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
@@ -251,8 +280,15 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 
 	/* Prevent the device from being released while the buffer is used */
 	buf->dev = get_device(conf->dev);
+
+	sgt = &buf->sg_table;
+	if (dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) == 0)
+		goto userptr_fail_map;
+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	return buf;
 
+userptr_fail_map:
+	sg_free_table(&buf->sg_table);
 userptr_fail_alloc_table_from_pages:
 userptr_fail_get_user_pages:
 	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
@@ -275,10 +311,12 @@ userptr_fail_alloc_pages:
 static void vb2_dma_sg_put_userptr(void *buf_priv)
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
+	struct sg_table *sgt = &buf->sg_table;
 	int i = buf->num_pages;
 
 	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
 	       __func__, buf->num_pages);
+	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	if (buf->vaddr)
 		vm_unmap_ram(buf->vaddr, buf->num_pages);
 	sg_free_table(&buf->sg_table);
@@ -366,6 +404,8 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
 	.put		= vb2_dma_sg_put,
 	.get_userptr	= vb2_dma_sg_get_userptr,
 	.put_userptr	= vb2_dma_sg_put_userptr,
+	.prepare	= vb2_dma_sg_prepare,
+	.finish		= vb2_dma_sg_finish,
 	.vaddr		= vb2_dma_sg_vaddr,
 	.mmap		= vb2_dma_sg_mmap,
 	.num_users	= vb2_dma_sg_num_users,
-- 
2.1.1


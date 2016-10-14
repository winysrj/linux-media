Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50563 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbcJNMKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 08:10:55 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] [media] vb2: Store dma_dir in vb2_queue
Date: Fri, 14 Oct 2016 14:08:13 +0200
Message-Id: <1476446894-4220-2-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1476446894-4220-1-git-send-email-thierry.escande@collabora.com>
References: <1476446894-4220-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Store dma_dir in struct vb2_queue and reuse it, instead of recalculating
it each time.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Tested-by: Pawel Osciak <posciak@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Reviewed-by: Owen Lin <owenlin@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 12 +++---------
 drivers/media/v4l2-core/videobuf2-v4l2.c |  2 ++
 include/media/videobuf2-core.h           |  2 ++
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 21900202..f12103c 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -194,8 +194,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
 static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	void *mem_priv;
 	int plane;
 	int ret = -ENOMEM;
@@ -209,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 
 		mem_priv = call_ptr_memop(vb, alloc,
 				q->alloc_devs[plane] ? : q->dev,
-				q->dma_attrs, size, dma_dir, q->gfp_flags);
+				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
 		if (IS_ERR(mem_priv)) {
 			if (mem_priv)
 				ret = PTR_ERR(mem_priv);
@@ -978,8 +976,6 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1030,7 +1026,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 		mem_priv = call_ptr_memop(vb, get_userptr,
 				q->alloc_devs[plane] ? : q->dev,
 				planes[plane].m.userptr,
-				planes[plane].length, dma_dir);
+				planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed acquiring userspace "
 						"memory for plane %d\n", plane);
@@ -1096,8 +1092,6 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 	void *mem_priv;
 	unsigned int plane;
 	int ret = 0;
-	enum dma_data_direction dma_dir =
-		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 	bool reacquired = vb->planes[0].mem_priv == NULL;
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
@@ -1156,7 +1150,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 		/* Acquire each plane's memory */
 		mem_priv = call_ptr_memop(vb, attach_dmabuf,
 				q->alloc_devs[plane] ? : q->dev,
-				dbuf, planes[plane].length, dma_dir);
+				dbuf, planes[plane].length, q->dma_dir);
 		if (IS_ERR(mem_priv)) {
 			dprintk(1, "failed to attach dmabuf\n");
 			ret = PTR_ERR(mem_priv);
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 52ef883..fde1e2d 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -659,6 +659,8 @@ int vb2_queue_init(struct vb2_queue *q)
 	 * queues will always initialize waiting_for_buffers to false.
 	 */
 	q->quirk_poll_must_check_waiting_for_buffers = true;
+	q->dma_dir = V4L2_TYPE_IS_OUTPUT(q->type)
+		   ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 
 	return vb2_core_queue_init(q);
 }
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ac5898a..38410dd 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -489,6 +489,7 @@ struct vb2_buf_ops {
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
+ * @dma_dir:	DMA direction to use for buffers on this queue
  */
 struct vb2_queue {
 	unsigned int			type;
@@ -540,6 +541,7 @@ struct vb2_queue {
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
+	enum dma_data_direction		dma_dir;
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
-- 
2.7.4


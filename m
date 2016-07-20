Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47169
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbcGTQSj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 12:18:39 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] vb2: remove TODO comment for dma-buf in QBUF
Date: Wed, 20 Jul 2016 12:18:25 -0400
Message-Id: <1469031506-3641-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a TODO comment about the dma-buf being mapped in VIDIOC_QBUF
instead of doing it closer to when the actual DMA is going to happen
when the buffers are queued in the driver (i.e: __enqueue_in_driver).

But there is a reason to do it earlier in QBUF, and is that userspace
has no way to know if a exported dma-buf can be imported successfully
and so relies on QBUF succeeding as indication that the dma-buf mapped.

If QBUF fails, the application can fallback to another streaming I/O
method. But moving the dma-buf mapping later when queueing the buffers
can be too late for userspace to recover, since it may had dropped the
buffer(s) already when it knows that the dma-buf mapping failed.

So remove the TODO instead and change the comment to explain this.

Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---
Hello,

This patch was suggested by Hans as a feedback in a previous patch
that attempted to get rid of the TODO by moving the dma-buf mapping:

https://lkml.org/lkml/2016/7/20/338

Best regards,
Javier

 drivers/media/v4l2-core/videobuf2-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bbba50d6e1ad..7128b09810be 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1272,9 +1272,10 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 		vb->planes[plane].mem_priv = mem_priv;
 	}
 
-	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
-	 * really we want to do this just before the DMA, not while queueing
-	 * the buffer(s)..
+	/*
+	 * This pins the buffer(s) with dma_buf_map_attachment()). It's done
+	 * here instead just before the DMA, while queueing the buffer(s) so
+	 * userspace knows sooner rather than later if the dma-buf map fails.
 	 */
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		ret = call_memop(vb, map_dmabuf, vb->planes[plane].mem_priv);
-- 
2.5.5


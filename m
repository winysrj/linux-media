Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:33207 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZGWN4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 09:56:50 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n6NDuSaW010987
	for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 16:56:43 +0300
From: tuukka.o.toivonen@nokia.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com,
	tuukka.o.toivonen@nokia.com
Subject: [PATCH] v4l2: do not force buffer size to be multiple of PAGE_SIZE
Date: Thu, 23 Jul 2009 16:56:25 +0300
Message-Id: <1248357387-14720-2-git-send-email-tuukka.o.toivonen@nokia.com>
In-Reply-To: <1248357387-14720-1-git-send-email-tuukka.o.toivonen@nokia.com>
References: <1248357387-14720-1-git-send-email-tuukka.o.toivonen@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>

When the image size (bytesperline*height) is not multiple
of PAGE_SIZE, v4l2 rounded the required buffer size to
be multiple of PAGE_SIZE. This prevented user space
to store images directly into userptr buffers which were
not multiple of PAGE_SIZE. This constraint is removed.

The start address is still assumed to be required
page-aligned, ie., when v4l2 allocates mmap buffers,
the offset between different buffers is page-aligned.

Signed-off-by: Tuukka Toivonen <tuukka.o.toivonen@nokia.com>
---
 drivers/media/video/videobuf-core.c   |    7 +++----
 drivers/media/video/videobuf-dma-sg.c |    4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index b7b0584..0b18ac2 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -358,7 +358,7 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 		q->bufs[i]->bsize  = bsize;
 		switch (memory) {
 		case V4L2_MEMORY_MMAP:
-			q->bufs[i]->boff  = bsize * i;
+			q->bufs[i]->boff = PAGE_ALIGN(bsize) * i;
 			break;
 		case V4L2_MEMORY_USERPTR:
 		case V4L2_MEMORY_OVERLAY:
@@ -428,9 +428,8 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 		count = VIDEO_MAX_FRAME;
 	size = 0;
 	q->ops->buf_setup(q, &count, &size);
-	size = PAGE_ALIGN(size);
 	dprintk(1, "reqbufs: bufs=%d, size=0x%x [%d pages total]\n",
-		count, size, (count*size)>>PAGE_SHIFT);
+		count, size, (count*PAGE_ALIGN(size))>>PAGE_SHIFT);
 
 	retval = __videobuf_mmap_setup(q, count, size, req->memory);
 	if (retval < 0) {
@@ -1096,7 +1095,7 @@ int videobuf_cgmbuf(struct videobuf_queue *q,
 	mbuf->size   = 0;
 	for (i = 0; i < mbuf->frames; i++) {
 		mbuf->offsets[i]  = q->bufs[i]->boff;
-		mbuf->size       += q->bufs[i]->bsize;
+		mbuf->size       += PAGE_ALIGN(q->bufs[i]->bsize);
 	}
 
 	return 0;
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 21d979f..2a8ade7 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -588,7 +588,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 			retval = -EBUSY;
 			goto done;
 		}
-		size += q->bufs[last]->bsize;
+		size += PAGE_ALIGN(q->bufs[last]->bsize);
 		if (size == (vma->vm_end - vma->vm_start))
 			break;
 	}
@@ -610,7 +610,7 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
 			continue;
 		q->bufs[i]->map   = map;
 		q->bufs[i]->baddr = vma->vm_start + size;
-		size += q->bufs[i]->bsize;
+		size += PAGE_ALIGN(q->bufs[i]->bsize);
 	}
 
 	map->count    = 1;
-- 
1.5.4.3


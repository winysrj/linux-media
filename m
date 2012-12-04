Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3452 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2LDPt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 10:49:29 -0500
To: LMML <linux-media@vger.kernel.org>
Subject: [RFC PATCH] vb2: force output buffers to fault into memory
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Tue, 4 Dec 2012 16:48:40 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201212041648.40108.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(repost after accidentally using HTML formatting)

This needs a good review. The change is minor, but as I am not a mm expert,
I'd like to get some more feedback on this. The dma-sg change has been
successfully tested on our hardware, but I don't have any hardware to test
the vmalloc change.

Note that the 'write' attribute is still stored internally and used to tell
whether set_page_dirty_lock() should be called during put_userptr.

It is my understanding that that still makes sense, so I didn't change that.

Regards,

	Hans

--- start patch ---

When calling get_user_pages for output buffers, the 'write' argument is set
to 0 (since the DMA isn't writing to memory), This can cause unexpected results:

If you calloc() buffer memory and do not fill that memory afterwards, then
the kernel assigns most of that memory to one single physical 'zero' page.

If you queue that buffer to the V4L2 driver, then it will call get_user_pages
and store the results. Next you dequeue it, fill the buffer and queue it
again. Now the V4L2 core code sees the same userptr and length and expects it
to be the same buffer that it got before and it will reuse the results of the
previous get_user_pages call. But that still points to zero pages, whereas
userspace filled it up and so changed the buffer to use different pages. In
other words, the pages the V4L2 core knows about are no longer correct.

The solution is to always set 'write' to 1 as this will force the kernel to
fault in proper pages.

We do this for videobuf2-dma-sg.c and videobuf2-vmalloc.c, but not for
videobuf2-dma-contig.c since the userptr there is already supposed to
point to contiguous memory and shouldn't use the zero page at all.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-sg.c  |    3 ++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index 25c3b36..c29f159 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -143,7 +143,8 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	num_pages_from_user = get_user_pages(current, current->mm,
 					     vaddr & PAGE_MASK,
 					     buf->sg_desc.num_pages,
-					     write,
+					     1, /* always set write to force
+						   faulting all pages */
 					     1, /* force */
 					     buf->pages,
 					     NULL);
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index a47fd4f..c8d8519 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -107,7 +107,9 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 		/* current->mm->mmap_sem is taken by videobuf2 core */
 		n_pages = get_user_pages(current, current->mm,
 					 vaddr & PAGE_MASK, buf->n_pages,
-					 write, 1, /* force */
+					 1, /* always set write to force
+					       faulting all pages */
+					 1, /* force */
 					 buf->pages, NULL);
 		if (n_pages != buf->n_pages)
 			goto fail_get_user_pages;
-- 
1.7.10.4


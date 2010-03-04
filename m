Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:51466
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0CDQBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 11:01:38 -0500
From: Arnout Vandecappelle <arnout@mind.be>
To: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	mchehab@infradead.org
Cc: Arnout Vandecappelle <arnout@mind.be>
Subject: [PATCH 2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memory
Date: Thu,  4 Mar 2010 17:00:51 +0100
Message-Id: <1267718451-24961-3-git-send-email-arnout@mind.be>
In-Reply-To: <201003031512.45428.arnout@mind.be>
References: <201003031512.45428.arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_dma_init_user_locked() uses get_user_pages() to get the
virtual-to-physical address mapping for user-allocated memory.
However, the user-allocated memory may be non-pageable because it
is an I/O range or similar.  get_user_pages() fails with -EFAULT
in that case.

If the user-allocated memory is physically contiguous, the approach
of V4L2_MEMORY_OVERLAY can be used.  If it is not, -EFAULT is still
returned.
---
 drivers/media/video/videobuf-dma-sg.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 3b6f1b8..7884207 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -136,6 +136,7 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 {
 	unsigned long first,last;
 	int err, rw = 0;
+	struct vm_area_struct *vma;
 
 	dma->direction = direction;
 	switch (dma->direction) {
@@ -153,6 +154,23 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	last  = ((data+size-1) & PAGE_MASK) >> PAGE_SHIFT;
 	dma->offset   = data & ~PAGE_MASK;
 	dma->nr_pages = last-first+1;
+
+	/* In case the buffer is user-allocated and is actually an IO buffer for
+	   some other hardware, we cannot map pages for it.  It in fact behaves
+	   the same as an overlay. */
+	vma = find_vma (current->mm, data);
+	if (vma && (vma->vm_flags & VM_IO)) {
+		/* Only a single contiguous buffer is supported. */
+		if (vma->vm_end < data + size) {
+			dprintk(1, "init user: non-contiguous IO buffer.\n");
+			return -EFAULT; /* same error that get_user_pages() would give */
+		}
+		dma->bus_addr = (vma->vm_pgoff << PAGE_SHIFT) +	(data - vma->vm_start);
+		dprintk(1,"init user IO [0x%lx+0x%lx => %d pages at 0x%x]\n",
+			data, size, dma->nr_pages, dma->bus_addr);
+		return 0;
+	}
+
 	dma->pages = kmalloc(dma->nr_pages * sizeof(struct page*),
 			     GFP_KERNEL);
 	if (NULL == dma->pages)
-- 
1.6.3.3


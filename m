Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32611 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2JBOa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 10:30:29 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MB900EV3SA0IC00@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:28 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MB9005A7S65K790@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Oct 2012 23:30:28 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: [PATCHv9 22/25] v4l: vb2-dma-contig: fail if user ptr buffer is not
 correctly aligned
Date: Tue, 02 Oct 2012 16:27:33 +0200
Message-id: <1349188056-4886-23-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

The DMA transfer must be aligned to a specific value. If userptr is not aligned
to DMA requirements then unexpected corruptions of the memory may occur before
or after a buffer.  To prevent such situations, all unligned userptr buffers
are rejected at VIDIOC_QBUF.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index b4d287a..55f8c80 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -494,6 +494,13 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	struct vm_area_struct *vma;
 	struct sg_table *sgt;
 	unsigned long contig_size;
+	unsigned long dma_align = dma_get_cache_alignment();
+
+	/* Only cache aligned DMA transfers are reliable */
+	if (!IS_ALIGNED(vaddr | size, dma_align)) {
+		pr_err("user data must be aligned to %lu bytes\n", dma_align);
+		return ERR_PTR(-EINVAL);
+	}
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-- 
1.7.9.5


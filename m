Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45637 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2JJPCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:02:03 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBO006NNN3EQC11@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:02:02 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBO002YDME0EC70@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Oct 2012 00:02:02 +0900 (KST)
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
Subject: [PATCHv10 22/26] v4l: vb2-dma-contig: fail if user ptr buffer is not
 correctly aligned
Date: Wed, 10 Oct 2012 16:46:41 +0200
Message-id: <1349880405-26049-23-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

The DMA transfer must be aligned to a specific value. If userptr is not aligned
to DMA requirements then unexpected corruptions of the memory may occur before
or after a buffer.  To prevent such situations, all unligned userptr buffers
are rejected at VIDIOC_QBUF.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-dma-contig.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index 2d661fd..571a919 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -493,6 +493,18 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	struct vm_area_struct *vma;
 	struct sg_table *sgt;
 	unsigned long contig_size;
+	unsigned long dma_align = dma_get_cache_alignment();
+
+	/* Only cache aligned DMA transfers are reliable */
+	if (!IS_ALIGNED(vaddr | size, dma_align)) {
+		pr_debug("user data must be aligned to %lu bytes\n", dma_align);
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!size) {
+		pr_debug("size is zero\n");
+		return ERR_PTR(-EINVAL);
+	}
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-- 
1.7.9.5


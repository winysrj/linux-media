Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:53930 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2HNPiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 11:38:03 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8R00MQW4RD8F20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:38:02 +0900 (KST)
Received: from mcdsrvbld02.digital.local ([106.116.37.23])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8R004J44MBC810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 15 Aug 2012 00:38:01 +0900 (KST)
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de, dmitriyz@google.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
Subject: [PATCHv8 22/26] media: vb2: fail if user ptr buffer is not correctly
 aligned
Date: Tue, 14 Aug 2012 17:34:52 +0200
Message-id: <1344958496-9373-23-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-dma-contig.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index d44766e..11f4a46 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -498,6 +498,16 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
 	struct vm_area_struct *vma;
 	struct sg_table *sgt;
 	unsigned long contig_size;
+	unsigned long dma_align = dma_get_cache_alignment();
+
+	/*
+	 * DMA transfers are not reliable to buffers which
+	 * are not cache line aligned!
+	 */
+	if (vaddr & (dma_align - 1)) {
+		pr_err("userptr must be aligned to %lu bytes\n", dma_align);
+		return ERR_PTR(-EINVAL);
+	}
 
 	buf = kzalloc(sizeof *buf, GFP_KERNEL);
 	if (!buf)
-- 
1.7.9.5


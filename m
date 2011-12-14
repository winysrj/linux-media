Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56233 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab1LNOB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Dec 2011 09:01:29 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v2 3/8] media: videobuf2: move out of setting pgprot_noncached from vb2_mmap_pfn_range
Date: Wed, 14 Dec 2011 22:00:09 +0800
Message-Id: <1323871214-25435-4-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So that we can reuse vb2_mmap_pfn_range for the coming videobuf2_page
memops.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/video/videobuf2-dma-contig.c |    1 +
 drivers/media/video/videobuf2-memops.c     |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f17ad98..0ea8866 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -106,6 +106,7 @@ static int vb2_dma_contig_mmap(void *buf_priv, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	return vb2_mmap_pfn_range(vma, buf->dma_addr, buf->size,
 				  &vb2_common_vm_ops, &buf->handler);
 }
diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
index 71a7a78..77e0def 100644
--- a/drivers/media/video/videobuf2-memops.c
+++ b/drivers/media/video/videobuf2-memops.c
@@ -162,7 +162,6 @@ int vb2_mmap_pfn_range(struct vm_area_struct *vma, unsigned long paddr,
 
 	size = min_t(unsigned long, vma->vm_end - vma->vm_start, size);
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	ret = remap_pfn_range(vma, vma->vm_start, paddr >> PAGE_SHIFT,
 				size, vma->vm_page_prot);
 	if (ret) {
-- 
1.7.5.4


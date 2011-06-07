Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64454 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1FGHbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 03:31:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LME00MRPSW5JE70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jun 2011 08:31:17 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LME0000BSW4FV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jun 2011 08:31:17 +0100 (BST)
Date: Tue, 07 Jun 2011 09:31:12 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] media: vb2: add __GFP_NOWARN to dma-sg allocator
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Message-id: <1307431872-19262-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add __GFP_NOWARN parameter to videobuf2 dma-sg allocator to prevent
kernel warning and stack dump if there is not enough memory available.
Videobuf2 and drivers should correctly handle no memory case, so there
is no need for stack dump and extensive log.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
 drivers/media/video/videobuf2-dma-iommu.c |    2 +-
 drivers/media/video/videobuf2-dma-sg.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
index 240abaa..5fd6f03 100644
--- a/drivers/media/video/videobuf2-dma-sg.c
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -63,7 +63,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 		goto fail_pages_array_alloc;
 
 	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
-		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN);
 		if (NULL == buf->pages[i])
 			goto fail_pages_alloc;
 		sg_set_page(&buf->sg_desc.sglist[i],
-- 
1.7.1.569.g6f426


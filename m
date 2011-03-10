Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37666 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab1CJM3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 07:29:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LHU008CWDCVKP80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LHU00COIDCUQZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Mar 2011 12:29:18 +0000 (GMT)
Date: Thu, 10 Mar 2011 13:28:42 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 3/3] v4l2: vb2-dma-sg: fix potential security hole
In-reply-to: <1299760122-29493-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	andrzej.p@samsung.com, pawel@osciak.com
Message-id: <1299760122-29493-4-git-send-email-m.szyprowski@samsung.com>
References: <1299760122-29493-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

Memory allocated by alloc_page() function might contain some potentially
important data from other system processes. The patch adds a flag to
zero the allocated page before giving it to videobuf2 (and then to
userspace).

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-dma-sg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
index d5311ff..b2d9485 100644
--- a/drivers/media/video/videobuf2-dma-sg.c
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -62,7 +62,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 		goto fail_pages_array_alloc;
 
 	for (i = 0; i < buf->sg_desc.num_pages; ++i) {
-		buf->pages[i] = alloc_page(GFP_KERNEL);
+		buf->pages[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (NULL == buf->pages[i])
 			goto fail_pages_alloc;
 		sg_set_page(&buf->sg_desc.sglist[i],
-- 
1.7.1.569.g6f426

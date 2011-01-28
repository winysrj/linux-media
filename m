Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14869 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1A1M5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 07:57:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LFQ00JK5HB7AR80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jan 2011 12:57:08 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LFQ00DXXHB7XJ@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Jan 2011 12:57:07 +0000 (GMT)
Date: Fri, 28 Jan 2011 13:56:40 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] v4l2: vb2-dma-sg: fix memory leak
In-reply-to: <1296219400-2582-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <1296219400-2582-3-git-send-email-m.szyprowski@samsung.com>
References: <1296219400-2582-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

This patch fixes two minor memory leaks in videobuf2-dma-sg module. They
might happen only in case some other operations (like memory allocation)
failed.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf2-dma-sg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/videobuf2-dma-sg.c b/drivers/media/video/videobuf2-dma-sg.c
index 20b5c5d..d5311ff 100644
--- a/drivers/media/video/videobuf2-dma-sg.c
+++ b/drivers/media/video/videobuf2-dma-sg.c
@@ -88,6 +88,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size)
 fail_pages_alloc:
 	while (--i >= 0)
 		__free_page(buf->pages[i]);
+	kfree(buf->pages);
 
 fail_pages_array_alloc:
 	vfree(buf->sg_desc.sglist);
@@ -176,6 +177,7 @@ userptr_fail_get_user_pages:
 	       num_pages_from_user, buf->sg_desc.num_pages);
 	while (--num_pages_from_user >= 0)
 		put_page(buf->pages[num_pages_from_user]);
+	kfree(buf->pages);
 
 userptr_fail_pages_array_alloc:
 	vfree(buf->sg_desc.sglist);
-- 
1.7.1.569.g6f426


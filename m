Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26102 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0IFGx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8B0072HCHTIF20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B001CBCHSA4@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:53 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:47 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5/8] v4l: videobuf: prevent passing a NULL to
 dma_free_coherent()
In-reply-to: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com
Message-id: <1283756030-28634-6-git-send-email-m.szyprowski@samsung.com>
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <p.osciak@samsung.com>

When a driver that uses videobuf-dma-contig is used with the USERPTR
memory access method a kernel oops might happen: a NULL address may be
passed to dma_free_coherent(). This happens when an application calls
REQBUFS and then exits without queuing any buffers. This patch fixes
that bug.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/videobuf-dma-contig.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 372b87e..6ff9e4b 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -393,8 +393,10 @@ void videobuf_dma_contig_free(struct videobuf_queue *q,
 	}
 
 	/* read() method */
-	dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
-	mem->vaddr = NULL;
+	if (mem->vaddr) {
+		dma_free_coherent(q->dev, mem->size, mem->vaddr, mem->dma_handle);
+		mem->vaddr = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(videobuf_dma_contig_free);
 
-- 
1.7.2.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:35601
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0CQWyU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 18:54:20 -0400
From: Arnout Vandecappelle <arnout@mind.be>
To: linux-media@vger.kernel.org, mchehab@infradead.org, arnout@mind.be
Subject: [PATCH 1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen
Date: Wed, 17 Mar 2010 23:53:04 +0100
Message-Id: <1268866385-15692-2-git-send-email-arnout@mind.be>
In-Reply-To: <1268866385-15692-1-git-send-email-arnout@mind.be>
References: <1268866385-15692-1-git-send-email-arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_pages_to_sg() and videobuf_vmalloc_to_sg() happen to create
a scatterlist element for every page.  However, this is not true for
bus addresses, so other functions shouldn't rely on the length of the
scatter list being equal to nr_pages.
---
 drivers/media/video/videobuf-dma-sg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index da1790e..18aaf54 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -262,7 +262,7 @@ int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 	BUG_ON(!dma->sglen);
 
-	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->nr_pages, dma->direction);
+	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->sglen, dma->direction);
 	return 0;
 }
 
@@ -272,7 +272,7 @@ int videobuf_dma_unmap(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 	if (!dma->sglen)
 		return 0;
 
-	dma_unmap_sg(q->dev, dma->sglist, dma->nr_pages, dma->direction);
+	dma_unmap_sg(q->dev, dma->sglist, dma->sglen, dma->direction);
 
 	kfree(dma->sglist);
 	dma->sglist = NULL;
-- 
1.6.3.3


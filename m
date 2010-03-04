Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:51458
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0CDQB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 11:01:29 -0500
From: Arnout Vandecappelle <arnout@mind.be>
To: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	mchehab@infradead.org
Cc: Arnout Vandecappelle <arnout@mind.be>
Subject: [PATCH 1/2] V4L/DVB: buf-dma-sg.c: don't assume nr_pages == sglen
Date: Thu,  4 Mar 2010 17:00:50 +0100
Message-Id: <1267718451-24961-2-git-send-email-arnout@mind.be>
In-Reply-To: <201003031512.45428.arnout@mind.be>
References: <201003031512.45428.arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf_pages_to_sg() and videobuf_vmalloc_to_sg() happen to create
a scatterlist element for every page.  However, this is not true for
bus addresses, so other functions shouldn't rely on the length of the
scatter list being equal to nr_pages.
---
 drivers/media/video/videobuf-dma-sg.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index da1790e..3b6f1b8 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -244,7 +244,7 @@ int videobuf_dma_map(struct videobuf_queue* q, struct videobuf_dmabuf *dma)
 	}
 	if (!dma->bus_addr) {
 		dma->sglen = dma_map_sg(q->dev, dma->sglist,
-					dma->nr_pages, dma->direction);
+					dma->sglen, dma->direction);
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
 			       "%s: videobuf_map_sg failed\n",__func__);
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


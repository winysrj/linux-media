Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019Ab0EETXV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 May 2010 15:23:21 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o45JNKWg019729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 5 May 2010 15:23:20 -0400
Received: from [10.11.9.8] (vpn-9-8.rdu.redhat.com [10.11.9.8])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o45JNHHC018910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 5 May 2010 15:23:19 -0400
Message-ID: <4BE1C5A4.5060600@redhat.com>
Date: Wed, 05 May 2010 16:23:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] videobuf: remove external function videobuf_dma_sync()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While analyzing one of the videobuf patches, I noticed that
videobuf_dma_sync is only used internally inside videobuf-dma-sg.
So, let's remove this function, merging the code at __videobuf_dma_sync()

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index f733833..b49f1e2 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -279,17 +279,6 @@ int videobuf_dma_map(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 }
 EXPORT_SYMBOL_GPL(videobuf_dma_map);
 
-int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
-{
-	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
-	BUG_ON(!dma->sglen);
-
-	dma_sync_sg_for_cpu(q->dev, dma->sglist, dma->nr_pages, dma->direction);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(videobuf_dma_sync);
-
 int videobuf_dma_unmap(struct videobuf_queue *q, struct videobuf_dmabuf *dma)
 {
 	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
@@ -542,10 +531,15 @@ static int __videobuf_sync(struct videobuf_queue *q,
 			   struct videobuf_buffer *buf)
 {
 	struct videobuf_dma_sg_memory *mem = buf->priv;
-	BUG_ON(!mem);
+	BUG_ON(!mem || !mem->dma.sglen);
+
 	MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
+	MAGIC_CHECK(mem->dma.magic, MAGIC_DMABUF);
 
-	return videobuf_dma_sync(q, &mem->dma);
+	dma_sync_sg_for_cpu(q->dev, mem->dma.sglist,
+			    mem->dma.nr_pages, mem->dma.direction);
+
+	return 0;
 }
 
 static int __videobuf_mmap_mapper(struct videobuf_queue *q,
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index dbfd8cf..a195f3b 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -97,7 +97,6 @@ int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 int videobuf_dma_free(struct videobuf_dmabuf *dma);
 
 int videobuf_dma_map(struct videobuf_queue *q, struct videobuf_dmabuf *dma);
-int videobuf_dma_sync(struct videobuf_queue *q, struct videobuf_dmabuf *dma);
 int videobuf_dma_unmap(struct videobuf_queue *q, struct videobuf_dmabuf *dma);
 struct videobuf_dmabuf *videobuf_to_dma(struct videobuf_buffer *buf);
 

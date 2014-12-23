Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33856 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbaLWMqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 07:46:33 -0500
Received: from [192.168.1.106] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id C82A22A0085
	for <linux-media@vger.kernel.org>; Tue, 23 Dec 2014 13:46:11 +0100 (CET)
Message-ID: <54996423.5000303@xs4all.nl>
Date: Tue, 23 Dec 2014 13:46:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] videobuf: make unused exported functions static
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The videobuf_dma_init* and videobuf_dma_map() functions are no longer
used except in videobuf-dma-sg.c itself. Make them static.

These functions were abused in various drivers. All those drivers
have now been fixed, so by no longer exporting these functions
future abuse is now prevented.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 15 +++++----------
 include/media/videobuf-dma-sg.h           |  8 --------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 3ff15f1..f669ced 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -145,12 +145,11 @@ struct videobuf_dmabuf *videobuf_to_dma(struct videobuf_buffer *buf)
 }
 EXPORT_SYMBOL_GPL(videobuf_to_dma);
 
-void videobuf_dma_init(struct videobuf_dmabuf *dma)
+static void videobuf_dma_init(struct videobuf_dmabuf *dma)
 {
 	memset(dma, 0, sizeof(*dma));
 	dma->magic = MAGIC_DMABUF;
 }
-EXPORT_SYMBOL_GPL(videobuf_dma_init);
 
 static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 			int direction, unsigned long data, unsigned long size)
@@ -195,7 +194,7 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 	return 0;
 }
 
-int videobuf_dma_init_user(struct videobuf_dmabuf *dma, int direction,
+static int videobuf_dma_init_user(struct videobuf_dmabuf *dma, int direction,
 			   unsigned long data, unsigned long size)
 {
 	int ret;
@@ -206,9 +205,8 @@ int videobuf_dma_init_user(struct videobuf_dmabuf *dma, int direction,
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(videobuf_dma_init_user);
 
-int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
+static int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
 			     int nr_pages)
 {
 	int i;
@@ -267,9 +265,8 @@ out_free_pages:
 	return -ENOMEM;
 
 }
-EXPORT_SYMBOL_GPL(videobuf_dma_init_kernel);
 
-int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
+static int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 			      dma_addr_t addr, int nr_pages)
 {
 	dprintk(1, "init overlay [%d pages @ bus 0x%lx]\n",
@@ -284,9 +281,8 @@ int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(videobuf_dma_init_overlay);
 
-int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
+static int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 {
 	MAGIC_CHECK(dma->magic, MAGIC_DMABUF);
 	BUG_ON(0 == dma->nr_pages);
@@ -328,7 +324,6 @@ int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(videobuf_dma_map);
 
 int videobuf_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma)
 {
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index fb6fd4d8..d8b27854 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -84,16 +84,8 @@ struct videobuf_dma_sg_memory {
  * Despite the name, this is totally unrelated to videobuf, except that
  * videobuf-dma-sg uses the same API internally.
  */
-void videobuf_dma_init(struct videobuf_dmabuf *dma);
-int videobuf_dma_init_user(struct videobuf_dmabuf *dma, int direction,
-			   unsigned long data, unsigned long size);
-int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
-			     int nr_pages);
-int videobuf_dma_init_overlay(struct videobuf_dmabuf *dma, int direction,
-			      dma_addr_t addr, int nr_pages);
 int videobuf_dma_free(struct videobuf_dmabuf *dma);
 
-int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma);
 int videobuf_dma_unmap(struct device *dev, struct videobuf_dmabuf *dma);
 struct videobuf_dmabuf *videobuf_to_dma(struct videobuf_buffer *buf);
 
-- 
2.1.3


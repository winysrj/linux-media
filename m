Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755988AbZFJTob (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 15:44:31 -0400
Message-Id: <200906101944.n5AJiKW6031741@imap1.linux-foundation.org>
Subject: [patch 3/6] vino: replace dma_sync_single with dma_sync_single_for_cpu
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	fujita.tomonori@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Wed, 10 Jun 2009 12:44:20 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This replaces dma_sync_single() with dma_sync_single_for_cpu() because
dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/vino.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/media/video/vino.c~vino-replace-dma_sync_single-with-dma_sync_single_for_cpu drivers/media/video/vino.c
--- a/drivers/media/video/vino.c~vino-replace-dma_sync_single-with-dma_sync_single_for_cpu
+++ a/drivers/media/video/vino.c
@@ -868,9 +868,9 @@ static void vino_sync_buffer(struct vino
 	dprintk("vino_sync_buffer():\n");
 
 	for (i = 0; i < fb->desc_table.page_count; i++)
-		dma_sync_single(NULL,
-				fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
-				PAGE_SIZE, DMA_FROM_DEVICE);
+		dma_sync_single_for_cpu(NULL,
+					fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
+					PAGE_SIZE, DMA_FROM_DEVICE);
 }
 
 /* Framebuffer fifo functions (need to be locked externally) */
_

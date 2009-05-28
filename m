Return-path: <linux-media-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:56492 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760100AbZE1BLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 21:11:01 -0400
Date: Thu, 28 May 2009 10:10:43 +0900
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH] vino: replace dma_sync_single with dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090528100938I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This replaces dma_sync_single() with dma_sync_single_for_cpu() because
dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/media/video/vino.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index 43e0998..97b082f 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -868,9 +868,9 @@ static void vino_sync_buffer(struct vino_framebuffer *fb)
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
-- 
1.6.0.6


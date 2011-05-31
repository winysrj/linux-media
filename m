Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:45853 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1EaOpv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 10:45:51 -0400
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: hvaibhav@ti.com, sakari.ailus@iki.fi, Amber Jain <amber@ti.com>
Subject: [PATCH] OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
Date: Tue, 31 May 2011 20:15:36 +0530
Message-ID: <1306853136-12106-2-git-send-email-amber@ti.com>
In-Reply-To: <1306853136-12106-1-git-send-email-amber@ti.com>
References: <1306853136-12106-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove GFP_DMA from the __get_free_pages() call from omap24xxcam as ZONE_DMA
is not configured on OMAP. Earlier the page allocator used to return a page
from ZONE_NORMAL even when GFP_DMA is passed and CONFIG_ZONE_DMA is disabled.
As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page allocator
returns null in such a scenario with a warning emitted to kernel log.

Signed-off-by: Amber Jain <amber@ti.com>
---
 drivers/media/video/omap24xxcam.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index f6626e8..d92d4c6 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -309,11 +309,11 @@ static int omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
 			order--;
 
 		/* try to allocate as many contiguous pages as possible */
-		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
+		page = alloc_pages(GFP_KERNEL, order);
 		/* if allocation fails, try to allocate smaller amount */
 		while (page == NULL) {
 			order--;
-			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
+			page = alloc_pages(GFP_KERNEL, order);
 			if (page == NULL && !order) {
 				err = -ENOMEM;
 				goto out;
-- 
1.7.1


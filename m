Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:38786 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315Ab1EaOpt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 10:45:49 -0400
From: Amber Jain <amber@ti.com>
To: <linux-media@vger.kernel.org>
CC: hvaibhav@ti.com, sakari.ailus@iki.fi, Amber Jain <amber@ti.com>
Subject: [PATCH] V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
Date: Tue, 31 May 2011 20:15:35 +0530
Message-ID: <1306853136-12106-1-git-send-email-amber@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove GFP_DMA from the __get_free_pages() call from omap_vout as ZONE_DMA 
is not configured on OMAP. Earlier the page allocator used to return a page
from ZONE_NORMAL even when GFP_DMA is passed and CONFIG_ZONE_DMA is disabled.
As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page allocator
returns null in such a scenario with a warning emitted to kernel log.

Signed-off-by: Amber Jain <amber@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 4ada9be..8cac624 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -181,7 +181,7 @@ static unsigned long omap_vout_alloc_buffer(u32 buf_size, u32 *phys_addr)
 
 	size = PAGE_ALIGN(buf_size);
 	order = get_order(size);
-	virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
+	virt_addr = __get_free_pages(GFP_KERNEL, order);
 	addr = virt_addr;
 
 	if (virt_addr) {
-- 
1.7.1


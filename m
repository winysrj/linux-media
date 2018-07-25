Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37734 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730594AbeGYWPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 18:15:01 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>,
        Jacob chen <jacob2.chen@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] rockchip/rga: Fix bad dma_free_attrs() parameter
Date: Wed, 25 Jul 2018 18:01:23 -0300
Message-Id: <20180725210123.10836-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In rga_remove(), dma_free_attrs is being passed the wrong
cpu address, which triggers an exception if the driver is
removed. Fix it.

Tested on a RK3399 platform, with a bind/unbind cycle.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/rockchip/rga/rga.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index 8ace1873202a..850da4b34e12 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -931,7 +931,7 @@ static int rga_remove(struct platform_device *pdev)
 {
 	struct rockchip_rga *rga = platform_get_drvdata(pdev);
 
-	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, &rga->cmdbuf_virt,
+	dma_free_attrs(rga->dev, RGA_CMDBUF_SIZE, rga->cmdbuf_virt,
 		       rga->cmdbuf_phy, DMA_ATTR_WRITE_COMBINE);
 
 	free_pages((unsigned long)rga->src_mmu_pages, 3);
-- 
2.18.0

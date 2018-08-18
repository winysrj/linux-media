Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11176 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726230AbeHRSg4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 14:36:56 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <yong.zhi@intel.com>, <sakari.ailus@linux.intel.com>,
        <bingbu.cao@intel.com>, <mchehab@kernel.org>,
        <matthias.bgg@gmail.com>
CC: <tian.shu.qiu@intel.com>, <jian.xu.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] media: mtk_vcodec_util: Use dma_zalloc_coherent to replace dma_alloc_coherent + memset
Date: Sat, 18 Aug 2018 23:16:55 +0800
Message-ID: <1534605415-11452-3-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1534605415-11452-1-git-send-email-zhongjiang@huawei.com>
References: <1534605415-11452-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_zalloc_coherent has implemented the dma_alloc_coherent() + memset(),
We prefer to dma_zalloc_coherent instead of open-codeing.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
index 0c28d0b..e80123c 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
@@ -49,16 +49,13 @@ int mtk_vcodec_mem_alloc(struct mtk_vcodec_ctx *data,
 	struct mtk_vcodec_ctx *ctx = (struct mtk_vcodec_ctx *)data;
 	struct device *dev = &ctx->dev->plat_dev->dev;
 
-	mem->va = dma_alloc_coherent(dev, size, &mem->dma_addr, GFP_KERNEL);
-
+	mem->va = dma_zalloc_coherent(dev, size, &mem->dma_addr, GFP_KERNEL);
 	if (!mem->va) {
 		mtk_v4l2_err("%s dma_alloc size=%ld failed!", dev_name(dev),
 			     size);
 		return -ENOMEM;
 	}
 
-	memset(mem->va, 0, size);
-
 	mtk_v4l2_debug(3, "[%d]  - va      = %p", ctx->id, mem->va);
 	mtk_v4l2_debug(3, "[%d]  - dma     = 0x%lx", ctx->id,
 		       (unsigned long)mem->dma_addr);
-- 
1.7.12.4

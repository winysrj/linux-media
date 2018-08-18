Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11143 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbeHRShD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 14:37:03 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <yong.zhi@intel.com>, <sakari.ailus@linux.intel.com>,
        <bingbu.cao@intel.com>, <mchehab@kernel.org>,
        <matthias.bgg@gmail.com>
CC: <tian.shu.qiu@intel.com>, <jian.xu.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] media: ipu3-cio2: Use dma_zalloc_coherent to replace dma_alloc_coherent + memset
Date: Sat, 18 Aug 2018 23:16:54 +0800
Message-ID: <1534605415-11452-2-git-send-email-zhongjiang@huawei.com>
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
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 2902715..f0c6374 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -218,13 +218,11 @@ static int cio2_fbpt_init(struct cio2_device *cio2, struct cio2_queue *q)
 {
 	struct device *dev = &cio2->pci_dev->dev;
 
-	q->fbpt = dma_alloc_coherent(dev, CIO2_FBPT_SIZE, &q->fbpt_bus_addr,
-				     GFP_KERNEL);
+	q->fbpt = dma_zalloc_coherent(dev, CIO2_FBPT_SIZE, &q->fbpt_bus_addr,
+				      GFP_KERNEL);
 	if (!q->fbpt)
 		return -ENOMEM;
 
-	memset(q->fbpt, 0, CIO2_FBPT_SIZE);
-
 	return 0;
 }
 
-- 
1.7.12.4

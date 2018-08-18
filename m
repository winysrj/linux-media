Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:11142 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbeHRSg6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Aug 2018 14:36:58 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <yong.zhi@intel.com>, <sakari.ailus@linux.intel.com>,
        <bingbu.cao@intel.com>, <mchehab@kernel.org>,
        <matthias.bgg@gmail.com>
CC: <tian.shu.qiu@intel.com>, <jian.xu.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH 0/2] media: Use dma_zalloc_coherent to replace dma_alloc_coherent + memset
Date: Sat, 18 Aug 2018 23:16:53 +0800
Message-ID: <1534605415-11452-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The issue is detected with the help of Coccinelle.

zhong jiang (2):
  media: ipu3-cio2: Use dma_zalloc_coherent to replace
    dma_alloc_coherent + memset
  media: mtk_vcodec_util: Use dma_zalloc_coherent to replace
    dma_alloc_coherent + memset

 drivers/media/pci/intel/ipu3/ipu3-cio2.c            | 6 ++----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c | 5 +----
 2 files changed, 3 insertions(+), 8 deletions(-)

-- 
1.7.12.4

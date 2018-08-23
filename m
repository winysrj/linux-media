Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:45518 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbeHWOxN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 10:53:13 -0400
Message-ID: <5B7E9947.5000005@huawei.com>
Date: Thu, 23 Aug 2018 19:23:51 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: <yong.zhi@intel.com>, <sakari.ailus@linux.intel.com>,
        <bingbu.cao@intel.com>, <mchehab@kernel.org>,
        <matthias.bgg@gmail.com>
CC: <tian.shu.qiu@intel.com>, <jian.xu.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/2] media: Use dma_zalloc_coherent to replace dma_alloc_coherent
 + memset
References: <1534605415-11452-1-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1534605415-11452-1-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping,  Anyone has any objections about the patcheset?

Best wishes,
zhong jiang
On 2018/8/18 23:16, zhong jiang wrote:
> The issue is detected with the help of Coccinelle.
>
> zhong jiang (2):
>   media: ipu3-cio2: Use dma_zalloc_coherent to replace
>     dma_alloc_coherent + memset
>   media: mtk_vcodec_util: Use dma_zalloc_coherent to replace
>     dma_alloc_coherent + memset
>
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c            | 6 ++----
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c | 5 +----
>  2 files changed, 3 insertions(+), 8 deletions(-)
>

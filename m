Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64509 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725735AbeHXG15 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 02:27:57 -0400
Subject: Re: [PATCH 1/2] media: ipu3-cio2: Use dma_zalloc_coherent to replace
 dma_alloc_coherent + memset
To: zhong jiang <zhongjiang@huawei.com>, yong.zhi@intel.com,
        sakari.ailus@linux.intel.com, bingbu.cao@intel.com,
        mchehab@kernel.org, matthias.bgg@gmail.com
Cc: tian.shu.qiu@intel.com, jian.xu.zheng@intel.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <1534605415-11452-1-git-send-email-zhongjiang@huawei.com>
 <1534605415-11452-2-git-send-email-zhongjiang@huawei.com>
From: Bing Bu Cao <bingbu.cao@linux.intel.com>
Message-ID: <541b8c22-018f-4df6-85d1-82a72d9ab669@linux.intel.com>
Date: Fri, 24 Aug 2018 10:58:52 +0800
MIME-Version: 1.0
In-Reply-To: <1534605415-11452-2-git-send-email-zhongjiang@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Jiang

This looks fine for me in ipu3-cio2.
Actually, we already have this change locally, but I think we miss submit it to community.
Thanks!

On 08/18/2018 11:16 PM, zhong jiang wrote:
> dma_zalloc_coherent has implemented the dma_alloc_coherent() + memset(),
> We prefer to dma_zalloc_coherent instead of open-codeing.
>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> index 2902715..f0c6374 100644
> --- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> +++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
> @@ -218,13 +218,11 @@ static int cio2_fbpt_init(struct cio2_device *cio2, struct cio2_queue *q)
>  {
>  	struct device *dev = &cio2->pci_dev->dev;
>  
> -	q->fbpt = dma_alloc_coherent(dev, CIO2_FBPT_SIZE, &q->fbpt_bus_addr,
> -				     GFP_KERNEL);
> +	q->fbpt = dma_zalloc_coherent(dev, CIO2_FBPT_SIZE, &q->fbpt_bus_addr,
> +				      GFP_KERNEL);
>  	if (!q->fbpt)
>  		return -ENOMEM;
>  
> -	memset(q->fbpt, 0, CIO2_FBPT_SIZE);
> -
>  	return 0;
>  }
>  

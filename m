Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23003 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbcG0HuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2016 03:50:22 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OAY00CLTR3U4860@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jul 2016 08:50:18 +0100 (BST)
Subject: Re: media: vb2-dma-contig: fix sizeof(pointer) allocation
To: Alexey Dobriyan <adobriyan@gmail.com>, s.nawrocki@samsung.com,
	mchehab@s-opensource.com
References: <20160727073706.GA15733@p183.telecom.by>
Cc: linux-media@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <c71cc1cc-e64f-8dff-b60e-4ef85e318636@samsung.com>
Date: Wed, 27 Jul 2016 09:50:17 +0200
MIME-version: 1.0
In-reply-to: <20160727073706.GA15733@p183.telecom.by>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey


On 2016-07-27 09:37, Alexey Dobriyan wrote:
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

A fix for this issue has been already queued:
https://patchwork.linuxtv.org/patch/35582/

> ---
>
>   drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -749,7 +749,7 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>   int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
>   {
>   	if (!dev->dma_parms) {
> -		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
> +		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
>   		if (!dev->dma_parms)
>   			return -ENOMEM;
>   	}
>
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


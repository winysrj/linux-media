Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64323 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbcGSIm0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 04:42:26 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Subject: Re: [PATCH next] [media] vb2: Fix allocation size of dma_parms
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@laposte.net>,
	linux-media@vger.kernel.org
References: <1464074167-27330-2-git-send-email-m.szyprowski@samsung.com>
 <1468864444-19053-1-git-send-email-vincent.stehle@laposte.net>
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <c501ff83-b74c-0be0-7a97-19a406074ea3@samsung.com>
Date: Tue, 19 Jul 2016 10:42:20 +0200
In-reply-to: <1468864444-19053-1-git-send-email-vincent.stehle@laposte.net>
Content-transfer-encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi


On 2016-07-18 19:54, Vincent Stehlé wrote:
> When allocating memory to hold the device dma parameters in
> vb2_dma_contig_set_max_seg_size(), the requested size is by mistake only
> the size of a pointer. Request the correct size instead.
>
> Fixes: 3f0339691896 ("media: vb2-dma-contig: add helper for setting dma max seg size")
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

I'm really sorry for such silly mistake. Thanks for spotting this issue.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>
>
> Hi,
>
> I saw that in linux next-20160718.
>
> Best regards,
>
> Vincent.
>
>
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index b09b2c9..59fa204 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -743,7 +743,7 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>   int vb2_dma_contig_set_max_seg_size(struct device *dev, unsigned int size)
>   {
>   	if (!dev->dma_parms) {
> -		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);
> +		dev->dma_parms = kzalloc(sizeof(*dev->dma_parms), GFP_KERNEL);
>   		if (!dev->dma_parms)
>   			return -ENOMEM;
>   	}

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


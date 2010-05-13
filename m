Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway02.websitewelcome.com ([69.56.159.20]:41910 "HELO
	gateway02.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750785Ab0EMWcG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 18:32:06 -0400
Subject: Re: [PATCH] Staging: saa7134-go7007: replace dma_sync_single with
 dma_sync_single_for_cpu
From: Pete Eberlein <pete@sensoray.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <20100513124613U.fujita.tomonori@lab.ntt.co.jp>
References: <20100513124613U.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 15:25:24 -0700
Message-ID: <1273789524.4502.51.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, Tomonori.

Does this need to get submitted to the linux-media tree as well, or will
this patch get pulled automatically from Linus' tree?

Thanks,
Pete Eberlein

On Thu, 2010-05-13 at 12:45 +0900, FUJITA Tomonori wrote:
> dma_sync_single() is deprecated and will be removed soon.
> 
> No functional change since dma_sync_single is the wrapper of
> dma_sync_single_for_cpu.
> 
> saa7134-go7007.c is commented out but anyway let's replace it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/staging/go7007/saa7134-go7007.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/go7007/saa7134-go7007.c b/drivers/staging/go7007/saa7134-go7007.c
> index b25d7d2..0d36ce7 100644
> --- a/drivers/staging/go7007/saa7134-go7007.c
> +++ b/drivers/staging/go7007/saa7134-go7007.c
> @@ -242,13 +242,13 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
>  		printk(KERN_DEBUG "saa7134-go7007: irq: lost %ld\n",
>  				(status >> 16) & 0x0f);
>  	if (status & 0x100000) {
> -		dma_sync_single(&dev->pci->dev,
> -				saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
> +		dma_sync_single_for_cpu(&dev->pci->dev,
> +					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
>  		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
>  		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
>  	} else {
> -		dma_sync_single(&dev->pci->dev,
> -				saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
> +		dma_sync_single_for_cpu(&dev->pci->dev,
> +					saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
>  		go7007_parse_video_stream(go, saa->top, PAGE_SIZE);
>  		saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
>  	}



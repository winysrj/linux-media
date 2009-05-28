Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:32530 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZE1GCz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 02:02:55 -0400
Message-ID: <4A1E28E6.2090807@gmail.com>
Date: Thu, 28 May 2009 08:02:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] vino: replace dma_sync_single with dma_sync_single_for_cpu
References: <20090528100938I.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090528100938I.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/28/2009 03:10 AM, FUJITA Tomonori wrote:
> This replaces dma_sync_single() with dma_sync_single_for_cpu() because
> dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:
> 
> /* Backwards compat, remove in 2.7.x */
> #define dma_sync_single		dma_sync_single_for_cpu
> #define dma_sync_sg		dma_sync_sg_for_cpu
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/media/video/vino.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
> index 43e0998..97b082f 100644
> --- a/drivers/media/video/vino.c
> +++ b/drivers/media/video/vino.c
> @@ -868,9 +868,9 @@ static void vino_sync_buffer(struct vino_framebuffer *fb)
>  	dprintk("vino_sync_buffer():\n");
>  
>  	for (i = 0; i < fb->desc_table.page_count; i++)
> -		dma_sync_single(NULL,
> -				fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
> -				PAGE_SIZE, DMA_FROM_DEVICE);
> +		dma_sync_single_for_cpu(NULL,
> +					fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
> +					PAGE_SIZE, DMA_FROM_DEVICE);

Shouldn't be there sync_for_device in vino_dma_setup (or somewhere)
then? If I understand the API correctly this won't (and didn't) work on
some platforms.

The same for other drivers who don't free the buffer after the sync but
recycle it instead.

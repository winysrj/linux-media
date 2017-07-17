Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:31029 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdGQKWg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 06:22:36 -0400
Subject: Re: [PATCH] [BUGREPORT] media: v4l: omap_vout: vrfb: initialize DMA
 flags
To: Arnd Bergmann <arnd@arndb.de>
References: <20170710111912.887188-1-arnd@arndb.de>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <e236a458-b89b-2ce1-0eee-7a26ea343647@ti.com>
Date: Mon, 17 Jul 2017 13:23:22 +0300
MIME-Version: 1.0
In-Reply-To: <20170710111912.887188-1-arnd@arndb.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arnd,

sorry for the delayed response, I was away w/o internet connection for
the past weeks.

On 2017-07-10 14:18, Arnd Bergmann wrote:
> Passing uninitialized flags into device_prep_interleaved_dma is clearly
> a bad idea, and we get a compiler warning for it:
> 
> drivers/media/platform/omap/omap_vout_vrfb.c: In function 'omap_vout_prepare_vrfb':
> drivers/media/platform/omap/omap_vout_vrfb.c:273:5: error: 'flags' may be used uninitialized in this function [-Werror=maybe-uninitialized]

I can not explain why I have missed this.

> It seems that the OMAP dmaengine ignores the flags, but we should
> pick the right ones anyway. Unfortunately I don't know what they
> should be, so I just picked the most common flags. Please set the
> right flags here and fold the modified patch.

The flags are fine.

> 
> Fixes: 6a1560ecaa8c ("media: v4l: omap_vout: vrfb: Convert to dmaengine")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/media/platform/omap/omap_vout_vrfb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
> index 45a553d4f5b2..fed28b6bbbc0 100644
> --- a/drivers/media/platform/omap/omap_vout_vrfb.c
> +++ b/drivers/media/platform/omap/omap_vout_vrfb.c
> @@ -233,7 +233,7 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
>  			   struct videobuf_buffer *vb)
>  {
>  	struct dma_async_tx_descriptor *tx;
> -	enum dma_ctrl_flags flags;
> +	enum dma_ctrl_flags flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
>  	struct dma_chan *chan = vout->vrfb_dma_tx.chan;
>  	struct dma_device *dmadev = chan->device;
>  	struct dma_interleaved_template *xt = vout->vrfb_dma_tx.xt;
> 

- Péter

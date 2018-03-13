Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:27512 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932706AbeCMN31 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 09:29:27 -0400
Subject: Re: [PATCH] media: v4l: omap_vout: vrfb: remove an unused variable
To: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20180313120548.2603484-1-arnd@arndb.de>
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <e8698583-75b1-7dcb-f331-521a4581c3b4@ti.com>
Date: Tue, 13 Mar 2018 15:29:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180313120548.2603484-1-arnd@arndb.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2018-03-13 14:05, Arnd Bergmann wrote:
> We now get a warning after the 'dmadev' variable is no longer used:
> 
> drivers/media/platform/omap/omap_vout_vrfb.c: In function 'omap_vout_prepare_vrfb':
> drivers/media/platform/omap/omap_vout_vrfb.c:239:21: error: unused variable 'dmadev' [-Werror=unused-variable]
> 
> Fixes: 8f0aa38292f2 ("media: v4l: omap_vout: vrfb: Use the wrapper for prep_interleaved_dma()")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/media/platform/omap/omap_vout_vrfb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
> index 72c0ac2cbf3d..1d8508237220 100644
> --- a/drivers/media/platform/omap/omap_vout_vrfb.c
> +++ b/drivers/media/platform/omap/omap_vout_vrfb.c
> @@ -236,7 +236,6 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
>  	struct dma_async_tx_descriptor *tx;
>  	enum dma_ctrl_flags flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
>  	struct dma_chan *chan = vout->vrfb_dma_tx.chan;
> -	struct dma_device *dmadev = chan->device;
>  	struct dma_interleaved_template *xt = vout->vrfb_dma_tx.xt;
>  	dma_cookie_t cookie;
>  	enum dma_status status;
> 

- Péter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

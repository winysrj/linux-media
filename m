Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:53948 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbbEZPJG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 11:09:06 -0400
Date: Tue, 26 May 2015 08:08:53 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: vinod.koul@intel.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 03/13] serial: 8250_dma: Support for deferred probing
 when requesting DMA channels
Message-ID: <20150526150852.GC16525@atomide.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Peter Ujfalusi <peter.ujfalusi@ti.com> [150526 06:28]:
> Switch to use ma_request_slave_channel_compat_reason() to request the DMA
> channels. In case of error, return the error code we received including
> -EPROBE_DEFER
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/8250/8250_dma.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
> index 21d01a491405..a617eca4e97d 100644
> --- a/drivers/tty/serial/8250/8250_dma.c
> +++ b/drivers/tty/serial/8250/8250_dma.c
> @@ -182,21 +182,19 @@ int serial8250_request_dma(struct uart_8250_port *p)
>  	dma_cap_set(DMA_SLAVE, mask);
>  
>  	/* Get a channel for RX */
> -	dma->rxchan = dma_request_slave_channel_compat(mask,
> -						       dma->fn, dma->rx_param,
> -						       p->port.dev, "rx");
> -	if (!dma->rxchan)
> -		return -ENODEV;
> +	dma->rxchan = dma_request_slave_channel_compat_reason(mask, dma->fn,
> +					dma->rx_param, p->port.dev, "rx");
> +	if (IS_ERR(dma->rxchan))
> +		return PTR_ERR(dma->rxchan);
>  
>  	dmaengine_slave_config(dma->rxchan, &dma->rxconf);
>  
>  	/* Get a channel for TX */
> -	dma->txchan = dma_request_slave_channel_compat(mask,
> -						       dma->fn, dma->tx_param,
> -						       p->port.dev, "tx");
> -	if (!dma->txchan) {
> +	dma->txchan = dma_request_slave_channel_compat_reason(mask, dma->fn,
> +					dma->tx_param, p->port.dev, "tx");
> +	if (IS_ERR(dma->txchan)) {
>  		dma_release_channel(dma->rxchan);
> -		return -ENODEV;
> +		return PTR_ERR(dma->txchan);
>  	}
>  
>  	dmaengine_slave_config(dma->txchan, &dma->txconf);

In general the drivers need to work just fine also without DMA.

Does this handle the case properly where no DMA channel is configured
for the driver in the dts file?

Regards,

Tony

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34733 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbE1HX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 03:23:26 -0400
Received: by qgez61 with SMTP id z61so12617103qge.1
        for <linux-media@vger.kernel.org>; Thu, 28 May 2015 00:23:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432646768-12532-6-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<1432646768-12532-6-git-send-email-peter.ujfalusi@ti.com>
Date: Thu, 28 May 2015 09:23:25 +0200
Message-ID: <CAPDyKFocEvZnV=BpPB8L3+XvS4YrMB9OJUW4_x=7H43mDww45Q@mail.gmail.com>
Subject: Re: [PATCH 05/13] mmc: omap_hsmmc: Support for deferred probing when
 requesting DMA channels
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
	Tony Lindgren <tony@atomide.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap <linux-omap@vger.kernel.org>,
	linux-mmc <linux-mmc@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 May 2015 at 15:26, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Switch to use ma_request_slave_channel_compat_reason() to request the DMA

I guess it should be dma_request_slave_... huh, that was a long name. :-)

> channels. In case of error, return the error code we received including
> -EPROBE_DEFER
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Ulf Hansson <ulf.hansson@linaro.org>

With the minor change above.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/mmc/host/omap_hsmmc.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 57bb85930f81..d252478391ee 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -2088,23 +2088,21 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
>         dma_cap_zero(mask);
>         dma_cap_set(DMA_SLAVE, mask);
>
> -       host->rx_chan =
> -               dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
> -                                                &rx_req, &pdev->dev, "rx");
> +       host->rx_chan = dma_request_slave_channel_compat_reason(mask,
> +                               omap_dma_filter_fn, &rx_req, &pdev->dev, "rx");
>
> -       if (!host->rx_chan) {
> +       if (IS_ERR(host->rx_chan)) {
>                 dev_err(mmc_dev(host->mmc), "unable to obtain RX DMA engine channel %u\n", rx_req);
> -               ret = -ENXIO;
> +               ret = PTR_ERR(host->rx_chan);
>                 goto err_irq;
>         }
>
> -       host->tx_chan =
> -               dma_request_slave_channel_compat(mask, omap_dma_filter_fn,
> -                                                &tx_req, &pdev->dev, "tx");
> +       host->tx_chan = dma_request_slave_channel_compat_reason(mask,
> +                               omap_dma_filter_fn, &tx_req, &pdev->dev, "tx");
>
> -       if (!host->tx_chan) {
> +       if (IS_ERR(host->tx_chan)) {
>                 dev_err(mmc_dev(host->mmc), "unable to obtain TX DMA engine channel %u\n", tx_req);
> -               ret = -ENXIO;
> +               ret = PTR_ERR(host->tx_chan);
>                 goto err_irq;
>         }
>
> @@ -2166,9 +2164,9 @@ err_slot_name:
>         if (host->use_reg)
>                 omap_hsmmc_reg_put(host);
>  err_irq:
> -       if (host->tx_chan)
> +       if (!IS_ERR_OR_NULL(host->tx_chan))
>                 dma_release_channel(host->tx_chan);
> -       if (host->rx_chan)
> +       if (!IS_ERR_OR_NULL(host->rx_chan))
>                 dma_release_channel(host->rx_chan);
>         pm_runtime_put_sync(host->dev);
>         pm_runtime_disable(host->dev);
> --
> 2.3.5
>

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34475 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbE1HUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 03:20:19 -0400
Received: by qkoo18 with SMTP id o18so19976569qko.1
        for <linux-media@vger.kernel.org>; Thu, 28 May 2015 00:20:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432646768-12532-5-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<1432646768-12532-5-git-send-email-peter.ujfalusi@ti.com>
Date: Thu, 28 May 2015 09:20:18 +0200
Message-ID: <CAPDyKFrOUOuctSMpx+RFixB_ub=d66YqXEsa7D78gyFeiGiNkQ@mail.gmail.com>
Subject: Re: [PATCH 04/13] mmc: omap_hsmmc: No need to check DMA channel
 validity at module remove
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

On 26 May 2015 at 15:25, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> The driver will not probe without valid DMA channels so no need to check
> if they are valid when the module is removed.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/mmc/host/omap_hsmmc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 2cd828f42151..57bb85930f81 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -2190,10 +2190,8 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
>         if (host->use_reg)
>                 omap_hsmmc_reg_put(host);
>
> -       if (host->tx_chan)
> -               dma_release_channel(host->tx_chan);
> -       if (host->rx_chan)
> -               dma_release_channel(host->rx_chan);
> +       dma_release_channel(host->tx_chan);
> +       dma_release_channel(host->rx_chan);
>
>         pm_runtime_put_sync(host->dev);
>         pm_runtime_disable(host->dev);
> --
> 2.3.5
>

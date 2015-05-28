Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:33999 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbbE1HbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 03:31:20 -0400
Received: by qcbhb1 with SMTP id hb1so14118626qcb.1
        for <linux-media@vger.kernel.org>; Thu, 28 May 2015 00:31:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432646768-12532-8-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<1432646768-12532-8-git-send-email-peter.ujfalusi@ti.com>
Date: Thu, 28 May 2015 09:31:19 +0200
Message-ID: <CAPDyKFpiHz9nePG0D5HzMkuBGcyt7340hWjjn1emqAKZGWoUnA@mail.gmail.com>
Subject: Re: [PATCH 07/13] mmc: davinci_mmc: Support for deferred probing when
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
> channels. Only fall back to pio mode if the error code returned is not
> -EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.
>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> CC: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

> ---
>  drivers/mmc/host/davinci_mmc.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index b2b3f8bbfd8c..df81e4e2f662 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -530,20 +530,20 @@ static int __init davinci_acquire_dma_channels(struct mmc_davinci_host *host)
>         dma_cap_zero(mask);
>         dma_cap_set(DMA_SLAVE, mask);
>
> -       host->dma_tx =
> -               dma_request_slave_channel_compat(mask, edma_filter_fn,
> -                               &host->txdma, mmc_dev(host->mmc), "tx");
> -       if (!host->dma_tx) {
> +       host->dma_tx = dma_request_slave_channel_compat_reason(mask,
> +                               edma_filter_fn, &host->txdma,
> +                               mmc_dev(host->mmc), "tx");
> +       if (IS_ERR(host->dma_tx)) {
>                 dev_err(mmc_dev(host->mmc), "Can't get dma_tx channel\n");
> -               return -ENODEV;
> +               return PTR_ERR(host->dma_tx);
>         }
>
> -       host->dma_rx =
> -               dma_request_slave_channel_compat(mask, edma_filter_fn,
> -                               &host->rxdma, mmc_dev(host->mmc), "rx");
> -       if (!host->dma_rx) {
> +       host->dma_rx = dma_request_slave_channel_compat_reason(mask,
> +                               edma_filter_fn, &host->rxdma,
> +                               mmc_dev(host->mmc), "rx");
> +       if (IS_ERR(host->dma_rx)) {
>                 dev_err(mmc_dev(host->mmc), "Can't get dma_rx channel\n");
> -               r = -ENODEV;
> +               r = PTR_ERR(host->dma_rx);
>                 goto free_master_write;
>         }
>
> @@ -1307,8 +1307,12 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>         host->mmc_irq = irq;
>         host->sdio_irq = platform_get_irq(pdev, 1);
>
> -       if (host->use_dma && davinci_acquire_dma_channels(host) != 0)
> +       if (host->use_dma) {
> +               ret = davinci_acquire_dma_channels(host);
> +               if (ret == -EPROBE_DEFER)
> +                       goto out;
>                 host->use_dma = 0;
> +       }
>
>         /* REVISIT:  someday, support IRQ-driven card detection.  */
>         mmc->caps |= MMC_CAP_NEEDS_POLL;
> --
> 2.3.5
>

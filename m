Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44271 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbDLNK0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2015 09:10:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] media: atmel-isi: remove the useless code which disable isi
Date: Sun, 12 Apr 2015 16:10:53 +0300
Message-ID: <2109629.IWfKzc1IIn@avalon>
In-Reply-To: <1428570108-4961-2-git-send-email-josh.wu@atmel.com>
References: <1428570108-4961-1-git-send-email-josh.wu@atmel.com> <1428570108-4961-2-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Thursday 09 April 2015 17:01:46 Josh Wu wrote:
> To program ISI control register, the pixel clock should be enabled.

That's an awful hardware design :-(

> So without pixel clock (from sensor) enabled, disable ISI controller is
> not make sense. So this patch remove those code.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> 
> Changes in v2:
> - this file is new added.
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> b/drivers/media/platform/soc_camera/atmel-isi.c index c125b1d..31254b4
> 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -131,8 +131,6 @@ static int configure_geometry(struct atmel_isi *isi, u32
> width, return -EINVAL;
>  	}
> 
> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> -
>  	cfg2 = isi_readl(isi, ISI_CFG2);

Can the configuration registers be accessed when the pixel clock is disabled ?

>  	/* Set YCC swap mode */
>  	cfg2 &= ~ISI_CFG2_YCC_SWAP_MODE_MASK;
> @@ -843,7 +841,6 @@ static int isi_camera_set_bus_param(struct
> soc_camera_device *icd)
> 
>  	cfg1 |= ISI_CFG1_THMASK_BEATS_16;
> 
> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
>  	isi_writel(isi, ISI_CFG1, cfg1);
> 
>  	return 0;
> @@ -1022,8 +1019,6 @@ static int atmel_isi_probe(struct platform_device
> *pdev) if (isi->pdata.data_width_flags & ISI_DATAWIDTH_10)
>  		isi->width_flags |= 1 << 9;
> 
> -	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> -
>  	irq = platform_get_irq(pdev, 0);
>  	if (IS_ERR_VALUE(irq)) {
>  		ret = irq;

-- 
Regards,

Laurent Pinchart


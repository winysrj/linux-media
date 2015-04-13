Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45567 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbbDMVVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 17:21:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tim Nordell <tim.nordell@logicpd.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Subject: Re: [PATCH v2] OMAP3 ISP: Set DMA segment size
Date: Tue, 14 Apr 2015 00:22:10 +0300
Message-ID: <1510418.BOtJjAzaMU@avalon>
In-Reply-To: <1426773592-30182-1-git-send-email-tim.nordell@logicpd.com>
References: <1426719343-13027-1-git-send-email-tim.nordell@logicpd.com> <1426773592-30182-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tim,

Thank you for the patch.

On Thursday 19 March 2015 08:59:52 Tim Nordell wrote:
> When utilizing userptr buffers for output from the CCDC, the
> DMA subsystem maps buffers into the virtual address space.
> However, the DMA subsystem also has a configurable parameter
> for what the largest segment to allocate is out of the virtual
> address space as well.
> 
> Since we need contiguous buffers for the memory space from the
> OMAP3 ISP's vantage point, we need to configure the segments
> to be at least as large as the largest buffer we expect.
> 
> Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
> ---
>  drivers/media/platform/omap3isp/isp.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index ead2d0d..906d3e5 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2170,6 +2170,20 @@ static int isp_attach_iommu(struct isp_device *isp)
>  		goto error;
>  	}
> 
> +	isp->dev->dma_parms = devm_kzalloc(isp->dev,
> +		sizeof(*isp->dev->dma_parms), GFP_KERNEL);
> +	if (!isp->dev->dma_parms) {
> +		dev_err(isp->dev, "failed to allocate memory for dma_parms\n");
> +		ret = -ENOMEM;
> +		goto error;
> +	}

How about adding a struct device_dma_parameters field in struct isp_device and 
just assigning isp->dev->dma_parms = &isp->dma_parms ? This would get rid of 
the separate allocation step.

> +
> +	ret = dma_set_max_seg_size(isp->dev, SZ_32M);

There's no reason to limit the size to 32MB, you can use the full 4GB 
addressable space.

> +	if (ret < 0) {
> +		dev_err(isp->dev, "failed to set max segment size for dma\n");
> +		goto error;
> +	}
> +
>  	return 0;
> 
>  error:

-- 
Regards,

Laurent Pinchart


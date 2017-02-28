Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43940 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752388AbdB1NMJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:12:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/6] omap3isp: Don't rely on devm for memory resource management
Date: Tue, 28 Feb 2017 15:12:39 +0200
Message-ID: <17312150.yLXnxzLeiM@avalon>
In-Reply-To: <1487604142-27610-2-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com> <1487604142-27610-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 20 Feb 2017 17:22:17 Sakari Ailus wrote:
> devm functions are fine for managing resources that are directly related
> to the device at hand and that have no other dependencies. However, a
> process holding a file handle to a device created by a driver for a device
> may result in the file handle left behind after the device is long gone.
> This will result in accessing released (and potentially reallocated)
> memory.
> 
> Instead, manage the memory resources in the driver. Releasing the
> resources can be later on bound to e.g. by releasing a reference.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/omap3isp/isp.c         | 18 ++++++++++++------
>  drivers/media/platform/omap3isp/isph3a_aewb.c | 24 +++++++++++++++++-------
> drivers/media/platform/omap3isp/isph3a_af.c   | 24 +++++++++++++++++-------
> drivers/media/platform/omap3isp/isphist.c     | 11 +++++++----
>  drivers/media/platform/omap3isp/ispstat.c     |  2 ++
>  5 files changed, 55 insertions(+), 24 deletions(-)

[snip]

> diff --git a/drivers/media/platform/omap3isp/isphist.c
> b/drivers/media/platform/omap3isp/isphist.c index a4ed5d1..9e448c6 100644
> --- a/drivers/media/platform/omap3isp/isphist.c
> +++ b/drivers/media/platform/omap3isp/isphist.c
> @@ -476,9 +476,9 @@ int omap3isp_hist_init(struct isp_device *isp)
>  {
>  	struct ispstat *hist = &isp->isp_hist;
>  	struct omap3isp_hist_config *hist_cfg;
> -	int ret = -1;
> +	int ret;
> 
> -	hist_cfg = devm_kzalloc(isp->dev, sizeof(*hist_cfg), GFP_KERNEL);
> +	hist_cfg = kzalloc(sizeof(*hist_cfg), GFP_KERNEL);
>  	if (hist_cfg == NULL)
>  		return -ENOMEM;
> 
> @@ -500,7 +500,7 @@ int omap3isp_hist_init(struct isp_device *isp)
>  		if (IS_ERR(hist->dma_ch)) {
>  			ret = PTR_ERR(hist->dma_ch);
>  			if (ret == -EPROBE_DEFER)
> -				return ret;
> +				goto err;
> 
>  			hist->dma_ch = NULL;
>  			dev_warn(isp->dev,
> @@ -516,9 +516,12 @@ int omap3isp_hist_init(struct isp_device *isp)
>  	hist->event_type = V4L2_EVENT_OMAP3ISP_HIST;
> 
>  	ret = omap3isp_stat_init(hist, "histogram", &hist_subdev_ops);
> +
> +err:
>  	if (ret) {
> -		if (hist->dma_ch)
> +		if (!IS_ERR(hist->dma_ch))

I think this change is wrong. dma_ch is initialize to NULL by kzalloc(). You 
will end up calling dma_release_channel() on a NULL channel if 
omap3isp_stat_init() fails and HIST_CONFIG_DMA is false. The check should be

	if (!IS_ERR_OR_NULL(hist->dma_ch))

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  			dma_release_channel(hist->dma_ch);
> +		kfree(hist_cfg);
>  	}
> 
>  	return ret;

[snip]

-- 
Regards,

Laurent Pinchart

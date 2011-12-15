Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49087 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1LOK3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:29:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC 4/4] omap3isp: Use pixel clock from sensor media bus frameformat
Date: Thu, 15 Dec 2011 11:29:48 +0100
Cc: linux-media@vger.kernel.org
References: <20111215095015.GC3677@valkosipuli.localdomain> <1323942635-13058-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1323942635-13058-4-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151129.48607.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 15 December 2011 10:50:35 Sakari Ailus wrote:
> Configure the ISP based on the pixel clock in media bus frame format.
> Previously the same was configured from the board code.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/isp.c      |    3 +--
>  drivers/media/video/omap3isp/isp.h      |    3 ++-
>  drivers/media/video/omap3isp/ispvideo.c |    3 +++
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c index b818cac..c9bed37 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -344,7 +344,7 @@ void omap3isp_configure_bridge(struct isp_device *isp,
>   * Set the average pixel clock required by the sensor. The ISP will use
> the * lowest possible memory bandwidth settings compatible with the clock.
> **/
> -static void isp_set_pixel_clock(struct isp_device *isp, unsigned int
> pixelclk) +void omap3isp_set_pixel_clock(struct isp_device *isp, unsigned
> int pixelclk) {
>  	isp->isp_ccdc.vpcfg.pixelclk = pixelclk;
>  }
> @@ -2072,7 +2072,6 @@ static int isp_probe(struct platform_device *pdev)
> 
>  	isp->autoidle = autoidle;
>  	isp->platform_cb.set_xclk = isp_set_xclk;
> -	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
> 
>  	mutex_init(&isp->isp_mutex);
>  	spin_lock_init(&isp->stat_lock);
> diff --git a/drivers/media/video/omap3isp/isp.h
> b/drivers/media/video/omap3isp/isp.h index c5935ae..dd7b303 100644
> --- a/drivers/media/video/omap3isp/isp.h
> +++ b/drivers/media/video/omap3isp/isp.h
> @@ -126,7 +126,6 @@ struct isp_reg {
> 
>  struct isp_platform_callback {
>  	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
> -	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
>  };
> 
>  /*
> @@ -219,6 +218,8 @@ struct isp_device {
>  #define v4l2_dev_to_isp_device(dev) \
>  	container_of(dev, struct isp_device, v4l2_dev)
> 
> +void omap3isp_set_pixel_clock(struct isp_device *isp, unsigned int
> pixelclk); +
>  void omap3isp_hist_dma_done(struct isp_device *isp);
> 
>  void omap3isp_flush(struct isp_device *isp);
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index cdcf1d0..64f29ac 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -372,6 +372,9 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) if (IS_ERR_VALUE(ret))
>  					return -EPIPE;
>  			}
> +			omap3isp_set_pixel_clock(isp,
> +						 fmt_source.format.pixel_clock
> +						 * 1000);

Similarly to 3/4, I think this belongs to isp_pipeline_enable(), or even 
possibly the subdev s_stream operation (same for 3/4 actually).

>  		}
> 
>  		if (subdev->host_priv) {

-- 
Regards,

Laurent Pinchart

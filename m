Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.48]:57988 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0KTLZj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Nov 2010 06:25:39 -0500
Date: Sat, 20 Nov 2010 13:26:40 +0200
From: David Cohen <david.cohen@nokia.com>
To: ext Sergio Aguirre <saaguirre@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [omap3isp RFC][PATCH 1/4] omap3isp: Abstract isp subdevs clock
 control
Message-ID: <20101120112640.GE13186@esdhcp04381.research.nokia.com>
References: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
 <1290209031-12817-2-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290209031-12817-2-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio,

Thanks for the patch. :)

On Sat, Nov 20, 2010 at 12:23:48AM +0100, ext Sergio Aguirre wrote:
> Submodules shouldn't be aware of global register bit structure,
> specially if the submodules are shared in the future with
> other TI architectures (Davinci, future OMAPs, etc)
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/isp/isp.c        |   54 ++++++++++++++++++++++++++++++++++
>  drivers/media/video/isp/isp.h        |   12 +++++++
>  drivers/media/video/isp/ispccdc.c    |    6 +--
>  drivers/media/video/isp/isppreview.c |    6 +--
>  drivers/media/video/isp/ispresizer.c |    6 +--
>  5 files changed, 72 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
> index 30bdc48..2e5030f 100644
> --- a/drivers/media/video/isp/isp.c
> +++ b/drivers/media/video/isp/isp.c
> @@ -991,6 +991,60 @@ void isp_sbl_disable(struct isp_device *isp, enum isp_sbl_resource res)
>   * Clock management
>   */
>  
> +void isp_subclk_enable(struct isp_device *isp, enum isp_subclk_resource res)
> +{
> +	u32 clk = 0;
> +
> +	isp->subclk_resources |= res;
> +
> +	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_H3A)
> +		clk |= ISPCTRL_H3A_CLK_EN;
> +
> +	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_HIST)
> +		clk |= ISPCTRL_HIST_CLK_EN;
> +
> +	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_RESIZER)
> +		clk |= ISPCTRL_RSZ_CLK_EN;
> +
> +	/* NOTE: For CCDC & Preview submodules, we need to affect internal
> +	 *       RAM aswell.
> +	 */
> +	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_CCDC)
> +		clk |= ISPCTRL_CCDC_CLK_EN | ISPCTRL_CCDC_RAM_EN;
> +
> +	if (isp->subclk_resources & OMAP3_ISP_SUBCLK_PREVIEW)
> +		clk |= ISPCTRL_PREV_CLK_EN | ISPCTRL_PREV_RAM_EN;
> +
> +	isp_reg_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, clk);
> +}

To decrease the lines of code, you can create a new static function
called e.g. isp_subclk_update(). It can be a copy of isp_subclk_enable()
but removing the line where it changes 'isp->subclk_resources' and
replacing 'isp_reg_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, clk)' by
'isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, <clocks mask>, clk)'.

Then, isp_subclk_enable() can update isp->subclk_resources, call
isp_subclk_update() and finish.

> +
> +void isp_subclk_disable(struct isp_device *isp, enum isp_subclk_resource res)
> +{
> +	u32 clk = 0;
> +
> +	isp->subclk_resources &= ~res;

Same here. This function can call isp_subclk_update() and end now.

> +
> +	if (!(isp->subclk_resources & OMAP3_ISP_SUBCLK_H3A))
> +		clk |= ISPCTRL_H3A_CLK_EN;
> +
> +	if (!(isp->subclk_resources & OMAP3_ISP_SUBCLK_HIST))
> +		clk |= ISPCTRL_HIST_CLK_EN;
> +
> +	if (!(isp->subclk_resources & OMAP3_ISP_SUBCLK_RESIZER))
> +		clk |= ISPCTRL_RSZ_CLK_EN;
> +
> +	/* NOTE: For CCDC & Preview submodules, we need to affect internal
> +	 *       RAM aswell.
> +	 */
> +	if (!(isp->subclk_resources & OMAP3_ISP_SUBCLK_CCDC))
> +		clk |= ISPCTRL_CCDC_CLK_EN | ISPCTRL_CCDC_RAM_EN;
> +
> +	if (!(isp->subclk_resources & OMAP3_ISP_SUBCLK_PREVIEW))
> +		clk |= ISPCTRL_PREV_CLK_EN | ISPCTRL_PREV_RAM_EN;
> +
> +	isp_reg_clr(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL, clk);
> +}
> +
>  /*
>   * isp_enable_clocks - Enable ISP clocks
>   * @isp: OMAP3 ISP device
> diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
> index b8f63e2..1260e9f 100644
> --- a/drivers/media/video/isp/isp.h
> +++ b/drivers/media/video/isp/isp.h
> @@ -85,6 +85,14 @@ enum isp_sbl_resource {
>  	OMAP3_ISP_SBL_RESIZER_WRITE	= 0x200,
>  };
>  
> +enum isp_subclk_resource {
> +	OMAP3_ISP_SUBCLK_CCDC		= 0x1,
> +	OMAP3_ISP_SUBCLK_H3A		= 0x2,
> +	OMAP3_ISP_SUBCLK_HIST		= 0x4,
> +	OMAP3_ISP_SUBCLK_PREVIEW	= 0x8,
> +	OMAP3_ISP_SUBCLK_RESIZER	= 0x10,

I'm fine with this way, but (1 << 0), (1 << 1), ... has a better readability.

Br,

David Cohen

> +};
> +
>  enum isp_interface_type {
>  	ISP_INTERFACE_PARALLEL,
>  	ISP_INTERFACE_CSI2A_PHY2,
> @@ -262,6 +270,7 @@ struct isp_device {
>  	struct isp_csiphy isp_csiphy2;
>  
>  	unsigned int sbl_resources;
> +	unsigned int subclk_resources;
>  
>  	struct iommu *iommu;
>  };
> @@ -294,6 +303,9 @@ void isp_print_status(struct isp_device *isp);
>  void isp_sbl_enable(struct isp_device *isp, enum isp_sbl_resource res);
>  void isp_sbl_disable(struct isp_device *isp, enum isp_sbl_resource res);
>  
> +void isp_subclk_enable(struct isp_device *isp, enum isp_subclk_resource res);
> +void isp_subclk_disable(struct isp_device *isp, enum isp_subclk_resource res);
> +
>  int omap3isp_register_entities(struct platform_device *pdev,
>  			       struct v4l2_device *v4l2_dev);
>  void omap3isp_unregister_entities(struct platform_device *pdev);
> diff --git a/drivers/media/video/isp/ispccdc.c b/drivers/media/video/isp/ispccdc.c
> index c3d1d7a..4244edf 100644
> --- a/drivers/media/video/isp/ispccdc.c
> +++ b/drivers/media/video/isp/ispccdc.c
> @@ -1687,8 +1687,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
>  		if (enable == ISP_PIPELINE_STREAM_STOPPED)
>  			return 0;
>  
> -		isp_reg_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> -			    ISPCTRL_CCDC_RAM_EN | ISPCTRL_CCDC_CLK_EN);
> +		isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_CCDC);
>  		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
>  			    ISPCCDC_CFG_VDLC);
>  
> @@ -1725,8 +1724,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
>  		ret = ispccdc_disable(ccdc);
>  		if (ccdc->output & CCDC_OUTPUT_MEMORY)
>  			isp_sbl_disable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
> -		isp_reg_clr(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> -			    ISPCTRL_CCDC_CLK_EN | ISPCTRL_CCDC_RAM_EN);
> +		isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_CCDC);
>  		ccdc->underrun = 0;
>  		break;
>  	}
> diff --git a/drivers/media/video/isp/isppreview.c b/drivers/media/video/isp/isppreview.c
> index 74e4f6a..3e55123 100644
> --- a/drivers/media/video/isp/isppreview.c
> +++ b/drivers/media/video/isp/isppreview.c
> @@ -1648,8 +1648,7 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
>  		if (enable == ISP_PIPELINE_STREAM_STOPPED)
>  			return 0;
>  
> -		isp_reg_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> -			    ISPCTRL_PREV_RAM_EN | ISPCTRL_PREV_CLK_EN);
> +		isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_PREVIEW);
>  		preview_configure(prev);
>  		isppreview_print_status(prev);
>  	}
> @@ -1677,8 +1676,7 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
>  	case ISP_PIPELINE_STREAM_STOPPED:
>  		isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_READ);
>  		isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_WRITE);
> -		isp_reg_clr(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> -			    ISPCTRL_PREV_CLK_EN | ISPCTRL_PREV_RAM_EN);
> +		isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_PREVIEW);
>  		prev->underrun = 0;
>  		break;
>  	}
> diff --git a/drivers/media/video/isp/ispresizer.c b/drivers/media/video/isp/ispresizer.c
> index 95c5895..bd33f21 100644
> --- a/drivers/media/video/isp/ispresizer.c
> +++ b/drivers/media/video/isp/ispresizer.c
> @@ -1120,8 +1120,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
>  
>  	if (enable != ISP_PIPELINE_STREAM_STOPPED &&
>  	    res->state == ISP_PIPELINE_STREAM_STOPPED) {
> -		isp_reg_set(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> -			    ISPCTRL_RSZ_CLK_EN);
> +		isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_RESIZER);
>  		resizer_configure(res);
>  		ispresizer_print_status(res);
>  	}
> @@ -1146,8 +1145,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
>  	case ISP_PIPELINE_STREAM_STOPPED:
>  		isp_sbl_disable(isp, OMAP3_ISP_SBL_RESIZER_READ |
>  				OMAP3_ISP_SBL_RESIZER_WRITE);
> -		isp_reg_clr(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL,
> -			    ISPCTRL_RSZ_CLK_EN);
> +		isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_RESIZER);
>  		res->underrun = 0;
>  		break;
>  	}
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

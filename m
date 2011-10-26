Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58635 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab1JZBNf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 21:13:35 -0400
Date: Wed, 26 Oct 2011 04:13:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] omap3isp: preview: Rename min/max input/output
 sizes defines
Message-ID: <20111026011330.GB20295@valkosipuli.localdomain>
References: <1318972497-8367-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1318972497-8367-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318972497-8367-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch. I have a single comment below.

On Tue, Oct 18, 2011 at 11:14:56PM +0200, Laurent Pinchart wrote:
> The macros that define the minimum/maximum input and output sizes are
> defined in seperate files and have no consistent naming. In preparation
> for preview engine cropping support, move them all to isppreview.c and
> rename them to PREV_{MIN|MAX}_{IN|OUT}_{WIDTH|HEIGHT}*.
> 
> Remove unused and/or unneeded local variables that store the maximum
> output width.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/isppreview.c |   33 +++++++++++++++--------------
>  drivers/media/video/omap3isp/ispreg.h     |    3 --
>  2 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
> index c920c1e..d5cce42 100644
> --- a/drivers/media/video/omap3isp/isppreview.c
> +++ b/drivers/media/video/omap3isp/isppreview.c
> @@ -76,9 +76,15 @@ static struct omap3isp_prev_csc flr_prev_csc = {
>  
>  #define DEF_DETECT_CORRECT_VAL	0xe
>  
> -#define PREV_MIN_WIDTH		64
> -#define PREV_MIN_HEIGHT		8
> -#define PREV_MAX_HEIGHT		16384
> +#define PREV_MIN_IN_WIDTH	64
> +#define PREV_MIN_IN_HEIGHT	8
> +#define PREV_MAX_IN_HEIGHT	16384
> +
> +#define PREV_MIN_OUT_WIDTH	0
> +#define PREV_MIN_OUT_HEIGHT	0
> +#define PREV_MAX_OUT_WIDTH	1280
> +#define PREV_MAX_OUT_WIDTH_ES2	3300
> +#define PREV_MAX_OUT_WIDTH_3630	4096

The preview line buffer size very probably depends on the ISP revision and
not OMAP revision. I think this name is such for historical reasons.

I just thought this now that you're changing them anyway. :)

>  
>  /*
>   * Coeficient Tables for the submodules in Preview.
> @@ -1280,14 +1286,14 @@ static unsigned int preview_max_out_width(struct isp_prev_device *prev)
>  
>  	switch (isp->revision) {
>  	case ISP_REVISION_1_0:
> -		return ISPPRV_MAXOUTPUT_WIDTH;
> +		return PREV_MAX_OUT_WIDTH;
>  
>  	case ISP_REVISION_2_0:
>  	default:
> -		return ISPPRV_MAXOUTPUT_WIDTH_ES2;
> +		return PREV_MAX_OUT_WIDTH_ES2;
>  
>  	case ISP_REVISION_15_0:
> -		return ISPPRV_MAXOUTPUT_WIDTH_3630;
> +		return PREV_MAX_OUT_WIDTH_3630;
>  	}
>  }
>  
> @@ -1295,7 +1301,6 @@ static void preview_configure(struct isp_prev_device *prev)
>  {
>  	struct isp_device *isp = to_isp_device(prev);
>  	struct v4l2_mbus_framefmt *format;
> -	unsigned int max_out_width;
>  
>  	preview_setup_hw(prev);
>  
> @@ -1333,8 +1338,6 @@ static void preview_configure(struct isp_prev_device *prev)
>  		preview_config_outlineoffset(prev,
>  				ALIGN(format->width, 0x10) * 2);
>  
> -	max_out_width = preview_max_out_width(prev);
> -
>  	preview_config_averager(prev, 0);
>  	preview_config_ycpos(prev, format->code);
>  }
> @@ -1620,12 +1623,9 @@ static void preview_try_format(struct isp_prev_device *prev,
>  			       enum v4l2_subdev_format_whence which)
>  {
>  	struct v4l2_mbus_framefmt *format;
> -	unsigned int max_out_width;
>  	enum v4l2_mbus_pixelcode pixelcode;
>  	unsigned int i;
>  
> -	max_out_width = preview_max_out_width(prev);
> -
>  	switch (pad) {
>  	case PREV_PAD_SINK:
>  		/* When reading data from the CCDC, the input size has already
> @@ -1638,10 +1638,11 @@ static void preview_try_format(struct isp_prev_device *prev,
>  		 * filter array interpolation.
>  		 */
>  		if (prev->input == PREVIEW_INPUT_MEMORY) {
> -			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_WIDTH,
> -					     max_out_width);
> -			fmt->height = clamp_t(u32, fmt->height, PREV_MIN_HEIGHT,
> -					      PREV_MAX_HEIGHT);
> +			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_IN_WIDTH,
> +					     preview_max_out_width(prev));
> +			fmt->height = clamp_t(u32, fmt->height,
> +					      PREV_MIN_IN_HEIGHT,
> +					      PREV_MAX_IN_HEIGHT);
>  		}
>  
>  		fmt->colorspace = V4L2_COLORSPACE_SRGB;
> diff --git a/drivers/media/video/omap3isp/ispreg.h b/drivers/media/video/omap3isp/ispreg.h
> index 69f6af6..084ea77 100644
> --- a/drivers/media/video/omap3isp/ispreg.h
> +++ b/drivers/media/video/omap3isp/ispreg.h
> @@ -402,9 +402,6 @@
>  #define ISPPRV_YENH_TABLE_ADDR		0x1000
>  #define ISPPRV_CFA_TABLE_ADDR		0x1400
>  
> -#define ISPPRV_MAXOUTPUT_WIDTH		1280
> -#define ISPPRV_MAXOUTPUT_WIDTH_ES2	3300
> -#define ISPPRV_MAXOUTPUT_WIDTH_3630	4096
>  #define ISPRSZ_MIN_OUTPUT		64
>  #define ISPRSZ_MAX_OUTPUT		3312
>  
> -- 
> 1.7.3.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:43638 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683Ab2GMKMI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 06:12:08 -0400
Message-ID: <4FFFF48B.8010609@iki.fi>
Date: Fri, 13 Jul 2012 13:12:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH v2 6/6] omap3isp: preview: Add support for non-GRBG Bayer
 patterns
References: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341581569-8292-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341581569-8292-7-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

Laurent Pinchart wrote:
> Rearrange the CFA interpolation coefficients table based on the Bayer
> pattern. Support for non-Bayer CFA patterns is dropped as they were not
> correctly supported, and have never been tested.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/isppreview.c |  134 ++++++++++++++++++-----------
>  drivers/media/video/omap3isp/isppreview.h |    1 +
>  2 files changed, 85 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isppreview.c b/drivers/media/video/omap3isp/isppreview.c
> index 71ce0f4..475908b 100644
> --- a/drivers/media/video/omap3isp/isppreview.c
> +++ b/drivers/media/video/omap3isp/isppreview.c
> @@ -236,20 +236,30 @@ static void preview_enable_hmed(struct isp_prev_device *prev, bool enable)
>  			    ISPPRV_PCR_HMEDEN);
>  }
>  
> +#define OMAP3ISP_PREV_CFA_BLK_SIZE	(OMAP3ISP_PREV_CFA_TBL_SIZE / 4)
> +
>  /*
> - * preview_config_cfa - Configure CFA Interpolation
> - */
> -static void
> -preview_config_cfa(struct isp_prev_device *prev,
> -		   const struct prev_params *params)
> -{
> -	struct isp_device *isp = to_isp_device(prev);
> + * preview_config_cfa - Configure CFA Interpolation for Bayer formats
> + *
> + * The CFA table is organised in four blocks, one per Bayer component. The
> + * hardware expects blocks to follow the Bayer order of the input data, while
> + * the driver stores the table in GRBG order in memory. The blocks need to be
> + * reordered to support non-GRBG Bayer patterns.
> + */
> +static void preview_config_cfa(struct isp_prev_device *prev,
> +			       const struct prev_params *params)
> +{
> +	static const unsigned int cfa_coef_order[4][4] = {
> +		{ 0, 1, 2, 3 }, /* GRBG */
> +		{ 1, 0, 3, 2 }, /* RGGB */
> +		{ 2, 3, 0, 1 }, /* BGGR */
> +		{ 3, 2, 1, 0 }, /* GBRG */
> +	};
> +	const unsigned int *order = cfa_coef_order[prev->params.cfa_order];
>  	const struct omap3isp_prev_cfa *cfa = &params->cfa;
> +	struct isp_device *isp = to_isp_device(prev);
>  	unsigned int i;
> -
> -	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> -			ISPPRV_PCR_CFAFMT_MASK,
> -			cfa->format << ISPPRV_PCR_CFAFMT_SHIFT);
> +	unsigned int j;
>  
>  	isp_reg_writel(isp,
>  		(cfa->gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> @@ -259,9 +269,13 @@ preview_config_cfa(struct isp_prev_device *prev,
>  	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
>  		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
>  
> -	for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
> -		isp_reg_writel(isp, cfa->table[i],
> -			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> +	for (i = 0; i < 4; ++i) {
> +		const __u32 *block = cfa->table
> +				   + order[i] * OMAP3ISP_PREV_CFA_BLK_SIZE;
> +
> +		for (j = 0; j < OMAP3ISP_PREV_CFA_BLK_SIZE; ++j)
> +			isp_reg_writel(isp, block[j], OMAP3_ISP_IOMEM_PREV,
> +				       ISPPRV_SET_TBL_DATA);
>  	}
>  }
>  

I think struct omap3isp_prev_cfa would benefit from more detailed
definition of the gamma table. That would also change the API albeit not
ABI... unless you use an anonymous union which then requires a GCC newer
than or equal to 4.4, I think.

The table should be two-dimensional array, not one-dimensional.

Now that we're making changes to the user space API anyway, what would
you think about this? I think it'd make the code much nicer.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi



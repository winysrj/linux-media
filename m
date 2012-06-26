Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38233 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab2FZBaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 21:30:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Tue, 26 Jun 2012 03:30:09 +0200
Message-ID: <2750049.lYuKrB1hfJ@avalon>
In-Reply-To: <20120623082237.GA17925@valkosipuli.retiisi.org.uk>
References: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com> <20120623082237.GA17925@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 23 June 2012 11:22:37 Sakari Ailus wrote:
> On Mon, Jun 18, 2012 at 04:30:53PM +0200, Laurent Pinchart wrote:
> > Rearrange the CFA interpolation coefficients table based on the Bayer
> > pattern. Modifying the table during streaming isn't supported anymore,
> > but didn't make sense in the first place anyway.
> 
> Why not? I could imagine someone might want to change the table while
> streaming to change the white balance, for example. Gamma tables or the SRGB
> matrix can be used to do mostly the same but we should leave the decision
> which one to use to the user space.

Because making the CFA table runtime-configurable brings an additional 
complexity without a use case I'm aware of. The preview engine has separate 
gamma tables, white balance matrices, and RGB-to-RGB and RGB-to-YUV matrices 
that can be modified during streaming. If a user really needs to modify the 
CFA tables during streaming I'll be happy to implement that (and even happier 
to receive a patch :-)), but I'm a bit reluctant to add complexity to an 
already complex code without a real use case.

> > Support for non-Bayer CFA patterns is dropped as they were not correctly
> > supported, and have never been tested.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/omap3isp/isppreview.c |  118 ++++++++++++++----------
> >  1 files changed, 67 insertions(+), 51 deletions(-)
> > 
> > Jean-Philippe,
> > 
> > Could you please test this patch on your hardware ?
> > 
> > diff --git a/drivers/media/video/omap3isp/isppreview.c
> > b/drivers/media/video/omap3isp/isppreview.c index 8a4935e..bfa3107 100644
> > --- a/drivers/media/video/omap3isp/isppreview.c
> > +++ b/drivers/media/video/omap3isp/isppreview.c
> > @@ -309,36 +309,6 @@ preview_config_dcor(struct isp_prev_device *prev,
> > const void *prev_dcor)> 
> >  }
> >  
> >  /*
> > 
> > - * preview_config_cfa - Configures the CFA Interpolation parameters.
> > - * @prev_cfa: Structure containing the CFA interpolation table, CFA
> > format
> > - *            in the image, vertical and horizontal gradient threshold.
> > - */
> > -static void
> > -preview_config_cfa(struct isp_prev_device *prev, const void *prev_cfa)
> > -{
> > -	struct isp_device *isp = to_isp_device(prev);
> > -	const struct omap3isp_prev_cfa *cfa = prev_cfa;
> > -	unsigned int i;
> > -
> > -	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> > -			ISPPRV_PCR_CFAFMT_MASK,
> > -			cfa->format << ISPPRV_PCR_CFAFMT_SHIFT);
> > -
> > -	isp_reg_writel(isp,
> > -		(cfa->gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> > -		(cfa->gradthrs_horz << ISPPRV_CFA_GRADTH_HOR_SHIFT),
> > -		OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA);
> > -
> > -	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
> > -		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> > -
> > -	for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
> > -		isp_reg_writel(isp, cfa->table[i],
> > -			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> > -	}
> > -}
> > -
> > -/*
> > 
> >   * preview_config_gammacorrn - Configures the Gamma Correction table
> >   values
> >   * @gtable: Structure containing the table for red, blue, green gamma
> >   table.
> >   */
> > 
> > @@ -813,7 +783,7 @@ static const struct preview_update update_attrs[] = {
> > 
> >  		FIELD_SIZEOF(struct prev_params, hmed),
> >  		offsetof(struct omap3isp_prev_update_config, hmed),
> >  	
> >  	}, /* OMAP3ISP_PREV_CFA */ {
> > 
> > -		preview_config_cfa,
> > +		NULL,
> > 
> >  		NULL,
> >  		offsetof(struct prev_params, cfa),
> >  		FIELD_SIZEOF(struct prev_params, cfa),
> > 
> > @@ -1043,42 +1013,88 @@ preview_config_ycpos(struct isp_prev_device *prev,
> > 
> >  static void preview_config_averager(struct isp_prev_device *prev, u8
> >  average) {
> >  
> >  	struct isp_device *isp = to_isp_device(prev);
> > 
> > -	struct prev_params *params;
> > -	int reg = 0;
> > 
> > -	params = (prev->params.active & OMAP3ISP_PREV_CFA)
> > -	       ? &prev->params.params[0] : &prev->params.params[1];
> > -
> > -	if (params->cfa.format == OMAP3ISP_CFAFMT_BAYER)
> > -		reg = ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
> > -		      ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
> > -		      average;
> > -	else if (params->cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
> > -		reg = ISPPRV_AVE_EVENDIST_3 << ISPPRV_AVE_EVENDIST_SHIFT |
> > -		      ISPPRV_AVE_ODDDIST_3 << ISPPRV_AVE_ODDDIST_SHIFT |
> > -		      average;
> > -	isp_reg_writel(isp, reg, OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE);
> > +	isp_reg_writel(isp, ISPPRV_AVE_EVENDIST_2 << 
ISPPRV_AVE_EVENDIST_SHIFT |
> > +		       ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
> > +		       average, OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE);
> > 
> >  }
> > 
> > +
> > +#define OMAP3ISP_PREV_CFA_BLK_SIZE	(OMAP3ISP_PREV_CFA_TBL_SIZE / 4)
> > +
> > 
> >  /*
> >  
> >   * preview_config_input_format - Configure the input format
> >   * @prev: The preview engine
> >   * @format: Format on the preview engine sink pad
> >   *
> > 
> > - * Enable CFA interpolation for Bayer formats and disable it for
> > greyscale
> > - * formats.
> > + * Enable and configure CFA interpolation for Bayer formats and disable
> > it for + * greyscale formats.
> > + *
> > + * The CFA table is organised in four blocks, one per Bayer component.
> > The
> > + * hardware expects blocks to follow the Bayer order of the input data,
> > while + * the driver stores the table in GRBG order in memory. The blocks
> > need to be + * reordered to support non-GRBG Bayer patterns.
> > 
> >   */
> >  
> >  static void preview_config_input_format(struct isp_prev_device *prev,
> >  
> >  					const struct v4l2_mbus_framefmt *format)
> >  
> >  {
> > 
> > +	static const unsigned int cfa_coef_order[4][4] = {
> > +		{ 0, 1, 2, 3 }, /* GRBG */
> > +		{ 1, 0, 3, 2 }, /* RGGB */
> > +		{ 2, 3, 0, 1 }, /* BGGR */
> > +		{ 3, 2, 1, 0 }, /* GBRG */
> > +	};
> > 
> >  	struct isp_device *isp = to_isp_device(prev);
> > 
> > +	struct prev_params *params;
> > +	const unsigned int *order;
> > +	unsigned int i;
> > +	unsigned int j;
> > 
> > -	if (format->code != V4L2_MBUS_FMT_Y10_1X10)
> > -		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> > -			    ISPPRV_PCR_CFAEN);
> > -	else
> > +	if (format->code == V4L2_MBUS_FMT_Y10_1X10) {
> > 
> >  		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> >  		
> >  			    ISPPRV_PCR_CFAEN);
> > 
> > +		return;
> > +	}
> > +
> > +	params = (prev->params.active & OMAP3ISP_PREV_CFA)
> > +	       ? &prev->params.params[0] : &prev->params.params[1];
> > +
> > +	isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR, ISPPRV_PCR_CFAEN);
> > +	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> > +			ISPPRV_PCR_CFAFMT_MASK, ISPPRV_PCR_CFAFMT_BAYER);
> > +
> > +	isp_reg_writel(isp,
> > +		(params->cfa.gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> > +		(params->cfa.gradthrs_horz << ISPPRV_CFA_GRADTH_HOR_SHIFT),
> > +		OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA);
> > +
> > +	switch (prev->formats[PREV_PAD_SINK].code) {
> > +	case V4L2_MBUS_FMT_SGRBG10_1X10:
> 
> > +	default:
> Is the "default" case expected to ever happen?
> 
> > +		order = cfa_coef_order[0];
> > +		break;
> > +	case V4L2_MBUS_FMT_SRGGB10_1X10:
> > +		order = cfa_coef_order[1];
> > +		break;
> > +	case V4L2_MBUS_FMT_SBGGR10_1X10:
> > +		order = cfa_coef_order[2];
> > +		break;
> > +	case V4L2_MBUS_FMT_SGBRG10_1X10:
> > +		order = cfa_coef_order[3];
> > +		break;
> > +	}
> > +
> > +	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
> > +		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> > +
> > +	for (i = 0; i < 4; ++i) {
> > +		__u32 *block = params->cfa.table
> > +			     + order[i] * OMAP3ISP_PREV_CFA_BLK_SIZE;
> > +
> > +		for (j = 0; j < OMAP3ISP_PREV_CFA_BLK_SIZE; ++j)
> > +			isp_reg_writel(isp, block[j], OMAP3_ISP_IOMEM_PREV,
> > +				       ISPPRV_SET_TBL_DATA);
> > +	}
> > 
> >  }
> >  
> >  /*

-- 
Regards,

Laurent Pinchart


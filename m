Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48144 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab2GMLZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 07:25:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH v2 6/6] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Fri, 13 Jul 2012 13:25:11 +0200
Message-ID: <1513848.JfAFJNZTHg@avalon>
In-Reply-To: <4FFFF48B.8010609@iki.fi>
References: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com> <1341581569-8292-7-git-send-email-laurent.pinchart@ideasonboard.com> <4FFFF48B.8010609@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On Friday 13 July 2012 13:12:27 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > Rearrange the CFA interpolation coefficients table based on the Bayer
> > pattern. Support for non-Bayer CFA patterns is dropped as they were not
> > correctly supported, and have never been tested.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[snip]

> > +static void preview_config_cfa(struct isp_prev_device *prev,
> > +			       const struct prev_params *params)
> > +{
> > +	static const unsigned int cfa_coef_order[4][4] = {
> > +		{ 0, 1, 2, 3 }, /* GRBG */
> > +		{ 1, 0, 3, 2 }, /* RGGB */
> > +		{ 2, 3, 0, 1 }, /* BGGR */
> > +		{ 3, 2, 1, 0 }, /* GBRG */
> > +	};
> > +	const unsigned int *order = cfa_coef_order[prev->params.cfa_order];
> >  	const struct omap3isp_prev_cfa *cfa = &params->cfa;
> > +	struct isp_device *isp = to_isp_device(prev);
> >  	unsigned int i;
> > -
> > -	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> > -			ISPPRV_PCR_CFAFMT_MASK,
> > -			cfa->format << ISPPRV_PCR_CFAFMT_SHIFT);
> > +	unsigned int j;
> > 
> >  	isp_reg_writel(isp,
> >  		(cfa->gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> > @@ -259,9 +269,13 @@ preview_config_cfa(struct isp_prev_device *prev,
> >  	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
> >  		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> > 
> > -	for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
> > -		isp_reg_writel(isp, cfa->table[i],
> > -			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
> > +	for (i = 0; i < 4; ++i) {
> > +		const __u32 *block = cfa->table
> > +				   + order[i] * OMAP3ISP_PREV_CFA_BLK_SIZE;
> > +
> > +		for (j = 0; j < OMAP3ISP_PREV_CFA_BLK_SIZE; ++j)
> > +			isp_reg_writel(isp, block[j], OMAP3_ISP_IOMEM_PREV,
> > +				       ISPPRV_SET_TBL_DATA);
> >  	}
> >  }
> 
> I think struct omap3isp_prev_cfa would benefit from more detailed definition
> of the gamma table.

I suppose you mean the CFA table.

> That would also change the API albeit not ABI... unless you use an anonymous
> union which then requires a GCC newer than or equal to 4.4, I think.
> 
> The table should be two-dimensional array, not one-dimensional.
> 
> Now that we're making changes to the user space API anyway, what would
> you think about this? I think it'd make the code much nicer.

It's a good idea. I'll fix that. I'd like to document the table contents as 
well, but the information is unfortunately not available publicly :-(

-- 
Regards,

Laurent Pinchart


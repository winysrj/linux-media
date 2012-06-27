Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab2F0OH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 10:07:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH] omap3isp: preview: Add support for non-GRBG Bayer patterns
Date: Wed, 27 Jun 2012 16:07:28 +0200
Message-ID: <24382322.OKOfD6GpLz@avalon>
In-Reply-To: <20120626190114.GA18715@valkosipuli.retiisi.org.uk>
References: <1340029853-2648-1-git-send-email-laurent.pinchart@ideasonboard.com> <2750049.lYuKrB1hfJ@avalon> <20120626190114.GA18715@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 26 June 2012 22:01:14 Sakari Ailus wrote:
> On Tue, Jun 26, 2012 at 03:30:09AM +0200, Laurent Pinchart wrote:
> > On Saturday 23 June 2012 11:22:37 Sakari Ailus wrote:
> > > On Mon, Jun 18, 2012 at 04:30:53PM +0200, Laurent Pinchart wrote:
> > > > Rearrange the CFA interpolation coefficients table based on the Bayer
> > > > pattern. Modifying the table during streaming isn't supported anymore,
> > > > but didn't make sense in the first place anyway.
> > > 
> > > Why not? I could imagine someone might want to change the table while
> > > streaming to change the white balance, for example. Gamma tables or the
> > > SRGB matrix can be used to do mostly the same but we should leave the
> > > decision which one to use to the user space.
> > 
> > Because making the CFA table runtime-configurable brings an additional
> > complexity without a use case I'm aware of. The preview engine has
> > separate
> > gamma tables, white balance matrices, and RGB-to-RGB and RGB-to-YUV
> > matrices that can be modified during streaming. If a user really needs to
> > modify the CFA tables during streaming I'll be happy to implement that
> > (and even happier to receive a patch :-)), but I'm a bit reluctant to add
> > complexity to an already complex code without a real use case.
> 
> I'm fine with that. Let's get back to the topic once this is really needed.

It seems to be really needed now, so I'll fix this.

> ...
> 
> > > > +		return;
> > > > +	}
> > > > +
> > > > +	params = (prev->params.active & OMAP3ISP_PREV_CFA)
> > > > +	       ? &prev->params.params[0] : &prev->params.params[1];
> > > > +
> > > > +	isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> > > > ISPPRV_PCR_CFAEN);
> > > > +	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
> > > > +			ISPPRV_PCR_CFAFMT_MASK, ISPPRV_PCR_CFAFMT_BAYER);
> > > > +
> > > > +	isp_reg_writel(isp,
> > > > +		(params->cfa.gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
> > > > +		(params->cfa.gradthrs_horz << ISPPRV_CFA_GRADTH_HOR_SHIFT),
> > > > +		OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA);
> > > > +
> > > > +	switch (prev->formats[PREV_PAD_SINK].code) {
> > > > +	case V4L2_MBUS_FMT_SGRBG10_1X10:
> > > 
> > > > +	default:
> > > Is the "default" case expected to ever happen?
> 
> How about this one?

It's not expected to happen, no. I expected the compiler to produce a warning, 
but it doesn't. I'm not sure if that's good or bad though.

I'll reorder the code to avoid crashes if we get an unexpected format.

> > > > +		order = cfa_coef_order[0];
> > > > +		break;
> > > > +	case V4L2_MBUS_FMT_SRGGB10_1X10:
> > > > +		order = cfa_coef_order[1];
> > > > +		break;
> > > > +	case V4L2_MBUS_FMT_SBGGR10_1X10:
> > > > +		order = cfa_coef_order[2];
> > > > +		break;
> > > > +	case V4L2_MBUS_FMT_SGBRG10_1X10:
> > > > +		order = cfa_coef_order[3];
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
> > > > +		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
> > > > +
> > > > +	for (i = 0; i < 4; ++i) {
> > > > +		__u32 *block = params->cfa.table
> > > > +			     + order[i] * OMAP3ISP_PREV_CFA_BLK_SIZE;
> > > > +
> > > > +		for (j = 0; j < OMAP3ISP_PREV_CFA_BLK_SIZE; ++j)
> > > > +			isp_reg_writel(isp, block[j], OMAP3_ISP_IOMEM_PREV,
> > > > +				       ISPPRV_SET_TBL_DATA);
> > > > +	}
> > > > 
> > > >  }
> > > >  
> > > >  /*

-- 
Regards,

Laurent Pinchart


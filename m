Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40243 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab2BYBma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 20:42:30 -0500
Date: Sat, 25 Feb 2012 03:42:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 27/33] omap3isp: Implement proper CCDC link
 validation, check pixel rate
Message-ID: <20120225014225.GD12602@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1329703032-31314-27-git-send-email-sakari.ailus@iki.fi>
 <2683690.y1jIJeGq9p@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2683690.y1jIJeGq9p@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On Wed, Feb 22, 2012 at 12:11:07PM +0100, Laurent Pinchart wrote:
> On Monday 20 February 2012 03:57:06 Sakari Ailus wrote:
> > Implement correct link validation for the CCDC. Use external_rate from
> > isp_pipeline to configurat vp divisor and check that external_rate does not
> > exceed our data rate limitations.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/omap3isp/ispccdc.c |   69
> > +++++++++++++++++++++++++++++-- 1 files changed, 64 insertions(+), 5
> > deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/ispccdc.c
> > b/drivers/media/video/omap3isp/ispccdc.c index 6aff241..1555891 100644
> > --- a/drivers/media/video/omap3isp/ispccdc.c
> > +++ b/drivers/media/video/omap3isp/ispccdc.c
> > @@ -836,8 +836,8 @@ static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
> > 
> >  	if (pipe->input)
> >  		div = DIV_ROUND_UP(l3_ick, pipe->max_rate);
> > -	else if (ccdc->vpcfg.pixelclk)
> > -		div = l3_ick / ccdc->vpcfg.pixelclk;
> > +	else if (pipe->external_rate)
> > +		div = l3_ick / pipe->external_rate;
> > 
> >  	div = clamp(div, 2U, max_div);
> >  	fmtcfg_vp |= (div - 2) << ISPCCDC_FMTCFG_VPIF_FRQ_SHIFT;
> > @@ -1749,7 +1749,18 @@ static int ccdc_set_stream(struct v4l2_subdev *sd,
> > int enable) }
> > 
> >  	switch (enable) {
> > -	case ISP_PIPELINE_STREAM_CONTINUOUS:
> > +	case ISP_PIPELINE_STREAM_CONTINUOUS: {
> > +		struct isp_pipeline *pipe = to_isp_pipeline(&sd->entity);
> > +		unsigned int rate = UINT_MAX;
> > +
> > +		/*
> > +		 * Check that maximum allowed rate isn't exceeded by
> > +		 * the pixel rate.
> > +		 */
> > +		omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
> > +		if (pipe->external_rate > rate)
> > +			return -ENOSPC;
> > +
> 
> What about checking this at pipeline validation time ?

If the external entity is found before pipeline validation, then I can move
this there. I agree in principle that's the right thing to do.

> >  		if (ccdc->output & CCDC_OUTPUT_MEMORY)
> >  			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
> > 
> > @@ -1758,6 +1769,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int
> > enable)
> > 
> >  		ccdc->underrun = 0;
> >  		break;
> > +	}
> > 
> >  	case ISP_PIPELINE_STREAM_SINGLESHOT:
> >  		if (ccdc->output & CCDC_OUTPUT_MEMORY &&
> > @@ -1999,6 +2011,37 @@ static int ccdc_set_format(struct v4l2_subdev *sd,
> > struct v4l2_subdev_fh *fh, return 0;
> >  }
> > 
> > +/*
> > + * Decide whether desired output pixel code can be obtained with
> > + * the lane shifter by shifting the input pixel code.
> > + * @in: input pixelcode to shifter
> > + * @out: output pixelcode from shifter
> > + * @additional_shift: # of bits the sensor's LSB is offset from CAMEXT[0]
> > + *
> > + * return true if the combination is possible
> > + * return false otherwise
> > + */
> > +static bool ccdc_is_shiftable(enum v4l2_mbus_pixelcode in,
> > +			      enum v4l2_mbus_pixelcode out,
> > +			      unsigned int additional_shift)
> > +{
> > +	const struct isp_format_info *in_info, *out_info;
> > +
> > +	if (in == out)
> > +		return true;
> > +
> > +	in_info = omap3isp_video_format_info(in);
> > +	out_info = omap3isp_video_format_info(out);
> > +
> > +	if ((in_info->flavor == 0) || (out_info->flavor == 0))
> > +		return false;
> > +
> > +	if (in_info->flavor != out_info->flavor)
> > +		return false;
> > +
> > +	return in_info->bpp - out_info->bpp + additional_shift <= 6;
> > +}
> > +
> >  static int ccdc_link_validate(struct v4l2_subdev *sd,
> >  			      struct media_link *link,
> >  			      struct v4l2_subdev_format *source_fmt,
> > @@ -2008,13 +2051,31 @@ static int ccdc_link_validate(struct v4l2_subdev
> > *sd, struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity); int
> > rval;
> > 
> > +	/* Check if the two ends match */
> > +	if (source_fmt->format.width != sink_fmt->format.width ||
> > +	    source_fmt->format.height != sink_fmt->format.height)
> > +		return -EPIPE;
> > +
> >  	/* We've got a parallel sensor here. */
> >  	if (ccdc->input == CCDC_INPUT_PARALLEL) {
> 
> The lane shifter is usable with the CCP2 and CSI2 inputs as well. The 
> parallel_shift value is restricted to parallel input though. Please perform 
> the same check as done in isp_video_validate_pipeline().

Good catch. I'll fix this.

> Revies would also be easier if you removed the CCDC-specific code from 
> isp_video_validate_pipeline() in this patch.

Ok. I see what I could do for the next version.

> > +		struct isp_parallel_platform_data *pdata =
> > +			&((struct isp_v4l2_subdevs_group *)
> > +			  media_entity_to_v4l2_subdev(link->source->entity)
> > +			  ->host_priv)->bus.parallel;
> > +		unsigned long parallel_shift = pdata->data_lane_shift * 2;
> > +		/* Lane shifter may be used to drop bits on CCDC sink pad */
> > +		if (!ccdc_is_shiftable(source_fmt->format.code,
> > +				       sink_fmt->format.code, parallel_shift))
> > +			return -EPIPE;
> > +
> >  		pipe->external =
> >  			media_entity_to_v4l2_subdev(link->source->entity);
> >  		rval = omap3isp_get_external_info(pipe, link);
> >  		if (rval < 0)
> >  			return 0;
> > +	} else {
> > +		if (source_fmt->format.code != sink_fmt->format.code)
> > +			return -EPIPE;
> >  	}
> > 
> >  	return 0;
> > @@ -2299,8 +2360,6 @@ int omap3isp_ccdc_init(struct isp_device *isp)
> >  	ccdc->clamp.oblen = 0;
> >  	ccdc->clamp.dcsubval = 0;
> > 
> > -	ccdc->vpcfg.pixelclk = 0;
> > -
> >  	ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
> >  	ccdc_apply_controls(ccdc);
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

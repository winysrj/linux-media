Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34659 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1CPQ1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 12:27:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v3 4/4] omap3isp: lane shifter support
Date: Wed, 16 Mar 2011 17:27:43 +0100
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de> <1299830749-7269-5-git-send-email-michael.jones@matrix-vision.de> <4D80DAF1.3040002@maxwell.research.nokia.com>
In-Reply-To: <4D80DAF1.3040002@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103161727.43838.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

Thanks for the comments.

On Wednesday 16 March 2011 16:44:49 Sakari Ailus wrote:
> Hi Michael,
> 
> Thanks for the patch. I have some comments below.
> 
> Michael Jones wrote:
> > To use the lane shifter, set different pixel formats at each end of
> > the link at the CCDC input.
> > 
> > Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> > ---
> > 
> >  drivers/media/video/omap3-isp/isp.c      |    7 ++-
> >  drivers/media/video/omap3-isp/isp.h      |    5 +-
> >  drivers/media/video/omap3-isp/ispccdc.c  |   27 ++++++--
> >  drivers/media/video/omap3-isp/ispvideo.c |  108
> >  ++++++++++++++++++++++++------ drivers/media/video/omap3-isp/ispvideo.h
> >  |    3 +
> >  5 files changed, 120 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3-isp/isp.c
> > b/drivers/media/video/omap3-isp/isp.c index 08d90fe..866ce09 100644
> > --- a/drivers/media/video/omap3-isp/isp.c
> > +++ b/drivers/media/video/omap3-isp/isp.c
> > @@ -285,7 +285,8 @@ static void isp_power_settings(struct isp_device
> > *isp, int idle)
> > 
> >   */
> >  
> >  void omap3isp_configure_bridge(struct isp_device *isp,
> >  
> >  			       enum ccdc_input_entity input,
> > 
> > -			       const struct isp_parallel_platform_data *pdata)
> > +			       const struct isp_parallel_platform_data *pdata,
> > +			       int shift)
> 
> This goes more or less directly to register, so what about u32?
> Definitely unsigned at least.

Agreed.

[snip]

> > @@ -98,6 +116,37 @@ omap3isp_video_format_info(enum v4l2_mbus_pixelcode
> > code)
> > 
> >  }
> >  
> >  /*
> > 
> > + * Decide whether desired output pixel code can be obtained with
> > + * the lane shifter by shifting the input pixel code.
> > + * @in: input pixelcode to shifter
> > + * @out: output pixelcode from shifter
> > + * @additional_shift: # of bits the sensor's LSB is offset from
> > CAMEXT[0] + *
> > + * return true if the combination is possible
> > + * return false otherwise
> > + */
> > +static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
> > +		enum v4l2_mbus_pixelcode out,
> > +		unsigned int additional_shift)
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
> 
> Currently there are no formats that would behave badly in this check?
> Perhaps it'd be good idea to take that into consideration. The shift
> that can be done is even.

I've asked Michael to remove the check because we have no misbehaving formats 
:-) Do you think we need to add a check back ?

> > +}
> > +
> > +/*
> > 
> >   * isp_video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
> >   * @video: ISP video instance
> >   * @mbus: v4l2_mbus_framefmt format (input)
> > 
> > @@ -247,6 +296,7 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe)
> > 
> >  		return -EPIPE;
> >  	
> >  	while (1) {
> > 
> > +		unsigned int link_has_shifter;
> 
> link_has_shifter is only used in one place. Would it be cleaner to test
> below if it's the CCDC? A comment there could be nice, too.

I would like that better as well, but between the line where link_has_shifter 
is set and the line where it is checked, the subdev variable changes so we 
can't just check subdev == &isp->isp_ccdc.subdev there.

> >  		/* Retrieve the sink format */
> >  		pad = &subdev->entity.pads[0];
> >  		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> > 
> > @@ -275,6 +325,10 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe)
> > 
> >  				return -ENOSPC;
> >  		
> >  		}
> > 
> > +		/* If sink pad is on CCDC, the link has the lane shifter
> > +		 * in the middle of it. */
> > +		link_has_shifter = subdev == &isp->isp_ccdc.subdev;
> > +
> > 
> >  		/* Retrieve the source format */
> >  		pad = media_entity_remote_source(pad);
> >  		if (pad == NULL ||
> > 
> > @@ -290,10 +344,24 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe)
> > 
> >  			return -EPIPE;
> >  		
> >  		/* Check if the two ends match */
> > 
> > -		if (fmt_source.format.code != fmt_sink.format.code ||
> > -		    fmt_source.format.width != fmt_sink.format.width ||
> > +		if (fmt_source.format.width != fmt_sink.format.width ||
> > 
> >  		    fmt_source.format.height != fmt_sink.format.height)
> >  			
> >  			return -EPIPE;
> > 
> > +
> > +		if (link_has_shifter) {
> > +			unsigned int parallel_shift = 0;
> > +			if (isp->isp_ccdc.input == CCDC_INPUT_PARALLEL) {
> > +				struct isp_parallel_platform_data *pdata =
> > +					&((struct isp_v4l2_subdevs_group *)
> > +					      subdev->host_priv)->bus.parallel;
> > +				parallel_shift = pdata->data_lane_shift * 2;
> > +			}
> > +			if (!isp_video_is_shiftable(fmt_source.format.code,
> > +						fmt_sink.format.code,
> > +						parallel_shift))
> > +				return -EPIPE;
> > +		} else if (fmt_source.format.code != fmt_sink.format.code)
> > +			return -EPIPE;
> > 
> >  	}
> >  	
> >  	return 0;
> > 

-- 
Regards,

Laurent Pinchart

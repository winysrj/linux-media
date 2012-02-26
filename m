Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36931 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2BZXOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Feb 2012 18:14:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 26/33] omap3isp: Default link validation for ccp2, csi2, preview and resizer
Date: Mon, 27 Feb 2012 00:14:12 +0100
Message-ID: <2204981.cc3x3nBuNt@avalon>
In-Reply-To: <20120225013436.GC12602@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain> <4620159.TXeRQHhZdd@avalon> <20120225013436.GC12602@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 25 February 2012 03:34:36 Sakari Ailus wrote:
> On Wed, Feb 22, 2012 at 12:01:26PM +0100, Laurent Pinchart wrote:
> > On Monday 20 February 2012 03:57:05 Sakari Ailus wrote:
> > > Use default link validation for ccp2, csi2, preview and resizer. On
> > > ccp2, csi2 and ccdc we also collect information on external subdevs as
> > > one may be connected to those entities.
> > > 
> > > The CCDC link validation still must be done separately.
> > > 
> > > Also set pipe->external correctly as we go

[snip]

> > > @@ -1999,6 +1999,27 @@ static int ccdc_set_format(struct v4l2_subdev
> > > *sd,
> > > struct v4l2_subdev_fh *fh, return 0;
> > > 
> > >  }
> > > 
> > > +static int ccdc_link_validate(struct v4l2_subdev *sd,
> > > +			      struct media_link *link,
> > > +			      struct v4l2_subdev_format *source_fmt,
> > > +			      struct v4l2_subdev_format *sink_fmt)
> > > +{
> > > +	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
> > > +	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
> > > +	int rval;
> > > +
> > > +	/* We've got a parallel sensor here. */
> > > +	if (ccdc->input == CCDC_INPUT_PARALLEL) {
> > > +		pipe->external =
> > > +			media_entity_to_v4l2_subdev(link->source->entity);
> > > +		rval = omap3isp_get_external_info(pipe, link);
> > > +		if (rval < 0)
> > > +			return 0;
> > > +	}
> > 
> > Pending my comments on 25/33, this wouldn't be needed in this patch, and
> > could be squashed with 27/33.
> 
> If I moved this code out of pipeline validation, I'd have to walk the graph
> one additional time. Do you think it's worth it, or are there easier ways to
> find the external entity connected to a pipeline?

If I understand you correctly, the problem is that 
omap3isp_get_external_info() can only be called when the external entity has 
been located, and the CCDC link validation operation would be called before 
that. Is that correct ?

One option would be to locate the external entity before validating the link. 
When the validation pipeline walk operation gets to the CCDC entity, it would 
first follow the link, check if the connected entity is external (and in that 
case sotre it in pipe->external and call omap3isp_get_external_info()), and 
then only call the CCDC link validation operation.

The other option is to leave the code as-is :-) Or rather modify it slightly: 
assigning the entity to pipe->external and calling 
omap3isp_get_external_info() should be done in ispvideo.c at pipeline 
validation time.

> > > +
> > > +	return 0;
> > > +}
> > > +
> > > 
> > >  /*
> > >  
> > >   * ccdc_init_formats - Initialize formats on all pads
> > >   * @sd: ISP CCDC V4L2 subdevice
> > > 

-- 
Regards,

Laurent Pinchart

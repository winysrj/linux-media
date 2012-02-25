Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49059 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab2BYBel (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 20:34:41 -0500
Date: Sat, 25 Feb 2012 03:34:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 26/33] omap3isp: Default link validation for ccp2,
 csi2, preview and resizer
Message-ID: <20120225013436.GC12602@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1329703032-31314-26-git-send-email-sakari.ailus@iki.fi>
 <4620159.TXeRQHhZdd@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4620159.TXeRQHhZdd@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments.

On Wed, Feb 22, 2012 at 12:01:26PM +0100, Laurent Pinchart wrote:
> On Monday 20 February 2012 03:57:05 Sakari Ailus wrote:
> > Use default link validation for ccp2, csi2, preview and resizer. On ccp2,
> > csi2 and ccdc we also collect information on external subdevs as one may be
> > connected to those entities.
> > 
> > The CCDC link validation still must be done separately.
> > 
> > Also set pipe->external correctly as we go
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/omap3isp/ispccdc.c    |   23 +++++++++++++++++++++++
> >  drivers/media/video/omap3isp/ispccp2.c    |   20 ++++++++++++++++++++
> >  drivers/media/video/omap3isp/ispcsi2.c    |   19 +++++++++++++++++++
> >  drivers/media/video/omap3isp/isppreview.c |    2 ++
> >  drivers/media/video/omap3isp/ispresizer.c |    2 ++
> >  drivers/media/video/omap3isp/ispvideo.c   |    4 ++++
> >  6 files changed, 70 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/ispccdc.c
> > b/drivers/media/video/omap3isp/ispccdc.c index a74a797..6aff241 100644
> > --- a/drivers/media/video/omap3isp/ispccdc.c
> > +++ b/drivers/media/video/omap3isp/ispccdc.c
> > @@ -1999,6 +1999,27 @@ static int ccdc_set_format(struct v4l2_subdev *sd,
> > struct v4l2_subdev_fh *fh, return 0;
> >  }
> > 
> > +static int ccdc_link_validate(struct v4l2_subdev *sd,
> > +			      struct media_link *link,
> > +			      struct v4l2_subdev_format *source_fmt,
> > +			      struct v4l2_subdev_format *sink_fmt)
> > +{
> > +	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
> > +	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
> > +	int rval;
> > +
> > +	/* We've got a parallel sensor here. */
> > +	if (ccdc->input == CCDC_INPUT_PARALLEL) {
> > +		pipe->external =
> > +			media_entity_to_v4l2_subdev(link->source->entity);
> > +		rval = omap3isp_get_external_info(pipe, link);
> > +		if (rval < 0)
> > +			return 0;
> > +	}
> 
> Pending my comments on 25/33, this wouldn't be needed in this patch, and could 
> be squashed with 27/33.

If I moved this code out of pipeline validation, I'd have to walk the graph
one additional time. Do you think it's worth it, or are there easier ways to
find the external entity connected to a pipeline?

> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * ccdc_init_formats - Initialize formats on all pads
> >   * @sd: ISP CCDC V4L2 subdevice
> > @@ -2041,6 +2062,7 @@ static const struct v4l2_subdev_pad_ops
> > ccdc_v4l2_pad_ops = { .enum_frame_size = ccdc_enum_frame_size,
> >  	.get_fmt = ccdc_get_format,
> >  	.set_fmt = ccdc_set_format,
> > +	.link_validate = ccdc_link_validate,
> >  };
> > 
> >  /* V4L2 subdev operations */
> > @@ -2150,6 +2172,7 @@ static int ccdc_link_setup(struct media_entity
> > *entity, /* media operations */
> >  static const struct media_entity_operations ccdc_media_ops = {
> >  	.link_setup = ccdc_link_setup,
> > +	.link_validate = v4l2_subdev_link_validate,
> >  };
> > 
> >  void omap3isp_ccdc_unregister_entities(struct isp_ccdc_device *ccdc)
> > diff --git a/drivers/media/video/omap3isp/ispccp2.c
> > b/drivers/media/video/omap3isp/ispccp2.c index 70ddbf3..4fb34ee 100644
> > --- a/drivers/media/video/omap3isp/ispccp2.c
> > +++ b/drivers/media/video/omap3isp/ispccp2.c
> > @@ -819,6 +819,24 @@ static int ccp2_set_format(struct v4l2_subdev *sd,
> > struct v4l2_subdev_fh *fh, return 0;
> >  }
> > 
> > +static int ccp2_link_validate(struct v4l2_subdev *sd, struct media_link
> > *link, +			      struct v4l2_subdev_format *source_fmt,
> > +			      struct v4l2_subdev_format *sink_fmt)
> > +{
> > +	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
> > +	struct isp_pipeline *pipe = to_isp_pipeline(&ccp2->subdev.entity);
> > +	int rval;
> > +
> > +	pipe->external = media_entity_to_v4l2_subdev(link->source->entity);
> > +	rval = omap3isp_get_external_info(pipe, link);
> > +	if (rval < 0)
> > +		return rval;
> > +
> > +	return v4l2_subdev_link_validate_default(sd, link, source_fmt,
> > +						 sink_fmt);
> 
> That's the default behaviour, if omap3isp_get_external_info() is moved to 
> ispvideo.c you can just leave .link_validate as NULL.
> 
> > +}
> > +
> > +
> >  /*
> >   * ccp2_init_formats - Initialize formats on all pads
> >   * @sd: ISP CCP2 V4L2 subdevice
> > @@ -925,6 +943,7 @@ static const struct v4l2_subdev_pad_ops ccp2_sd_pad_ops
> > = { .enum_frame_size = ccp2_enum_frame_size,
> >  	.get_fmt = ccp2_get_format,
> >  	.set_fmt = ccp2_set_format,
> > +	.link_validate = ccp2_link_validate,
> >  };
> > 
> >  /* subdev operations */
> > @@ -1021,6 +1040,7 @@ static int ccp2_link_setup(struct media_entity
> > *entity, /* media operations */
> >  static const struct media_entity_operations ccp2_media_ops = {
> >  	.link_setup = ccp2_link_setup,
> > +	.link_validate = v4l2_subdev_link_validate,
> >  };
> > 
> >  /*
> > diff --git a/drivers/media/video/omap3isp/ispcsi2.c
> > b/drivers/media/video/omap3isp/ispcsi2.c index fcb5168..9313f7c 100644
> > --- a/drivers/media/video/omap3isp/ispcsi2.c
> > +++ b/drivers/media/video/omap3isp/ispcsi2.c
> > @@ -1012,6 +1012,23 @@ static int csi2_set_format(struct v4l2_subdev *sd,
> > struct v4l2_subdev_fh *fh, return 0;
> >  }
> > 
> > +static int csi2_link_validate(struct v4l2_subdev *sd, struct media_link
> > *link, +			      struct v4l2_subdev_format *source_fmt,
> > +			      struct v4l2_subdev_format *sink_fmt)
> > +{
> > +	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
> > +	struct isp_pipeline *pipe = to_isp_pipeline(&csi2->subdev.entity);
> > +	int rval;
> > +
> > +	pipe->external = media_entity_to_v4l2_subdev(link->source->entity);
> > +	rval = omap3isp_get_external_info(pipe, link);
> > +	if (rval < 0)
> > +		return rval;
> > +
> > +	return v4l2_subdev_link_validate_default(sd, link, source_fmt,
> > +						 sink_fmt);
> 
> Same here.
> 
> > +}
> > +
> >  /*
> >   * csi2_init_formats - Initialize formats on all pads
> >   * @sd: ISP CSI2 V4L2 subdevice
> > @@ -1107,6 +1124,7 @@ static const struct v4l2_subdev_pad_ops csi2_pad_ops =
> > { .enum_frame_size = csi2_enum_frame_size,
> >  	.get_fmt = csi2_get_format,
> >  	.set_fmt = csi2_set_format,
> > +	.link_validate = csi2_link_validate,
> >  };
> > 
> >  /* subdev operations */
> > @@ -1181,6 +1199,7 @@ static int csi2_link_setup(struct media_entity
> > *entity, /* media operations */
> >  static const struct media_entity_operations csi2_media_ops = {
> >  	.link_setup = csi2_link_setup,
> > +	.link_validate = v4l2_subdev_link_validate,
> >  };
> > 
> >  void omap3isp_csi2_unregister_entities(struct isp_csi2_device *csi2)
> > diff --git a/drivers/media/video/omap3isp/isppreview.c
> > b/drivers/media/video/omap3isp/isppreview.c index 6d0fb2c..c2bf500 100644
> > --- a/drivers/media/video/omap3isp/isppreview.c
> > +++ b/drivers/media/video/omap3isp/isppreview.c
> > @@ -1981,6 +1981,7 @@ static const struct v4l2_subdev_pad_ops
> > preview_v4l2_pad_ops = { .set_fmt = preview_set_format,
> >  	.get_crop = preview_get_crop,
> >  	.set_crop = preview_set_crop,
> > +	.link_validate = v4l2_subdev_link_validate_default,
> 
> You can leave this as NULL as well.
> 
> >  };
> > 
> >  /* subdev operations */
> > @@ -2076,6 +2077,7 @@ static int preview_link_setup(struct media_entity
> > *entity, /* media operations */
> >  static const struct media_entity_operations preview_media_ops = {
> >  	.link_setup = preview_link_setup,
> > +	.link_validate = v4l2_subdev_link_validate,
> >  };
> > 
> >  void omap3isp_preview_unregister_entities(struct isp_prev_device *prev)
> > diff --git a/drivers/media/video/omap3isp/ispresizer.c
> > b/drivers/media/video/omap3isp/ispresizer.c index 6958a9e..6ce2349 100644
> > --- a/drivers/media/video/omap3isp/ispresizer.c
> > +++ b/drivers/media/video/omap3isp/ispresizer.c
> > @@ -1532,6 +1532,7 @@ static const struct v4l2_subdev_pad_ops
> > resizer_v4l2_pad_ops = { .set_fmt = resizer_set_format,
> >  	.get_crop = resizer_g_crop,
> >  	.set_crop = resizer_s_crop,
> > +	.link_validate = v4l2_subdev_link_validate_default,
> 
> And this too.
> 
> >  };
> > 
> >  /* subdev operations */
> > @@ -1603,6 +1604,7 @@ static int resizer_link_setup(struct media_entity
> > *entity, /* media operations */
> >  static const struct media_entity_operations resizer_media_ops = {
> >  	.link_setup = resizer_link_setup,
> > +	.link_validate = v4l2_subdev_link_validate,
> >  };
> > 
> >  void omap3isp_resizer_unregister_entities(struct isp_res_device *res)
> > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > b/drivers/media/video/omap3isp/ispvideo.c index 17522db..f1c68ca 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.c
> > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > @@ -993,6 +993,10 @@ isp_video_streamon(struct file *file, void *fh, enum
> > v4l2_buf_type type) */
> >  	pipe = video->video.entity.pipe
> >  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
> > +	pipe->external = NULL;
> > +	pipe->external_rate = 0;
> > +	pipe->external_bpp = 0;
> > +
> >  	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
> >  	if (ret < 0)
> >  		goto err_media_entity_pipeline_start;
> -- 
> Regards,
> 
> Laurent Pinchart

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094Ab1I2IoQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 04:44:16 -0400
Date: Thu, 29 Sep 2011 10:44:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: add convenience macros to the subdevice / Media
 Controller API
In-Reply-To: <201109291032.00328.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1109291040460.30865@axis700.grange>
References: <Pine.LNX.4.64.1109291016250.30865@axis700.grange>
 <201109291032.00328.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Sep 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Thursday 29 September 2011 10:18:31 Guennadi Liakhovetski wrote:
> > Drivers, that can be built and work with and without
> > CONFIG_VIDEO_V4L2_SUBDEV_API, need the v4l2_subdev_get_try_format() and
> > v4l2_subdev_get_try_crop() functions, even though their return value
> > should never be dereferenced. Also add convenience macros to init and
> > clean up subdevice internal media entities.
> 
> Why don't you just make the drivers depend on CONFIG_VIDEO_V4L2_SUBDEV_API ? 
> They don't need to actually export a device node to userspace, but they 
> require the in-kernel API.

Why? Why should the user build and load all the media controller stuff, 
buy all the in-kernel objects and code to never actually use it? Where 
OTOH all is needed to avoid that is a couple of NOP macros?

Thanks
Guennadi

> 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  include/media/v4l2-subdev.h |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index f0f3358..4670506 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -569,6 +569,9 @@ v4l2_subdev_get_try_crop(struct v4l2_subdev_fh *fh,
> > unsigned int pad) {
> >  	return &fh->try_crop[pad];
> >  }
> > +#else
> > +#define v4l2_subdev_get_try_format(arg...)	NULL
> > +#define v4l2_subdev_get_try_crop(arg...)	NULL
> >  #endif
> > 
> >  extern const struct v4l2_file_operations v4l2_subdev_fops;
> > @@ -610,4 +613,12 @@ void v4l2_subdev_init(struct v4l2_subdev *sd,
> >  	((!(sd) || !(sd)->v4l2_dev || !(sd)->v4l2_dev->notify) ? -ENODEV : \
> >  	 (sd)->v4l2_dev->notify((sd), (notification), (arg)))
> > 
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +#define subdev_media_entity_init(sd, n, p,
> > e)	media_entity_init(&(sd)->entity, n, p, e) +#define
> > subdev_media_entity_cleanup(sd)		media_entity_cleanup(&(sd)->entity)
> > +#else
> > +#define subdev_media_entity_init(sd, n, p, e)	0
> > +#define subdev_media_entity_cleanup(sd)		do {} while (0)
> > +#endif
> > +
> >  #endif
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

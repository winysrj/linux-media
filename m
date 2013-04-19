Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58956 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599Ab3DSIwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 04:52:34 -0400
Date: Fri, 19 Apr 2013 10:52:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 21/24] V4L2: add a subdevice-driver pad-operation wrapper
In-Reply-To: <201304191020.44583.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1304191043470.591@axis700.grange>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
 <1366320945-21591-22-git-send-email-g.liakhovetski@gmx.de>
 <201304191020.44583.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 19 Apr 2013, Hans Verkuil wrote:

> On Thu April 18 2013 23:35:42 Guennadi Liakhovetski wrote:
> > Some subdevice drivers implement only the pad-level API, making them
> > unusable with V4L2 camera host drivers, using the plain subdevice
> > video API. This patch implements a wrapper to allow those two types
> > of drivers to be used together. So far only a subset of operations is
> > supported, the rest shall be added as needed.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> I wish you'd discussed this with me before spending time on this. This is
> really not the right approach to this problem.

I don't see this as such a strict requirement. I think, many systems work 
sufficiently well with subdevice video ops and don't need pad operations. 
Those systems simply don't have all the complexity, that really led to the 
pad-level API / MC. Think about simple camera interfaces, that can only 
capture data from a camera and DMA it to RAM with no or very little 
processing. No fancy scalers, converters, compressors etc. Do you really 
want to spend time converting such host drivers to the pad-level API and 
either use fake file-handles or really export everything to the user-space 
and make users configure both the camera source and the host sink pads 
manually independently... Isn't it an overkill? With my approach you just 
add "I want to stay with subdev ops and use a wrapper with pad-enabled 
sensor drivers" to the _host_ driver, because it's really the host driver, 
that has to be punished for being lazy. And you're done. No need to modify 
subdevice drivers first to add wrappers and then to remove them again...

Thanks
Guennadi

> The problem is that all the non-pad ops should be converted to the pad ops.
> There is no point in having two different implementations of the same thing.
> 
> IMHO the best approach is to convert the users of the old ops to the pad ops
> and add helper functions to v4l2-subdev.c that subdev drivers can use to
> still support the old ops by calling the new pad op instead. The next step
> is to convert all bridge driver uses of the old ops to the new ops and once
> that's done we can drop the old ops. This second step can be done at leisure.
> 
> So in v4l2-subdev.c you would have a helper like this:
> 
> int v4l2_subdev_video_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
>                              enum v4l2_mbus_pixelcode *code)
> {
> 	struct v4l2_subdev_mbus_code_enum mbus_code;
> 	int err;
> 
> 	memset(&mbus_code, 0, sizeof(mbus_code));
> 	mbus_code.index = index;
> 	err = v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &mbus_code);
> 	if (err >= 0)
> 		*code = mbus_code.code;
> 	return err;
> }
> 
> This helper would then be used in a subdev driver as the video enum_mbus_fmt op.
> 
> I now also understand your earlier patch allowing dummy v4l2_fh structs. That's
> definitely not the right approach, instead the v4l2_subdev_get_try_##fun_name
> macro (which IMHO should be dropped: just write out the functions in full) should
> be modified to handle a NULL v4l2_fh:
> 
> #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)           \
>         static inline struct rtype *                                    \
>         v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,       \
>                                        unsigned int pad)                \
>         {                                                               \
> 		if (fh == NULL)						\
> 			return NULL;					\
>                 BUG_ON(unlikely(pad >= vdev_to_v4l2_subdev(             \
>                                         fh->vfh.vdev)->entity.num_pads)); \
>                 return &fh->pad[pad].field_name;                        \
>         }
> 
> Is there any point to the try variants if you don't have file handles? If
> there is (and I don't see it), then v4l2_subdev could get a pointer to a
> struct v4l2_subdev_try_buf and the macro could use that if fh == NULL.
> 
> Regards,
> 
> 	Hans
> 
> > ---
> >  drivers/media/v4l2-core/Makefile        |    3 +
> >  drivers/media/v4l2-core/v4l2-pad-wrap.c |  329 +++++++++++++++++++++++++++++++
> >  include/media/v4l2-pad-wrap.h           |   23 +++
> >  include/media/v4l2-subdev.h             |    2 +
> >  4 files changed, 357 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/v4l2-core/v4l2-pad-wrap.c
> >  create mode 100644 include/media/v4l2-pad-wrap.h
> > 
> > diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> > index 4c33b8d6..85dda29 100644
> > --- a/drivers/media/v4l2-core/Makefile
> > +++ b/drivers/media/v4l2-core/Makefile
> > @@ -13,6 +13,9 @@ endif
> >  ifeq ($(CONFIG_OF),y)
> >    videodev-objs += v4l2-of.o
> >  endif
> > +ifeq ($(CONFIG_VIDEO_V4L2_SUBDEV_API),y)
> > +  videodev-objs += v4l2-pad-wrap.o
> > +endif
> >  
> >  obj-$(CONFIG_VIDEO_V4L2) += videodev.o
> >  obj-$(CONFIG_VIDEO_V4L2_INT_DEVICE) += v4l2-int-device.o
> > diff --git a/drivers/media/v4l2-core/v4l2-pad-wrap.c b/drivers/media/v4l2-core/v4l2-pad-wrap.c
> > new file mode 100644
> > index 0000000..f45a5e7
> > --- /dev/null
> > +++ b/drivers/media/v4l2-core/v4l2-pad-wrap.c
> > @@ -0,0 +1,329 @@
> > +/*
> > + * V4L2 pad operation wrapper for pure subdevice bridge drivers
> > + *
> > + * Copyright (C) 2013, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <media/v4l2-subdev.h>
> > +
> > +struct v4l2_subdev_pad_wrapper {
> > +	struct v4l2_subdev_ops		sd_ops;
> > +	struct v4l2_subdev_video_ops	video;
> > +	struct v4l2_subdev_fh		fh;
> > +	u32				pad;
> > +	const struct v4l2_subdev_ops	*ops_orig;
> > +	bool				touched;
> > +	struct v4l2_subdev_try_buf	try[];
> > +};
> > +
> > +/*
> > + * It seems some subdev drivers, implementing the pad-level API, expect their
> > + * pad devnode(s) to be opened at least once before any their operations can be
> > + * called. This initialiser emulates such an open() / close() cycle.
> > + */
> > +static int wrap_init_once(struct v4l2_subdev *sd,
> > +			  struct v4l2_subdev_pad_wrapper *wrap)
> > +{
> > +	int ret;
> > +
> > +	if (wrap->touched)
> > +		return 0;
> > +
> > +	ret = sd->internal_ops->open(sd, &wrap->fh);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	wrap->touched = true;
> > +
> > +	return sd->internal_ops->close(sd, &wrap->fh);
> > +}
> > +
> > +static int wrap_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_selection sel = {
> > +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > +		.pad = wrap->pad,
> > +		.target = V4L2_SEL_TGT_CROP_BOUNDS,
> > +		.flags = V4L2_SEL_FLAG_KEEP_CONFIG,
> > +	};
> > +	struct v4l2_rect rect;
> > +	int ret = wrap_init_once(sd, wrap);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = sd->ops->pad->get_selection(sd, &wrap->fh, &sel);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	rect = sel.r;
> > +
> > +	sel.target = V4L2_SEL_TGT_CROP_DEFAULT;
> > +
> > +	ret = sd->ops->pad->get_selection(sd, &wrap->fh, &sel);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	a->bounds = rect;
> > +	a->defrect = sel.r;
> > +	a->pixelaspect.numerator = 1;
> > +	a->pixelaspect.denominator = 1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int wrap_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_crop crop = {
> > +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > +		.pad = wrap->pad,
> > +	};
> > +	int ret = wrap_init_once(sd, wrap);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = sd->ops->pad->get_crop(sd, &wrap->fh, &crop);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	a->c = crop.rect;
> > +
> > +	return 0;
> > +}
> > +
> > +static int wrap_s_crop(struct v4l2_subdev *sd, const struct v4l2_crop *a)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_crop crop = {
> > +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > +		.pad = wrap->pad,
> > +		.rect = a->c,
> > +	};
> > +	int ret = wrap_init_once(sd, wrap);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return sd->ops->pad->set_crop(sd, &wrap->fh, &crop);
> > +}
> > +
> > +static int wrap_g_mbus_fmt(struct v4l2_subdev *sd,
> > +			   struct v4l2_mbus_framefmt *mf)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_format fmt = {
> > +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > +		.pad = wrap->pad,
> > +	};
> > +	int ret = wrap_init_once(sd, wrap);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = sd->ops->pad->get_fmt(sd, &wrap->fh, &fmt);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	*mf = fmt.format;
> > +
> > +	return 0;
> > +}
> > +
> > +static int wrap_try_mbus_fmt(struct v4l2_subdev *sd,
> > +			     struct v4l2_mbus_framefmt *mf)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_format fmt = {
> > +		.which = V4L2_SUBDEV_FORMAT_TRY,
> > +		.pad = wrap->pad,
> > +		.format = *mf,
> > +	};
> > +	/*
> > +	 * *TRY operations are using temporary buffers in the filehandle, so,
> > +	 * drivers can expect to be between an .open() and a .close() calls
> > +	 */
> > +	int ret_close, ret = sd->internal_ops->open(sd, &wrap->fh);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = sd->ops->pad->set_fmt(sd, &wrap->fh, &fmt);
> > +	ret_close = sd->internal_ops->close(sd, &wrap->fh);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (!ret_close)
> > +		*mf = fmt.format;
> > +
> > +	return ret_close;
> > +}
> > +
> > +static int wrap_s_mbus_fmt(struct v4l2_subdev *sd,
> > +			   struct v4l2_mbus_framefmt *mf)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_format fmt = {
> > +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > +		.pad = wrap->pad,
> > +		.format = *mf,
> > +	};
> > +	int ret = wrap_init_once(sd, wrap);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = sd->ops->pad->set_fmt(sd, &wrap->fh, &fmt);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	*mf = fmt.format;
> > +
> > +	return 0;
> > +}
> > +
> > +static int wrap_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
> > +			      enum v4l2_mbus_pixelcode *code)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_mbus_code_enum code_enum = {
> > +		.pad = wrap->pad,
> > +		.index = index,
> > +	};
> > +	int ret = wrap_init_once(sd, wrap);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = sd->ops->pad->enum_mbus_code(sd, &wrap->fh, &code_enum);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	*code = code_enum.code;
> > +
> > +	return 0;
> > +}
> > +
> > +static int wrap_enum_framesizes(struct v4l2_subdev *sd,
> > +				struct v4l2_frmsizeenum *fsize)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +	struct v4l2_subdev_frame_size_enum fse = {
> > +		.index = fsize->index,
> > +		.pad = wrap->pad,
> > +		.code = fsize->pixel_format,
> > +	};
> > +	int ret = wrap_init_once(sd, wrap);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = sd->ops->pad->enum_frame_size(sd, &wrap->fh, &fse);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (fse.min_width == fse.max_width &&
> > +	    fse.min_height == fse.max_height) {
> > +		fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
> > +		fsize->discrete.width = fse.min_width;
> > +		fsize->discrete.height = fse.min_height;
> > +	} else {
> > +		fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
> > +		fsize->stepwise.min_width = fse.min_width;
> > +		fsize->stepwise.min_height = fse.min_height;
> > +		fsize->stepwise.max_width = fse.max_width;
> > +		fsize->stepwise.max_height = fse.max_height;
> > +		fsize->stepwise.step_width = 1;
> > +		fsize->stepwise.step_height = 1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int v4l2_subdev_pad_wrap(struct v4l2_subdev *sd)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap;
> > +	const struct v4l2_subdev_video_ops *video_orig = sd->ops->video;
> > +	const struct v4l2_subdev_pad_ops *pad_orig = sd->ops->pad;
> > +	int i;
> > +
> > +	if (!pad_orig)
> > +		return -ENOSYS;
> > +
> > +	wrap = kzalloc(sizeof(*wrap) + sd->entity.num_pads * sizeof(*wrap->fh.pad),
> > +		       GFP_KERNEL);
> > +	if (!wrap)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < sd->entity.num_pads; i++)
> > +		if (sd->entity.pads[i].flags == MEDIA_PAD_FL_SOURCE) {
> > +			wrap->pad = sd->entity.pads[i].index;
> > +			break;
> > +		}
> > +
> > +	if (i == sd->entity.num_pads) {
> > +		kfree(wrap);
> > +		return -ENODEV;
> > +	}
> > +
> > +	wrap->fh.subdev = sd;
> > +	wrap->fh.pad = wrap->try;
> > +	v4l2_fh_init(&wrap->fh.vfh, sd->devnode);
> > +
> > +	/* Do subdev drivers use fh? Do we need a v4l2_fh_add()? */
> > +
> > +	memcpy(&wrap->sd_ops, sd->ops, sizeof(wrap->sd_ops));
> > +	if (video_orig)
> > +		memcpy(&wrap->video, video_orig, sizeof(wrap->video));
> > +
> > +	/*
> > +	 * Assign wrappers individually. This way we won't overwrite by accident
> > +	 * new video operations before their wrappers are implemented here.
> > +	 */
> > +	if (pad_orig->get_selection && (!video_orig || !video_orig->cropcap))
> > +		wrap->video.cropcap = wrap_cropcap;
> > +	if (pad_orig->get_crop && (!video_orig || !video_orig->g_crop))
> > +		wrap->video.g_crop = wrap_g_crop;
> > +	if (pad_orig->set_crop && (!video_orig || !video_orig->s_crop))
> > +		wrap->video.s_crop = wrap_s_crop;
> > +	if (pad_orig->get_fmt && (!video_orig || !video_orig->g_mbus_fmt))
> > +		wrap->video.g_mbus_fmt = wrap_g_mbus_fmt;
> > +	if (pad_orig->set_fmt && (!video_orig || !video_orig->s_mbus_fmt)) {
> > +		wrap->video.s_mbus_fmt = wrap_s_mbus_fmt;
> > +		wrap->video.try_mbus_fmt = wrap_try_mbus_fmt;
> > +	}
> > +	if (pad_orig->enum_mbus_code && (!video_orig || !video_orig->enum_mbus_fmt))
> > +		wrap->video.enum_mbus_fmt = wrap_enum_mbus_fmt;
> > +	if (pad_orig->enum_frame_size && (!video_orig || !video_orig->enum_framesizes))
> > +		wrap->video.enum_framesizes = wrap_enum_framesizes;
> > +
> > +	wrap->ops_orig = sd->ops;
> > +	wrap->sd_ops.video = &wrap->video;
> > +	sd->ops = &wrap->sd_ops;
> > +
> > +	sd->flags |= V4L2_SUBDEV_FL_PADOPS_WRAP;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(v4l2_subdev_pad_wrap);
> > +
> > +void v4l2_subdev_pad_unwrap(struct v4l2_subdev *sd)
> > +{
> > +	struct v4l2_subdev_pad_wrapper *wrap = container_of(sd->ops,
> > +				struct v4l2_subdev_pad_wrapper, sd_ops);
> > +
> > +	if (!(sd->flags & V4L2_SUBDEV_FL_PADOPS_WRAP))
> > +		return;
> > +
> > +	sd->ops = wrap->ops_orig;
> > +	kfree(wrap);
> > +}
> > +EXPORT_SYMBOL(v4l2_subdev_pad_unwrap);
> > diff --git a/include/media/v4l2-pad-wrap.h b/include/media/v4l2-pad-wrap.h
> > new file mode 100644
> > index 0000000..800e608
> > --- /dev/null
> > +++ b/include/media/v4l2-pad-wrap.h
> > @@ -0,0 +1,23 @@
> > +/*
> > + * V4L2 pad operation wrapper for pure subdevice bridge drivers
> > + *
> > + * Copyright (C) 2013, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef V4L2_PAD_WRAP_H
> > +#define V4L2_PAD_WRAP_H
> > +
> > +struct v4l2_subdev;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +int v4l2_subdev_pad_wrap(struct v4l2_subdev *sd);
> > +void v4l2_subdev_pad_unwrap(struct v4l2_subdev *sd);
> > +#else
> > +#define v4l2_subdev_pad_wrap(sd) ({ (void)(sd); -ENOSYS; })
> > +#define v4l2_subdev_pad_unwrap(sd) do { (void)(sd); } while (0)
> > +#endif
> > +
> > +#endif
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 0581781..7d53177 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -560,6 +560,8 @@ struct v4l2_subdev_internal_ops {
> >  #define V4L2_SUBDEV_FL_HAS_DEVNODE		(1U << 2)
> >  /* Set this flag if this subdev generates events. */
> >  #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
> > +/* Set this flag if this subdev emulates video operations */
> > +#define V4L2_SUBDEV_FL_PADOPS_WRAP		(1U << 4)
> >  
> >  struct regulator_bulk_data;
> >  
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

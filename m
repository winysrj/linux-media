Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33769 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751800AbeCCRE6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 12:04:58 -0500
Received: by mail-lf0-f68.google.com with SMTP id o145so17542547lff.0
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2018 09:04:57 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 3 Mar 2018 18:04:54 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 16/32] rcar-vin: read subdevice format for crop only
 when needed
Message-ID: <20180303170454.GL12470@bigcity.dyn.berto.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
 <20180302015751.25596-17-niklas.soderlund+renesas@ragnatech.se>
 <1860931.WLVs16Imm2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1860931.WLVs16Imm2@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2018-03-02 13:06:27 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 2 March 2018 03:57:35 EET Niklas Söderlund wrote:
> > Instead of caching the subdevice format each time the video device
> > format is set read it directly when it's needed. As it turns out the
> > format is only needed when figuring out the max rectangle for cropping.
> > 
> > This simplifies the code and makes it clearer what the source format is
> > used for.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 158 +++++++++++++------------
> >  drivers/media/platform/rcar-vin/rcar-vin.h  |  12 ---
> >  2 files changed, 80 insertions(+), 90 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > 3290e603b44cdf3a..55640c6b2a1200ca 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -144,67 +144,62 @@ static int rvin_format_align(struct rvin_dev *vin,
> > struct v4l2_pix_format *pix) * V4L2
> >   */
> > 
> > -static void rvin_reset_crop_compose(struct rvin_dev *vin)
> > +static int rvin_get_vin_format_from_source(struct rvin_dev *vin,
> > +					   struct v4l2_pix_format *pix)
> >  {
> > +	struct v4l2_subdev_format fmt = {
> > +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > +		.pad = vin->digital->source_pad,
> > +	};
> > +	int ret;
> > +
> > +	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
> > +	if (ret)
> > +		return ret;
> > +
> > +	v4l2_fill_pix_format(pix, &fmt.format);
> > +
> > +	return rvin_format_align(vin, pix);
> > +}
> > +
> > +static int rvin_reset_format(struct rvin_dev *vin)
> > +{
> > +	int ret;
> > +
> > +	ret = rvin_get_vin_format_from_source(vin, &vin->format);
> > +	if (ret)
> > +		return ret;
> > +
> >  	vin->crop.top = vin->crop.left = 0;
> > -	vin->crop.width = vin->source.width;
> > -	vin->crop.height = vin->source.height;
> > +	vin->crop.width = vin->format.width;
> > +	vin->crop.height = vin->format.height;
> > 
> >  	vin->compose.top = vin->compose.left = 0;
> >  	vin->compose.width = vin->format.width;
> >  	vin->compose.height = vin->format.height;
> > -}
> > -
> > -static int rvin_reset_format(struct rvin_dev *vin)
> > -{
> > -	struct v4l2_subdev_format fmt = {
> > -		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > -	};
> > -	struct v4l2_mbus_framefmt *mf = &fmt.format;
> > -	int ret;
> > -
> > -	fmt.pad = vin->digital->source_pad;
> > -
> > -	ret = v4l2_subdev_call(vin_to_source(vin), pad, get_fmt, NULL, &fmt);
> > -	if (ret)
> > -		return ret;
> > -
> > -	vin->format.width	= mf->width;
> > -	vin->format.height	= mf->height;
> > -	vin->format.colorspace	= mf->colorspace;
> > -	vin->format.field	= mf->field;
> > -
> > -	rvin_reset_crop_compose(vin);
> > -
> > -	vin->format.bytesperline = rvin_format_bytesperline(&vin->format);
> > -	vin->format.sizeimage = rvin_format_sizeimage(&vin->format);
> > 
> >  	return 0;
> >  }
> > 
> > -static int __rvin_try_format_source(struct rvin_dev *vin,
> > -				    u32 which,
> > -				    struct v4l2_pix_format *pix,
> > -				    struct rvin_source_fmt *source)
> > +static int rvin_try_format(struct rvin_dev *vin, u32 which,
> > +			   struct v4l2_pix_format *pix,
> > +			   struct v4l2_rect *crop, struct v4l2_rect *compose)
> >  {
> > -	struct v4l2_subdev *sd;
> > +	struct v4l2_subdev *sd = vin_to_source(vin);
> >  	struct v4l2_subdev_pad_config *pad_cfg;
> >  	struct v4l2_subdev_format format = {
> >  		.which = which,
> > +		.pad = vin->digital->source_pad,
> >  	};
> >  	enum v4l2_field field;
> >  	u32 width, height;
> >  	int ret;
> > 
> > -	sd = vin_to_source(vin);
> > -
> > -	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
> > -
> >  	pad_cfg = v4l2_subdev_alloc_pad_config(sd);
> >  	if (pad_cfg == NULL)
> >  		return -ENOMEM;
> > 
> > -	format.pad = vin->digital->source_pad;
> > +	v4l2_fill_mbus_format(&format.format, pix, vin->digital->code);
> > 
> >  	/* Allow the video device to override field and to scale */
> >  	field = pix->field;
> > @@ -217,34 +212,34 @@ static int __rvin_try_format_source(struct rvin_dev
> > *vin,
> > 
> >  	v4l2_fill_pix_format(pix, &format.format);
> > 
> > -	source->width = pix->width;
> > -	source->height = pix->height;
> > +	crop->top = crop->left = 0;
> > +	crop->width = pix->width;
> > +	crop->height = pix->height;
> > +
> > +	/*
> > +	 * If source is ALTERNATE the driver will use the VIN hardware
> > +	 * to INTERLACE it. The crop height then needs to be doubled.
> > +	 */
> > +	if (pix->field == V4L2_FIELD_ALTERNATE)
> > +		crop->height *= 2;
> > +
> > +	if (field != V4L2_FIELD_ANY)
> > +		pix->field = field;
> > 
> > -	pix->field = field;
> >  	pix->width = width;
> >  	pix->height = height;
> > 
> > -	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
> > -		source->height);
> > +	ret = rvin_format_align(vin, pix);
> > +	if (ret)
> > +		return ret;
> > 
> > +	compose->top = compose->left = 0;
> > +	compose->width = pix->width;
> > +	compose->height = pix->height;
> >  done:
> >  	v4l2_subdev_free_pad_config(pad_cfg);
> > -	return ret;
> > -}
> > 
> > -static int __rvin_try_format(struct rvin_dev *vin,
> > -			     u32 which,
> > -			     struct v4l2_pix_format *pix,
> > -			     struct rvin_source_fmt *source)
> > -{
> > -	int ret;
> > -
> > -	/* Limit to source capabilities */
> > -	ret = __rvin_try_format_source(vin, which, pix, source);
> > -	if (ret)
> > -		return ret;
> > -
> > -	return rvin_format_align(vin, pix);
> > +	return 0;
> >  }
> > 
> >  static int rvin_querycap(struct file *file, void *priv,
> > @@ -263,33 +258,30 @@ static int rvin_try_fmt_vid_cap(struct file *file,
> > void *priv, struct v4l2_format *f)
> >  {
> >  	struct rvin_dev *vin = video_drvdata(file);
> > -	struct rvin_source_fmt source;
> > +	struct v4l2_rect crop, compose;
> > 
> > -	return __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix,
> > -				 &source);
> > +	return rvin_try_format(vin, V4L2_SUBDEV_FORMAT_TRY, &f->fmt.pix, &crop,
> > +			       &compose);
> >  }
> > 
> >  static int rvin_s_fmt_vid_cap(struct file *file, void *priv,
> >  			      struct v4l2_format *f)
> >  {
> >  	struct rvin_dev *vin = video_drvdata(file);
> > -	struct rvin_source_fmt source;
> > +	struct v4l2_rect crop, compose;
> >  	int ret;
> > 
> >  	if (vb2_is_busy(&vin->queue))
> >  		return -EBUSY;
> > 
> > -	ret = __rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> > -				&source);
> > +	ret = rvin_try_format(vin, V4L2_SUBDEV_FORMAT_ACTIVE, &f->fmt.pix,
> > +			      &crop, &compose);
> >  	if (ret)
> >  		return ret;
> > 
> > -	vin->source.width = source.width;
> > -	vin->source.height = source.height;
> > -
> >  	vin->format = f->fmt.pix;
> > -
> > -	rvin_reset_crop_compose(vin);
> > +	vin->crop = crop;
> > +	vin->compose = compose;
> > 
> >  	return 0;
> >  }
> > @@ -319,6 +311,8 @@ static int rvin_g_selection(struct file *file, void *fh,
> > struct v4l2_selection *s)
> >  {
> >  	struct rvin_dev *vin = video_drvdata(file);
> > +	struct v4l2_pix_format pix;
> > +	int ret;
> > 
> >  	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >  		return -EINVAL;
> > @@ -326,9 +320,12 @@ static int rvin_g_selection(struct file *file, void
> > *fh, switch (s->target) {
> >  	case V4L2_SEL_TGT_CROP_BOUNDS:
> >  	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +		ret = rvin_get_vin_format_from_source(vin, &pix);
> > +		if (ret)
> > +			return ret;
> >  		s->r.left = s->r.top = 0;
> > -		s->r.width = vin->source.width;
> > -		s->r.height = vin->source.height;
> > +		s->r.width = pix.width;
> > +		s->r.height = pix.height;
> >  		break;
> >  	case V4L2_SEL_TGT_CROP:
> >  		s->r = vin->crop;
> > @@ -353,6 +350,7 @@ static int rvin_s_selection(struct file *file, void *fh,
> > struct v4l2_selection *s)
> >  {
> >  	struct rvin_dev *vin = video_drvdata(file);
> > +	struct v4l2_pix_format pix;
> >  	const struct rvin_video_format *fmt;
> >  	struct v4l2_rect r = s->r;
> >  	struct v4l2_rect max_rect;
> > @@ -360,6 +358,7 @@ static int rvin_s_selection(struct file *file, void *fh,
> > .width = 6,
> >  		.height = 2,
> >  	};
> > +	int ret;
> > 
> >  	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >  		return -EINVAL;
> > @@ -369,22 +368,25 @@ static int rvin_s_selection(struct file *file, void
> > *fh, switch (s->target) {
> >  	case V4L2_SEL_TGT_CROP:
> >  		/* Can't crop outside of source input */
> > +		ret = rvin_get_vin_format_from_source(vin, &pix);
> > +		if (ret)
> > +			return ret;
> 
> I don't think the crop rectangle should be validated against the current 
> source format, but against the current video node format. As noted in my 
> review of the previous version:
> 
> If you stop caching the source format you'll end up validating the crop 
> rectangle against the current source format. What will happen if the format 
> changed since the last VIDIOC_S_FMT call ?
> 
> And thinking about it, are sources allowed to change their format autonomously 
> ? They surely can detect format changes, but can they update the format 
> without notifying anyone ? Looking at the adv7180 driver for instance, the 
> format depends on the TV standard, but the driver doesn't change it. It only 
> reports newly detected standards and relies on someone then calling the s_std 
> operation. The VIN driver should then in its S_STD handler retrieve the new 
> source format, and reset the crop rectangle accordingly.
> 
> I believe the same applies to V4L2_SEL_TGT_CROP_BOUNDS and 
> V4L2_SEL_TGT_CROP_DEFAULT.

OK, after the latest version and some sleep I now see your point, and I 
agree with it. I will keep caching the source format :-) I will 
repurpose this patch to keep the format cleanups but keep caching of the 
source dimensions. Thanks for being persistent and making me understand 
the issue.

> 
> >  		max_rect.top = max_rect.left = 0;
> > -		max_rect.width = vin->source.width;
> > -		max_rect.height = vin->source.height;
> > +		max_rect.width = pix.width;
> > +		max_rect.height = pix.height;
> >  		v4l2_rect_map_inside(&r, &max_rect);
> > 
> > -		v4l_bound_align_image(&r.width, 2, vin->source.width, 1,
> > -				      &r.height, 4, vin->source.height, 2, 0);
> > +		v4l_bound_align_image(&r.width, 2, pix.width, 1,
> > +				      &r.height, 4, pix.height, 2, 0);
> > 
> > -		r.top  = clamp_t(s32, r.top, 0, vin->source.height - r.height);
> > -		r.left = clamp_t(s32, r.left, 0, vin->source.width - r.width);
> > +		r.top  = clamp_t(s32, r.top, 0, pix.height - r.height);
> > +		r.left = clamp_t(s32, r.left, 0, pix.width - r.width);
> > 
> >  		vin->crop = s->r = r;
> > 
> >  		vin_dbg(vin, "Cropped %dx%d@%d:%d of %dx%d\n",
> >  			r.width, r.height, r.left, r.top,
> > -			vin->source.width, vin->source.height);
> > +			pix.width, pix.height);
> >  		break;
> >  	case V4L2_SEL_TGT_COMPOSE:
> >  		/* Make sure compose rect fits inside output format */
> > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h
> > b/drivers/media/platform/rcar-vin/rcar-vin.h index
> > 8daba9db0e927a49..39051da31650bd79 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > @@ -48,16 +48,6 @@ enum rvin_dma_state {
> >  	STOPPING,
> >  };
> > 
> > -/**
> > - * struct rvin_source_fmt - Source information
> > - * @width:	Width from source
> > - * @height:	Height from source
> > - */
> > -struct rvin_source_fmt {
> > -	u32 width;
> > -	u32 height;
> > -};
> > -
> >  /**
> >   * struct rvin_video_format - Data format stored in memory
> >   * @fourcc:	Pixelformat
> > @@ -124,7 +114,6 @@ struct rvin_info {
> >   * @sequence:		V4L2 buffers sequence number
> >   * @state:		keeps track of operation state
> >   *
> > - * @source:		active format from the video source
> >   * @format:		active V4L2 pixel format
> >   *
> >   * @crop:		active cropping
> > @@ -151,7 +140,6 @@ struct rvin_dev {
> >  	unsigned int sequence;
> >  	enum rvin_dma_state state;
> > 
> > -	struct rvin_source_fmt source;
> >  	struct v4l2_pix_format format;
> > 
> >  	struct v4l2_rect crop;
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund

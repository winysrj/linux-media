Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56019 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754168AbeEWIr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 04:47:59 -0400
Message-ID: <1527065278.6875.1.camel@pengutronix.de>
Subject: Re: [PATCH] media: video-mux: fix compliance failures
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Rui Miguel Silva <rui.silva@linaro.org>, kernel@pengutronix.de
Date: Wed, 23 May 2018 10:47:58 +0200
In-Reply-To: <16e0879d-2db3-951b-fd96-636b9615a3f2@xs4all.nl>
References: <20180522162925.16854-1-p.zabel@pengutronix.de>
         <16e0879d-2db3-951b-fd96-636b9615a3f2@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thank you for the review comments.

On Tue, 2018-05-22 at 19:47 +0200, Hans Verkuil wrote:
> On 22/05/18 18:29, Philipp Zabel wrote:
> > Limit frame sizes to the [1, UINT_MAX-1] interval, media bus formats to
> > the available list of formats, and initialize pad and try formats.
> > 
> > Reported-by: Rui Miguel Silva <rui.silva@linaro.org>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/video-mux.c | 110 +++++++++++++++++++++++++++++
> >  1 file changed, 110 insertions(+)
> > 
> > diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> > index 1fb887293337..ade1dae706aa 100644
> > --- a/drivers/media/platform/video-mux.c
> > +++ b/drivers/media/platform/video-mux.c
> > @@ -180,6 +180,87 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
> >  	if (!source_mbusformat)
> >  		return -EINVAL;
> >  
> > +	/* No size limitations except V4L2 compliance requirements */
> > +	v4l_bound_align_image(&sdformat->format.width, 1, UINT_MAX - 1, 0,
> > +			      &sdformat->format.height, 1, UINT_MAX - 1, 0, 0);
> 
> This is a bit dubious. I would pick more realistic min/max values like 16 and

Why 16? A grayscale or RGB sensor could crop down to 1x1, see mt9v032
for example.

> 65536. UINT_MAX - 1 will overflow whenever code increments/multiplies it for some
> reason, which can cause all sorts of weird issues.

Ok. Should v4l2-compliance check for > 65536 then, instead of (or
additionally to) UINT_MAX?

> > +
> > +	/* All formats except LVDS and vendor specific formats are acceptable */
> > +	switch (sdformat->format.code) {
> > +	case MEDIA_BUS_FMT_RGB444_1X12:
> > +	case MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE:
[...]
> > +	case MEDIA_BUS_FMT_JPEG_1X8:
> > +	case MEDIA_BUS_FMT_AHSV8888_1X32:
> > +		break;
> > +	default:
> > +		sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;
> 
> Add a break here.

Will do.

> > +	}
> > +	if (sdformat->format.field == V4L2_FIELD_ANY)
> > +		sdformat->format.field = V4L2_FIELD_NONE;
> > +
> >  	mutex_lock(&vmux->lock);
> >  
> >  	/* Source pad mirrors active sink pad, no limitations on sink pads */
> > @@ -197,11 +278,33 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
> >  	return 0;
> >  }
> >  
> > +static int video_mux_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> > +{
> > +	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
> > +	struct v4l2_mbus_framefmt *mbusformat;
> > +	int i;
> > +
> > +	mutex_lock(&vmux->lock);
> > +
> > +	for (i = 0; i < sd->entity.num_pads; i++) {
> > +		mbusformat = v4l2_subdev_get_try_format(sd, fh->pad, i);
> > +		*mbusformat = vmux->format_mbus[i];
> > +	}
> > +
> > +	mutex_unlock(&vmux->lock);
> > +
> > +	return 0;
> > +}
> 
> This isn't the right approach. Instead implement the init_cfg pad op.

How embarrassing, yes.

> > +
> >  static const struct v4l2_subdev_pad_ops video_mux_pad_ops = {
> >  	.get_fmt = video_mux_get_format,
> >  	.set_fmt = video_mux_set_format,
> >  };
> >  
> > +static const struct v4l2_subdev_internal_ops video_mux_internal_ops = {
> > +	.open = video_mux_open,
> > +};
> 
> So this can be dropped.

Ok, thanks!

regards
Philipp

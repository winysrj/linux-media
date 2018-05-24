Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59785 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964791AbeEXMmo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 08:42:44 -0400
Message-ID: <1527165761.5106.5.camel@pengutronix.de>
Subject: Re: [PATCH v2] media: video-mux: fix compliance failures
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Rui Miguel Silva <rui.silva@linaro.org>,
        kernel@pengutronix.de
Date: Thu, 24 May 2018 14:42:41 +0200
In-Reply-To: <20180524113824.3znoltw3yfj2ngrd@valkosipuli.retiisi.org.uk>
References: <20180523092423.4386-1-p.zabel@pengutronix.de>
         <20180524113824.3znoltw3yfj2ngrd@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thank you for the review comments.

On Thu, 2018-05-24 at 14:38 +0300, Sakari Ailus wrote:
> Hi Philipp,
> 
> Thanks for the patch.
> 
> On Wed, May 23, 2018 at 11:24:23AM +0200, Philipp Zabel wrote:
> > Limit frame sizes to the [1, 65536] interval, media bus formats to
> > the available list of formats, and initialize pad and try formats.
> > 
> > Reported-by: Rui Miguel Silva <rui.silva@linaro.org>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v1:
> >  - Limit to [1, 65536] instead of [1, UINT_MAX - 1]
> >  - Add missing break in default case
> >  - Use .init_cfg pad op instead of .open internal op
> > ---
> >  drivers/media/platform/video-mux.c | 108 +++++++++++++++++++++++++++++
> >  1 file changed, 108 insertions(+)
> > 
> > diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> > index 1fb887293337..d27cb42ce6b1 100644
> > --- a/drivers/media/platform/video-mux.c
> > +++ b/drivers/media/platform/video-mux.c
> > @@ -180,6 +180,88 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
> >  	if (!source_mbusformat)
> >  		return -EINVAL;
> >  
> > +	/* No size limitations except V4L2 compliance requirements */
> > +	v4l_bound_align_image(&sdformat->format.width, 1, 65536, 0,
> > +			      &sdformat->format.height, 1, 65536, 0, 0);
> 
> Why 65536? And not e.g. U32_MAX?

v4l2-compliance submits a format struct memset to all 0xff and complains
if width or height return U32_MAX.
I first evaded this by limiting to UINT_MAX - 1, but Hans suggested I
reduce this to 65536 as a more realistic maximum [1].

[1] https://patchwork.linuxtv.org/patch/49827/

[...]
> > @@ -197,7 +279,27 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
> >  	return 0;
> >  }
> >  
> > +static int video_mux_init_cfg(struct v4l2_subdev *sd,
> > +			      struct v4l2_subdev_pad_config *cfg)
> > +{
> > +	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
> > +	struct v4l2_mbus_framefmt *mbusformat;
> > +	int i;
> 
> unsigned int i

Ok.

> > +
> > +	mutex_lock(&vmux->lock);
> > +
> > +	for (i = 0; i < sd->entity.num_pads; i++) {
> > +		mbusformat = v4l2_subdev_get_try_format(sd, cfg, i);
> > +		*mbusformat = vmux->format_mbus[i];
> 
> The initial format is the default one, not the current configured format.

I'm fine with changing that if that is the expected behavior.
Is this what was meant with:
  "Try formats do not depend on active formats, but can depend on the
   current links configuration or sub-device controls value." [1]
? I read that as currently active formats should not limit the try
formats accepted on the other pad.

[1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/vidioc-subdev-g-fmt.html#description

> With these addressed,
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> > +	}
> > +
> > +	mutex_unlock(&vmux->lock);
> > +
> > +	return 0;
> > +}
> > +
> >  static const struct v4l2_subdev_pad_ops video_mux_pad_ops = {
> > +	.init_cfg = video_mux_init_cfg,
> >  	.get_fmt = video_mux_get_format,
> >  	.set_fmt = video_mux_set_format,
> >  };
> > @@ -263,6 +365,12 @@ static int video_mux_probe(struct platform_device *pdev)
> >  	for (i = 0; i < num_pads - 1; i++)
> >  		vmux->pads[i].flags = MEDIA_PAD_FL_SINK;
> >  	vmux->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
> > +	for (i = 0; i < num_pads; i++) {

I'll also turn this i into unsigned int.

> > +		vmux->format_mbus[i].width = 1;
> > +		vmux->format_mbus[i].height = 1;
> > +		vmux->format_mbus[i].code = MEDIA_BUS_FMT_Y8_1X8;
> > +		vmux->format_mbus[i].field = V4L2_FIELD_NONE;
> > +	}
> >  
> >  	vmux->subdev.entity.function = MEDIA_ENT_F_VID_MUX;
> >  	ret = media_entity_pads_init(&vmux->subdev.entity, num_pads,
> > -- 
> > 2.17.0

regards
Philipp

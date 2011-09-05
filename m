Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60696 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1IEJZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 05:25:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH 1/2 v2] media: Add support for arbitrary resolution for the ov5642 camera driver
Date: Mon, 5 Sep 2011 11:25:33 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1108311420540.2154@ipanema> <201108311932.08252.laurent.pinchart@ideasonboard.com> <CABYn4sx25RbeKFDn8=cPuJETpornXW+osstrMEi9AjrtQAfSeA@mail.gmail.com>
In-Reply-To: <CABYn4sx25RbeKFDn8=cPuJETpornXW+osstrMEi9AjrtQAfSeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051125.33829.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

On Monday 05 September 2011 11:10:48 Bastian Hecht wrote:
> 2011/8/31 Laurent Pinchart:
> > Hi Bastian,
> > 
> > Guennadi pointed out that "should" can sound a bit harsh, so please read
> > my reviews as if
> > 
> > #define "you should" "I think you should"
> 
> I think that you think I should do the right thing. I removed out_sizes and
> repost v3 in a moment :)

Thanks :-)

> > was prepended to all of them :-)
> > 
> > On Wednesday 31 August 2011 19:06:25 Laurent Pinchart wrote:
> >> On Wednesday 31 August 2011 17:05:52 Bastian Hecht wrote:
> >> > This patch adds the ability to get arbitrary resolutions with a width
> >> > up to 2592 and a height up to 720 pixels instead of the standard
> >> > 1280x720 only.
> >> > 
> >> > Signed-off-by: Bastian Hecht <hechtb@gmail.com>
> >> > ---
> >> > diff --git a/drivers/media/video/ov5642.c
> >> > b/drivers/media/video/ov5642.c index 6410bda..87b432e 100644
> >> > --- a/drivers/media/video/ov5642.c
> >> > +++ b/drivers/media/video/ov5642.c
> >> 
> >> [snip]
> >> 
> >> > @@ -684,107 +737,101 @@ static int ov5642_write_array(struct
> >> > i2c_client
> >> 
> >> [snip]
> >> 
> >> > -static int ov5642_s_fmt(struct v4l2_subdev *sd,
> >> > -                   struct v4l2_mbus_framefmt *mf)
> >> > +static int ov5642_s_fmt(struct v4l2_subdev *sd, struct
> >> > v4l2_mbus_framefmt *mf) {
> >> > 
> >> >     struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> >     struct ov5642 *priv = to_ov5642(client);
> >> > 
> >> > -
> >> > -   dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
> >> > +   int ret;
> >> > 
> >> >     /* MIPI CSI could have changed the format, double-check */
> >> >     if (!ov5642_find_datafmt(mf->code))
> >> > 
> >> >             return -EINVAL;
> >> > 
> >> >     ov5642_try_fmt(sd, mf);
> >> > 
> >> > -
> >> > 
> >> >     priv->fmt = ov5642_find_datafmt(mf->code);
> >> > 
> >> > -   ov5642_write_array(client, ov5642_default_regs_init);
> >> > -   ov5642_set_resolution(client);
> >> > -   ov5642_write_array(client, ov5642_default_regs_finalise);
> >> > +   ret = ov5642_write_array(client, ov5642_default_regs_init);
> >> > +   if (!ret)
> >> > +           ret = ov5642_set_resolution(sd);
> >> > +   if (!ret)
> >> > +           ret = ov5642_write_array(client,
> >> > ov5642_default_regs_finalise);
> >> 
> >> You shouldn't write anything to the sensor here. As only .s_crop can
> >> currently change the format, .s_fmt should just return the current
> >> format without performing any change or writing anything to the device.
> 
> We talked about it in the ov5642 controls thread. I need to initialize
> the sensor at some point and it doesn't work to divide the calls
> between different locations.

Sure, but calling s_fmt isn't mandatory for hosts/bridges. What about moving 
sensor initialization to s_stream() ?

> >> > -   return 0;
> >> > +   return ret;
> >> > 
> >> >  }
> >> 
> >> [snip]
> >> 
> >> > @@ -827,15 +874,42 @@ static int ov5642_g_chip_ident(struct
> >> > v4l2_subdev
> >> 
> >> [snip]
> >> 
> >> >  static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> >> >  {
> >> > 
> >> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> > +   struct ov5642 *priv = to_ov5642(client);
> >> > 
> >> >     struct v4l2_rect *rect = &a->c;
> >> > 
> >> > -   a->type         = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >> > -   rect->top       = 0;
> >> > -   rect->left      = 0;
> >> > -   rect->width     = OV5642_WIDTH;
> >> > -   rect->height    = OV5642_HEIGHT;
> >> > +   a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >> 
> >> Shouldn't you return an error instead when a->type is not
> >> V4L2_BUF_TYPE_VIDEO_CAPTURE ?
> 
> No idea, but if you say so, I'll change it.

VIDIOC_G_FMT documentation states that

"When the requested buffer type is not supported drivers return an EINVAL 
error code."

I thought VIDIOC_G_CROP documentation did as well, but it doesn't. However I 
believe the above should apply to VIDIOC_G_CROP as well. There is no explicit 
documentation about error codes for subdev operations, but I think it makes 
sense to follow what the V4L2 ioctls do.

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52253 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1IEKHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 06:07:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2 v2] media: Add support for arbitrary resolution for the ov5642 camera driver
Date: Mon, 5 Sep 2011 12:07:41 +0200
Cc: Bastian Hecht <hechtb@googlemail.com>, linux-media@vger.kernel.org
References: <alpine.DEB.2.02.1108311420540.2154@ipanema> <201109051125.33829.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1109051130590.1112@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109051130590.1112@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051207.42195.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 05 September 2011 11:51:57 Guennadi Liakhovetski wrote:
> On Mon, 5 Sep 2011, Laurent Pinchart wrote:
> > On Monday 05 September 2011 11:10:48 Bastian Hecht wrote:
> > > 2011/8/31 Laurent Pinchart:
> > > > On Wednesday 31 August 2011 19:06:25 Laurent Pinchart wrote:
> > > >> On Wednesday 31 August 2011 17:05:52 Bastian Hecht wrote:
> > > >> > This patch adds the ability to get arbitrary resolutions with a
> > > >> > width up to 2592 and a height up to 720 pixels instead of the
> > > >> > standard 1280x720 only.
> > > >> > 
> > > >> > Signed-off-by: Bastian Hecht <hechtb@gmail.com>
> > > >> > ---
> > > >> > diff --git a/drivers/media/video/ov5642.c
> > > >> > b/drivers/media/video/ov5642.c index 6410bda..87b432e 100644
> > > >> > --- a/drivers/media/video/ov5642.c
> > > >> > +++ b/drivers/media/video/ov5642.c
> > > >> 
> > > >> [snip]
> > > >> 
> > > >> > @@ -684,107 +737,101 @@ static int ov5642_write_array(struct
> > > >> > i2c_client
> > > >> 
> > > >> [snip]
> > > >> 
> > > >> > -static int ov5642_s_fmt(struct v4l2_subdev *sd,
> > > >> > -                   struct v4l2_mbus_framefmt *mf)
> > > >> > +static int ov5642_s_fmt(struct v4l2_subdev *sd, struct
> > > >> > v4l2_mbus_framefmt *mf) {
> > > >> > 
> > > >> >     struct i2c_client *client = v4l2_get_subdevdata(sd);
> > > >> >     struct ov5642 *priv = to_ov5642(client);
> > > >> > 
> > > >> > -
> > > >> > -   dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
> > > >> > +   int ret;
> > > >> > 
> > > >> >     /* MIPI CSI could have changed the format, double-check */
> > > >> >     if (!ov5642_find_datafmt(mf->code))
> > > >> >     
> > > >> >             return -EINVAL;
> > > >> >     
> > > >> >     ov5642_try_fmt(sd, mf);
> > > >> > 
> > > >> > -
> > > >> > 
> > > >> >     priv->fmt = ov5642_find_datafmt(mf->code);
> > > >> > 
> > > >> > -   ov5642_write_array(client, ov5642_default_regs_init);
> > > >> > -   ov5642_set_resolution(client);
> > > >> > -   ov5642_write_array(client, ov5642_default_regs_finalise);
> > > >> > +   ret = ov5642_write_array(client, ov5642_default_regs_init);
> > > >> > +   if (!ret)
> > > >> > +           ret = ov5642_set_resolution(sd);
> > > >> > +   if (!ret)
> > > >> > +           ret = ov5642_write_array(client,
> > > >> > ov5642_default_regs_finalise);
> > > >> 
> > > >> You shouldn't write anything to the sensor here. As only .s_crop can
> > > >> currently change the format, .s_fmt should just return the current
> > > >> format without performing any change or writing anything to the
> > > >> device.
> > > 
> > > We talked about it in the ov5642 controls thread. I need to initialize
> > > the sensor at some point and it doesn't work to divide the calls
> > > between different locations.
> > 
> > Sure, but calling s_fmt isn't mandatory for hosts/bridges. What about
> > moving sensor initialization to s_stream() ?
> 
> Throughout the development of this driver, I was opposing the "delayed
> configuration" approach. I.e., the approach, in which all the ioctl()s,
> like S_FMT, S_CROP, etc. only store user values internally, and the actual
> hardware configuration is only performed at STREAMON time. There are
> several reasons to this: the spec says "the driver may program the
> hardware, allocate resources and generally prepare for data exchange"
> (yes, "may" != "must"), most drivers seem to do the same, the possibility
> to check and return any hardware errors, returned by this operation, I
> probably have forgotten something. But if we ignore all these reasons as
> insufficiently important, then yes, doing the actualy hardware
> configuration in .s_stream() brings a couple of advantages with it,
> especially for drivers / devices like this one.
> 
> So, if there are no strong objections, maybe indeed move this back to
> .s_stream() would be the better solution here.

I have no strong opinion here. Your points are certainly valid. I'm fine with 
performing direct hardware setup in .s_crop(), but doing it in .s_fmt() looks 
weird to me as .s_fmt() doesn't perform any operation now that the driver 
moved to using .s_crop(). Without delayed initialization I believe the device 
should be initialized when powered up, and have its crop rectangle altered in 
.s_crop().

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56836 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1IEJl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 05:41:29 -0400
Received: by gwaa12 with SMTP id a12so2745628gwa.19
        for <linux-media@vger.kernel.org>; Mon, 05 Sep 2011 02:41:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201109051125.33829.laurent.pinchart@ideasonboard.com>
References: <alpine.DEB.2.02.1108311420540.2154@ipanema>
	<201108311932.08252.laurent.pinchart@ideasonboard.com>
	<CABYn4sx25RbeKFDn8=cPuJETpornXW+osstrMEi9AjrtQAfSeA@mail.gmail.com>
	<201109051125.33829.laurent.pinchart@ideasonboard.com>
Date: Mon, 5 Sep 2011 09:41:28 +0000
Message-ID: <CABYn4sxJQsoCZXcVtKg9N+oJBgf42JSKe6YXV+fCCtY919Suaw@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] media: Add support for arbitrary resolution for
 the ov5642 camera driver
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/9/5 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Bastian,
>
> On Monday 05 September 2011 11:10:48 Bastian Hecht wrote:
>> 2011/8/31 Laurent Pinchart:
>> > Hi Bastian,
>> >
>> > Guennadi pointed out that "should" can sound a bit harsh, so please read
>> > my reviews as if
>> >
>> > #define "you should" "I think you should"
>>
>> I think that you think I should do the right thing. I removed out_sizes and
>> repost v3 in a moment :)
>
> Thanks :-)
>
>> > was prepended to all of them :-)
>> >
>> > On Wednesday 31 August 2011 19:06:25 Laurent Pinchart wrote:
>> >> On Wednesday 31 August 2011 17:05:52 Bastian Hecht wrote:
>> >> > This patch adds the ability to get arbitrary resolutions with a width
>> >> > up to 2592 and a height up to 720 pixels instead of the standard
>> >> > 1280x720 only.
>> >> >
>> >> > Signed-off-by: Bastian Hecht <hechtb@gmail.com>
>> >> > ---
>> >> > diff --git a/drivers/media/video/ov5642.c
>> >> > b/drivers/media/video/ov5642.c index 6410bda..87b432e 100644
>> >> > --- a/drivers/media/video/ov5642.c
>> >> > +++ b/drivers/media/video/ov5642.c
>> >>
>> >> [snip]
>> >>
>> >> > @@ -684,107 +737,101 @@ static int ov5642_write_array(struct
>> >> > i2c_client
>> >>
>> >> [snip]
>> >>
>> >> > -static int ov5642_s_fmt(struct v4l2_subdev *sd,
>> >> > - � � � � � � � � � struct v4l2_mbus_framefmt *mf)
>> >> > +static int ov5642_s_fmt(struct v4l2_subdev *sd, struct
>> >> > v4l2_mbus_framefmt *mf) {
>> >> >
>> >> > � � struct i2c_client *client = v4l2_get_subdevdata(sd);
>> >> > � � struct ov5642 *priv = to_ov5642(client);
>> >> >
>> >> > -
>> >> > - � dev_dbg(sd->v4l2_dev->dev, "%s(%u)\n", __func__, mf->code);
>> >> > + � int ret;
>> >> >
>> >> > � � /* MIPI CSI could have changed the format, double-check */
>> >> > � � if (!ov5642_find_datafmt(mf->code))
>> >> >
>> >> > � � � � � � return -EINVAL;
>> >> >
>> >> > � � ov5642_try_fmt(sd, mf);
>> >> >
>> >> > -
>> >> >
>> >> > � � priv->fmt = ov5642_find_datafmt(mf->code);
>> >> >
>> >> > - � ov5642_write_array(client, ov5642_default_regs_init);
>> >> > - � ov5642_set_resolution(client);
>> >> > - � ov5642_write_array(client, ov5642_default_regs_finalise);
>> >> > + � ret = ov5642_write_array(client, ov5642_default_regs_init);
>> >> > + � if (!ret)
>> >> > + � � � � � ret = ov5642_set_resolution(sd);
>> >> > + � if (!ret)
>> >> > + � � � � � ret = ov5642_write_array(client,
>> >> > ov5642_default_regs_finalise);
>> >>
>> >> You shouldn't write anything to the sensor here. As only .s_crop can
>> >> currently change the format, .s_fmt should just return the current
>> >> format without performing any change or writing anything to the device.
>>
>> We talked about it in the ov5642 controls thread. I need to initialize
>> the sensor at some point and it doesn't work to divide the calls
>> between different locations.
>
> Sure, but calling s_fmt isn't mandatory for hosts/bridges. What about moving
> sensor initialization to s_stream() ?
>
>> >> > - � return 0;
>> >> > + � return ret;
>> >> >
>> >> > �}
>> >>
>> >> [snip]
>> >>
>> >> > @@ -827,15 +874,42 @@ static int ov5642_g_chip_ident(struct
>> >> > v4l2_subdev
>> >>
>> >> [snip]
>> >>
>> >> > �static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>> >> > �{
>> >> >
>> >> > + � struct i2c_client *client = v4l2_get_subdevdata(sd);
>> >> > + � struct ov5642 *priv = to_ov5642(client);
>> >> >
>> >> > � � struct v4l2_rect *rect = &a->c;
>> >> >
>> >> > - � a->type � � � � = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> >> > - � rect->top � � � = 0;
>> >> > - � rect->left � � �= 0;
>> >> > - � rect->width � � = OV5642_WIDTH;
>> >> > - � rect->height � �= OV5642_HEIGHT;
>> >> > + � a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> >>
>> >> Shouldn't you return an error instead when a->type is not
>> >> V4L2_BUF_TYPE_VIDEO_CAPTURE ?
>>
>> No idea, but if you say so, I'll change it.
>
> VIDIOC_G_FMT documentation states that
>
> "When the requested buffer type is not supported drivers return an EINVAL
> error code."
>
> I thought VIDIOC_G_CROP documentation did as well, but it doesn't. However I
> believe the above should apply to VIDIOC_G_CROP as well. There is no explicit
> documentation about error codes for subdev operations, but I think it makes
> sense to follow what the V4L2 ioctls do.

And these ioctl calls go straight through to my driver? Or is there
some intermediate work by the subdev architecture? I'm asking because
I don't check the buffer type in g_fmt as well. If so, I have to
change that too.

best,

 Bastian

> --
> Regards,
>
> Laurent Pinchart
>

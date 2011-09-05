Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35740 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1IEJok (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2011 05:44:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bastian Hecht <hechtb@googlemail.com>
Subject: Re: [PATCH 1/2 v2] media: Add support for arbitrary resolution for the ov5642 camera driver
Date: Mon, 5 Sep 2011 11:45:19 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <alpine.DEB.2.02.1108311420540.2154@ipanema> <201109051125.33829.laurent.pinchart@ideasonboard.com> <CABYn4sxJQsoCZXcVtKg9N+oJBgf42JSKe6YXV+fCCtY919Suaw@mail.gmail.com>
In-Reply-To: <CABYn4sxJQsoCZXcVtKg9N+oJBgf42JSKe6YXV+fCCtY919Suaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109051145.19702.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bastian,

On Monday 05 September 2011 11:41:28 Bastian Hecht wrote:
> 2011/9/5 Laurent Pinchart:
> > On Monday 05 September 2011 11:10:48 Bastian Hecht wrote:
> >> 2011/8/31 Laurent Pinchart:
> >> >> >  static int ov5642_g_crop(struct v4l2_subdev *sd, struct v4l2_crop
> >> >> > *a) {
> >> >> > 
> >> >> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> >> > +   struct ov5642 *priv = to_ov5642(client);
> >> >> > 
> >> >> >     struct v4l2_rect *rect = &a->c;
> >> >> > 
> >> >> > -   a->type         = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >> >> > -   rect->top       = 0;
> >> >> > -   rect->left      = 0;
> >> >> > -   rect->width     = OV5642_WIDTH;
> >> >> > -   rect->height    = OV5642_HEIGHT;
> >> >> > +   a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> >> >> 
> >> >> Shouldn't you return an error instead when a->type is not
> >> >> V4L2_BUF_TYPE_VIDEO_CAPTURE ?
> >> 
> >> No idea, but if you say so, I'll change it.
> > 
> > VIDIOC_G_FMT documentation states that
> > 
> > "When the requested buffer type is not supported drivers return an EINVAL
> > error code."
> > 
> > I thought VIDIOC_G_CROP documentation did as well, but it doesn't.
> > However I believe the above should apply to VIDIOC_G_CROP as well. There
> > is no explicit documentation about error codes for subdev operations,
> > but I think it makes sense to follow what the V4L2 ioctls do.
> 
> And these ioctl calls go straight through to my driver? Or is there
> some intermediate work by the subdev architecture? I'm asking because
> I don't check the buffer type in g_fmt as well. If so, I have to
> change that too.

The ioctls go to the host/bridge driver, which then decides when and how to 
call g/s_fmt and g/s_crop. I would add the same check to g_fmt.

-- 
Regards,

Laurent Pinchart

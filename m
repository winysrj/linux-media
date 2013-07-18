Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3GRJ1e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 05:27:34 -0400
Date: Thu, 18 Jul 2013 11:27:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: phil.edworthy@renesas.com
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
In-Reply-To: <OFA3A542CD.036B9760-ON80257BAC.0030962D-80257BAC.00327F73@eu.necel.com>
Message-ID: <Pine.LNX.4.64.1307181120400.15796@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
 <OFA3A542CD.036B9760-ON80257BAC.0030962D-80257BAC.00327F73@eu.necel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phil

On Thu, 18 Jul 2013, phil.edworthy@renesas.com wrote:

> Hi Guennadi,
> 
> > > +{
> > > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > > +   struct ov10635_priv *priv = to_ov10635(client);
> > > +   struct v4l2_captureparm *cp = &parms->parm.capture;
> > > +   enum v4l2_mbus_pixelcode code;
> > > +   int ret;
> > > +
> > > +   if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > > +      return -EINVAL;
> > > +   if (cp->extendedmode != 0)
> > > +      return -EINVAL;
> > > +
> > > +   /* FIXME Check we can handle the requested framerate */
> > > +   priv->fps_denominator = cp->timeperframe.numerator;
> > > +   priv->fps_numerator = cp->timeperframe.denominator;
> > 
> > Yes, fixing this could be a good idea :) Just add one parameter to your 
> > set_params() and use NULL elsewhere.
> 
> There is one issue with setting the camera to achieve different framerate. 
> The camera can work at up to 60fps with lower resolutions, i.e. when 
> vertical sub-sampling is used. However, the API uses separate functions 
> for changing resolution and framerate. So, userspace could use a low 
> resolution, high framerate setting, then attempt to use a high resolution, 
> low framerate setting. Clearly, it's possible for userspace to call s_fmt 
> and s_parm in a way that attempts to set high resolution with the old 
> (high) framerate. In this case, a check for valid settings will fail.
> 
> Is this a generally known issue and userspace works round it?

It is generally known, that not all ioctl() settings can be combined, yes. 
E.g. a driver can support a range of cropping values and multiple formats, 
but not every format can be used with every cropping rectangle. So, if you 
first set a format and then an incompatible cropping or vice versa, one of 
ioctl()s will either fail or adjust parameters as close to the original 
request as possible. This has been discussed multiple times, ideas were 
expressed to create a recommended or even a compulsory ioctl() order, but 
I'm not sure how far this has come. I'm sure other developers on the list 
will have more info to this topic.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

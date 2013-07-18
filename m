Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:55422 "EHLO
	relmlor2.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3GRJLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 05:11:46 -0400
Received: from relmlir1.idc.renesas.com ([10.200.68.151])
 by relmlor2.idc.renesas.com ( SJSMS)
 with ESMTP id <0MQ400212K7K2E40@relmlor2.idc.renesas.com> for
 linux-media@vger.kernel.org; Thu, 18 Jul 2013 18:11:44 +0900 (JST)
Received: from relmlac4.idc.renesas.com ([10.200.69.24])
 by relmlir1.idc.renesas.com (SJSMS)
 with ESMTP id <0MQ400JLKK7K5460@relmlir1.idc.renesas.com> for
 linux-media@vger.kernel.org; Thu, 18 Jul 2013 18:11:44 +0900 (JST)
In-reply-to: <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
References: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
 <1370423495-16784-1-git-send-email-phil.edworthy@renesas.com>
 <Pine.LNX.4.64.1307141216310.9479@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Message-id: <OFA3A542CD.036B9760-ON80257BAC.0030962D-80257BAC.00327F73@eu.necel.com>
Date: Thu, 18 Jul 2013 10:11:34 +0100
Subject: Re: [PATCH v3] ov10635: Add OmniVision ov10635 SoC camera driver
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> > +{
> > +   struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +   struct ov10635_priv *priv = to_ov10635(client);
> > +   struct v4l2_captureparm *cp = &parms->parm.capture;
> > +   enum v4l2_mbus_pixelcode code;
> > +   int ret;
> > +
> > +   if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +      return -EINVAL;
> > +   if (cp->extendedmode != 0)
> > +      return -EINVAL;
> > +
> > +   /* FIXME Check we can handle the requested framerate */
> > +   priv->fps_denominator = cp->timeperframe.numerator;
> > +   priv->fps_numerator = cp->timeperframe.denominator;
> 
> Yes, fixing this could be a good idea :) Just add one parameter to your 
> set_params() and use NULL elsewhere.

There is one issue with setting the camera to achieve different framerate. 
The camera can work at up to 60fps with lower resolutions, i.e. when 
vertical sub-sampling is used. However, the API uses separate functions 
for changing resolution and framerate. So, userspace could use a low 
resolution, high framerate setting, then attempt to use a high resolution, 
low framerate setting. Clearly, it's possible for userspace to call s_fmt 
and s_parm in a way that attempts to set high resolution with the old 
(high) framerate. In this case, a check for valid settings will fail.

Is this a generally known issue and userspace works round it?

Thanks
Phil

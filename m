Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3833 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1GZJzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 05:55:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Migrate from soc_camera to v4l2
Date: Tue, 26 Jul 2011 11:55:04 +0200
Cc: Teresa Gamez <T.Gamez@phytec.de>, LBM <lbm9527@qq.com>,
	"linux-media" <linux-media@vger.kernel.org>
References: <tencent_0C81805C0261B60E5643A744@qq.com> <1310737039.2366.394.camel@lws-gamez> <Pine.LNX.4.64.1107151710220.22613@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107151710220.22613@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107261155.04639.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, July 15, 2011 17:31:13 Guennadi Liakhovetski wrote:
> Hello Teresa
> 
> On Fri, 15 Jul 2011, Teresa Gamez wrote:
> 
> > Hello Guennadi,
> > 
> > Am Mittwoch, den 13.07.2011, 09:14 +0200 schrieb Guennadi Liakhovetski:
> > > On Wed, 13 Jul 2011, LBM wrote:
> > > 
> > > > my dear Guennadi
> > > >      I'm wrong about that "v4l2-int-device",maybe it just "V4L2".  
> > > >        Now i have a board of OMAP3530 and a cmos camera MT9M111,so i want to get the image from the mt9m111.
> > > >  and ,I want to use the V4L2 API. But in the linux kernel 2.6.38,the driver of the mt9m111 is  a soc_camera.I see some thing about how to convert the soc_camera to V4L2,like "soc-camera: (partially) convert to v4l2-(sub)dev API".
> > > >       Can you tell me how to migrate from soc_camera to v4l2,and
> > > >      or do you tell me some experience about that?
> > > 
> > > Currently there's no standard way to make a driver to work with both 
> > > soc-camera and (pure) v4l2-subdev APIs. It is being worked on:
> > > 
> > > http://www.spinics.net/lists/linux-media/msg34878.html
> > > 
> > > and, hopefully, beginning with the next kernel version 3.1 it will become 
> > > at least theoretically possible. For now you just have to hack the driver 
> > > yourself for your local uses by removing all soc-camera specific code and 
> > > replacing it with your own glue, something along these lines:
> > 
> > We are also interested in the support of the MT9M111 and MT9V022 for OMAP-4460/OMAP-4430/OMAP-3525.
> > I have not taken a deeper look at it yet. But what do you mean by theoretically possible?
> 
> By this I mean, that most important APIs, required for a "proper" 
> conversion, suitable for the mainline, should be in place by then. 
> Although there still might be one thing, preventing this: controls. 
> Unfortunately, it looks like Hans haven't found the time yet to submit a 
> new version of his soc-camera conversion to the new v4l2 control 
> framework, and even if he did, it would be very difficult for me ATM to 
> find time to review, merge and push it.

This has been delayed by discussions on how to handle autogain/gain-like
controls (and my vacation as well). As soon as that has been resolved I can
continue with this.

A tree with a fairly up-to-date control conversion is here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/soc-camera

Missing is any support for the new control event, but that can wait until
the poll() changes are merged anyway.

> So, I'm not sure if it would be 
> possible to do a proper conversion without that, maybe not, then we'd 
> have to work on controls conversion too.

I'm pretty sure you need this.

Regards,

	Hans

> > Could it work out of the box? Or is there more work to do? 
> 
> No, first the APIs have to be made compatible, then individual drivers 
> have to be converted one by one.
> 
> Thanks
> Guennadi
> 
> > 
> > Regards,
> > Teresa
> > 
> > > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/11486/focus=11691
> > > 
> > > Thanks
> > > Guennadi
> > > ---
> > > Guennadi Liakhovetski, Ph.D.
> > > Freelance Open-Source Software Developer
> > > http://www.open-technology.de/
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

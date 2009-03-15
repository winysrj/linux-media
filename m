Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59590 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753903AbZCOUVl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 16:21:41 -0400
Date: Sun, 15 Mar 2009 21:21:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Jonathan Cameron <jic23@cam.ac.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	corbet@lwn.net
Subject: Re: RFC: ov7670 soc-camera driver
In-Reply-To: <200903152005.36265.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0903152112470.11969@axis700.grange>
References: <49BD3669.1070409@cam.ac.uk> <Pine.LNX.4.64.0903151948180.11969@axis700.grange>
 <200903152005.36265.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009, Hans Verkuil wrote:

> On Sunday 15 March 2009 19:50:39 Guennadi Liakhovetski wrote:
> > On Sun, 15 Mar 2009, Jonathan Cameron wrote:
> > > From: Jonathan Cameron <jic23@cam.ac.uk>
> > >
> > > OV7670 driver for soc-camera interfaces.
> >
> > Much appreciated, thanks!
> >
> > > ---
> > > There is already an ov7670 driver in tree, but it is very interface
> > > specific (olpc) and hence not much use for the crossbow IMB400 board
> > > which is plugged into an imote 2 pxa271 main board.

[snip]

> > > Clearly this driver shares considerable portions of code with
> > > Jonathan Corbet's driver (in tree). It would be complex to combine
> > > the two drivers, but perhaps people feel this would be worthwhile?
> >
> > Now, there we go... Hans, time for v4l2-device?...
> >
> > This means, I will look through the driver, but we should really think
> > properly whether to pull it in now, or "just" convert the OLPC driver and
> > soc-camera to v4l2-device and thus enable re-use.
> 
> I have already converted ov7670 to v4l2_subdev here:
> 
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-cafe2/
> 
> I'm waiting for test feedback (Hi Corbet!) before I'll merge it.
> 
> This situation is exactly why we need one single API for subdevices like 
> this. As soon as soc-camera is converted to v4l2-device it will just all 
> fall neatly into place.
> 
> I don't think it is a good idea to merge a second ov7670 driver as that's 
> exactly what we are trying to avoid. Migrating soc-camera to the 
> v4l2-device/v4l2-subdev framework is the right approach. Otherwise this 
> issue will just crop up time and again.
> 
> Although not good news for Jonathan, since his work will be delayed. 
> Jonathan, to get an idea what all of this is about you should read the 
> v4l2-framework.txt document in the master v4l-dvb repository 
> (linuxtv.org/hg/v4l-dvb). It will give you the background information on 
> the v4l2_subdev structure and associated API that we are migrating towards. 
> And soc-camera happens to a framework that hasn't been converted yet.

Well, I don't think Jonathan's work will be quite in vain - it will 
probably help having both drivers (soc-camera and v4l2-device) during the 
porting for comparison and feature exchange. But I agree, that it wouldn't 
be a right thing to merge this driver in the mainline now.

I am willing and planning to do (at least a part of) this conversion, the 
only problem is that I don't have much free (as in beer:-)) time for it, 
and so far I don't see anyone outside queuing to finance this work:-) In 
any case, looks like I'll have to pump up its priority and start working 
on it asap. I only have to review the next version of PXA DMA conversion 
patches, and then I'll declare a feature-freeze and just plunge into it. 
Once started it will be finished some time:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

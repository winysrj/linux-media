Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3DLGOl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 02:14:41 -0400
Date: Fri, 12 Apr 2013 08:13:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v8 0/7] V4L2 clock and async patches and soc-camera
 example
In-Reply-To: <516715FA.8000901@gmail.com>
Message-ID: <Pine.LNX.4.64.1304120733030.1727@axis700.grange>
References: <1365433538-15975-1-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1304111156400.23859@axis700.grange> <516715FA.8000901@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Thu, 11 Apr 2013, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 04/11/2013 11:59 AM, Guennadi Liakhovetski wrote:
> > Hi all
> > 
> > On Mon, 8 Apr 2013, Guennadi Liakhovetski wrote:
> > 
> > > >  Mostly just a re-spin of v7 with minor modifications.
> > > >
> > > >  Guennadi Liakhovetski (7):
> > > >     media: V4L2: add temporary clock helpers
> > > >     media: V4L2: support asynchronous subdevice registration
> > > >     media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
> > > >     soc-camera: add V4L2-async support
> > > >     sh_mobile_ceu_camera: add asynchronous subdevice probing support
> > > >     imx074: support asynchronous probing
> > > >     ARM: shmobile: convert ap4evb to asynchronously register camera
> > > >       subdevices
> > 
> > So far there haven't been any comments to this, and Mauro asked to push
> > all non-fixes to him by tomorrow. So, if at least the API is now ok, we
> > could push this to 3.10, at least the core patches 1 and 2. Then during
> > 3.10 we could look at porting individual drivers on top of this.
> 
> This patch series has significantly improved over time but I'm not sure
> it is all ready to merge it at this moment. At least it doesn't make sense
> to me to merge it without any users.

I wouldn't be too scared to also push my soc-camera patches from the same 
patch-series. But our V4L2 OF patches don't have many users so far either, 
right? And they aren't likely to get any until asynchronous probing is 
supported.

> The purpose of an introduction of this whole asynchronous probing concept
> was to add support for the device tree based systems. However there is no
> patch in this series that would be adding device tree support to some V4L2
> driver. That's a minor issue though I think.

It is indeed. And I did have such patches in the past, but I dropped them 
on purpose for now. It was too much work to update them all for each 
iteration, so, I picked up a testable minimum.

> A significant blocking point IMHO is that this API is bound to the circular
> dependency issue between a sub-device and the host driver. I think we should
> have at least some specific ideas on how to resolve it before pushing the
> API upstream. Or are there any already ?

Of course there is at least one. I wouldn't propose (soc-camera) patches, 
that lock modules hard into memory, once probing is complete.

> One of the ideas I had was to make a sub-device driver drop the reference
> it has to the clock provider module (the host) as soon as it gets registered
> to it. But it doesn't seem straightforward with the common clock API.

It isn't.

> Other option is a sysfs attribute at a host driver that would allow to
> release its sub-device(s). But it sounds a bit strange to me to require
> userspace to touch some sysfs attributes before being able to remove some
> modules.
> 
> Something probably needs to be changed at the high level design to avoid
> this circular dependency.

Here's what I do in my soc-camera patches atm: holding a reference to a 
(V4L2) clock doesn't increment bridge driver's use-count (for this 
discussion I describe the combined soc-camera host and soc-camera core 
functionality as a bridge driver, because that's what most non soc-camera 
drivers will look like). So, it can be unloaded. Once unloaded, it 
unregisters its V4L2 async notifier. Inside that the v4l2-async framework 
first detaches the subdevice driver, then calls the notifier's .unbind() 
method, which should now unregister the clock. Then, back in 
v4l2_async_notifier_unregister() the subdevice driver is re-probed, this 
time with no clock available, so, it re-enters the deferred probing state.

BTW, a bit of self-advertisement: most soc-camera host drivers will hardly 
need any modifications to support asynchronous subdevice probing. It's all 
hidden in the soc-camera core. The sh-mobile CEU driver had to be modified 
because it supports one more subdevice - a CSI-2 interface.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

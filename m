Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47145 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2JJMxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 08:53:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Wed, 10 Oct 2012 14:54 +0200
Message-ID: <1744244.z7BseID5vc@avalon>
In-Reply-To: <Pine.LNX.4.64.1210081306240.12203@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <201210051323.45571.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210081306240.12203@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 08 October 2012 14:23:25 Guennadi Liakhovetski wrote:
> On Fri, 5 Oct 2012, Hans Verkuil wrote:
> 
> [snip]
> 
> > I think the soc_camera patches should be left out for now. I suspect that
> > by adding core support for async i2c handling first,
> 
> Ok, let's think, what this meacs - async I2C in media / V4L2 core.
> 
> The main reason for our probing order problem is the master clock,
> typically supplied from the camera bridge to I2C subdevices, which we only
> want to start when necessary, i.e. when accessing the subdevice. And the
> subdevice driver needs that clock running during its .probe() to be able
> to access and verify or configure the hardware. Our current solution is to
> not register I2C subdevices from the platform data, as is usual for all
> I2C devices, but from the bridge driver and only after it has switched on
> the master clock. After the subdevice driver has completed its probing we
> switch the clock back off until the subdevice has to be activated, e.g.
> for video capture.
> 
> Also important - when we want to unregister the bridge driver we just also
> unregister the I2C device.
> 
> Now, to reverse the whole thing and to allow I2C devices be registered as
> usual - via platform data or OF, first of all we have to teach I2C
> subdevice drivers to recognise the "too early" situation and request
> deferred probing in such a case. Then it will be reprobed after each new
> successful probe or unregister on the system. After the bridge driver has
> successfully probed the subdevice driver will be re-probed and at that
> time it should succeed. Now, there is a problem here too: who should
> switch on and off the master clock?
> 
> If we do it from the bridge driver, we could install an I2C bus-notifier,
> _before_ the subdevice driver is probed, i.e. upon the
> BUS_NOTIFY_BIND_DRIVER event we could turn on the clock. If subdevice
> probing was successful, we can then wait for the BUS_NOTIFY_BOUND_DRIVER
> event to switch the clock back off. BUT - if the subdevice fails probing?
> How do we find out about that and turn the clock back off? There is no
> notification event for that... Possible solutions:
> 
> 1. timer - ugly and unreliable.
> 2. add a "probing failed" notifier event to the device core - would this
>    be accepted?
> 3. let the subdevice turn the master clock on and off for the duration of
>    probing.
> 
> My vote goes for (3). Ideally this should be done using the generic clock
> framework. But can we really expect all drivers and platforms to switch to
> it quickly enough? If not, we need a V4L2-specific callback from subdevice
> drivers to bridge drivers to turn the clock on and off. That's what I've
> done "temporarily" in this patch series for soc-camera.

I vote for (3) as well, using the generic clock framework. You're right that 
we need an interim solution, as not all platforms will switch quickly enough. 
I'm fine with that interim solution being a bit hackish, as long as we push 
new drivers towards the right solution.

> Suppose we decide to do the same for V4L2 centrally - add call-backs. Then
> we can think what else we need to add to V4L2 to support asynchronous
> subdevice driver probing.
> 
> 1. We'll have to create these V4L2 clock start and stop functions, that,
> supplied (in case of I2C) with client address and adapter number will find
> the correct v4l2_device instance and call its callbacks.
> 
> 2. The I2C notifier. I'm not sure, whether this one should be common. Of
> common tasks we have to refcount the I2C adapter and register the
> subdevice. Then we'd have to call the bridge driver's callback. Is it
> worth it doing this centrally or rather allow individual drivers to do
> that themselves?

What about going through board code for platforms that don't support the 
generic clock framework yet ? That's what the OMAP3 ISP driver does. DT 
support would then require the generic clock framework.

> Also, ideally OF-compatible (I2C) drivers should run with no platform
> data, but soc-camera is using I2C device platform data intensively. To
> avoid modifying the soc-camera core and all drivers, I also trigger on the
> BUS_NOTIFY_BIND_DRIVER event and assign a reference to the dynamically
> created platform data to the I2C device. Would we also want to do this for
> all V4L2 bridge drivers? We could call this a "prepare" callback or
> something similar...

If that's going to be an interim solution only I'm fine with keeping it in 
soc-camera.

> 3. Bridge driver unregistering. Here we have to put the subdevice driver
> back into the deferred-probe state... Ugliness alert: I'm doing this by
> unregistering and re-registering the I2C device... For that I also have to
> create a copy of devices I2C board-info data. Lovely, ain't it? This I'd
> be happy to move to the V4L2 core;-)

That's the ugly part. As soon as the I2C device starts using resources 
provided by the bridge, those resources can't disappear behind the scene. 
Reference counting must ensure that the bridge driver doesn't get removed. And 
that's where it gets bad: the bridge uses resources provided by the I2C 
driver, through the subdev operations. This creates circular dependencies that 
we need to break somehow. I currently have no solution for that problem.

-- 
Regards,

Laurent Pinchart


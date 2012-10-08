Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55590 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JHObE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 10:31:04 -0400
Date: Mon, 8 Oct 2012 16:30:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
In-Reply-To: <201210081548.11207.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1210081619200.14454@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <201210051323.45571.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210081306240.12203@axis700.grange>
 <201210081548.11207.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 8 Oct 2012, Hans Verkuil wrote:

> On Mon October 8 2012 14:23:25 Guennadi Liakhovetski wrote:
> > Hi Hans
> > 
> > On Fri, 5 Oct 2012, Hans Verkuil wrote:
> > 
> > [snip]
> > 
> > > I think the soc_camera patches should be left out for now. I suspect that
> > > by adding core support for async i2c handling first,
> > 
> > Ok, let's think, what this meacs - async I2C in media / V4L2 core.
> > 
> > The main reason for our probing order problem is the master clock, 
> > typically supplied from the camera bridge to I2C subdevices, which we only 
> > want to start when necessary, i.e. when accessing the subdevice. And the 
> > subdevice driver needs that clock running during its .probe() to be able 
> > to access and verify or configure the hardware. Our current solution is to 
> > not register I2C subdevices from the platform data, as is usual for all 
> > I2C devices, but from the bridge driver and only after it has switched on 
> > the master clock. After the subdevice driver has completed its probing we 
> > switch the clock back off until the subdevice has to be activated, e.g. 
> > for video capture.
> > 
> > Also important - when we want to unregister the bridge driver we just also 
> > unregister the I2C device.
> > 
> > Now, to reverse the whole thing and to allow I2C devices be registered as 
> > usual - via platform data or OF, first of all we have to teach I2C 
> > subdevice drivers to recognise the "too early" situation and request 
> > deferred probing in such a case. Then it will be reprobed after each new 
> > successful probe or unregister on the system. After the bridge driver has 
> > successfully probed the subdevice driver will be re-probed and at that 
> > time it should succeed. Now, there is a problem here too: who should 
> > switch on and off the master clock?
> > 
> > If we do it from the bridge driver, we could install an I2C bus-notifier, 
> > _before_ the subdevice driver is probed, i.e. upon the 
> > BUS_NOTIFY_BIND_DRIVER event we could turn on the clock. If subdevice 
> > probing was successful, we can then wait for the BUS_NOTIFY_BOUND_DRIVER 
> > event to switch the clock back off. BUT - if the subdevice fails probing? 
> > How do we find out about that and turn the clock back off? There is no 
> > notification event for that... Possible solutions:
> > 
> > 1. timer - ugly and unreliable.
> > 2. add a "probing failed" notifier event to the device core - would this 
> >    be accepted?
> > 3. let the subdevice turn the master clock on and off for the duration of 
> >    probing.
> > 
> > My vote goes for (3). Ideally this should be done using the generic clock 
> > framework. But can we really expect all drivers and platforms to switch to 
> > it quickly enough? If not, we need a V4L2-specific callback from subdevice 
> > drivers to bridge drivers to turn the clock on and off. That's what I've 
> > done "temporarily" in this patch series for soc-camera.
> > 
> > Suppose we decide to do the same for V4L2 centrally - add call-backs. Then 
> > we can think what else we need to add to V4L2 to support asynchronous 
> > subdevice driver probing.
> 
> I wonder, don't we have the necessary code already? V4L2 subdev drivers can
> have internal_ops with register/unregister ops. These are called by
> v4l2_device_register_subdev. This happens during the bridge driver's probe.
> 
> Suppose the subdev's probe does not actually access the i2c device, but
> instead defers that to the register callback? The bridge driver will turn on
> the clock before calling v4l2_device_register_subdev to ensure that the
> register callback can access the i2c registers. The register callback will
> do any initialization and can return an error. In case of an error the i2c
> client is automatically unregistered as well.

Yes, if v4l2_i2c_new_subdev_board() is used. This has been discussed 
several times before and always what I didn't like in this is, that I2C 
device probe() in this case succeeds without even trying to access the 
hardware. And think about DT. In this case we don't instantiate the I2C 
device, OF code does it for us. What do you do then? If you let probe() 
succeed, then you will have to somehow remember the subdevice to later 
match it against bridges...

> In addition, during the register op the subdev driver can call into the
> bridge driver since it knows the v4l2_device struct.
> 
> This has also the advantage that subdev drivers can change to this model
> gradually. Only drivers that need master clocks, etc. need to move any probe
> code that actually accesses hardware to the register op. Others can remain
> as. Nor should this change behavior of existing drivers as this happens
> all in the V4L2 core.
> 
> The bridge driver may still have to wait until all i2c drivers are loaded,
> though. But that can definitely be handled centrally (i.e.: 'I need these
> drivers, wait until all are loaded').
> 
> > 1. We'll have to create these V4L2 clock start and stop functions, that, 
> > supplied (in case of I2C) with client address and adapter number will find 
> > the correct v4l2_device instance and call its callbacks.
> > 
> > 2. The I2C notifier. I'm not sure, whether this one should be common. Of 
> > common tasks we have to refcount the I2C adapter and register the 
> > subdevice. Then we'd have to call the bridge driver's callback. Is it 
> > worth it doing this centrally or rather allow individual drivers to do 
> > that themselves?
> > 
> > Also, ideally OF-compatible (I2C) drivers should run with no platform 
> > data, but soc-camera is using I2C device platform data intensively. To 
> > avoid modifying the soc-camera core and all drivers, I also trigger on the 
> > BUS_NOTIFY_BIND_DRIVER event and assign a reference to the dynamically 
> > created platform data to the I2C device. Would we also want to do this for 
> > all V4L2 bridge drivers? We could call this a "prepare" callback or 
> > something similar...
> 
> Well, subdev drivers should either parse the OF data, or use the platform_data.
> The way soc_camera uses platform_data is one reason why it is so hard to
> reuse subdevs for non-soc_camera drivers. All the callbacks in soc_camera_link
> should be replaced by calls to the v4l2_device notify() callback. After that we
> can see what is needed to drop struct soc_camera_link altogether as platform_data.

They don't have to be, they are not (or should not be) called by 
subdevices.

> > 3. Bridge driver unregistering. Here we have to put the subdevice driver 
> > back into the deferred-probe state... Ugliness alert: I'm doing this by 
> > unregistering and re-registering the I2C device... For that I also have to 
> > create a copy of devices I2C board-info data. Lovely, ain't it? This I'd 
> > be happy to move to the V4L2 core;-)
> 
> By just using the unregister ops this should be greatly simplified as well.

Sorry, which unregister ops do you mean? internal_ops->unregistered()? 
Yes, but only if we somehow go your way and use dummy probe() methods...

Thanks
Guennadi

> Unless I am missing something, which is perfectly possible :-)
> 
> Regards,
> 
> 	Hans
> 
> > Thanks
> > Guennadi
> > 
> > > the soc_camera patches
> > > will become a lot easier to understand.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

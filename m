Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46924 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2JJNLX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:11:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Wed, 10 Oct 2012 15:12:07 +0200
Message-ID: <2383203.Zfjf4t4omf@avalon>
In-Reply-To: <201210081653.55984.hverkuil@xs4all.nl>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1210081619200.14454@axis700.grange> <201210081653.55984.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 08 October 2012 16:53:55 Hans Verkuil wrote:
> On Mon October 8 2012 16:30:53 Guennadi Liakhovetski wrote:
> > On Mon, 8 Oct 2012, Hans Verkuil wrote:
> > > On Mon October 8 2012 14:23:25 Guennadi Liakhovetski wrote:
> > > > On Fri, 5 Oct 2012, Hans Verkuil wrote:
> > > > 
> > > > [snip]
> > > > 
> > > > > I think the soc_camera patches should be left out for now. I suspect
> > > > > that by adding core support for async i2c handling first,
> > > > 
> > > > Ok, let's think, what this meacs - async I2C in media / V4L2 core.
> > > > 
> > > > The main reason for our probing order problem is the master clock,
> > > > typically supplied from the camera bridge to I2C subdevices, which we
> > > > only want to start when necessary, i.e. when accessing the subdevice.
> > > > And the subdevice driver needs that clock running during its .probe()
> > > > to be able to access and verify or configure the hardware. Our current
> > > > solution is to not register I2C subdevices from the platform data, as
> > > > is usual for all I2C devices, but from the bridge driver and only
> > > > after it has switched on the master clock. After the subdevice driver
> > > > has completed its probing we switch the clock back off until the
> > > > subdevice has to be activated, e.g. for video capture.
> > > > 
> > > > Also important - when we want to unregister the bridge driver we just
> > > > also> unregister the I2C device.
> > > > 
> > > > Now, to reverse the whole thing and to allow I2C devices be registered
> > > > as usual - via platform data or OF, first of all we have to teach I2C
> > > > subdevice drivers to recognise the "too early" situation and request
> > > > deferred probing in such a case. Then it will be reprobed after each
> > > > new successful probe or unregister on the system. After the bridge
> > > > driver has successfully probed the subdevice driver will be re-probed
> > > > and at that time it should succeed. Now, there is a problem here too:
> > > > who should switch on and off the master clock?
> > > > 
> > > > If we do it from the bridge driver, we could install an I2C bus-
> > > > notifier, _before_ the subdevice driver is probed, i.e. upon the
> > > > BUS_NOTIFY_BIND_DRIVER event we could turn on the clock. If subdevice
> > > > probing was successful, we can then wait for the
> > > > BUS_NOTIFY_BOUND_DRIVER event to switch the clock back off. BUT - if
> > > > the subdevice fails probing?
> > > > How do we find out about that and turn the clock back off? There is no
> > > > notification event for that... Possible solutions:
> > > > 
> > > > 1. timer - ugly and unreliable.
> > > > 2. add a "probing failed" notifier event to the device core - would
> > > > this be accepted?
> > > > 3. let the subdevice turn the master clock on and off for the duration
> > > > of probing.
> > > > 
> > > > My vote goes for (3). Ideally this should be done using the generic
> > > > clock framework. But can we really expect all drivers and platforms to
> > > > switch to it quickly enough? If not, we need a V4L2-specific callback
> > > > from subdevice drivers to bridge drivers to turn the clock on and off.
> > > > That's what I've done "temporarily" in this patch series for soc-
> > > > camera.
> > > > 
> > > > Suppose we decide to do the same for V4L2 centrally - add call-backs.
> > > > Then we can think what else we need to add to V4L2 to support
> > > > asynchronous subdevice driver probing.
> > > 
> > > I wonder, don't we have the necessary code already? V4L2 subdev drivers
> > > can have internal_ops with register/unregister ops. These are called by
> > > v4l2_device_register_subdev. This happens during the bridge driver's
> > > probe.
> > > 
> > > Suppose the subdev's probe does not actually access the i2c device, but
> > > instead defers that to the register callback? The bridge driver will
> > > turn on the clock before calling v4l2_device_register_subdev to ensure
> > > that the register callback can access the i2c registers. The register
> > > callback will do any initialization and can return an error. In case of
> > > an error the i2c client is automatically unregistered as well.
> > 
> > Yes, if v4l2_i2c_new_subdev_board() is used. This has been discussed
> > several times before and always what I didn't like in this is, that I2C
> > device probe() in this case succeeds without even trying to access the
> > hardware. And think about DT. In this case we don't instantiate the I2C
> > device, OF code does it for us. What do you do then? If you let probe()
> > succeed, then you will have to somehow remember the subdevice to later
> > match it against bridges...
> 
> Yes, but you need that information anyway. The bridge still needs to call
> v4l2_device_register_subdev so it needs to know which subdevs are loaded.
> And can't it get that from DT as well?

That information will definitely come from the DT, but the bridge won't 
instantiate the I2C devices. They will be instantiated asynchronously by the 
I2C bus master driver when parsing the DT. The bridge will then need to be 
notified or I2C devices registration and finish its initialization when all 
needed I2C (or SPI, ...) devices will be available. That should in my opinion 
be handled by the V4L2 core : the bridge would pass a list of devices 
(possibly DT nodes) to a V4L2 core function along with a callback, and the 
callback would be called when all required devices are available.

I've also thought about adding a synchronous function that would wait until 
all required devices are available, but I'm not sure whether that's a good 
idea.

> In my view you cannot do a proper initialization unless you have both the
> bridge driver and all subdev drivers loaded and instantiated.

You can do a proper initialization of the bridge device. The OMAP3 ISP could 
already be used for mem-to-mem operation for instance.

> They need one another. So I am perfectly fine with letting the probe
> function do next to nothing and postponing that until register() is called.

I don't really like that solution, it's an abuse of the probe() function. It 
would be much better to defer probing of the I2C device until all the needed 
resources (such as clocks) are available. That would also mean that the I2C 
device won't be able to access the bridge directly during probing, which could 
actually be seen as a feature : with proper abstractions in place (such as 
generic clock objects) accessing the bridge at probe() time should not be 
needed.

> I2C and actual probing to check if it's the right device is a bad idea in
> general since you have no idea what a hardware access to an unknown i2c
> device will do. There are still some corner cases where that is needed, but
> I do not think that that is an issue here.
> 
> It would simplify things a lot IMHO. Also note that the register() op will
> work with any device, not just i2c. That may be a useful property as well.
> 
> > > In addition, during the register op the subdev driver can call into the
> > > bridge driver since it knows the v4l2_device struct.
> > > 
> > > This has also the advantage that subdev drivers can change to this model
> > > gradually. Only drivers that need master clocks, etc. need to move any
> > > probe code that actually accesses hardware to the register op. Others
> > > can remain as. Nor should this change behavior of existing drivers as
> > > this happens all in the V4L2 core.
> > > 
> > > The bridge driver may still have to wait until all i2c drivers are
> > > loaded, though. But that can definitely be handled centrally (i.e.: 'I
> > > need these drivers, wait until all are loaded').
> > > 
> > > > 1. We'll have to create these V4L2 clock start and stop functions,
> > > > that, supplied (in case of I2C) with client address and adapter number
> > > > will find the correct v4l2_device instance and call its callbacks.
> > > > 
> > > > 2. The I2C notifier. I'm not sure, whether this one should be common.
> > > > Of common tasks we have to refcount the I2C adapter and register the
> > > > subdevice. Then we'd have to call the bridge driver's callback. Is it
> > > > worth it doing this centrally or rather allow individual drivers to do
> > > > that themselves?
> > > > 
> > > > Also, ideally OF-compatible (I2C) drivers should run with no platform
> > > > data, but soc-camera is using I2C device platform data intensively. To
> > > > avoid modifying the soc-camera core and all drivers, I also trigger on
> > > > the BUS_NOTIFY_BIND_DRIVER event and assign a reference to the
> > > > dynamically created platform data to the I2C device. Would we also
> > > > want to do this for all V4L2 bridge drivers? We could call this a
> > > > "prepare" callback or something similar...
> > > 
> > > Well, subdev drivers should either parse the OF data, or use the
> > > platform_data. The way soc_camera uses platform_data is one reason why
> > > it is so hard to reuse subdevs for non-soc_camera drivers. All the
> > > callbacks in soc_camera_link should be replaced by calls to the
> > > v4l2_device notify() callback. After that we can see what is needed to
> > > drop struct soc_camera_link altogether as platform_data.
> > 
> > They don't have to be, they are not (or should not be) called by
> > subdevices.
> 
> Then why are those callbacks in a struct that subdevs can access? I always
> have a hard time with soc_camera figuring out who is using what when :-(
> 
> > > > 3. Bridge driver unregistering. Here we have to put the subdevice
> > > > driver back into the deferred-probe state... Ugliness alert: I'm doing
> > > > this by unregistering and re-registering the I2C device... For that I
> > > > also have to create a copy of devices I2C board-info data. Lovely,
> > > > isn't it? This I'd be happy to move to the V4L2 core;-)
> > > 
> > > By just using the unregister ops this should be greatly simplified as
> > > well.
> > 
> > Sorry, which unregister ops do you mean? internal_ops->unregistered()?
> 
> Yes.
> 
> > Yes, but only if we somehow go your way and use dummy probe() methods...
> 
> Of course.

-- 
Regards,

Laurent Pinchart


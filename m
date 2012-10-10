Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57332 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2JJNR6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 09:17:58 -0400
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
Date: Wed, 10 Oct 2012 15:18:41 +0200
Message-ID: <2002286.8sbBLyKbDe@avalon>
In-Reply-To: <Pine.LNX.4.64.1210081708240.14454@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <201210081653.55984.hverkuil@xs4all.nl> <Pine.LNX.4.64.1210081708240.14454@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 08 October 2012 17:15:53 Guennadi Liakhovetski wrote:
> On Mon, 8 Oct 2012, Hans Verkuil wrote:
> > On Mon October 8 2012 16:30:53 Guennadi Liakhovetski wrote:
> > > On Mon, 8 Oct 2012, Hans Verkuil wrote:
> > > > On Mon October 8 2012 14:23:25 Guennadi Liakhovetski wrote:
> > > > > On Fri, 5 Oct 2012, Hans Verkuil wrote:
> > > > > 
> > > > > [snip]
> > > > > 
> > > > > > I think the soc_camera patches should be left out for now. I
> > > > > > suspect that by adding core support for async i2c handling first,
> > > > > 
> > > > > Ok, let's think, what this meacs - async I2C in media / V4L2 core.
> > > > > 
> > > > > The main reason for our probing order problem is the master clock,
> > > > > typically supplied from the camera bridge to I2C subdevices, which
> > > > > we only want to start when necessary, i.e. when accessing the
> > > > > subdevice. And the subdevice driver needs that clock running during
> > > > > its .probe() to be able to access and verify or configure the
> > > > > hardware. Our current solution is to not register I2C subdevices
> > > > > from the platform data, as is usual for all I2C devices, but from
> > > > > the bridge driver and only after it has switched on the master
> > > > > clock. After the subdevice driver has completed its probing we
> > > > > switch the clock back off until the subdevice has to be activated,
> > > > > e.g. for video capture.
> > > > > 
> > > > > Also important - when we want to unregister the bridge driver we
> > > > > just also unregister the I2C device.
> > > > > 
> > > > > Now, to reverse the whole thing and to allow I2C devices be
> > > > > registered as usual - via platform data or OF, first of all we have
> > > > > to teach I2C subdevice drivers to recognise the "too early"
> > > > > situation and request deferred probing in such a case. Then it will
> > > > > be reprobed after each new successful probe or unregister on the
> > > > > system. After the bridge driver has successfully probed the
> > > > > subdevice driver will be re-probed and at that time it should
> > > > > succeed. Now, there is a problem here too: who should switch on and
> > > > > off the master clock?
> > > > > 
> > > > > If we do it from the bridge driver, we could install an I2C
> > > > > bus-notifier, _before_ the subdevice driver is probed, i.e. upon the
> > > > > BUS_NOTIFY_BIND_DRIVER event we could turn on the clock. If
> > > > > subdevice probing was successful, we can then wait for the
> > > > > BUS_NOTIFY_BOUND_DRIVER event to switch the clock back off. BUT - if
> > > > > the subdevice fails probing?
> > > > > How do we find out about that and turn the clock back off? There is
> > > > > no notification event for that... Possible solutions:
> > > > > 
> > > > > 1. timer - ugly and unreliable.
> > > > > 2. add a "probing failed" notifier event to the device core - would
> > > > > this be accepted?
> > > > > 3. let the subdevice turn the master clock on and off for the
> > > > > duration of probing.
> > > > > 
> > > > > My vote goes for (3). Ideally this should be done using the generic
> > > > > clock framework. But can we really expect all drivers and platforms
> > > > > to switch to it quickly enough? If not, we need a V4L2-specific
> > > > > callback from subdevice drivers to bridge drivers to turn the clock
> > > > > on and off. That's what I've done "temporarily" in this patch series
> > > > > for soc-camera.
> > > > > 
> > > > > Suppose we decide to do the same for V4L2 centrally - add
> > > > > call-backs. Then we can think what else we need to add to V4L2 to
> > > > > support asynchronous subdevice driver probing.
> > > > 
> > > > I wonder, don't we have the necessary code already? V4L2 subdev
> > > > drivers can have internal_ops with register/unregister ops. These are
> > > > called by v4l2_device_register_subdev. This happens during the bridge
> > > > driver's probe.
> > > > 
> > > > Suppose the subdev's probe does not actually access the i2c device,
> > > > but instead defers that to the register callback? The bridge driver
> > > > will turn on the clock before calling v4l2_device_register_subdev to
> > > > ensure that the register callback can access the i2c registers. The
> > > > register callback will do any initialization and can return an error.
> > > > In case of an error the i2c client is automatically unregistered as
> > > > well.
> > > 
> > > Yes, if v4l2_i2c_new_subdev_board() is used. This has been discussed
> > > several times before and always what I didn't like in this is, that I2C
> > > device probe() in this case succeeds without even trying to access the
> > > hardware. And think about DT. In this case we don't instantiate the I2C
> > > device, OF code does it for us. What do you do then? If you let probe()
> > > succeed, then you will have to somehow remember the subdevice to later
> > > match it against bridges...
> > 
> > Yes, but you need that information anyway. The bridge still needs to call
> > v4l2_device_register_subdev so it needs to know which subdevs are loaded.
> 
> But how do you get the subdev pointer? With the notifier I get it from
> i2c_get_clientdata(client) and what do you do without it? How do you get
> to the client?
> 
> > And can't it get that from DT as well?
> 
> No, I don't think there is a way to get a device pointer from a DT node.

But we'll need a way. The bridge driver will get sensor DT nodes from the V4L2 
DT bindings, and will need to get the corresponding subdev. This could be 
limited to V4L2 though, we could keep a map of DT nodes to subdevs without 
requiring a generic solution in the device base code (although I'm wondering 
if there's a specific reason not to have a device pointer in the DT node 
structure).

> > In my view you cannot do a proper initialization unless you have both the
> > bridge driver and all subdev drivers loaded and instantiated. They need
> > one another. So I am perfectly fine with letting the probe function do
> > next to nothing and postponing that until register() is called. I2C and
> > actualprobing to check if it's the right device is a bad idea in general
> > since you have no idea what a hardware access to an unknown i2c device
> > will do. There are still some corner cases where that is needed, but I do
> > not think that that is an issue here.
> > 
> > It would simplify things a lot IMHO. Also note that the register() op will
> > work with any device, not just i2c. That may be a useful property as well.
> 
> And what if the subdevice device is not yet instantiated by OF by the time
> your bridge driver probes?

-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32853 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761860Ab2KAPM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2012 11:12:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/2] media: V4L2: support asynchronous subdevice registration
Date: Thu, 01 Nov 2012 16:13:20 +0100
Message-ID: <1710313.9IGrY1RFHv@avalon>
In-Reply-To: <201210221536.03112.hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <Pine.LNX.4.64.1210221421020.26216@axis700.grange> <201210221536.03112.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 22 October 2012 15:36:03 Hans Verkuil wrote:
> On Mon October 22 2012 14:50:14 Guennadi Liakhovetski wrote:
> > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > > On Mon October 22 2012 13:08:12 Guennadi Liakhovetski wrote:
> > > > On Mon, 22 Oct 2012, Hans Verkuil wrote:
> > > > > On Sat October 20 2012 00:20:24 Guennadi Liakhovetski wrote:
> > > > > > Currently bridge device drivers register devices for all
> > > > > > subdevices synchronously, tupically, during their probing. E.g. if
> > > > > > an I2C CMOS sensor is attached to a video bridge device, the
> > > > > > bridge driver will create an I2C device and wait for the
> > > > > > respective I2C driver to probe. This makes linking of devices
> > > > > > straight forward, but this approach cannot be used with
> > > > > > intrinsically asynchronous and unordered device registration
> > > > > > systems like the Flattened Device Tree. To support such systems
> > > > > > this patch adds an asynchronous subdevice registration framework
> > > > > > to V4L2. To use it respective (e.g. I2C) subdevice drivers must
> > > > > > request deferred probing as long as their bridge driver hasn't
> > > > > > probed. The bridge driver during its probing submits a an
> > > > > > arbitrary number of subdevice descriptor groups to the framework
> > > > > > to manage. After that it can add callbacks to each of those groups
> > > > > > to be called at various stages during subdevice probing, e.g.
> > > > > > after completion. Then the bridge driver can request single groups
> > > > > > to be probed, finish its own probing and continue its video
> > > > > > subsystem configuration from its callbacks.

[snip]

> > > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > > ---
> > > > > > 
> > > > > > One more thing to note about this patch. Subdevice drivers,
> > > > > > supporting asynchronous probing, and using this framework, need a
> > > > > > unified way to detect, whether their probing should succeed or
> > > > > > they should request deferred probing. I implement this using
> > > > > > device platform data. This means, that all subdevice drivers,
> > > > > > wishing to use this API will have to use the same platform data
> > > > > > struct. I don't think this is a major inconvenience, but if we
> > > > > > decide against this, we'll have to add a V4L2 function to verify
> > > > > > "are you ready for me or not." The latter would be inconvenient,
> > > > > > because then we would have to look through all registered
> > > > > > subdevice descriptor groups for this specific subdevice.
> > > > > 
> > > > > I have to admit that I don't quite follow this. I guess I would need
> > > > > to see this being used in an actual driver.
> > > > 
> > > > The issue is simple: subdevice drivers have to recognise, when it's
> > > > still too early to probe and return -EPROBE_DEFER. If you have a
> > > > sensor, whose master clock is supplied from an external oscillator.
> > > > You load its driver, it will happily get a clock reference and find no
> > > > reason to fail probe(). It will initialise its subdevice and return
> > > > from probing. Then, when your bridge driver probes, it will have no
> > > > way to find that subdevice.

This is where I fundamentally disagree. You're right that the subdev driver 
would have no reason to fail probe(). So why would it ? If the subdev driver 
can succeed probe(), it should. -EPROBE_DEFER should only be returned if one 
of the resources required by the subdev isn't available, such as a GPIO, clock 
or regulator for instance. When all resources required to make the subdev 
usable are present, probe() should simply succeed.

This implies that you can pass the subdev platform data directly to the 
subdev, either through the platform data pointer or through DT. Passing subdev 
platform data through the host/bridge is a hack. Removing it should, in my 
opinion, be one of the goals of this patch.

This will leave us with the problem of locating the subdev from the host in 
the notification callback. I had envision a different approach than yours to 
fix the problem: similarly to your v4l2-clk service, I propose to make subdev 
drivers registering themselves to the V4L2 core. Instead of using I2C and 
platform bus notifiers you would then have a single internal notifier 
(possibly based on a subdev bus notifier if that makes sense) that would 
support both hot-plug notification (notify drivers when a new subdev is 
registered with the core) and cold-plug notification (go through the 
registered subdevs list when a new async group (or whatever replaces the async 
groups if we get rid of multiple groups) is registered.

> > > This problem is specific to platform subdev drivers, right? Since for
> > > i2c subdevs you can use i2c_get_clientdata().
> > 
> > But how do you get the client? With DT you can follow our "remote"
> > phandle, and without DT?
> 
> You would need a i2c_find_client() function for that. I would like to see
> some more opinions about this.
> 
> > > I wonder whether it isn't a better idea to have platform_data embed a
> > > standard struct containing a v4l2_subdev pointer. Subdevs can use
> > > container_of to get from the address of that struct to the full
> > > platform_data, and you don't have that extra dereference (i.e. a
> > > pointer to the new struct which has a pointer to the actual
> > > platform_data). The impact of that change is much smaller for existing
> > > subdevs.
> > 
> > This standard platform data object is allocated by the bridge driver, so,
> > it will not know where it is embedded in the subdevice specific platform
> > data.
> 
> It should. The platform_data is specific to the subdev, so whoever is
> allocating the platform_data has to know the size and contents of the
> struct. Normally this structure is part of the board code for embedded
> systems.
> 
> That soc-camera doesn't do this is a major soc-camera design flaw.
> Soc-camera should not force the platform_data contents for subdev drivers.

That's something I tried to fix some time ago. Part of my cleanup patches went 
to mainline but I haven't had time to finish the implementation. Guennadi and 
I were planning to work on this topic together at ELC-E, if time permits.

This being said, part of the information supplied through platform data, such 
as lists of regulators, could be extracted to a standard V4L2 platform data 
structure embedded in the driver-specific platform data. That could be useful 
to provide helper functions, such as handling power on/off sequences.

> > > And if it isn't necessary for i2c subdev drivers, then I think we should
> > > do this only for platform drivers.
> > 
> > See above, and I don't think we should implement 2 different methods.
> > Besides, the change is very small. You anyway have to adapt sensor drivers
> > to return -EPROBE_DEFER. This takes 2 lines of code:
> > 
> > +	if (!client->dev.platform_data)
> > +		return -EPROBE_DEFER;
> > 
> > If the driver isn't using platform data, that's it. If it is, you add two
> > more lines:
> > 
> > -	struct my_platform_data *pdata = client->dev.platform_data;
> > +	struct v4l2_subdev_platform_data *sdpd = client->dev.platform_data;
> > +	struct my_platform_data *pdata = sdpd->platform_data;
> > 
> > That's it. Of course, you have to do this everywhere, where the driver
> > dereferences client->dev.platform_data, but even that shouldn't be too
> > difficult.
> 
> I'd like to see other people's opinions on this as well. I do think I prefer
> embedding it (in most if not all cases such a standard struct would be at
> the beginning of the platform_data).

As explained above, embedding a standard V4L2 platform data structure (if we 
decide to create one) in the driver-specific platform data has my preference 
as well.

> > > That said, how does this new framework take care of timeouts if one of
> > > the subdevs is never bound?
> > 
> > It doesn't.
> > 
> > > You don't want to have this wait indefinitely, I think.
> > 
> > There's no waiting:-) The bridge and other subdev drivers just remain
> > loaded and inactive.
> 
> Is that what we want? I definitely would like to get other people's opinions
> on this.
> 
> For the record: while it is waiting, can you safely rmmod the module?
> Looking at the code I think you can, but I'm not 100% certain.

I'd like to propose a two layers approach. The lower layer would provide 
direct notifications of subdev availability to host/bridge drivers. It could 
be used directly, or an upper helper layer could handle the notifications and 
provide a single complete callback when all requested subdevs are available.

Implementing a timeout-based instead of completetion callback-based upper 
layer shouldn't be difficult, but I'm not sure whether it's a good approach. I 
think the host/bridge driver should complete its probe(), registering all the 
resources it provides (such as clocks that can be used by sensors), even if 
not all connected subdevs are available. The device nodes would only be 
created later when all required subdevs are available (depending on the driver 
some device nodes could be created right-away, to allow mem-to-mem operation 
for instance).

-- 
Regards,

Laurent Pinchart


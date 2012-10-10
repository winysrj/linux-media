Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60316 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2JJPPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 11:15:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 05/14] media: add a V4L2 OF parser
Date: Wed, 10 Oct 2012 17:15:49 +0200
Message-ID: <2383216.ATDgiWr0QW@avalon>
In-Reply-To: <20121010115703.7a72fdd1@redhat.com>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <1909082.6p5inUAuOH@avalon> <20121010115703.7a72fdd1@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 10 October 2012 11:57:03 Mauro Carvalho Chehab wrote:
> Em Wed, 10 Oct 2012 16:48 +0200 Laurent Pinchart escreveu:
> > On Wednesday 10 October 2012 10:45:22 Mauro Carvalho Chehab wrote:
> > > Em Wed, 10 Oct 2012 14:54 +0200 Laurent Pinchart escreveu:
> > > > > Also, ideally OF-compatible (I2C) drivers should run with no
> > > > > platform data, but soc-camera is using I2C device platform data
> > > > > intensively. To avoid modifying the soc-camera core and all drivers,
> > > > > I also trigger on the BUS_NOTIFY_BIND_DRIVER event and assign a
> > > > > reference to the dynamically created platform data to the I2C
> > > > > device. Would we also want to do this for all V4L2 bridge drivers?
> > > > > We could call this a "prepare" callback or something similar...
> > > > 
> > > > If that's going to be an interim solution only I'm fine with keeping
> > > > it in soc-camera.
> > > 
> > > I'm far from being an OF expert, but why do we need to export I2C
> > > devices to DT/OF? On my understanding, it is the bridge code that
> > > should be responsible for detecting, binding and initializing the proper
> > > I2C devices. On several cases, it is impossible or it would cause lots
> > > of ugly hacks if we ever try to move away from platform data stuff, as
> > > only the bridge driver knows what initialization is needed for an
> > > specific I2C driver.
> > 
> > In a nutshell, a DT-based platform doesn't have any board code (except in
> > rare cases, but let's not get into that), and thus doesn't pass any
> > platform data structure to drivers. However, drivers receive a DT node,
> > which contains a hierarchical description of the hardware, and parse
> > those to extract information necessary to configure the device.
> > 
> > One very important point to keep in mind here is that the DT is not Linux-
> > specific. DT bindings are designed to be portable, and thus must only
> > contain hardware descriptions, without any OS-specific information or
> > policy information. For instance information such as the maximum video
> > buffers size is not allowed in the DT.
> > 
> > The DT is used both to provide platform data to drivers and to instantiate
> > devices. I2C device DT nodes are stored as children of the I2C bus master
> > DT node, and are automatically instantiated by the I2C bus master. This
> > is a significant change compared to our current situation where the V4L2
> > bridge driver receives an array of I2C board information structures and
> > instatiates the devices itself. Most of the DT support work will go in
> > supporting that new instantiation mechanism. The bridge driver doesn't
> > control instantiation of the I2C devices anymore, but need to bind with
> > them at runtime.
> > 
> > > To make things more complex, it is expected that most I2C drivers to be
> > > arch independent, and they should be allowed to be used by a personal
> > > computer or by an embedded device.
> > 
> > Agreed. That's why platform data structures won't go away anytime soon, a
> > PCI bridge driver for hardware that contain I2C devices will still
> > instantiate the I2C devices itself. We don't plan to or even want to get
> > rid of that mechanism, as there are perfectly valid use cases. However,
> > for DT-based embedded platforms, we need to support a new instantiation
> > mechanism.
> >
> > > Let me give 2 such examples:
> > > 	- ir-i2c-kbd driver supports lots of IR devices. Platform_data is
> > > 	needed
> > > 
> > > to specify what hardware will actually be used, and what should be the
> > > default Remote Controller keymap;
> > 
> > That driver isn't used on embedded platforms so it doesn't need to be
> > changed now.
> > 
> > > 	- Sensor drivers like ov2940 is needed by soc_camera and by other
> > > 
> > > webcam drivers like em28xx. The setup for em28xx should be completely
> > > different than the one for soc_camera: the initial registers init
> > > sequence
> > > is different for both. As several registers there aren't properly
> > > documented, there's no easy way to parametrize the configuration.
> > 
> > Such drivers will need to support both DT-based platform data and
> > structure- based platform data. They will likely parse the DT node and
> > fill a platform data structure, to avoid duplicating initialization code.
> > 
> > Please note that the new subdevs instantiation mechanism needed for DT
> > will need to handle any instantiation order, as we can't guarantee the I2C
> > device and bridge device instantiation order with DT. It should thus then
> > support the current instantiation order we use for PCI and USB platforms.
> > 
> > > So, for me, we should not expose the I2C devices directly on OF; it
> > > should,
> > > instead, see just the bridge, and let the bridge to map the needed I2C
> > > devices using the needed platform_data.
> > 
> > We can't do that, there will be no platform data anymore with DT-based
> > platforms.
> > 
> > As a summary, platform data structures won't go away, I2C drivers that
> > need to work both on DT-based and non-DT-based platforms will need to
> > support both the DT and platform data structures to get platform data.
> > PCI and USB bridges will still instantiate their I2C devices, and binding
> > between the I2C devices and the bridge can either be handled with two
> > different instantiation mechanisms (the new one for DT platforms, with
> > runtime bindings, and the existing one for non-DT platforms, with binding
> > at instantiation time) or move to a single runtime binding mechanism.
> > It's too early to know which solution will be simpler.
> 
> It seems that you're designing a Frankstein monster with DT/OF and I2C.
> 
> Increasing each I2C driver code to support both platform_data and DT way
> of doing things seems a huge amount of code that will be added, and I really
> fail to understand why this is needed, in the first place.
> 
> Ok, I understand that OF specs are OS-independent, but I suspect that
> they don't dictate how things should be wired internally at the OS.
> 
> So, if DT/OF is so restrictive, and require its own way of doing things,
> instead of changing everything with the risks of adding (more) regressions
> to platform drivers, why don't just create a shell driver that will
> encapsulate DT/OF specific stuff into the platform_data?

DT support requires two independent parts, DT-based probing and device 
instantiation changes.

To support DT probing existing I2C drivers (and only the drivers that need to 
support DT-enabled platforms, we don't have to modify any I2C driver used on 
non-DT platforms only) will need to add a function that parses a DT node to 
fill a platform data structure, and a new OF match table pointer in their 
struct device.

For instance here's what the OMAP I2C bus master does in its probe function:

        match = of_match_device(of_match_ptr(omap_i2c_of_match), &pdev->dev);
        if (match) {
                u32 freq = 100000; /* default to 100000 Hz */

                pdata = match->data;
                dev->dtrev = pdata->rev;
                dev->flags = pdata->flags;

                of_property_read_u32(node, "clock-frequency", &freq);
                /* convert DT freq value in Hz into kHz for speed */
                dev->speed = freq / 1000;
        } else if (pdata != NULL) {
                dev->speed = pdata->clkrate;
                dev->flags = pdata->flags;
                dev->set_mpu_wkup_lat = pdata->set_mpu_wkup_lat;
                dev->dtrev = pdata->rev;
        }

Before DT support only the second branch of the if was there. The above code 
could be rewritten as

	if (DT enabled)
		fill_pdata_from_dt(pdata, DT node);

	Rest of normal pdata-based initialization code here

with the first branch of the if in the fill_pdata_from_dt() function.

It's really not a big deal in my opinion, and creating a new wrapper for that 
would just be overkill.

The device instantiation issue, discusses in this mail thread, is a more 
complex problem for which we need a solution, but isn't related to platform 
data.

-- 
Regards,

Laurent Pinchart


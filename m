Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36393 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2JJOrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 10:47:17 -0400
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
Date: Wed, 10 Oct 2012 16:48 +0200
Message-ID: <1909082.6p5inUAuOH@avalon>
In-Reply-To: <20121010104522.53dabe5e@redhat.com>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de> <1744244.z7BseID5vc@avalon> <20121010104522.53dabe5e@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 10 October 2012 10:45:22 Mauro Carvalho Chehab wrote:
> Em Wed, 10 Oct 2012 14:54 +0200 Laurent Pinchart escreveu:
> > > Also, ideally OF-compatible (I2C) drivers should run with no platform
> > > data, but soc-camera is using I2C device platform data intensively. To
> > > avoid modifying the soc-camera core and all drivers, I also trigger on
> > > the
> > > BUS_NOTIFY_BIND_DRIVER event and assign a reference to the dynamically
> > > created platform data to the I2C device. Would we also want to do this
> > > for
> > > all V4L2 bridge drivers? We could call this a "prepare" callback or
> > > something similar...
> > 
> > If that's going to be an interim solution only I'm fine with keeping it in
> > soc-camera.
> 
> I'm far from being an OF expert, but why do we need to export I2C devices to
> DT/OF? On my understanding, it is the bridge code that should be
> responsible for detecting, binding and initializing the proper I2C devices.
> On several cases, it is impossible or it would cause lots of ugly hacks if
> we ever try to move away from platform data stuff, as only the bridge
> driver knows what initialization is needed for an specific I2C driver.

In a nutshell, a DT-based platform doesn't have any board code (except in rare 
cases, but let's not get into that), and thus doesn't pass any platform data 
structure to drivers. However, drivers receive a DT node, which contains a 
hierarchical description of the hardware, and parse those to extract 
information necessary to configure the device.

One very important point to keep in mind here is that the DT is not Linux-
specific. DT bindings are designed to be portable, and thus must only contain 
hardware descriptions, without any OS-specific information or policy 
information. For instance information such as the maximum video buffers size 
is not allowed in the DT.

The DT is used both to provide platform data to drivers and to instantiate 
devices. I2C device DT nodes are stored as children of the I2C bus master DT 
node, and are automatically instantiated by the I2C bus master. This is a 
significant change compared to our current situation where the V4L2 bridge 
driver receives an array of I2C board information structures and instatiates 
the devices itself. Most of the DT support work will go in supporting that new 
instantiation mechanism. The bridge driver doesn't control instantiation of 
the I2C devices anymore, but need to bind with them at runtime.

> To make things more complex, it is expected that most I2C drivers to be arch
> independent, and they should be allowed to be used by a personal computer
> or by an embedded device.

Agreed. That's why platform data structures won't go away anytime soon, a PCI 
bridge driver for hardware that contain I2C devices will still instantiate the 
I2C devices itself. We don't plan to or even want to get rid of that 
mechanism, as there are perfectly valid use cases. However, for DT-based 
embedded platforms, we need to support a new instantiation mechanism.

> Let me give 2 such examples:
> 
> 	- ir-i2c-kbd driver supports lots of IR devices. Platform_data is needed
> to specify what hardware will actually be used, and what should be the
> default Remote Controller keymap;

That driver isn't used on embedded platforms so it doesn't need to be changed 
now.

> 	- Sensor drivers like ov2940 is needed by soc_camera and by other
> webcam drivers like em28xx. The setup for em28xx should be completely
> different than the one for soc_camera: the initial registers init sequence
> is different for both. As several registers there aren't properly
> documented, there's no easy way to parametrize the configuration.

Such drivers will need to support both DT-based platform data and structure-
based platform data. They will likely parse the DT node and fill a platform 
data structure, to avoid duplicating initialization code.

Please note that the new subdevs instantiation mechanism needed for DT will 
need to handle any instantiation order, as we can't guarantee the I2C device 
and bridge device instantiation order with DT. It should thus then support the 
current instantiation order we use for PCI and USB platforms.

> So, for me, we should not expose the I2C devices directly on OF; it should,
> instead, see just the bridge, and let the bridge to map the needed I2C
> devices using the needed platform_data.

We can't do that, there will be no platform data anymore with DT-based 
platforms.

As a summary, platform data structures won't go away, I2C drivers that need to 
work both on DT-based and non-DT-based platforms will need to support both the 
DT and platform data structures to get platform data. PCI and USB bridges will 
still instantiate their I2C devices, and binding between the I2C devices and 
the bridge can either be handled with two different instantiation mechanisms 
(the new one for DT platforms, with runtime bindings, and the existing one for 
non-DT platforms, with binding at instantiation time) or move to a single 
runtime binding mechanism. It's too early to know which solution will be 
simpler.

-- 
Regards,

Laurent Pinchart


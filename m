Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53271 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbaCTSsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Mar 2014 14:48:22 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so1007093eek.30
        for <linux-media@vger.kernel.org>; Thu, 20 Mar 2014 11:48:21 -0700 (PDT)
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from drivers/media/v4l2-core to drivers/of
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <20140320153804.35d5b835@samsung.com>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de> < 20140226110114.CF2C7C40A89@trevor.secretlab.ca> <531D916C.2010903@ti.com> < 5427810.BUKJ3iUXnO@avalon> <20140312102556.GC21483@n2100.arm.linux.org.uk> <20140320175432.0559CC4067A@trevor.secretlab.ca> <20140320153804.35d5b835@ samsung.com>
Date: Thu, 20 Mar 2014 18:48:16 +0000
Message-Id: <20140320184816.7AB02C4067A@trevor.secretlab.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 20 Mar 2014 15:38:04 -0300, Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:
> Em Thu, 20 Mar 2014 17:54:31 +0000
> Grant Likely <grant.likely@linaro.org> escreveu:
> 
> > On Wed, 12 Mar 2014 10:25:56 +0000, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > On Mon, Mar 10, 2014 at 02:52:53PM +0100, Laurent Pinchart wrote:
> > > > In theory unidirectional links in DT are indeed enough. However, let's not 
> > > > forget the following.
> > > > 
> > > > - There's no such thing as single start points for graphs. Sure, in some 
> > > > simple cases the graph will have a single start point, but that's not a 
> > > > generic rule. For instance the camera graphs 
> > > > http://ideasonboard.org/media/omap3isp.ps and 
> > > > http://ideasonboard.org/media/eyecam.ps have two camera sensors, and thus two 
> > > > starting points from a data flow point of view.
> > > 
> > > I think we need to stop thinking of a graph linked in terms of data
> > > flow - that's really not useful.
> > > 
> > > Consider a display subsystem.  The CRTC is the primary interface for
> > > the CPU - this is the "most interesting" interface, it's the interface
> > > which provides access to the picture to be displayed for the CPU.  Other
> > > interfaces are secondary to that purpose - reading the I2C DDC bus for
> > > the display information is all secondary to the primary purpose of
> > > displaying a picture.
> > > 
> > > For a capture subsystem, the primary interface for the CPU is the frame
> > > grabber (whether it be an already encoded frame or not.)  The sensor
> > > devices are all secondary to that.
> > > 
> > > So, the primary software interface in each case is where the data for
> > > the primary purpose is transferred.  This is the point at which these
> > > graphs should commence since this is where we would normally start
> > > enumeration of the secondary interfaces.
> > > 
> > > V4L2 even provides interfaces for this: you open the capture device,
> > > which then allows you to enumerate the capture device's inputs, and
> > > this in turn allows you to enumerate their properties.  You don't open
> > > a particular sensor and work back up the tree.
> > > 
> > > I believe trying to do this according to the flow of data is just wrong.
> > > You should always describe things from the primary device for the CPU
> > > towards the peripheral devices and never the opposite direction.
> > 
> > Agreed.
> 
> I don't agree, as what's the primary device is relative. 
> 
> Actually, in the case of a media data flow, the CPU is generally not
> the primary device.
> 
> Even on general purpose computers, if the full data flow is taken into
> the account, the CPU is a mere device that will just be used to copy
> data either to GPU and speakers or to disk, eventually doing format
> conversions, when the hardware is cheap and don't provide format
> converters.
> 
> On more complex devices, like the ones we want to solve with the
> media controller, like an embedded hardware like a TV or a STB, the CPU
> is just an ancillary component that could even hang without stopping 
> TV reception, as the data flow can be fully done inside the chipset.

We're talking about wiring up device drivers here, not data flow. Yes, I
completely understand that data flow is often not even remotely
cpu-centric. However, device drivers are, and the kernel needs to know
the dependency graph for choosing what devices depend on other devices.

g.


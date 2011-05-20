Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36548 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935587Ab1ETKMX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 06:12:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev
 =?iso-8859-1?q?registration=09function?=
Date: Fri, 20 May 2011 12:12:23 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	michael.jones@matrix-vision.de
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com> <201105201137.25556.laurent.pinchart@ideasonboard.com> <201105201152.17414.hansverk@cisco.com>
In-Reply-To: <201105201152.17414.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201212.24046.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Friday 20 May 2011 11:52:17 Hans Verkuil wrote:
> On Friday, May 20, 2011 11:37:24 Laurent Pinchart wrote:
> > On Friday 20 May 2011 11:19:48 Hans Verkuil wrote:
> > > On Friday, May 20, 2011 11:05:00 Laurent Pinchart wrote:

[snip]

> > > > My idea was to use bus notifiers to delay the bridge/host device
> > > > initialization. The bridge probe() function would pre-initialize the
> > > > bridge and register notifiers. The driver would then wait until all
> > > > subdevs are properly registered, and then proceed from to register
> > > > V4L2 devices from the bus notifier callback (or possible a work
> > > > queue). There would be no nested probe() calls.
> > > 
> > > Would it be an option to create a new platform bus for the subdevs?
> > > That would have its own lock. It makes sense from a hierarchical point
> > > of view, but I'm not certain about the amount of work involved.
> > 
> > Do you mean a subdev-platform bus for platform subdevs, or a V4L2 subdev
> > bus for all subdevs ? The first option is possible, but it looks more
> > like a hack to me. If the subdev really is a platform device, it should be
> > handled by the platform bus.
> 
> The first. So you have a 'top-level' platform device that wants to load
> platform subdevs (probably representing internal IP blocks). So it would
> create its own platform bus that is used to probe those platform subdevs.
> 
> It is similar to e.g. an I2C device that has internal I2C busses: you would
> also create nested busses there.
> 
> BTW, why do these platform subdevs have to be on the platform bus? Why not
> have standalone subdev drivers that are not on any bus? That's for example
> what ivtv does for the internal GPIO audio subdev.

There's some misunderstanging here. Internal IP blocks don't need to sit on 
any bus. The host/bridge driver can create subdevs for those blocks directly, 
as it doesn't need to load a separate driver.

The issue comes from external subdevs that offer little control or even none 
at all. The best example is an FPGA that will feed video data to the bridge in 
a fixed format without any mean of control, or with just an on/off control 
through a GPIO. Support for such subdevices need to be handled by a separate 
driver, so we need a way to load it at runtime. I'm not sure on what bus that 
driver should sit.

> > I don't think the second option is possible, I2C and SPI subdevs need to
> > sit on an I2C or SPI bus (I could be mistaken though, there's at least
> > one example of a logical bus type in the kernel with the HID bus).
> > 
> > Let's also not forget about sub-sub-devices. We need to handle them at
> > some point as well.
> 
> Sub-sub-devices are not a problem by themselves. They are only a problem if
> they on the same bus.
> 
> > This being said, I think that the use of platform devices to solve the
> > initial problem can also be considered a hack as well. What we really need
> > is a way to handle subdevs that can't be controlled at all (a video source
> > that continuously delivers data for instance), or that can be controlled
> > through GPIO. What bus should we use for a bus-less subdev ? And for
> > GPIO-based subdevs, should we create a GPIO bus ?
> 
> It is perfectly possible to have bus-less subdevs. See ivtv (I think there
> are one or two other examples as well).

But how can we handle bus-less subdevs for embedded devices, where the host 
(e.g. OMAP3 ISP) doesn't know about the external subdevs (e.g. FPGA controlled 
by a couple of GPIOs) ?

-- 
Regards,

Laurent Pinchart

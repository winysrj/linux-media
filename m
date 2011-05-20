Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56623 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab1ETQDF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 12:03:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev
 =?iso-8859-1?q?registration=09function?=
Date: Fri, 20 May 2011 18:03:07 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	michael.jones@matrix-vision.de
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com> <201105200929.33226.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1105201455270.17254@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105201455270.17254@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201803.08185.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Friday 20 May 2011 15:08:00 Guennadi Liakhovetski wrote:
> On Fri, 20 May 2011, Laurent Pinchart wrote:
> > On Friday 20 May 2011 09:14:36 Sylwester Nawrocki wrote:
> [snip]
> 
> > > I had an issue when tried to call request_module, to register subdev of
> > > platform device type, in probe() of other platform device. Driver's
> > > probe() for devices belonging same bus type cannot be nested as the bus
> > > lock is taken by the driver core before entering probe(), so this would
> > > lead to a deadlock.
> > > That exactly happens in __driver_attach().
> > > 
> > > For the same reason v4l2_new_subdev_board could not be called from
> > > probe() of devices belonging to I2C or SPI bus, as request_module is
> > > called inside of it. I'm not sure how to solve it, yet:)
> > 
> > Ouch. I wasn't aware of that issue. Looks like it's indeed time to fix
> > the subdev registration issue, including the module load race condition.
> > Michael, you said you have a patch to add platform subdev support, how
> > have you avoided the race condition ?
> > 
> > I've been thinking for some time now about removing the module load code
> > completely. I2C, SPI and platform subdevs would be registered either by
> > board code (possibly through the device tree on platforms that suppport
> > it) for embedded platforms, and by host drivers for pluggable hardware
> > (PCI and USB). Module loading would be handled automatically by the
> > kernel module auto loader, but asynchronously instead of synchronously.
> > Bus notifiers would then be used by host drivers to wait for all subdevs
> > to be registered.
> 
> Sorry, I'm probably missing something. The reason for this module loading
> was, that you cannot probe i2c sensors before the host is initialised and
> has turned the master clock on.

Only when the subdev clock is provided by the host. And worse than that, when 
clock configuration needs to go through board code, you often need to wait 
until the host has registered the subdev before the board code can be 
executed. That's why many subdev drivers only initialize a couple of 
structures in their probe() function, and don't access the hardware until the 
registered() callback is called.

> If you want to go back to the traditional platform-based I2C device
> registration, you'll have to wait in your sensor (subdev) probe function for
> host registration, which wouldn't be a good thing to do, IMHO.

Waiting for host initialization in the subdev probe function is definitely not 
a good option.

There are various dependencies between the host and the subdevs. The host 
can't obviously proceed before all subdevs are ready, and subdevs often depend 
on the host to provide clocks and power. Initializing the host first, making 
the host register the subdev devices and waiting synchronously for them to be 
initialized is the option we went for. Unfortunately this brings several 
issues, such as deadlocks when the host and the subdevs sit on the same bus.

Another option I'm proposing is to let Linux load modules and initialize 
devices without interfering with that. Host drivers would be notified that all 
subdevs are ready through bus notifiers, and subdev drivers would be notified 
that they can access host resources through the registered callback. This 
splits initialization in two parts.

I'm of course open to other options.

> > I'm not sure yet if this approach is viable. Hans, I think we've briefly
> > discussed this (possible quite a long time ago), do you have any opinion
> > ? Guennadi, based on your previous experience trying to use bus
> > notifiers to solve the module load race, what do you think about the
> > idea ? Others, please comment as well :-)

-- 
Regards,

Laurent Pinchart

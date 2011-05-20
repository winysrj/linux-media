Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:17222 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935461Ab1ETJTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 05:19:54 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev
 =?iso-8859-1?q?registration=09function?=
Date: Fri, 20 May 2011 11:19:48 +0200
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	michael.jones@matrix-vision.de
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com> <201105201053.33002.hansverk@cisco.com> <201105201105.02082.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105201105.02082.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105201119.48346.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, May 20, 2011 11:05:00 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Friday 20 May 2011 10:53:32 Hans Verkuil wrote:
> > On Friday, May 20, 2011 09:29:32 Laurent Pinchart wrote:
> > > On Friday 20 May 2011 09:14:36 Sylwester Nawrocki wrote:
> > > > On 05/19/2011 08:34 PM, Laurent Pinchart wrote:
> > > > > The new v4l2_new_subdev_board() function creates and register a
> > > > > subdev based on generic board information. The board information
> > > > > structure includes a bus type and bus type-specific information.
> > > > > 
> > > > > Only I2C and SPI busses are currently supported.
> > > > > 
> > > > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> [snip]
> 
> > > > I had an issue when tried to call request_module, to register subdev 
of
> > > > platform device type, in probe() of other platform device. Driver's
> > > > probe() for devices belonging same bus type cannot be nested as the 
bus
> > > > lock is taken by the driver core before entering probe(), so this 
would
> > > > lead to a deadlock.
> > > > That exactly happens in __driver_attach().
> > > > 
> > > > For the same reason v4l2_new_subdev_board could not be called from
> > > > probe() of devices belonging to I2C or SPI bus, as request_module is
> > > > called inside of it. I'm not sure how to solve it, yet:)
> > > 
> > > Ouch. I wasn't aware of that issue. Looks like it's indeed time to fix
> > > the subdev registration issue, including the module load race condition.
> > > Michael, you said you have a patch to add platform subdev support, how
> > > have you avoided the race condition ?
> > > 
> > > I've been thinking for some time now about removing the module load code
> > > completely. I2C, SPI and platform subdevs would be registered either by
> > > board code (possibly through the device tree on platforms that suppport
> > > it) for embedded platforms, and by host drivers for pluggable hardware
> > > (PCI and USB). Module loading would be handled automatically by the 
kernel
> > > module auto loader, but asynchronously instead of synchronously. Bus
> > > notifiers would then be used by host drivers to wait for all subdevs to 
be
> > > registered.
> > > 
> > > I'm not sure yet if this approach is viable. Hans, I think we've briefly
> > > discussed this (possible quite a long time ago), do you have any opinion
> > > ? Guennadi, based on your previous experience trying to use bus 
notifiers
> > > to solve the module load race, what do you think about the idea ? 
Others,
> > > please comment as well :-)
> > 
> > It's definitely viable (I believe the required bus notification has been
> > added some time ago), but I am not sure how to implement it in an
> > efficient manner.
> > 
> > My initial idea would be to just wait in v4l2_new_subdev_board until you
> > get the notification on the bus (with a timeout, of course). However, I
> > suspect that that does not solve the deadlock, although it would solve the
> > race.
> > 
> > As an aside: note that if the module is unloaded right after the
> > request_module, then that will be detected by the code and it will just
> > return an error. It won't oops or anything like that. Personally I don't
> > believe it is worth the effort just to solve this race, since it is highly
> > theoretical.
> > 
> > The problem of loading another bus module when in a bus probe function is 
a
> > separate issue. My initial reaction is: why do you want to do this? Even 
if
> > you use delayed module loads, you probably still have to wait for them to
> > succeed at a higher-level function. For example: in the probe function of
> > module A it will attempt to load module B. That probably can't succeed as
> > long as you are in A's probe function due to the bus lock. So you can't
> > check for a successful load of B until you return from that probe function
> > and a higher- level function (that likely loaded module A in the first
> > place) does that check.
> > 
> > That's all pretty tricky code, and my suggestion would be to simply not do
> > nested module loads from the same bus.
> 
> That's unfortunately not an option. Most bridge/host devices in embedded 
> systems are platform devices, and they will need to load platform subdevs. 
We 
> need to fix that.

Good point.

> My idea was to use bus notifiers to delay the bridge/host device 
> initialization. The bridge probe() function would pre-initialize the bridge 
> and register notifiers. The driver would then wait until all subdevs are 
> properly registered, and then proceed from to register V4L2 devices from the 
> bus notifier callback (or possible a work queue). There would be no nested 
> probe() calls.

Would it be an option to create a new platform bus for the subdevs? That would 
have its own lock. It makes sense from a hierarchical point of view, but I'm 
not certain about the amount of work involved.

Regards,

	Hans

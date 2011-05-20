Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:60290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab1ETNIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 09:08:07 -0400
Date: Fri, 20 May 2011 15:08:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	michael.jones@matrix-vision.de
Subject: Re: [RFC/PATCH 1/2] v4l: Add generic board subdev
 =?iso-8859-1?q?registration=09function?=
In-Reply-To: <201105200929.33226.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1105201455270.17254@axis700.grange>
References: <1305830080-18211-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <4DD614DC.3070905@samsung.com> <201105200929.33226.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 20 May 2011, Laurent Pinchart wrote:

> Hi Sylwester,
> 
> On Friday 20 May 2011 09:14:36 Sylwester Nawrocki wrote:

[snip]

> > I had an issue when tried to call request_module, to register subdev of
> > platform device type, in probe() of other platform device. Driver's
> > probe() for devices belonging same bus type cannot be nested as the bus
> > lock is taken by the driver core before entering probe(), so this would
> > lead to a deadlock.
> > That exactly happens in __driver_attach().
> > 
> > For the same reason v4l2_new_subdev_board could not be called from probe()
> > of devices belonging to I2C or SPI bus, as request_module is called inside
> > of it. I'm not sure how to solve it, yet:)
> 
> Ouch. I wasn't aware of that issue. Looks like it's indeed time to fix the 
> subdev registration issue, including the module load race condition. Michael, 
> you said you have a patch to add platform subdev support, how have you avoided 
> the race condition ?
> 
> I've been thinking for some time now about removing the module load code 
> completely. I2C, SPI and platform subdevs would be registered either by board 
> code (possibly through the device tree on platforms that suppport it) for 
> embedded platforms, and by host drivers for pluggable hardware (PCI and USB). 
> Module loading would be handled automatically by the kernel module auto 
> loader, but asynchronously instead of synchronously. Bus notifiers would then 
> be used by host drivers to wait for all subdevs to be registered.

Sorry, I'm probably missing something. The reason for this module loading 
was, that you cannot probe i2c sensors before the host is initialised and 
has turned the master clock on. If you want to go back to the traditional 
platform-based I2C device registration, you'll have to wait in your sensor 
(subdev) probe function for host registration, which wouldn't be a good 
thing to do, IMHO.

> I'm not sure yet if this approach is viable. Hans, I think we've briefly 
> discussed this (possible quite a long time ago), do you have any opinion ? 
> Guennadi, based on your previous experience trying to use bus notifiers to 
> solve the module load race, what do you think about the idea ? Others, please 
> comment as well :-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

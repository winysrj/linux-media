Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49465 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1H1L2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 07:28:31 -0400
Received: by eyx24 with SMTP id 24so3598116eyx.19
        for <linux-media@vger.kernel.org>; Sun, 28 Aug 2011 04:28:30 -0700 (PDT)
Message-ID: <4E5A2657.7030605@gmail.com>
Date: Sun, 28 Aug 2011 13:28:23 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree-discuss@lists.ozlabs.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
References: <201107261647.19235.laurent.pinchart@ideasonboard.com> <201108081750.07000.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108081750.07000.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/08/2011 05:50 PM, Laurent Pinchart wrote:
> Subdevs hierachy, Linux device model
> ------------------------------------
> 
>   Preliminary conclusions:
> 
>   - With the move to device tree on ARM (and other platforms), I2C, SPI and
>     platform subdevs should be created from board code, not from bridge/host
>     drivers.
>   - Bus notifiers should be used by bridge/host drivers to wait for all
>     required subdevs. V4L2 core should provide helper functions.
>   - struct clk should be used to handle clocks provided by hosts to subdevs.

I have been investigating recently possible ways to correct the external clock
handling in Samsung FIMC driver and this led me up to the device tree stuff. 
I.e. in order to be able to register any I2C client device there is a need
to enable its master clock at the v4l2 host/bridge driver.

There is an issue that the v4l2_device (host)/v4l2_subdev hierarchy is not
reflected by the linux device tree model, e.g. the host might be a platform
device while the client an I2C client device. Thus a proper device/driver 
registration order is not assured by the device driver core from v4l2 POV.

I thought about embedding some API in a struct v4l2_device for the subdevs
to be able to get their master clock(s) as they need it. But this would work
only when a v4l2_device and v4l2_subdev are matched (registered) before I2C
client's probe(), or alternatively subdev_internal_ops::registered() callback,
is called. 

Currently such requirement is satisfied when the I2C client/v4l2 subdev
devices are registered from within a v4l2 bridge/host driver initialization
routine. But we may need to stop doing this to adhere to the DT rules.

I guess above you didn't really mean to create subdevs from board code?
The I2C client registration is now done at the I2C bus drivers, using the OF
helpers to retrieve the child devices list from fdt.

I guess we could try to create some sort of replacement for
v4l2_i2c_new_subdev_board() function in linux/drivers/of/* (of_i2c.c ?),
similar to of_i2c_register_devices().

But first we would have somehow to make sure the host drivers are registered
and initialized first. I'm not sure how to do it.
Plus such a new subdev registration method would have to obtain a relevant
struct v4l2_device object reference during the process; which is getting
a bit cumbersome..

Also, if we used a 'struct clk' to handle clocks provided by hosts to subdevs,
could we use any subdev operation callback to pass a reference to such object
from host to subdev? I doubt since the clock may be needed in the subdev before
it is allocated and fully initialized, (i.e. available in the host).

If we have embedded a 'struct clk' pointer into struct v4l2_device, it would
have probably to be an array of clocks and the subdev would have to be able to
find out which clock applies to it. 

So I thought about doing something like:

diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index d61febf..9888f7d 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -54,6 +54,7 @@ struct v4l2_device {
        /* notify callback called by some sub-devices. */
        void (*notify)(struct v4l2_subdev *sd,
                        unsigned int notification, void *arg);
+       const struct clk * (*clock_get)(struct v4l2_subdev *sd);
        /* The control handler. May be NULL. */
        struct v4l2_ctrl_handler *ctrl_handler;
        /* Device's priority state */

This would allow the host to return proper clock for a subdev.
But it won't work unless the initialization order is assured..

> 
>   Actions:
> 
>   - Work on a proof-of-concept implementation of the new subdevs registration
>     mechanism and send an RFC (whoever needs it first).
>   - Work on a proof-of-concept clock handling using struct clk with the OMAP3
>     ISP driver (Laurent).

---
Regards,
Sylwester

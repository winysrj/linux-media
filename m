Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3267 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZFYGjn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 02:39:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: v4l2_subdev GPIO and Pin Control ops (Re: PxDVR3200 H LinuxTV v4l-dvb patch : Pull GPIO-20 low for DVB-T)
Date: Thu, 25 Jun 2009 08:39:40 +0200
Cc: linux-media <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	Terry Wu <terrywu2009@gmail.com>
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl> <1245897611.24270.19.camel@palomino.walls.org>
In-Reply-To: <1245897611.24270.19.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906250839.40916.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 25 June 2009 04:40:11 Andy Walls wrote:
> On Tue, 2009-06-23 at 14:33 +0200, Hans Verkuil wrote:
> > > On Tue, 2009-06-23 at 11:39 +0800, Terry Wu wrote:
> > >
> 
> > There is already an s_gpio in the core ops. It would be simple to add a
> > g_gpio as well if needed.
> 
> Hans,
> 
> As you probably know
> 
> 	int (*s_gpio)(v4l2_subdev *sd, u32 val);
> 
> is a little too simple for initial setup of GPIO pins.  With the
> collection of chips & cores supported by cx25840 module, setting the
> GPIO configuration also requires:
> 
> 	direction: In or Out
> 	multiplexed pins: GPIO or some other function
> 
> I could tack on direction as an argument to s_gpio(), but I think that
> is a bit inconvenient..  I'd rather have a 
> 
> 	int (*s_gpio_config)(v4l2_subdev *sd, u32 dir, u32 initval);
> 
> but that leaves out the method for multiplexed pin/pad configuration.
> Perhaps explicity setting a GPIO direction to OUT could be an implicit
> indication that a multiplexed pin should be set to it's GPIO function.
> However, that doesn't help for GPIO inputs that might have their pins
> multiplexed with other functions.
> 
> Here's an idea on how to specify multiplexed pin configuration
> information and it could involve pins that multiplex functions other
> than GPIO (the CX25843 is quite flexible in this regard):
> 
> 	int (*s_pin_function)(v4l2_subdev *sd, u32 pin_id, u32 function);
> 
> The type checking ends up pretty weak, but I figured it was better than
> a 'void *config' that had a subdev specific collection of pin
> configuration information.
> 
> Comments?

Hi Andy,

Is there any driver that needs to setup the multiplex functions? If not, then
I would not add support for this at the moment. Adding unused code is a bad
idea in general.

In addition, such information should only be needed at initialization time,
and since we now have the new v4l2_i2c_new_subdev_cfg function I think that
that is the right way to do this. The same approach can be used for setting
the gpio pin directions. That too is something you setup at config time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

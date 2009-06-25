Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47666 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZFYCiY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2009 22:38:24 -0400
Subject: v4l2_subdev GPIO and Pin Control ops (Re: PxDVR3200 H LinuxTV
 v4l-dvb patch : Pull GPIO-20 low for DVB-T)
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 22:40:11 -0400
Message-Id: <1245897611.24270.19.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-06-23 at 14:33 +0200, Hans Verkuil wrote:
> > On Tue, 2009-06-23 at 11:39 +0800, Terry Wu wrote:
> >

> There is already an s_gpio in the core ops. It would be simple to add a
> g_gpio as well if needed.

Hans,

As you probably know

	int (*s_gpio)(v4l2_subdev *sd, u32 val);

is a little too simple for initial setup of GPIO pins.  With the
collection of chips & cores supported by cx25840 module, setting the
GPIO configuration also requires:

	direction: In or Out
	multiplexed pins: GPIO or some other function

I could tack on direction as an argument to s_gpio(), but I think that
is a bit inconvenient..  I'd rather have a 

	int (*s_gpio_config)(v4l2_subdev *sd, u32 dir, u32 initval);

but that leaves out the method for multiplexed pin/pad configuration.
Perhaps explicity setting a GPIO direction to OUT could be an implicit
indication that a multiplexed pin should be set to it's GPIO function.
However, that doesn't help for GPIO inputs that might have their pins
multiplexed with other functions.

Here's an idea on how to specify multiplexed pin configuration
information and it could involve pins that multiplex functions other
than GPIO (the CX25843 is quite flexible in this regard):

	int (*s_pin_function)(v4l2_subdev *sd, u32 pin_id, u32 function);

The type checking ends up pretty weak, but I figured it was better than
a 'void *config' that had a subdev specific collection of pin
configuration information.

Comments?

Regards,
Andy



Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:3057 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZFWMdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 08:33:49 -0400
Message-ID: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
Date: Tue, 23 Jun 2009 14:33:49 +0200 (CEST)
Subject: Re: PxDVR3200 H LinuxTV v4l-dvb patch : Pull GPIO-20 low for DVB-T
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andy Walls" <awalls@radix.net>
Cc: "linux-media" <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	"Terry Wu" <terrywu2009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Tue, 2009-06-23 at 11:39 +0800, Terry Wu wrote:
>> Hi,
>>
>>     I add the following codes in the cx23885_initialize() of
>> cx25840-core.c:
>> 	/* Drive GPIO2 (GPIO 19~23) direction and values for DVB-T */
>> 	cx25840_and_or(client, 0x160, 0x1d, 0x00);
>> 	cx25840_write(client, 0x164, 0x00);
>>
>>     Before that, the tuning status is 0x1e, but <0> service found.
>>     Now, I can watch DVB-T (Taiwan, 6MHz bandwidth).
>>
>>     And if you are living in Australia, you should update the
>> tuner-xc2028.c too:
>>     http://tw1965.myweb.hinet.net/Linux/v4l-dvb/20090611-TDA18271HDC2/tuner-xc2028.c
>>
>> Best Regards,
>> Terry
>
>
> Hans,
>
> As I think of potential ways to handle this, I thought we may need to
> add a v4l2_subdev interface for setting and reading GPIO's.

There is already an s_gpio in the core ops. It would be simple to add a
g_gpio as well if needed.

It is not a good idea to directly control GPIO pins from within a subdev
driver for the simple reason that the subdev driver has no idea how its
gpio pins are hooked up. This should really be done from the v4l driver
itself. If you need a notification from the subdev that the v4l driver
needs to take some action, then the subdev can send a notification through
the notify function in v4l2_device. That's currently used by one subdev
driver that requires that the v4l driver toggles a GPIO pin at the right
time.

Regards,

          Hans

> A CX23418 based board has a Winbond W8360x GPIO IC connected via I2C.
> When I get to writing a v4l2_subdevice driver for that, it will need
> such an internal interface as well.
>
> Thoughts?
>
> Regards,
> Andy
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40241 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZFWKwR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 06:52:17 -0400
Subject: Re: PxDVR3200 H LinuxTV v4l-dvb patch : Pull GPIO-20 low for DVB-T
From: Andy Walls <awalls@radix.net>
To: hverkuil@xs4all.nl
Cc: linux-media <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <6ab2c27e0906222039y5b931f46vf7692d6e46248b68@mail.gmail.com>
References: <6ab2c27e0906222039y5b931f46vf7692d6e46248b68@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 06:53:15 -0400
Message-Id: <1245754395.3172.36.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-06-23 at 11:39 +0800, Terry Wu wrote:
> Hi,
> 
>     I add the following codes in the cx23885_initialize() of cx25840-core.c:
> 	/* Drive GPIO2 (GPIO 19~23) direction and values for DVB-T */
> 	cx25840_and_or(client, 0x160, 0x1d, 0x00);
> 	cx25840_write(client, 0x164, 0x00);
> 
>     Before that, the tuning status is 0x1e, but <0> service found.
>     Now, I can watch DVB-T (Taiwan, 6MHz bandwidth).
> 
>     And if you are living in Australia, you should update the
> tuner-xc2028.c too:
>     http://tw1965.myweb.hinet.net/Linux/v4l-dvb/20090611-TDA18271HDC2/tuner-xc2028.c
> 
> Best Regards,
> Terry


Hans,

As I think of potential ways to handle this, I thought we may need to
add a v4l2_subdev interface for setting and reading GPIO's.

A CX23418 based board has a Winbond W8360x GPIO IC connected via I2C.
When I get to writing a v4l2_subdevice driver for that, it will need
such an internal interface as well.

Thoughts?

Regards,
Andy


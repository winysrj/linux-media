Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51987 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZFZSR0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:17:26 -0400
Subject: Re: v4l2_subdev GPIO and Pin Control ops (Re: PxDVR3200 H LinuxTV
 v4l-dvb patch : Pull GPIO-20 low for DVB-T)
From: Andy Walls <awalls@radix.net>
To: Steven Toth <stoth@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Terry Wu <terrywu2009@gmail.com>
In-Reply-To: <4A44F697.2020008@kernellabs.com>
References: <8992.62.70.2.252.1245760429.squirrel@webmail.xs4all.nl>
	 <1245897611.24270.19.camel@palomino.walls.org>
	 <200906250839.40916.hverkuil@xs4all.nl>
	 <1245928543.4172.13.camel@palomino.walls.org>
	 <4A44DD1A.4030200@kernellabs.com>
	 <1246032766.3159.12.camel@palomino.walls.org>
	 <4A44F697.2020008@kernellabs.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 14:19:21 -0400
Message-Id: <1246040361.3159.37.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-06-26 at 12:25 -0400, Steven Toth wrote:
> On 6/26/09 12:12 PM, Andy Walls wrote:

> >
> > My plan was to add the necessary support to the cx25840 module for
> > setting up the cx23885 pin control multiplexers (subdev config time),
> > the GPIO 23-19 directions (subdev config time), and the GPIO 23-19
> > output states (dynamically as needed via subdev's .s_gpio call).
> 
> Ahh. I'm already working on this, the code is partially merged for the GPIO 
> overhaul (a few weeks ago). I'm currently on the next stage. You should see some 
> todo comments in the current cx23885 driver.
> 
> Doesn't the cx23885 driver already configure the multiplexer pins at config time 
> for the cx25840? Check the -cards.c for the HVR1800 entry.

I'm not talking about the AFE Mux, I was refering to things like, as an
example, if an external pin could be configured as either GPIO[n] pin or
an audio sample clock.  The mux setting that handles that. 

Regards,
Andy


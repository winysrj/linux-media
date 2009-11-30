Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbZK3J7v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 04:59:51 -0500
Message-ID: <4B139721.5030808@redhat.com>
Date: Mon, 30 Nov 2009 07:57:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jon Smirl <jonsmirl@gmail.com>, Andy Walls <awalls@radix.net>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, stefanr@s5r6.in-berlin.de,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain>	<BDkdITRHqgB@lirc>	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	<m3aay6y2m1.fsf@intrepid.localdomain>	<9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>	<1259469121.3125.28.camel@palomino.walls.org>	<20091129124011.4d8a6080@lxorguk.ukuu.org.uk>	<9e4733910911291019l27e5fea2x3db268311842b17@mail.gmail.com> <20091129190059.02c2a0ff@lxorguk.ukuu.org.uk>
In-Reply-To: <20091129190059.02c2a0ff@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

Alan Cox wrote:

> Does it really make sense to put big chunks of protocol decoding crap for
> an interface which runs at about 1 character per second on a good day
> into the kernel ? Does it really make sense ot move 50K of code from user
> context to kernel context where it must meet strict security
> requirements, be extensively audited and cannot be paged. For embedded
> users will also have to be highly modular so no unused bits are loaded.

The same logic would apply to mouse, keyboards and serial consoles. 
It is possible to move everything to userspace. 

However, there are some reassons for they to be in kernelspace:
	- you may need them during boot time;
	- they are mandatory to allow the users interaction;
	- you need low latency.

The same arguments apply to IR, especially on embedded devices: some devices,
like TVs, Set Top TV boxes and IPTV Set Top Boxes have IR as their primary
input device.

Also, as changing a digital TV or an IP TV channel requires to discard the current
MPEG stream and getting a newer one, and it requires a large time until you'll
be able to output something to the user, one of the needs is to handle IR keystrokes
(especially channel up/down) as fast as possible, to try to minimize the discomfort
of changing a channel.

Using an approach where you'll send a raw event to userspace, process there and return
back to kernel will increase the latency and can only be done after when loading
the SYSV runlevel stuff.

On the other hand, we already have IR decoding in-kernel. Most of the code are
at:
	drivers/media/common/ir-functions.c

But there are also some other decoders at bttv, saa7134 and cx88 drivers.

In the case of drivers/media stuff, there common case is that the drivers have
support for both space/pulse decoding and in-hardware decoding. On both cases,
the scancode is converted to a keystroke via evdev. IMHO, we shouldn't really
consider dropping those decoders from kernel.

Cheers,
Mauro. 

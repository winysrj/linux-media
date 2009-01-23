Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51216 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbZAWTrl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 14:47:41 -0500
Subject: Re: [linux-dvb] Which firmware for cx23885 and xc3028?
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <20090123194122.ez7tev87a8kcw00g@webmail.detek.unideb.hu>
References: <000001c97d7c$3005c130$0202a8c0@speedy>
	 <20090123194122.ez7tev87a8kcw00g@webmail.detek.unideb.hu>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 14:47:27 -0500
Message-Id: <1232740047.3907.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-01-23 at 19:41 +0100, lnovak@dragon.unideb.hu wrote:
> Wayne and Holly <wayneandholly@alice.it> wrote:
> 
> >> I am trying to make an AverMedia AverTV Hybrid Express (A577)
> >> work under Linux. It seems all major chips (cx23885, xc3028
> >> and af9013) are already supported, so it should be doable in
> >> principle.
> >>
> >> I am stuck a little bit since AFAIK both cx23885 and xc3028
> >> need an uploadable firmware. Where should I download/extract
> >> such firmware from? I tried Steven Toth's repo (the Hauppauge
> >> HVR-1400 seems to be built around these chips as well) but
> >> even after copying the files under /lib/firmware it didn't
> >> really work. I tried to specify different cardtypes for the
> >> cx23885 module. For cardtype=2 I got a /dev/video0 and a
> >> /dev/video1 (the latter is of course unusable, I don't have a
> >> MPEG encoder chip on my card) but tuning was unsuccesful. All
> >> the other types I tried either didn't work at all or only
> >> resulted in dvb devices detected. For the moment, I am fine
> >> without DVB, and are interested mainly in analog devices.
> >>
> >> Maybe I should locate the windows driver of my card and
> >> extract the firmware files from it? If so, how do I proceed?
> >>
> >
> > Have you followed these instructions?:
> > http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the
> > _Firmware
> >
> 
> Tried xc3028-v27.fw as well as v36 from Steven's site. There is nothing
> showing up in the syslog when modprobing tuner-xc2028 (the doc mentions
> the kernel driver should indicate which part it loads).
> 
> What's the situation with cx23885? After digging into the various docs
> and descriptions pertaining to this chip, it's still not clear whether I
> need a firmware (and if so, where from may I download/extract it).

The publicly available product brief for that chip is here:

http://www.conexant.com/products/entry.jsp?id=393

Given that the Linux driver tries to

	request_module("cx25840");

for some CX23885 boards and that the cx25840 linux module has cx23885
specific code in it, it's safe to assume you'll need the
"v4l-cx23885-avcore-01.fw" file from somewhere.  It's function is likely
very similar to firmware for the cx25840, but it's also very likely the
images are subtly different and hence not interchangable.

Since you don't have a CX23417 MPEG encoder chip handing off the bridge,
you shouldn't need the "v4l-cx23885-fw.enc" file.

I know very little about this driver myself, so I can't speak to the
state of analog support for any supported card, much less how well an
unsupported card may work.


Regards,
Andy

> Many thanks for your help!
> 
> Greetings,
> 
> Levente



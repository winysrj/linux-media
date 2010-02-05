Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:37874 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab0BEN3U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 08:29:20 -0500
Message-ID: <4B6C1AF7.2090503@linuxtv.org>
Date: Fri, 05 Feb 2010 14:19:51 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Chicken Shack <chicken.shack@gmx.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from same
 demux (Re: Videotext application crashes the kernel due to DVB-demux patch)
References: <1265018173.2449.19.camel@brian.bconsult.de>	 <1265028110.3098.3.camel@palomino.walls.org>	 <1265076008.3120.96.camel@palomino.walls.org>	 <1265101869.1721.28.camel@brian.bconsult.de>	 <1265115172.3104.17.camel@palomino.walls.org>	 <1265158862.3194.22.camel@pc07.localdom.local>	 <1265288042.3928.9.camel@palomino.walls.org>	 <1265292421.3258.53.camel@brian.bconsult.de> <1265336477.3071.29.camel@palomino.walls.org>
In-Reply-To: <1265336477.3071.29.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andy,

Andy Walls wrote:
> After investigation, my recommendation for fixing the problem is to
> revert the patch that is causing the problem.
> 
> The reason for this is not that fixing the patch is impossible.
> INstead, I'll assert that using the DMX_ADD_PID and DMX_REMOVE_PID in
> conjunction with output=DMX_OUT_TSDEMUX_TAP is simply converting the
> demux0 device into multiple dynamically created anonymous dvr0 devices,
> and that is the wrong thing to do.

why exactly do you think this is wrong?

> I understand the need for sending a single PID TS out to an open demux0
> instance as described in this email:
> 
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29814.html
> 
> even though it seems like a slight abuse of the demux0 device.

How so? It's all about reading demultiplexed packets, which is exactly
what a demux is good for. There is btw. no other way for multiple
readers to receive TS packets without implementing a second demux
layer in a userspace daemon, which must then be used by all readers.
This would needlessly create quite some overhead on high bandwidth
services.

> But sending multiple PIDs out in a TS to the open demux0 device instance
> is just an awkward way to essentially dynamically create a dvrN device
> associated with filter(s) set on an open demux0 instance.

Actually it makes dvrN obsolete, but it must of course be kept for
backwards compatibility.

> It would be better, in my opinion, to figure out a way to properly
> create and/or associate a dvrN device node with a collection of demuxN
> filters.

Would this involve running mknod for every recording you start?

> Maybe just allow creation of a logical demux1 device and dvr1 device and
> the use the DVB API calls as is on the new logical devices.

A demux device (and dvr respectively) represents a transport stream
input. Hardware with multiple transport stream inputs (read: embedded
set top boxes) already has multiple demux and dvr devices.

> I'm not a DVB apps programmer, so I don't know all the userspace needs
> nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
> ioctl()s.

The need for such an interface was already pointed out and discussed
back in 2006:
http://www.linuxtv.org/pipermail/linux-dvb/2006-April/009269.html

As Honza noted, these ioctls are used by enigma2 and, in general, by
software running on Dream Multimedia set top boxes. I'm sure, other
projects are going to adopt this interface sooner or later. It is
still quite new after all.

Regards,
Andreas


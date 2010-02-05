Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47378 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0BETWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 14:22:55 -0500
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from
 same demux (Re: Videotext application crashes the kernel due to DVB-demux
 patch)
From: Andy Walls <awalls@radix.net>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Chicken Shack <chicken.shack@gmx.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <4B6C1AF7.2090503@linuxtv.org>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <4B6C1AF7.2090503@linuxtv.org>
Content-Type: text/plain
Date: Fri, 05 Feb 2010 14:22:16 -0500
Message-Id: <1265397736.6310.98.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Fri, 2010-02-05 at 14:19 +0100, Andreas Oberritter wrote:
> Hello Andy,
> 
> Andy Walls wrote:
> > After investigation, my recommendation for fixing the problem is to
> > revert the patch that is causing the problem.
> > 
> > The reason for this is not that fixing the patch is impossible.
> > INstead, I'll assert that using the DMX_ADD_PID and DMX_REMOVE_PID in
> > conjunction with output=DMX_OUT_TSDEMUX_TAP is simply converting the
> > demux0 device into multiple dynamically created anonymous dvr0 devices,
> > and that is the wrong thing to do.
> 
> why exactly do you think this is wrong?


Originally the dvr0 device provided a single TS multiplex of PIDs while
the open instances of demux0 each provided a single stream.

The end objective appears to be able to have multiple different TS
multiplexes from a single hardware (or software) demux.

IMO, the logical answer from a userspace perspective is to have multiple
dvr device nodes (eg dvr0.n) corresponding to a single originating
demux0 device node.  With each one of those dvr0.n devices configurable
essentially as before from the demux0 node, but being able to steer the
output of a filter to a dvr node other than dvr0 (e.g. dvr0.2).


The patches that added DMX_OUT_TSDEMUX_TAP and then
DMX_ADD_PID/DMX_REMOVE_PID, seemed to be avoiding implementing multiple
dvr nodes associated with a single demux node.  The end result is that
demux0, essentially a device node intended for control AFAICT, has now
been transformed to be multiple anonymous dvr device nodes.

In my opinion, that was the wrong end result.  I guess that is based on
my notion that the original Nokia/Convergence API separated control from
datastream, and these changes together do just the opposite.


> > I understand the need for sending a single PID TS out to an open demux0
> > instance as described in this email:
> > 
> > http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29814.html
> > 
> > even though it seems like a slight abuse of the demux0 device.
> 
> How so? It's all about reading demultiplexed packets, which is exactly
> what a demux is good for.

My perception was that the demux0 node was for control of the TS output
(and perhaps debug for isolating stream).  The dvr0 node was for
presenting a TS to userspace.



>  There is btw. no other way for multiple
> readers to receive TS packets without implementing a second demux
> layer in a userspace daemon, which must then be used by all readers.
> This would needlessly create quite some overhead on high bandwidth
> services.

I agree.  The DVB subsystem need a way to present multiple TS multiplexs
to userspace from a single, orginating demultiplexer.


> > But sending multiple PIDs out in a TS to the open demux0 device instance
> > is just an awkward way to essentially dynamically create a dvrN device
> > associated with filter(s) set on an open demux0 instance.
> 
> Actually it makes dvrN obsolete, but it must of course be kept for
> backwards compatibility.

Yes it does, except for write() functionality, which is only available
for dvr0 and not demux0.

It also collapses control of one demultiplexer and all the data streams
available from it down to one device node.


> > It would be better, in my opinion, to figure out a way to properly
> > create and/or associate a dvrN device node with a collection of demuxN
> > filters.
> 
> Would this involve running mknod for every recording you start?

I would think that dvb_dmxdev_init() would register a number of
DVB_DEVICE_DVR device nodes for demux0 named something like dvr0.0 (or
dvr0), dvr0.1, dvr0.2, dvr0.3, etc.  udev rules would handle device node
creation.

A module parameter could allow the user to set the number of dvr0.n
nodes to a non-default number.

Just an idea.


> > Maybe just allow creation of a logical demux1 device and dvr1 device and
> > the use the DVB API calls as is on the new logical devices.
> 
> A demux device (and dvr respectively) represents a transport stream
> input. Hardware with multiple transport stream inputs (read: embedded
> set top boxes) already has multiple demux and dvr devices.

Yes, that was a bad idea.  I agree with you: one demux device node per
input TS and demultiplexer device.


One could still have multiple dvr0.m nodes representing different filter
configurations from a demux0 node.


> > I'm not a DVB apps programmer, so I don't know all the userspace needs
> > nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
> > ioctl()s.
> 
> The need for such an interface was already pointed out and discussed
> back in 2006:
> http://www.linuxtv.org/pipermail/linux-dvb/2006-April/009269.html
> 
> As Honza noted, these ioctls are used by enigma2 and, in general, by
> software running on Dream Multimedia set top boxes.

Right, so reverting the patch is not an option.

It also makes implementing multiple dvr0.n nodes for a demux0 device
node probably a waste of time at this point.

Thanks for the comments.

Regards,
Andy

>  I'm sure, other
> projects are going to adopt this interface sooner or later. It is
> still quite new after all.
> 
> Regards,
> Andreas



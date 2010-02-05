Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:47430 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab0BEU1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 15:27:12 -0500
Message-ID: <4B6C7F1B.7080100@linuxtv.org>
Date: Fri, 05 Feb 2010 21:27:07 +0100
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
References: <1265018173.2449.19.camel@brian.bconsult.de>	 <1265028110.3098.3.camel@palomino.walls.org>	 <1265076008.3120.96.camel@palomino.walls.org>	 <1265101869.1721.28.camel@brian.bconsult.de>	 <1265115172.3104.17.camel@palomino.walls.org>	 <1265158862.3194.22.camel@pc07.localdom.local>	 <1265288042.3928.9.camel@palomino.walls.org>	 <1265292421.3258.53.camel@brian.bconsult.de>	 <1265336477.3071.29.camel@palomino.walls.org>	 <4B6C1AF7.2090503@linuxtv.org> <1265397736.6310.98.camel@palomino.walls.org>
In-Reply-To: <1265397736.6310.98.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> Originally the dvr0 device provided a single TS multiplex of PIDs while
> the open instances of demux0 each provided a single stream.
> 
> The end objective appears to be able to have multiple different TS
> multiplexes from a single hardware (or software) demux.

Right.

> IMO, the logical answer from a userspace perspective is to have multiple
> dvr device nodes (eg dvr0.n) corresponding to a single originating
> demux0 device node.  With each one of those dvr0.n devices configurable
> essentially as before from the demux0 node, but being able to steer the
> output of a filter to a dvr node other than dvr0 (e.g. dvr0.2).

This sounds like a matter of taste to me.

But anyway, your proposal would have one of two possible side effects:
You could either choose to allocate those device nodes statically,
which would create an artificial limit of filter groups on hardware,
where filters are shared between multiple inputs. Or you could create
the device nodes dynamically, which would involve waiting for udev to
create the new node between setting up the filter(s) and being able to
read data.

Another reason for the addition of the two new ioctls was, that
changing the DMX_SET_PES_FILTER control was not an option, to keep old
software running on new kernels and vice versa.

> The patches that added DMX_OUT_TSDEMUX_TAP and then
> DMX_ADD_PID/DMX_REMOVE_PID, seemed to be avoiding implementing multiple
> dvr nodes associated with a single demux node.  The end result is that
> demux0, essentially a device node intended for control AFAICT, has now
> been transformed to be multiple anonymous dvr device nodes.
> 
> In my opinion, that was the wrong end result.  I guess that is based on
> my notion that the original Nokia/Convergence API separated control from
> datastream, and these changes together do just the opposite.

That's wrong. The demuxN devices have always been used to control
filters and to read section and PES (i.e. TS payload) data streams.
The addition of DMX_OUT_TSDEMUX_TAP was just an extension to read a
third type of data from it (TS header + payload).

>>> I understand the need for sending a single PID TS out to an open demux0
>>> instance as described in this email:
>>>
>>> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29814.html
>>>
>>> even though it seems like a slight abuse of the demux0 device.
>> How so? It's all about reading demultiplexed packets, which is exactly
>> what a demux is good for.
> 
> My perception was that the demux0 node was for control of the TS output
> (and perhaps debug for isolating stream). 

Being able to read section and PES data is very important for DVB
applications. This is definitely not a debugging feature. Processing
raw TS streams for other purposes than recording to disk is rarely
seen on DVB devices. It's something that mainly comes from the PC
world, which is dominated by cheap peripherials which have no or very
limited capabilities for filtering and stream processing.

> The dvr0 node was for
> presenting a TS to userspace.

Right.

>>> But sending multiple PIDs out in a TS to the open demux0 device instance
>>> is just an awkward way to essentially dynamically create a dvrN device
>>> associated with filter(s) set on an open demux0 instance.
>> Actually it makes dvrN obsolete, but it must of course be kept for
>> backwards compatibility.
> 
> Yes it does, except for write() functionality, which is only available
> for dvr0 and not demux0.

Right.

> It also collapses control of one demultiplexer and all the data streams
> available from it down to one device node.

That has already been the case for sections and PES since the first
days of the API. The only recent change is to allow multiple PIDs per
file descriptor (which only makes sense for TS, not for sections and
PES, where the PID value itself is not carried inside the payload).

>> As Honza noted, these ioctls are used by enigma2 and, in general, by
>> software running on Dream Multimedia set top boxes.
> 
> Right, so reverting the patch is not an option.
> 
> It also makes implementing multiple dvr0.n nodes for a demux0 device
> node probably a waste of time at this point.

I think so, too. But I guess it's always worth discussing alternatives.

Regards,
Andreas


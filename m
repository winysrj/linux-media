Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38970 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751252Ab0BEPeq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 10:34:46 -0500
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from
 same demux (Re: Videotext application crashes the kernel due to DVB-demux
 patch)
From: Chicken Shack <chicken.shack@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <4B6C1CFC.6090600@redhat.com>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <4B6C1AF7.2090503@linuxtv.org>  <4B6C1CFC.6090600@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 16:31:51 +0100
Message-ID: <1265383911.6235.15.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 05.02.2010, 11:28 -0200 schrieb Mauro Carvalho Chehab:
> Andreas Oberritter wrote:
> > Hello Andy,
> > 
> > Andy Walls wrote:
> >> After investigation, my recommendation for fixing the problem is to
> >> revert the patch that is causing the problem.
> 
> Well, the patch were already added on an upstream kernel, so just reverting it
> will cause regressions.
> 
> If it is just aletv-dvb that broke, it seems better to fix it than to cause 
> even more troubles by reverting two new ioctls.
> 
> >> The reason for this is not that fixing the patch is impossible.
> 
> Why? Where exactly the breakage happened?

Mauro,

I think the dissassembler extracts done by Andy do answer this question
already. Just go back to the first messages of that thread and you will
know where the breakage begins.
For an experienced programmer / coder it should not be too different to
draw the adequate conclusions what needs to be done.

While everybody is behaving rather passive defending the kernel status
quo, stressing the fact that this discussion is nearly one week old now:

The core questions are:

1. What is the minimum adequate requirement for alevt-dvb to conform to
the latest DVB demux design and do its work again without noise and
causing kernel oopses?

2. What is the minimum adequate requirement for alevt-dvb to stop
causing hanging processes when the transponder is changed?
In its current state the application does not seem to understand the
effects of a PMT change (->program management table).

3. Who can write / offer patches for alevt's DVB design?

Still hoping for qualified help

CS


> >> INstead, I'll assert that using the DMX_ADD_PID and DMX_REMOVE_PID in
> >> conjunction with output=DMX_OUT_TSDEMUX_TAP is simply converting the
> >> demux0 device into multiple dynamically created anonymous dvr0 devices,
> >> and that is the wrong thing to do.
> > 
> > why exactly do you think this is wrong?
> > 
> >> I understand the need for sending a single PID TS out to an open demux0
> >> instance as described in this email:
> >>
> >> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29814.html
> >>
> >> even though it seems like a slight abuse of the demux0 device.
> > 
> > How so? It's all about reading demultiplexed packets, which is exactly
> > what a demux is good for. There is btw. no other way for multiple
> > readers to receive TS packets without implementing a second demux
> > layer in a userspace daemon, which must then be used by all readers.
> > This would needlessly create quite some overhead on high bandwidth
> > services.
> >> But sending multiple PIDs out in a TS to the open demux0 device instance
> >> is just an awkward way to essentially dynamically create a dvrN device
> >> associated with filter(s) set on an open demux0 instance.
> > 
> > Actually it makes dvrN obsolete, but it must of course be kept for
> > backwards compatibility.
> > 
> >> It would be better, in my opinion, to figure out a way to properly
> >> create and/or associate a dvrN device node with a collection of demuxN
> >> filters.
> > 
> > Would this involve running mknod for every recording you start?
> > 
> >> Maybe just allow creation of a logical demux1 device and dvr1 device and
> >> the use the DVB API calls as is on the new logical devices.
> > 
> > A demux device (and dvr respectively) represents a transport stream
> > input. Hardware with multiple transport stream inputs (read: embedded
> > set top boxes) already has multiple demux and dvr devices.
> 
> 
> Andreas arguments makes sense to me.
> 
>  
> >> I'm not a DVB apps programmer, so I don't know all the userspace needs
> >> nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
> >> ioctl()s.
> > 
> > The need for such an interface was already pointed out and discussed
> > back in 2006:
> > http://www.linuxtv.org/pipermail/linux-dvb/2006-April/009269.html
> > 
> > As Honza noted, these ioctls are used by enigma2 and, in general, by
> > software running on Dream Multimedia set top boxes. I'm sure, other
> > projects are going to adopt this interface sooner or later. It is
> > still quite new after all.
> 
> 
> It seems too late for me to revert it. So, we need to figure out a way
> to workaround it or to fix the applications that got broken by this change.
> 



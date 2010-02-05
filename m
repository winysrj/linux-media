Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46005 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab0BESbG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 13:31:06 -0500
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from
 same  demux (Re: Videotext application crashes the kernel due to DVB-demux
 patch)
From: Andy Walls <awalls@radix.net>
To: HoP <jpetrous@gmail.com>
Cc: Chicken Shack <chicken.shack@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>, obi@linuxtv.org,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <846899811002050419r7bdc4632rae4cfbd7abcc93f3@mail.gmail.com>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <1265369987.3649.38.camel@brian.bconsult.de>
	 <846899811002050419r7bdc4632rae4cfbd7abcc93f3@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Feb 2010 13:29:59 -0500
Message-Id: <1265394599.6310.46.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-02-05 at 13:19 +0100, HoP wrote:
> Hi Chicken
> 
> >
> > Furthermore: If it is technically possible to send and receive, demux
> > and multiplex, play and record complete contents of a transponder (i. e.
> > multiple TS streams) by using dvbstream or mumudvb (-> 8192 command line
> > parameter), then I myself do not see the necessity to extend the
> > capabilities of one physical device dvr0 or demux0 into a multiplicity
> > of devices dvr0 or demux0.
> > The what and especially the why will remain Andreas Oberritters' secret.
> 
> I can only say my 2 words regarding Andreas' patch:
> 
> At least one big DVB application is using it - enigma (originally
> inside tuxbox project, later enhanced by Dream Multimedia
> for theirs well-known linux based set-top-boxes Dreambox).
> Those boxes are selling worlwide, so userbase is wide enough
> (note: I'm not in any way connected with Dream Multimedia,
> so it is only my personal feeling and/or investigation).
> 
> Of course using full TS and remuxing only in user land
> is not possible way for embedded application. And if you count
> that there can be more then one TS input, things are getting even worst.

Well then, it appears reverting the patch is not an option.

Time to slog through the code and fix it, I guess.


> And as Andy wrote:
> >> But sending multiple PIDs out in a TS to the open demux0 device instance
> >> is just an awkward way to essentially dynamically create a dvrN device
> >> associated with filter(s) set on an open demux0 instance.
> >>
> >> It would be better, in my opinion, to figure out a way to properly
> >> create and/or associate a dvrN device node with a collection of demuxN
> >> filters.
> >>
> >> Maybe just allow creation of a logical demux1 device and dvr1 device and
> >> the use the DVB API calls as is on the new logical devices.
> >>
> >> I'm not a DVB apps programmer, so I don't know all the userspace needs
> >> nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
> >> ioctl()s.
> >>
> >>
> 
> Well, it is also possible way. But it expands
> dvrX from usuall dvr0 to something like dvr0 ... dvr31 or so.
> 
> We definitelly need such feature.


I thought about this more and was thinking the device nodes presented to
userspace might look something like this:

/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/dvr0.0 (symlink to dvr0 or the other way around)
/dev/dvb/adapter0/dvr0.1
/dev/dvb/adapter0/dvr0.2
...
/dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/net0


So that dvr0.n was still associated with the demux0 filter settings, but
that the demux filter outputs could be steered to one of a number of
different dvr0.n devices.

That keeps dvr0.n devices as providing a TS multiplex of exactly the
PIDs one wants, allows multiple TS multiplexes to be recorded from the
originating demux0, and also allows the dvr0.n outputs to be controlled
by the originating demux0.

It would require the current DMX_SET_PES_FILTER_PARAMS ioctl()'s to be
modified, so that the output setting could include a "subaddress" (the n
in dvr0.n), but with a default of 0 for backward compatability.


> I, personally, like DMX_OUT_TSDEMUX_TAP approach.

>From what I gather, originally:

a. the demux0 device would provide a single PID stream (not a TS but a
"section"?) with DMX_OUT_TAP

b. the dvr0 device would provide a full TS multiplex of all the PIDs
specified with DMX_OUT_TS_TAP

c. a dvr node always delivered a TS and an open demux instance always
delivered a non-TS stream


So the problems were, I think:

a. No way to capture more than one TS from an originating demux.  So
userspace could not re-multiplex PIDs together easily(?).

b. No way to capture more than one TS multiplex from an originating
demux.  No way for userspace to easily capture separate TV programs from
a single multiplex, into separate TS multiplexes each containing only
the related PID for each spearate TV program (i.e. audio and video PIDs)



Problem a. was solved by the DMX_OUT_TSDEMUX_TAP change.  That was a
very simple patch and appear fairly straight forward.  It changes the
type of output one can get from an open demux0 instance from just
"section" to also include a single PID TS.  IMO, that change looks like
a conveient shortcut to avoid dealing with how to implement multiple dvr
nodes per originating demux.  But that's OK, if your userspace app just
needs one PID per TS:  mplayer playing audio and video from one TV
program (?)


Problem b. was solved by the DMX_ADD_PID, DMX_REMOVE_PID patch.  This
allows an open demux instance to now not only send a TS, but also send
multiple PIDs in that TS, essentially creating an output of the kind one
would see at a dvr0 node.


So my thinking at this point is why dance around the issue?  The
requirement appears to be to set up multiple dvr type feeds for
userspace from a single originating demux.

I would want to take the time to audit the code and fix the problems
with the DMX_ADD_PID, DMX_REMOVE_PID patch, if it were not used by any
popular userspace apps and if there were something that made more sense.

Regards,
Andy

> Rgds
> 
> /Honza



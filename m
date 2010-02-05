Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57354 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755275Ab0BELmm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 06:42:42 -0500
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from
 same demux (Re: Videotext application crashes the kernel due to DVB-demux
 patch)
From: Chicken Shack <chicken.shack@gmx.de>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, obi@linuxtv.org,
	hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <1265336477.3071.29.camel@palomino.walls.org>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 12:39:47 +0100
Message-ID: <1265369987.3649.38.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Donnerstag, den 04.02.2010, 21:21 -0500 schrieb Andy Walls:
> On Thu, 2010-02-04 at 15:07 +0100, Chicken Shack wrote:
> > Am Donnerstag, den 04.02.2010, 07:54 -0500 schrieb Andy Walls:
> > > On Wed, 2010-02-03 at 02:01 +0100, hermann pitton wrote:
> > > > Am Dienstag, den 02.02.2010, 07:52 -0500 schrieb Andy Walls:
> > > > > On Tue, 2010-02-02 at 10:11 +0100, Chicken Shack wrote:
> > > > > > Am Montag, den 01.02.2010, 21:00 -0500 schrieb Andy Walls:
> > > > > > > On Mon, 2010-02-01 at 07:41 -0500, Andy Walls wrote:
> > > > > > > > On Mon, 2010-02-01 at 10:56 +0100, Chicken Shack wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > here is a link to a patch which breaks backwards compatibility for a
> > > > > > > > > teletext software called alevt-dvb.
> > > > > > > > > 
> > > > > > > > > http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg04638.html
> > > > > > > > > 
> > > > > > > > > The kernel patch was introduced with kernel 2.6.32-rc1.
> > > > > > > > > It was Signed-off-by Brandon Philips, Mauro Carvalho Chehab and its
> > > > > > > > > author, Andreas Oberritter.
> > > > > > > > > 
> > > > > > > 
> > > > > > > > > Regards
> > > > > > > > > 
> > > > > > > > > CS
> > > > > > > > > 
> > > > > > > > > P. S.: This is how the kernel crash looks like:
> > > > > > > > 
> > > > > > > > The information below can get me started.  Could you please provide
> > > > > > > > whole Ooops from the output dmesg or from your /var/log/messages file?
> > > > > > > > 
> > > > > > > > I'll try to look at this tonight.
> > > > > > > > 
> > > > > > > > Regards,
> > > > > > > > Andy
> > > > > > > > 
> > > > > > > > > brian:~# alevt
> > > > > > > > > alevt: SDT: service_id 0xcf24 not in PAT
> > > > > 
> > > > > > > > > alevt: ioctl: DMX_SET_PES_FILTER Invalid argument (22)
> > > > > > > > > Getötet
> > > > > > > > > brian:~# 
> > > > > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > > > > >  kernel:[  116.563487] Oops: 0000 [#1] PREEMPT SMP 
> 
> > > > > > > So there is something wrong with the list manipulations or, if needed,
> > > > > > > locking around the the list manipulations of the list that was
> > > > > > > introduced in the patch you identified as the problem.  That is what is
> > > > > > > causing the Ooops on close().  It will take a some more scrutiny to see
> > > > > > > what exactly is wrong.
>  
> > > Schedule update: I'll be looking at this tonight (Thursday evening).
> 
> After investigation, my recommendation for fixing the problem is to
> revert the patch that is causing the problem.
> 
> The reason for this is not that fixing the patch is impossible.
> INstead, I'll assert that using the DMX_ADD_PID and DMX_REMOVE_PID in
> conjunction with output=DMX_OUT_TSDEMUX_TAP is simply converting the
> demux0 device into multiple dynamically created anonymous dvr0 devices,
> and that is the wrong thing to do.
> 
> I understand the need for sending a single PID TS out to an open demux0
> instance as described in this email:
> 
> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29814.html
> 
> even though it seems like a slight abuse of the demux0 device.
> 
> 
> But sending multiple PIDs out in a TS to the open demux0 device instance
> is just an awkward way to essentially dynamically create a dvrN device
> associated with filter(s) set on an open demux0 instance.
> 
> It would be better, in my opinion, to figure out a way to properly
> create and/or associate a dvrN device node with a collection of demuxN
> filters.
> 
> Maybe just allow creation of a logical demux1 device and dvr1 device and
> the use the DVB API calls as is on the new logical devices.
> 
> I'm not a DVB apps programmer, so I don't know all the userspace needs
> nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
> ioctl()s.
> 
> 
> Comments?
> 
> Regards,
> Andy

Hi Andy,

thanks for this excellent analysis :)

kaffeine-1.0pre3, xawtv-4.0pre (->discontinued), vdr-1.6.0, mythtv-0.22:

None of them uses neither DMX_ADD_PID nor DMX_REMOVE_PID in conjunction
with DMX_OUT_TSDEMUX_TAP.

So reverting the kernel patch does not do harm to anybody.

Furthermore: If it is technically possible to send and receive, demux
and multiplex, play and record complete contents of a transponder (i. e.
multiple TS streams) by using dvbstream or mumudvb (-> 8192 command line
parameter), then I myself do not see the necessity to extend the
capabilities of one physical device dvr0 or demux0 into a multiplicity
of devices dvr0 or demux0.
The what and especially the why will remain Andreas Oberritters' secret.

However: The hanging process that alevt-dvb produces if an external
application switches to a channel belonging to a different DVB-S
transponder still remains the second problem which is not touched by
this discussion - just as a reminder for everybody!

The one who wants to use teletext under Linux is in a very bad position:

1. There seems to be a plugin for vdr that I never tried because I do
not like vdr at all.
2. alevt-dvb is officially not maintained. The last contribution by its
original author happened in 2007 with the implementation of v4l2.
3. mtt by Gerd Knorr (Hoffmann) is part of a discontinued suite called
xawtv-4.0 pre. xawtv-4.0 pre was never officially released or finished.
Especially the main program xawtv is simply unusable for modern DVB
needs.

mtt is still buggy and I do not like its design at all.
On the other hand it's not impressed or handicapped at all by the kernel
patch incriminated above. That's why I said that the problem discussed
here cannot be uniquely defined as kernel-specific.
It's also application-specific. It's simply both.
 
In some distros (Debian f. ex.) mtt does not exist officially.

Who of the people reading this feels competent enough in DVB application
programming to have a look at alevt-dvb to resolve the problem with the
hanging processes please?
Who volunteers please? Manu Abraham perhaps?

Thanks and Regards

CS



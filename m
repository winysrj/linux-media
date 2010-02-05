Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56929 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739Ab0BECWE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 21:22:04 -0500
Subject: Need to discuss method for multiple, multiple-PID TS's from same
 demux (Re: Videotext application crashes the kernel due to DVB-demux patch)
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, obi@linuxtv.org
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Chicken Shack <chicken.shack@gmx.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <1265292421.3258.53.camel@brian.bconsult.de>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 21:21:16 -0500
Message-Id: <1265336477.3071.29.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-02-04 at 15:07 +0100, Chicken Shack wrote:
> Am Donnerstag, den 04.02.2010, 07:54 -0500 schrieb Andy Walls:
> > On Wed, 2010-02-03 at 02:01 +0100, hermann pitton wrote:
> > > Am Dienstag, den 02.02.2010, 07:52 -0500 schrieb Andy Walls:
> > > > On Tue, 2010-02-02 at 10:11 +0100, Chicken Shack wrote:
> > > > > Am Montag, den 01.02.2010, 21:00 -0500 schrieb Andy Walls:
> > > > > > On Mon, 2010-02-01 at 07:41 -0500, Andy Walls wrote:
> > > > > > > On Mon, 2010-02-01 at 10:56 +0100, Chicken Shack wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > here is a link to a patch which breaks backwards compatibility for a
> > > > > > > > teletext software called alevt-dvb.
> > > > > > > > 
> > > > > > > > http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg04638.html
> > > > > > > > 
> > > > > > > > The kernel patch was introduced with kernel 2.6.32-rc1.
> > > > > > > > It was Signed-off-by Brandon Philips, Mauro Carvalho Chehab and its
> > > > > > > > author, Andreas Oberritter.
> > > > > > > > 
> > > > > > 
> > > > > > > > Regards
> > > > > > > > 
> > > > > > > > CS
> > > > > > > > 
> > > > > > > > P. S.: This is how the kernel crash looks like:
> > > > > > > 
> > > > > > > The information below can get me started.  Could you please provide
> > > > > > > whole Ooops from the output dmesg or from your /var/log/messages file?
> > > > > > > 
> > > > > > > I'll try to look at this tonight.
> > > > > > > 
> > > > > > > Regards,
> > > > > > > Andy
> > > > > > > 
> > > > > > > > brian:~# alevt
> > > > > > > > alevt: SDT: service_id 0xcf24 not in PAT
> > > > 
> > > > > > > > alevt: ioctl: DMX_SET_PES_FILTER Invalid argument (22)
> > > > > > > > Getötet
> > > > > > > > brian:~# 
> > > > > > > > Message from syslogd@brian at Jan 31 19:52:33 ...
> > > > > > > >  kernel:[  116.563487] Oops: 0000 [#1] PREEMPT SMP 

> > > > > > So there is something wrong with the list manipulations or, if needed,
> > > > > > locking around the the list manipulations of the list that was
> > > > > > introduced in the patch you identified as the problem.  That is what is
> > > > > > causing the Ooops on close().  It will take a some more scrutiny to see
> > > > > > what exactly is wrong.
 
> > Schedule update: I'll be looking at this tonight (Thursday evening).

After investigation, my recommendation for fixing the problem is to
revert the patch that is causing the problem.

The reason for this is not that fixing the patch is impossible.
INstead, I'll assert that using the DMX_ADD_PID and DMX_REMOVE_PID in
conjunction with output=DMX_OUT_TSDEMUX_TAP is simply converting the
demux0 device into multiple dynamically created anonymous dvr0 devices,
and that is the wrong thing to do.

I understand the need for sending a single PID TS out to an open demux0
instance as described in this email:

http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29814.html

even though it seems like a slight abuse of the demux0 device.


But sending multiple PIDs out in a TS to the open demux0 device instance
is just an awkward way to essentially dynamically create a dvrN device
associated with filter(s) set on an open demux0 instance.

It would be better, in my opinion, to figure out a way to properly
create and/or associate a dvrN device node with a collection of demuxN
filters.

Maybe just allow creation of a logical demux1 device and dvr1 device and
the use the DVB API calls as is on the new logical devices.

I'm not a DVB apps programmer, so I don't know all the userspace needs
nor if anything is already using the DMX_ADD_PID and DMX_REMOVE_PID
ioctl()s.


Comments?

Regards,
Andy


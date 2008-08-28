Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7SLiRpC003062
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 17:44:27 -0400
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7SLiE6D018793
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 17:44:14 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
In-Reply-To: <20080828202043.GB824@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<20080826232913.GA2145@daniel.bse>
	<200808281611.38241.jdelvare@suse.de>
	<20080828202043.GB824@daniel.bse>
Content-Type: text/plain; charset=utf-8
Date: Thu, 28 Aug 2008 23:42:28 +0200
Message-Id: <1219959748.4731.21.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: bttv driver questions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

Am Donnerstag, den 28.08.2008, 22:20 +0200 schrieb Daniel Glöckner:
> On Thu, Aug 28, 2008 at 04:11:38PM +0200, Jean Delvare wrote:
> > What determines whether fields are captured independently?
> 
> Right now I can only think of V4L2_FIELD_ALTERNATE causing this.
> 
> > My tests with a SECAM
> > source show a rate of 74-78 interrupts/second, which would be 3
> > interrupts per frame. So I guess I a missing a 3rd cause of
> > interrupts. Any idea?
> 
> I checked the code. As soon as the device is opened, the VSYNC interrupt
> is unmasked to count the fields. These interrupts are in addition to the
> interrupts generated for queued buffers.
> 
> > I thought that there was only one RISC program
> > loaded at any given time and that it had to be changed twice per
> > frame, which would have taken one additional interrupt.
> 
> There is only one program with jumps that are patched at runtime to
> point to the program fragments for capture.
> 
> > The BT878 has a hint which suggests that the fastest model described
> > by Daniel is probably almost the right one.
> 
> The setup cycles mentioned by Andy and me depend on the target (the host
> bridge). The master must assert IRDY within 8 cycles in all data phases.
> 
> As a single Bt878 is able to capture PAL in BGR32 at 4*Fsc (70937900 byte/s
> peak), there must be less than one wait cycle per data phase on average.
> 
> > Apparently the bttv driver sets them to relatively large values,
> > instead of the small hardware default (4). This makes sense to me,
> > 4 was very small and would cause the BT878 to request control of the
> > PCI bus every now and then, significantly reducing the available PCI
> > bus bandwidth.
> 
> I think for competing Bt878s the smallest trigger point in combination
> with a high latency counter should perform best.
> 
> > > The master may request extended/another grant before its timer expires.
> > 
> > Do you happen to know if the BT878 does that? Couldn't find any
> > mention in the datasheet.
> 
> Well, if they give us a bit to turn it off, I assume it is done.
> Read the section about the 430FX Compatibility Mode.
> 
> > > Jean, is v4l-dvb-maintainer the right place to discuss these things?
> > 
> > I thought so. At least I received pertinent answers to my questions,
> > so it seems that I have reached the right persons. But if you think I
> > am abusing this list, I don't want to make anyone angry, so we can
> > either continue this discussion in private, or on another list you
> > think would be more appropriate.
> 
> Trent started CCing video4linux-list and from linux/MAINTAINERS I read
> that v4l-dvb-maintainer is mainly for patches..
> I'm only subscribed to video4linux-list, so I don't know what is customary
> on the maintainer list.
> 
>   Daniel
> 

for me it seems all lists are right and even linux-dvb should be added.

We had quite a lot of reports during the last years concerning bttv
throughput on certain hardware and often there was no quick solution.

It is nice to see how many are still aware of the driver's details.

Such a thing even caused the foundation of the v4l wiki, since David
Liontooth was on some affected bttv hardware mix times back and had to
dig into on which hardware best to start for his upcoming teaching.

Unrelated not yet working saa713x NTSC closed captions were fixed in
following attempts too.

But it sheds also a light on the saa713x restrictions, when DVB-T and/or
DVB-S on hybrid cards is in use already and why in such a case analog
video can only use packed formats at once, but no planar.

A user friendly solution still needs to be found and this here seems to
be a good point to start.

Cheers,
Hermann










--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

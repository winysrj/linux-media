Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7SKLerK031509
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 16:21:40 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7SKLCSC029204
	for <video4linux-list@redhat.com>; Thu, 28 Aug 2008 16:21:12 -0400
Date: Thu, 28 Aug 2008 22:20:43 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Jean Delvare <jdelvare@suse.de>
Message-ID: <20080828202043.GB824@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<20080826232913.GA2145@daniel.bse>
	<200808281611.38241.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808281611.38241.jdelvare@suse.de>
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
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

On Thu, Aug 28, 2008 at 04:11:38PM +0200, Jean Delvare wrote:
> What determines whether fields are captured independently?

Right now I can only think of V4L2_FIELD_ALTERNATE causing this.

> My tests with a SECAM
> source show a rate of 74-78 interrupts/second, which would be 3
> interrupts per frame. So I guess I a missing a 3rd cause of
> interrupts. Any idea?

I checked the code. As soon as the device is opened, the VSYNC interrupt
is unmasked to count the fields. These interrupts are in addition to the
interrupts generated for queued buffers.

> I thought that there was only one RISC program
> loaded at any given time and that it had to be changed twice per
> frame, which would have taken one additional interrupt.

There is only one program with jumps that are patched at runtime to
point to the program fragments for capture.

> The BT878 has a hint which suggests that the fastest model described
> by Daniel is probably almost the right one.

The setup cycles mentioned by Andy and me depend on the target (the host
bridge). The master must assert IRDY within 8 cycles in all data phases.

As a single Bt878 is able to capture PAL in BGR32 at 4*Fsc (70937900 byte/s
peak), there must be less than one wait cycle per data phase on average.

> Apparently the bttv driver sets them to relatively large values,
> instead of the small hardware default (4). This makes sense to me,
> 4 was very small and would cause the BT878 to request control of the
> PCI bus every now and then, significantly reducing the available PCI
> bus bandwidth.

I think for competing Bt878s the smallest trigger point in combination
with a high latency counter should perform best.

> > The master may request extended/another grant before its timer expires.
> 
> Do you happen to know if the BT878 does that? Couldn't find any
> mention in the datasheet.

Well, if they give us a bit to turn it off, I assume it is done.
Read the section about the 430FX Compatibility Mode.

> > Jean, is v4l-dvb-maintainer the right place to discuss these things?
> 
> I thought so. At least I received pertinent answers to my questions,
> so it seems that I have reached the right persons. But if you think I
> am abusing this list, I don't want to make anyone angry, so we can
> either continue this discussion in private, or on another list you
> think would be more appropriate.

Trent started CCing video4linux-list and from linux/MAINTAINERS I read
that v4l-dvb-maintainer is mainly for patches..
I'm only subscribed to video4linux-list, so I don't know what is customary
on the maintainer list.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

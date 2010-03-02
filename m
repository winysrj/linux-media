Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48318 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab0CBMls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Mar 2010 07:41:48 -0500
Subject: Re: cx18: Unable to find blank work order form to schedule
 incoming mailbox ...
From: Andy Walls <awalls@radix.net>
To: Mark Lord <kernel@teksavvy.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <4B8CA8DD.5030605@teksavvy.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
Content-Type: text/plain
Date: Tue, 02 Mar 2010 07:40:30 -0500
Message-Id: <1267533630.3123.17.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-03-02 at 00:57 -0500, Mark Lord wrote:
> On 03/01/10 20:34, Andy Walls wrote:
> > On Mon, 2010-03-01 at 11:07 -0500, Mark Lord wrote:
> >> I'm using MythTV-0.21-fixes (from svn) on top of Linux-2.6.33 (from kernel.org),
> >> with an HVR-1600 tuner card.  This card usually works okay (with workarounds for
> >> the known analog recording bugs) in both analog and digital modes.
> >>
> >> Last night, for the first time ever, MythTV chose to record from both the analog
> >> and digital sides of the HVR-1600 card at exactly the same times..
> >>
> >> The kernel driver failed, and neither recording was successful.
> >> The only message in /var/log/messages was:
> >>
> >> Feb 28 19:59:45 duke kernel: cx18-0: Unable to find blank work order form to schedule incoming mailbox command processing
> >
> >
> > This is really odd.  It means:
> >
> > 1. Your machine had a very busy burst of cx18 driver buffer handling
> > activity.  Stopping a number of different streams, MPEG, VBI, and (DTV)
> > TS at nearly the same time could do it
> >
> > 2. The firmware locked up.
> >
> > 3. The work handler kernel thread, cx18-0-in, got killed, if that's
> > possible, or the processor it was running on got really bogged down.
> ..
> 
> Yeah, it was pretty strange.
> I wonder.. the system also has a Hauppauge 950Q USB tuner,
> which is also partially controlled by the cx18 driver (I think).

Nope.  Different driver.  The processing for the 950Q USB may have put
some extra load on the system, but likely not enough load to stall 70
MDL handover requests from the firmware.


> I wonder if perhaps that had anything to do with it?
> 
> > If you want to make the problem "just go away" then up this parameter in
> > cx18-driver.h:
> >
> > #define CX18_MAX_IN_WORK_ORDERS (CX18_MAX_FW_MDLS_PER_STREAM + 7)
> > to something like
> > #define CX18_MAX_IN_WORK_ORDERS (2*CX18_MAX_FW_MDLS_PER_STREAM + 7)
> ..
> 
> Heh.. Yup, that's the first thing I did after looking at the code.  :)
> Dunno if it'll help or not, but easy enough to do.

If it doesn't, then there's a problem somewhere else. ;)

> And if the cx18 is indeed being used by two cards (HVR-1600 and HVR-950Q),
> then perhaps that number does need to be bigger or dynamic (?).

Dynamic would be better.

For each CX23418 based card in your system, a pool of these work
requests is allocated dynamically at card setup, and drawn from when
needed during operation.

Since the CX23418 can have up to 63 MDL done notifications (and 2 MDL
Ack notifications, IIRC) for the following 6 types of streams: MPEG,
VBI, IDX, PCM, YUV and TS.  The most work orders that should ever need
is 6 * 65.

One would only need that maximum when effectively stopping all 6 streams
on a card at once, while not processing the work requests in a timely
manner.  That is so pathological, its not worth considering.  That's why
the cx18 driver only has 70 in the pool: 63 for one stream stopping and
5 others for running streams (and 2 for a couple of MDL Acks, IIRC).


Again, maybe dynamically allocating these work order objects from the
kernel as needed, would be better from a small dynamically allocated
pool for each card.  I was concerned that the interrupt handler was
taking to long at the time I implemented the things the way they are
now.



> I've since tried to reproduce the failure on purpose, with no luck to date.
> 
> Thanks guys!

You're welcome.

Regards,
Andy



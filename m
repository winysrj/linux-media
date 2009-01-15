Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbZAORag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 12:30:36 -0500
Date: Thu, 15 Jan 2009 15:29:55 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, CityK <cityk@rogers.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	V4L <video4linux-list@redhat.com>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
Message-ID: <20090115152955.38f40e4e@pedra.chehab.org>
In-Reply-To: <496F488B.3010302@linuxtv.org>
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl>
	<496F488B.3010302@linuxtv.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Jan 2009 09:30:35 -0500
Michael Krufky <mkrufky@linuxtv.org> wrote:

> Hey Hans,
> 
> Hans Verkuil wrote:
> >> Hans Verkuil wrote:
> >>     
> >>> On Thursday 15 January 2009 06:01:28 CityK wrote:
> >>>
> >>>       
> >>>> Hans Verkuil wrote:
> >>>>
> >>>>         
> >>>>> OK, I couldn't help myself and went ahead and tested it. It seems
> >>>>> fine, so please test my tree:
> >>>>>
> >>>>> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-saa7134
> >>>>>
> >>>>> Let me know if it works.
> >>>>>
> >>>>>           
> >>>> Hi Hans,
> >>>>
> >>>> It didn't work.  No analog reception on either RF input.  (as Mauro
> >>>> noted, DVB is unaffected; it still works).
> >>>>
> >>>> dmesg output looks right:
> >>>>
> >>>> tuner-simple 1-0061: creating new instance
> >>>> tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual
> >>>> in)
> >>>>
> >>>> I tried backing out of the modules and then reloading them, but no
> >>>> change.  (including after fresh build or after rebooting)
> >>>>
> >>>>         
> >>> Can you give the full dmesg output? Also, is your board suppossed to
> >>> have a tda9887 as well?
> >>>
> >>>       
> >> Hans' changes are not enough to fix the ATSC115 issue.
> >>     
> >
> > Ah, OK.
> >
> >   
> >> I believe that if you can confirm that the same problem exists, but the
> >> previous workaround continues to work even after Hans' changes, then I
> >> believe that confirms that Hans' changes Do the Right Thing (tm).
> >>
> >> ATSC115 is broken not because the tuner type assignment has been removed
> >> from attach_inform.
> >>
> >> This is actually a huge problem across all analog drivers now, since we
> >> are no longer able to remove the "tuner" module and modprobe it again --
> >> the second modprobe will not allow for an attach, as there will be no
> >> way for the module to be recognized without having the glue code needed
> >> inside attach_inform...
> >>     
> >
> > Huh? Why would you want to rmmod and modprobe tuner? Anyway, drivers that
> > use v4l2_subdev (like my converted saa7134) will increase the tuner module
> > usecount, preventing it from being rmmod'ed.
> 
> There was a load order dependency in the saa7134 driver.  Some users 
> have to remove tuner and modprobe it again in order to make analog tv 
> work.  Yes, that's a bug.
> 
> The bug got worse when Mauro made changes to attach_inform -- I believe 
> this was for the sake of some xceive tuners... I don't recall the 
> details now.
> 
> Anyway, long story short... there are many different bugs all 
> manifesting themselves at once here.  Load order dependency -- I don't 
> think we ever understood why that issue exists.  The fix for the load 
> order dependency no longer works, as attach_inform no longer cares if a 
> new tuner appears on the bus.

It has nothing to do with the load order. It is related to i2c binding. With
the current approach (before Hans patch), the i2c core will try to bind the
tuner after having 2 conditions satisfied:
	1) I2C bus were registered;
	2) tuner code is available.

So, if you load tuner before saa7134 (or have it compiled in-kernel), the code
will try to probe tuners at the moment you register i2c bus. Otherwise, it will
try to bind only when request_module is handled.

Some devices with DVB has an internal i2c gate. For a subset of these, the i2c
gate is inside the tuner. So, you need to bind the tuner device before probing
for the frontends. On the other set of devices, the gate is inside the demod.
So, you need to turn the i2c gate before running the i2c address seek for tuner.

This generated lots of issues in the past, like machines with two boards
doesn't work anymore. With two boards, and a tuner module, the first board
probes tuner after opening the demod gateway. However, the second board will
try to probe tuner before opening the i2c gateway. So, tuner is not found.

-

After having Hans patches working, we need to implement the following workflow
inside the driver:

1) register the i2c bus and load tuner (the order shouldn't be relevant
anymore, since the attachment is not related anymore with i2c bus register and/or
with tuner load);
2) call the i2c open gate control, if it needs to open the demod i2c gate in
order to access the tuner;
3) tuner type is determined via eeprom and/or board entry;
3) tuner i2c address is scanned and tuner is bound with the proper type;
4) the i2c open gate control is called, if needed in order to access the demod;
5) demod is bound.

> So, my ATSC115 hack-patch restored the attach_inform functionality for 
> the sake of ATSC110/115 users.  I am not pushing for its merge -- this 
> *will* break the boards that Mauro was working on when he changed 
> attach_inform.
>
> As I don't really understand what he was going for when he made those 
> changes, I don't know how to fix this problem without creating new bugs 
> on Mauro's cards.  I put out that patch in hopes that somebody else 
> would put the pieces together and make a better fix that would work for 
> everybody.  That hasn't happened yet :-(

Hacks won't be needed anymore.

All we need is to fix the board entries, properly identifying what is needed to
access tuner and/or demod, and double check what devices need tda9887.

Cheers,
Mauro

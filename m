Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25194 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901Ab0IJNap (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:30:45 -0400
Subject: Re: [PATCH] Illuminators and status LED controls
From: Andy Walls <awalls@md.metrocast.net>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
In-Reply-To: <87r5h2awwr.fsf@macbook.be.48ers.dk>
References: <y1el0c4vecj8x6uk04ypatvd.1284039765001@email.android.com>
	 <275b6fc10404e9bda012060f49cdf2f3.squirrel@webmail.xs4all.nl>
	 <1284079784.4438.192.camel@morgan.silverblock.net>
	 <87r5h2awwr.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 09:30:11 -0400
Message-ID: <1284125411.2123.81.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 2010-09-10 at 09:19 +0200, Peter Korsgaard wrote:
> >>>>> "Andy" == Andy Walls <awalls@md.metrocast.net> writes:
> 
> Hi,
> 
>  Andy> Given choices I made when I patched up gspca/cpia1.c for my
>  Andy> prototype LED API usage, I got these associations
> 
>  Andy> By exposed LED name:
> 
>  Andy> 	/sys/class/leds/video0:white:illuminator0
> 
> Indeed. But didn't we just decide that illuminators were an integral
> part of the video handling (similar to gain control), and only use the
> LED API for status LEDs that don't directly interfere with the video
> data?

Hi Peter,

Correct, I still want illuminators controlled by the V4L2 control API.

The QX3 is the only unit I had to test with.    I needed to prototype
something so I could understand how the LED API worked.  The
Documentation/led-class.txt file does not explain things enough for an
end user nor a developer to use the interface.  Nothing in my desktop
system currently exported LEDs.

(git grep revealed that drivers dedicated to LED or GPIO chips, laptop
led drivers,  a few NIC drivers, and a some graphics devices were the
major exporters of LEDs via the LED API.  Nothing in my desktop system
exported LEDs.)


>  Andy> The LED API has some shortcomings/annoyances:
> 
>  Andy> - The method a driver provides to set the LED brightness cannot sleep,
>  Andy> so a workqueue is needed to simply turn a hardware light on and off for
>  Andy> USB devices.
> 
>  Andy> - The Documentation is not very good for end-users or kernel developers
>  Andy> on using the LED API. 
> 
> No? I agree that the documentation is pretty minimalistic, but ok - It's
> not that complicated.

It is opaque to the unfamiliar.  In a few Google searches, I could not
find userspace application code or scripts that demonstrated use of the
API.   An average user will give up on using it, before rummaging
through kernel code.

Even after reading the minimal documentation and looking at the code, I
improperly thought that more than one trigger could be set on an LED.

I wasted time on figuring out these things, where I think the
documentation could have easily helped:

- names of kernel provided LED trigger modules
- function/operation of each kernel provided LED trigger module
- of the LED triggers that took parameters, what were the units
- implementation difference between a simple and a complex LED trigger,
not just the LED class design objective differences
- location of a top level sysfs node that provides a list of all the LED
triggers available - there is none.  You need at least one LED exposed
to see the global list.
- that the LED core provides a simple suspend/resume, if drivers don't
want to provide their own.


And these, for which documentation will probably always lag:

- What drivers expose LEDs
- What drivers possibly provide LED trigger events, and what triggers
pick them up.



>  Andy> - For an LED trigger not to override a user's desire to inhibit an LED,
>  Andy> the user needs to know to cancel all the triggers on an LED before
>  Andy> setting the LEDs brightness to 0.
> 
> Only a single trigger can be active at a time for a given LED.

Hmmm.  I had supposed if I had a USB camera that has an LED and a button
then I could provide triggers:

	video0_stream (for video stream stop/start events)
	video0_button0 (for button press events from the first button)

then I could use these together to automatically turn the LED on and off
when a stream started or stopped and allow the user to extinguish the
LED by pressing the button.  (As a prototype test case for the LED API,
I was thinking of walking the two QX3 microscope illuminators through
different brightness sequences when pressing the button, and having them
both turn off when the stream stopped.)

So instead I guess I would have write a single LED trigger that responds
to all the event types I care to handle at once.  Again, it would have
been nice, if the documentation provided that as guidance.  Explaining
binding a trigger to an LED by referring to how a user changes I/O
schedulers, doesn't help most users.  Most end users have never needed
to change the I/O scheduler.



>  Andy> Again, that happens to be the only real compelling use case I see for
>  Andy> using the LED API.  However, I doubt many users will try to take
>  Andy> advantage of it, and I suspect even less will succeed in getting it
>  Andy> configured right.  Good documentation could go a long way in correcting
>  Andy> that.
> 
> That and using the LED for something else (perhaps with another trigger
> like I eplained earlier with wlan/hdd activity).

I personally don't think all the extra code in the V4L2 drivers is worth
it for sharing a camera LED for other purposes.  I don't see the average
user really using it for Network or HDD activity, when userspace tools
like GNOME system monitor provides a convenient display right on the
desktop bar.

Regards,
Andy


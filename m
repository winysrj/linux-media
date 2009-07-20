Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:56288 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZGTBMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 21:12:32 -0400
MIME-Version: 1.0
In-Reply-To: <4A63A15F.8040804@rtr.ca>
References: <4A631C8F.7000002@rtr.ca>
	 <829197380907190706i686fd1afwdca0d8be648129@mail.gmail.com>
	 <4A6337C1.6080104@rtr.ca> <4A63416E.2070103@rtr.ca>
	 <4A63A15F.8040804@rtr.ca>
Date: Sun, 19 Jul 2009 21:12:31 -0400
Message-ID: <829197380907191812v185e0869j2e5fa47483a4de4c@mail.gmail.com>
Subject: Re: Regression 2.6.31: xc5000 no longer works with Myth-0.21-fixes
	branch
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 19, 2009 at 6:42 PM, Mark Lord<lkml@rtr.ca> wrote:
> Mark Lord wrote:
> ..
>>
>> 3. In mythtv-setup -> CaptureCards -> DVB:1 -> RecordingOptions
>> there is a tickbox for "Open DVB Card on Demand".  It was ticked,
>> so I un-ticked that box.  Everything now works!
>>
>> When that tickbox was selected, the xc5000 took five (5) seconds to
>> "open",
>> as it did the firmware upload every time.  This appeared to exceed some
>> timeout inside myth.
>>
>> With the tickbox NOT ticked, myth just opens the tuner once at startup,
>> and keeps it open, so no more delay when it wants to use it.
>>
>> I wonder if we can be smarter/faster about the xc5000 firmware uploads?
>
> ..
>
> The firmware downloads take a little over six seconds, each time,
> and appear to be done after any "sleep" of the device.
>
> The "un-ticked checkbox" above means that the device will NEVER
> be put to sleep, though..
>
>
> One problem (not new) remains:  the device remains "live" on the USB
> even when the system is powered-off.  It stays quite warm to the touch
> and is obviously wasting power this way.
>
> Is there not something the driver could do to put it to sleep
> on system shutdown, so that it draws much less power, per USB spec ?
>
> thanks!
>

Hello Mark,

Yeah, the situation with the seven second firmware load time is well
known.  It's actually a result of the i2c's implementation in the
au0828 hardware not properly supporting i2c clock stretching.  Because
of some bugs in the hardware, I have it clocked down to something like
30KHz as a workaround.  I spent about a week investigating the i2c bus
issue with my logic analyzer, and had to move on to other things.  I
documented the gory details here back in March if you really care:

http://devinjh.livejournal.com/169333.html
http://devinjh.livejournal.com/169075.html

(and there is more discussion of the various issues at
http://www.kernellabs.com/blog )

That said, the issue only occurs with the HVR-950q (and other devices
that have both xc5000 and au0828).  On most boards, the combined time
to load the firmware and do the initial tune is actually about half
the time required compared to before the xc5000 improvements (for
example, the initial tune time on the PCTV 801e went from 3200ms down
to 1100ms with subsequent tunes now taking about 350ms).

There is a modprobe option I added for xc5000 called "no_poweroff=1"
which results in the tuner never being put to sleep.  People who are
hitting the MythTV issue can work around the problem that way, at the
expense of no power management (which is exactly how the product
behaved before the xc5000 improvements).

It is a limitation of the xc5000 hardware design that after putting
the chip to sleep, the firmware must be reloaded.

The xc5000 pulls about 300ma when powered up, which is why it is warm.
 In fact, my discomfort with how warm it got even when not in use was
the whole reason I got the power management working in the first
place.

Regarding your comments on being able to "put it to sleep on system
shutdown", *this* is something I actually was unaware of.  I had not
really investigated the behavior of the device after shutdown, but
this is an area that could certainly use some additional
investigation.  I've heard similar comments about em28xx, so perhaps
what needs to be happening is the dvb core needs to be calling the
tuner's sleep function when the module is being unloaded.  I would
have to figure out the right place to make such a change though (dvb
core?  the bridge driver?  the tuner driver?).

Regarding the analog issue with audio, I am aware of the problem, and
it is the big outstanding issue preventing people from using the
analog support under MythTV (the issue *is* specific to MythTV as
other apps work fine with analog audio).  I just haven't had the
cycles to investigate it yet, but I suspect it's probably a timing
issue combined with MythTV doing something really dumb when it hits
the exception condition (which causes the segfault).

So in summary:

1.  You found a regression in MythTV due to the need to reload
firmware on the first tune.  I can't help but want to blame MythTV for
at least part of this given it must have some crappy code for timeout
if it cannot distinguish between the time spent in the tuner
initalization phase versus the actual tuning request (the timeout
seems to be inclusive for both operations).   Either I will have to
spend some more time trying to "fix" the au0828 i2c bus so the
firmware time is actually reasonable, or see if I can trace down which
timeout MythTV hits and see if I can change the driver to load the
firmware somewhere earlier (if possible).  In the meantime, the
workarounds are to use the no_poweroff option or uncheck that box in
the mythtv-setup)

2.  You hit the known analog audio issue that is preventing people
from using analog with MythTV.  I guess you can look at the analog
support as a work in progress - it works with most apps, but there is
something going on specific to MythTV that I haven't isolated yet.
Note this issue is completely related to the 950q analog project and
has nothing to do with the xc5000 tuner improvements.

3.  You found a new issue with the xc5000 not being powered down on
system shutdown.  I was unaware of this issue, but I am confident this
is not new to 2.6.31, since previous versions of the code didn't make
any effort at all to power down the chip.

Thanks for taking the time to investigate/debug the issue.  There's
obviously more work to be done on my end to bring some resolution to
the above three issues.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

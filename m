Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52042 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936138Ab0COLvx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 07:51:53 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@radix.net>
To: Mark Lord <kernel@teksavvy.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <4B9DA003.90306@teksavvy.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
Content-Type: text/plain
Date: Mon, 15 Mar 2010 07:51:24 -0400
Message-Id: <1268653884.3209.32.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-03-14 at 22:48 -0400, Mark Lord wrote:
> On 03/02/10 07:40, Andy Walls wrote:
> > Again, maybe dynamically allocating these work order objects from the
> > kernel as needed, would be better from a small dynamically allocated
> > pool for each card.  I was concerned that the interrupt handler was
> > taking to long at the time I implemented the things the way they are
> > now.
> ..
> 
> I haven't seen that particular issue again, with or without increasing
> the work orders, so hopefully it won't recur.

OK.


> But after updating to the tip of the v4l2-dvb git tree last week,
> I've been hitting the "no audio" on analog recordings bug much more often.

Is that tuner audio or baseband (line-in) audio?



> Digging through google, it appears this problem has been around as long
> as the cx18 driver has existed, with no clear resolution.  Lots of people
> have reported it to you before, and nobody has found a silver bullet fix.

Correct.   I thought it was completely gone, but apparently, there just
isn't a lot of reporting of this intermittent problem.


> The problem is still there.
> 
> I have now spent a good many hours trying to isolate *when* it happens,
> and have narrowed it down to module initialization.
> 
> Basically, if the audio is working after modprobe cx18, it then continues
> to work from recording to recording until the next reboot.
>
> If the audio is not working after modprobe, then simply doing rmmod/modprobe
> in a loop (until working audio is achieved) is enough to cure it.

Good to know.


> So for my Mythtv box here, I now have a script to check for missing audio
> and do the rmmod/modprobe.  This is a good, effective workaround.
> 
>     http://rtr.ca/hvr1600/fix_hvr1600_audio.sh
> 
> That's a link to my script.
> 
> As for the actual underlying cause/bug, it's still not clear what is happening.
> But the problem is a LOT more prevalent (for me, and for two other people I know)
> with versions of the cx18 driver since spring 2009.
> 
> My suspicion is that the firmware download for the APU is somehow being corrupted,
> and now that the driver downloads the firmware *twice* during init, it doubles the
> odds of said corruption.  Just a theory, but it's the best fit so far.

Please isolate an APU load and initialization problem, by seeing if
audio fails for both tuner audio and baseband audio.


Here are all the potential problem areas I can think of:

1. A/V digitizer/decoder audio detection firmware load and init.  (I've
added firmware readback verification to try and head this off.)

2. A/V digitizer decoder audio microcontroller hard reset and "soft"
reset sequencing.  (I think the cx18 driver has this wrong ATM.)

3. APU load and init.  (The double load is to fix a DTV TS stream bug on
every other APU & CPU firmware load sequence.  The APU_AI_RESET is to
fix the audio bitrate problem on first capture after a double firmware
load.)

4. AI1 Mux setting failing when switching between the internal A/V
decoder's I2S output and the external I2S inputs.  (I thought I had this
fixed, but I don't have detailed register specs for that register - so
maybe not.)

5. A/V decoder audio clock PLL stops operating due to being programmed
out of range.  (This was a problem for 32 ksps audio a while ago, but
I'm pretty confident I have it fixed.)

6. A/V decoder analog frontend setup for SIF wrong?.  (I fixed this due
to a problen Helen Buus reported with cable TV.)



I think #2 is the real problem.  I just started to disassmble the
digitizer firmware 2 nights ago to see if I could get some insight as to
how to properly reset it.

I've got a first WAG at fixing the resets of the audio microcontroller's
resets at:

	http://linuxtv.org/hg/~awalls/cx18-audio

If it doesn't work, change the CXADEC_AUDIO_SOFT_RESET register define
from 0x810 to 0x9cc, although that may not work either.


> I think we have some nasty i2c issues somewhere in the kernel.

The only I2C connected devices for analog audio are the analog tuner IF
demodulator chip for SIF audio and the CS5345 chip for baseband audio.
Unlike the PVR-150, which has an I2C connected CX25843 A/V decoder, the
CX23418's A/V decoder is integrated and accessed via PCI bus registers.
 
With that said, the CX23418 will sometimes have to let register access
over the PCI bus fail.  For that, I have routines in cx18-io.[ch] to
perform retries.  You may wish to add a log statement there to watch for
retry loops that completely fail. 


Thanks for the troubleshooting and reporting.

Regards,
Andy



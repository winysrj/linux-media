Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61459 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab0DJWyn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 18:54:43 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@radix.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <4BC0FB79.7080601@pobox.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
Content-Type: text/plain
Date: Sat, 10 Apr 2010 18:54:03 -0400
Message-Id: <1270940043.3100.43.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-10 at 18:28 -0400, Mark Lord wrote:
> On 15/03/10 07:51 AM, Andy Walls wrote:
> > On Sun, 2010-03-14 at 22:48 -0400, Mark Lord wrote:
> >> On 03/02/10 07:40, Andy Walls wrote:
> ..
> >> after updating to the tip of the v4l2-dvb git tree last week,
> >> I've been hitting the "no audio" on analog recordings bug much more often.
> >>
> >> Digging through google, it appears this problem has been around as long
> >> as the cx18 driver has existed, with no clear resolution.  Lots of people
> >> have reported it to you before, and nobody has found a silver bullet fix.
> ..
> > Here are all the potential problem areas I can think of:
> >
> > 1. A/V digitizer/decoder audio detection firmware load and init.  (I've
> > added firmware readback verification to try and head this off.)
> >
> > 2. A/V digitizer decoder audio microcontroller hard reset and "soft"
> > reset sequencing.  (I think the cx18 driver has this wrong ATM.)
> >
> > 3. APU load and init.  (The double load is to fix a DTV TS stream bug on
> > every other APU&  CPU firmware load sequence.  The APU_AI_RESET is to
> > fix the audio bitrate problem on first capture after a double firmware
> > load.)
> >
> > 4. AI1 Mux setting failing when switching between the internal A/V
> > decoder's I2S output and the external I2S inputs.  (I thought I had this
> > fixed, but I don't have detailed register specs for that register - so
> > maybe not.)
> >
> > 5. A/V decoder audio clock PLL stops operating due to being programmed
> > out of range.  (This was a problem for 32 ksps audio a while ago, but
> > I'm pretty confident I have it fixed.)
> >
> > 6. A/V decoder analog frontend setup for SIF wrong?.  (I fixed this due
> > to a problen Helen Buus reported with cable TV.)
> >
> > I think #2 is the real problem.  I just started to disassmble the
> > digitizer firmware 2 nights ago to see if I could get some insight as to
> > how to properly reset it.
> >
> > I've got a first WAG at fixing the resets of the audio microcontroller's
> > resets at:
> >
> > 	http://linuxtv.org/hg/~awalls/cx18-audio
> >
> > If it doesn't work, change the CXADEC_AUDIO_SOFT_RESET register define
> > from 0x810 to 0x9cc, although that may not work either.
> ..
> > Thanks for the troubleshooting and reporting.
> ..
> 
> Back at this again today, after a month away from it -- getting tired
> of watching "Survivor" with closed-captioning instead of audio.  :)
> 
> I pulled your (Andy) repository today, and merged the cx18 audio reset
> changes from it into today's tip from v4l-dvb.  Patch attached for reference.
> 
> So far, so good.  I'll keep tabs on it over time, and see if the audio
> is stable, or if it still fails once in a while.

Hmmm.  Darren's having problems (loss of video/black screen) with my
patches under my cx18-audio repo, but I'm not quite convinced he doesn't
have some other PCI bus problem either.

Anyway, my plan now is this:

1. on cx18-av-core.c:input_change()
	a. set register 0x808 for audio autodetection
	b. restart the format detection loop
	c. set or reset a 1.5 second timeout

2. after the timer expires, if no audio standard was detected, 
	a. force the audio standard by programming register 0x808
		(e.g. BTSC for NTSC-M)
	b. restart the format detection loop so the micrcontroller will 
		do the unmute when it detects audio



Darren is in NTSC-M/BTSC land.  What TV standard are you dealing with?

Regards,
Andy


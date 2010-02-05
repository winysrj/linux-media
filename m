Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58747 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab0BEEQZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 23:16:25 -0500
Subject: Re: Any saa711x users out there?
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <829197381002040724u6a8d3b40m6e9f3751640685f4@mail.gmail.com>
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
	 <1265248280.3122.74.camel@palomino.walls.org>
	 <829197381002040724u6a8d3b40m6e9f3751640685f4@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 23:15:15 -0500
Message-Id: <1265343315.7784.28.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-02-04 at 10:24 -0500, Devin Heitmueller wrote:
> On Wed, Feb 3, 2010 at 8:51 PM, Andy Walls <awalls@radix.net> wrote:
> > With all that said, if you have a baseband Luma or Chroma signal with
> > strong spurious high frequency components (crappy source, or you're
> > overdriving the front end and getting intermods), then keep the
> > anti-alias filter turned on as the assumption of a bandlimited input
> > signal is violated in this case.
> 
> In this case, I'm seeing it with both the analog signal generator
> (which one might consider a fairly pristine source), as well coming
> off the s-video output of a DirectTV box (in which case the signal is
> being generated only a few feet away from the saa7113).

Hmmm.  The AGC (or static gain level?) of the amplifier in the SAA7113
before the anti-alias filter may be set too high causing the clipping
(intermods) there.  It may be worth looking at the gain setting for that
amp.


> > In the SAA7113 the anti-alias filter introduces a delay of 50 ns.  At
> > 13.5 Mpixels/sec, or 74.1 ns/pixel, that's less than 1 pixel time of
> > delay.
> >
> > Just turn it on in and leave it on in the SAA7113 to handle the
> > unexpected input signal case.
> 
> This would be my vote (assuming we try it with the other parts and
> confirm no regressions are introduced).  My only concern is the way
> the code is currently written, the saa7113 initialization block
> actually does enable it by default, and then some code for the saa7115
> tramples the register, turning it off (see saa7115_init_misc at
> saa7115.c:600).  I think the decision we have to make is which of the
> following paths to take:
> 
> 1.  Enable it in the saa7115_init_misc, thereby enabling it for the
> 7113, 7114, and 7115.
> 
> 2.  Exclude the saa7115_init_misc block from being run at all against the 7113
> 
> 3.  Let the saa7115_init_misc block get run, and then flip the bit
> back for the 7113.
> 
> My thinking at this point is that the AA filter should probably be on
> by default regardless of the chip, in which case we would just need to
> make the one line change to enable it in the saa7115_init_misc block.

Probably.

The visible effects of the anti-alais filter could possibly be:

1. Less range of color, if high freqs of the color get attenuated.
(Most people likely will not perceive this as most people are not that
sensitive to small color variations.)

2. Loss of rapid variations in Luma - softer edges between light and
dark areas on a scan line - if higher freqs of the Luma get attenuated.

but given that the anti-alais filter is essentially flat out to about
5.6 MHz and has a slow rolloff (only 3 dB down at about 6.9 MHz), I
doubt anyone would ever notice it is on with NTSC.


Since you have a signal generator, you should run experiments with PAL-D
and SECAM-D with a grid containing vertical lines since those both have
a 6.0 MHz video bandwidth.  SECAM also has FM color, so you might see
the greatest affect of an antialias filter on color on the Cyan color
bar in SECAM-D.

Regards,
Andy

> Devin



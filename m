Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36292 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab0BFQif (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Feb 2010 11:38:35 -0500
Subject: Re: Any saa711x users out there?
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <829197381002042034g486b6162rf065388a225a60be@mail.gmail.com>
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
	 <1265248280.3122.74.camel@palomino.walls.org>
	 <829197381002040724u6a8d3b40m6e9f3751640685f4@mail.gmail.com>
	 <1265343315.7784.28.camel@palomino.walls.org>
	 <829197381002042034g486b6162rf065388a225a60be@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 06 Feb 2010 11:37:26 -0500
Message-Id: <1265474246.3063.31.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-02-04 at 23:34 -0500, Devin Heitmueller wrote:
> Hey Andy,


> > The visible effects of the anti-alais filter could possibly be:
> >
> > 1. Less range of color, if high freqs of the color get attenuated.
> > (Most people likely will not perceive this as most people are not that
> > sensitive to small color variations.)
> >
> > 2. Loss of rapid variations in Luma - softer edges between light and
> > dark areas on a scan line - if higher freqs of the Luma get attenuated.
> >
> > but given that the anti-alais filter is essentially flat out to about
> > 5.6 MHz and has a slow rolloff (only 3 dB down at about 6.9 MHz), I
> > doubt anyone would ever notice it is on with NTSC.

Hi Devin,

I think I miscommunicated in the above.  To be more precise, I should
have said:

"The visible effects of the anti-alias filter, on a signal that does not
have unexpected high frequency components out of the normal channel
bandwidth, could possibly be:"

In other words "here's what someone might notice as degredation due to
an AA filter, if they had a proper signal throughout the entire
amplifier chain."




> To give you a better idea of what I'm talking about, look at this image:
> 
> http://imagebin.org/83458

OK.  It look pretty regular which is surprising, but nice for analysis.
It's approximate frequency after having been being folded down is about:

42 cycles/line / 704 pixels/line * 13.5 Mpixels/sec ~= 805.4 kHz ~= 1 MHz

which means it's likely a pretty high frequency, several MHz above the
Nyquist rate, before being folded down by the sampling.



> The above image was taken with the generator via the s-video input
> (ruling out the possibility that it's any sort of product of
> intermodulation).

You are correct that intermodulation product is the wrong term in the
case of basedband S-Video.

However, clipping caused by an overdriven amplifier will introduce high
frequency components - be the peak of the time domain signal caused by
mixing of unwanted TV stations or just a very strong or overamplified
basedband signal.  


> For the sake of comparison, here's the exact same signal source
> against an a similar em28xx design but with the tvp5150.
> 
> http://imagebin.org/83459

Much nicer.


> > Since you have a signal generator, you should run experiments with PAL-D
> > and SECAM-D with a grid containing vertical lines since those both have
> > a 6.0 MHz video bandwidth.  SECAM also has FM color, so you might see
> > the greatest affect of an antialias filter on color on the Cyan color
> > bar in SECAM-D.
> 
> Believe it or not, I'm actually having trouble with the generator
> right now with anything but NTSC.  I'm going back and forth with
> Promax on repair options.  So I cannot do any PAL or SECAM testing
> right now.

:(

I'll try to perform a quick test with my PVR-350 with NTSC and the YUV
capture device BTW.

Then I'll go outside and shovel more snow. :P

Regards,
Andy


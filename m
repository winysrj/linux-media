Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57916 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab0BDBvd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 20:51:33 -0500
Subject: Re: Any saa711x users out there?
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 20:51:20 -0500
Message-Id: <1265248280.3122.74.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-02-02 at 17:51 -0500, Devin Heitmueller wrote:
> Hello all,
> 
> I am doing some quality improvements for a couple of the
> em28xx/saa7113 designs, and I found a pretty serious problem which
> appears to have been there for some time.
> 
> In fact, the regression was introduced when the saa7115 support was
> added in 2005 (hg revision 2750).  This change resulted in the
> anti-alias filtering being disabled by default for the saa7113 (the
> saa7115_init_misc block clears bit 7 of register 0x02).  Without this
> change, vertical lines appear in the chroma on a fixed interval.
> 
> The big issue is that the driver is shared with other saa7113
> products, as well as products that have the saa7111, saa7114, and
> saa7115.  So I have to figure out whether to just force on the AA
> filter for the saa7113, or whether it should be enabled for the
> others, or whether I can even turn it on for saa7113 in general or
> need to hack something in there to only do it for the two or three
> products I am testing with.
> 
> So here's where I could use some help:  If you have a product that
> uses one of the above chips, please speak up.  I will be setting up a
> test tree where people can try out the change and see if it makes
> their situation better, worse, or no change.

I have a PVR-350 with an SAA7115 IIRC.  Other ivtv boards have SAA7114
chips.  I don't see any in ivtv-cards.c that have an SAA7113 explcitily
listed.

Whether or not an anti-alias filter is needed is a completely knowable
answer given:

1. The TV norm and hence the Luma and Chroma signal characteristics
2. The A/D sample rate
3. The parameters of any decimations or non-integer resampling being
performed

If you don't undersample, i.e. Fs/2 > single-sided BW of the signal
being sampled, then you don't need an anti alias filter before you
sample, otherwise you do.

The same sort of thing goes for decimation of digital samples.  If the
decimation is going to cause aliases to fold down into the spectrum, you
need a digital LPF before the decimation to band limit the digital
signal.


This should not be a "user control", this should be a configuration
setting that is knowable by the bridge driver and/or the module driving
the SAA7113.


With all that said, if you have a baseband Luma or Chroma signal with
strong spurious high frequency components (crappy source, or you're
overdriving the front end and getting intermods), then keep the
anti-alias filter turned on as the assumption of a bandlimited input
signal is violated in this case.

In the SAA7113 the anti-alias filter introduces a delay of 50 ns.  At
13.5 Mpixels/sec, or 74.1 ns/pixel, that's less than 1 pixel time of
delay.

Just turn it on in and leave it on in the SAA7113 to handle the
unexpected input signal case.

Regards,
Andy


> Devin



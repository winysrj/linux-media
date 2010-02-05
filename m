Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47224 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0BEEen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 23:34:43 -0500
Received: by bwz19 with SMTP id 19so1104697bwz.28
        for <linux-media@vger.kernel.org>; Thu, 04 Feb 2010 20:34:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265343315.7784.28.camel@palomino.walls.org>
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
	 <1265248280.3122.74.camel@palomino.walls.org>
	 <829197381002040724u6a8d3b40m6e9f3751640685f4@mail.gmail.com>
	 <1265343315.7784.28.camel@palomino.walls.org>
Date: Thu, 4 Feb 2010 23:34:41 -0500
Message-ID: <829197381002042034g486b6162rf065388a225a60be@mail.gmail.com>
Subject: Re: Any saa711x users out there?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Andy,

On Thu, Feb 4, 2010 at 11:15 PM, Andy Walls <awalls@radix.net> wrote:
> Hmmm.  The AGC (or static gain level?) of the amplifier in the SAA7113
> before the anti-alias filter may be set too high causing the clipping
> (intermods) there.  It may be worth looking at the gain setting for that
> amp.

It's possible.  One thing I did as a test though was I did a capture
of the i2c traffic under Windows (using the same reference video
source), and then compared the register programming (via some scripts
I whipped up).  There were some other registers that were different,
but the only one that made *any* visible difference in the output was
the AA flag.

> The visible effects of the anti-alais filter could possibly be:
>
> 1. Less range of color, if high freqs of the color get attenuated.
> (Most people likely will not perceive this as most people are not that
> sensitive to small color variations.)
>
> 2. Loss of rapid variations in Luma - softer edges between light and
> dark areas on a scan line - if higher freqs of the Luma get attenuated.
>
> but given that the anti-alais filter is essentially flat out to about
> 5.6 MHz and has a slow rolloff (only 3 dB down at about 6.9 MHz), I
> doubt anyone would ever notice it is on with NTSC.

To give you a better idea of what I'm talking about, look at this image:

http://imagebin.org/83458

The above image was taken with the generator via the s-video input
(ruling out the possibility that it's any sort of product of
intermodulation).

For the sake of comparison, here's the exact same signal source
against an a similar em28xx design but with the tvp5150.

http://imagebin.org/83459

> Since you have a signal generator, you should run experiments with PAL-D
> and SECAM-D with a grid containing vertical lines since those both have
> a 6.0 MHz video bandwidth.  SECAM also has FM color, so you might see
> the greatest affect of an antialias filter on color on the Cyan color
> bar in SECAM-D.

Believe it or not, I'm actually having trouble with the generator
right now with anything but NTSC.  I'm going back and forth with
Promax on repair options.  So I cannot do any PAL or SECAM testing
right now.

On a separate note, I really should look at extending the v4l2
capture-example to a version that let's me do a direct capture of the
YUYV frame and convert the output into a zero-loss RGB format.  It's
too easy to be mislead by things the applications are doing like
deinterlacing, rescaling, blending, and compression of the screenshot
when saving to a file.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

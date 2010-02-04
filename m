Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:57311 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131Ab0BDPYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 10:24:53 -0500
Received: by fxm20 with SMTP id 20so2659726fxm.1
        for <linux-media@vger.kernel.org>; Thu, 04 Feb 2010 07:24:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265248280.3122.74.camel@palomino.walls.org>
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
	 <1265248280.3122.74.camel@palomino.walls.org>
Date: Thu, 4 Feb 2010 10:24:51 -0500
Message-ID: <829197381002040724u6a8d3b40m6e9f3751640685f4@mail.gmail.com>
Subject: Re: Any saa711x users out there?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 3, 2010 at 8:51 PM, Andy Walls <awalls@radix.net> wrote:
> With all that said, if you have a baseband Luma or Chroma signal with
> strong spurious high frequency components (crappy source, or you're
> overdriving the front end and getting intermods), then keep the
> anti-alias filter turned on as the assumption of a bandlimited input
> signal is violated in this case.

In this case, I'm seeing it with both the analog signal generator
(which one might consider a fairly pristine source), as well coming
off the s-video output of a DirectTV box (in which case the signal is
being generated only a few feet away from the saa7113).

> In the SAA7113 the anti-alias filter introduces a delay of 50 ns.  At
> 13.5 Mpixels/sec, or 74.1 ns/pixel, that's less than 1 pixel time of
> delay.
>
> Just turn it on in and leave it on in the SAA7113 to handle the
> unexpected input signal case.

This would be my vote (assuming we try it with the other parts and
confirm no regressions are introduced).  My only concern is the way
the code is currently written, the saa7113 initialization block
actually does enable it by default, and then some code for the saa7115
tramples the register, turning it off (see saa7115_init_misc at
saa7115.c:600).  I think the decision we have to make is which of the
following paths to take:

1.  Enable it in the saa7115_init_misc, thereby enabling it for the
7113, 7114, and 7115.

2.  Exclude the saa7115_init_misc block from being run at all against the 7113

3.  Let the saa7115_init_misc block get run, and then flip the bit
back for the 7113.

My thinking at this point is that the AA filter should probably be on
by default regardless of the chip, in which case we would just need to
make the one line change to enable it in the saa7115_init_misc block.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

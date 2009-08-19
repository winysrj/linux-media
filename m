Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:36624 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbZHSWmk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 18:42:40 -0400
Subject: Re: Hauppauge 2250 - second tuner is only half working
From: Andy Walls <awalls@radix.net>
To: seth@cyberseth.com
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
In-Reply-To: <41128.76.104.173.166.1250691148.squirrel@www.cyberseth.com>
References: <35375.76.104.173.166.1250492844.squirrel@www.cyberseth.com>
	 <4A8A9D33.5050505@kernellabs.com>
	 <41128.76.104.173.166.1250691148.squirrel@www.cyberseth.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 18:41:12 -0400
Message-Id: <1250721672.2716.21.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-08-19 at 07:12 -0700, seth@cyberseth.com wrote:
> >> I'd really appreciate any help or guidance on this problem as i'm fully
> >> perplexed by it.
> >
> > Hey Seth,
> >
> > I ran the same tests on my cable system (channel 103) on 669Mhz and had no
> > issue, and my snr's reported as (0x172 and 0x17c).
> >
> > One possibility is that you're overwhelming the frontend. Try adding a
> > small
> > mount of attenuation to the signal for test purposes.
> >
> > Hard to believe but this is where I'd start looking.
> >
> > --
> > Steven Toth - Kernel Labs
> > http://www.kernellabs.com
> >
> >
> 
> Thank you for reply!  Hearing that the same frequency works on another
> card is pretty positive confirmation in my mind that this is a
> hardware/setup issue.  I tried stopping by a local radio shack last night,
> but wouldn't you know they no longer carried simple attenuators.  Looks
> like i'll be picking one up online (or maybe ill lookup a schematic online
> and try building a simple one).


You can build a bridged-T, they are pretty simple.

                Z
                  2
      +--------/\/\/\-------+
      |                     |
      |     Z         Z     |
      |      0         0    |
 V ---+--/\/\/\--+--/\/\/\--+---- V
  i              |                 o
                 >
                 > Z
                 >   1
   |             |              |
   =             =              =


Assuming that the source impedance and load impedance (not shown) are
also Z0 (e.g. 75 ohms) then

Z   = a Z
 1       0

      Z
       0
Z   = --
 2     a 
    
 

V
 o      1
-- =  -----
V         1
 i    1 + -
          a

                           V
                            o
Power Gain in dB = 20 log ----
                           V
                            i


So pick an attenuation that you want to achieve, and that tells you "a".
"a" will tell you the resistor values you need.  Then try and pick ones
that are close.

All this of course assumes I created and solved my system of equations
without making an error. 


Regards,
Andy

> On a side note - Thank you very much for hacking on the saa7164 - other
> than this frequency glitch its been working great for me!



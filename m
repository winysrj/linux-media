Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41217 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab0ISPtX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 11:49:23 -0400
Received: by eyb6 with SMTP id 6so1385834eyb.19
        for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 08:49:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinAdXQ0Q9a8Z2ZP91ALh65CHBO2YSRAYVqEPE9f@mail.gmail.com>
References: <AANLkTimt5bs1fNp=+36VLaTy0Kwi1rDPcpUTeN4z+c35@mail.gmail.com>
	<1284677325.2056.17.camel@morgan.silverblock.net>
	<AANLkTinddFfzQtaW_gUqi18OSPn437JTFiRa1HKM8Nva@mail.gmail.com>
	<1284812434.2053.28.camel@morgan.silverblock.net>
	<AANLkTi=HzqGW6qLxhTXprNW03LsnGjZ4Cg_PC=Wspv1A@mail.gmail.com>
	<AANLkTimX0-oLk2j5YTE_WeU1SCz=k2dH6SsjP1PReyuK@mail.gmail.com>
	<AANLkTimAojFoi2=o=7REycqy9RowYsbZY=oB83Sb-pyV@mail.gmail.com>
	<AANLkTinAdXQ0Q9a8Z2ZP91ALh65CHBO2YSRAYVqEPE9f@mail.gmail.com>
Date: Sun, 19 Sep 2010 11:49:22 -0400
Message-ID: <AANLkTimjUurkOGjeLzukibSBL-ztFT041KUacLzRiEmE@mail.gmail.com>
Subject: Re: HVR 1600 Distortion
From: Josh Borke <joshborke@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Sep 18, 2010 at 11:06 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sat, Sep 18, 2010 at 9:09 PM, Josh Borke <joshborke@gmail.com> wrote:
>> It could be the tuner card, it is over 2 years old...Why would the
>> analog tuner stop functioning while the digital tuner continues to
>> work?  Is it because the analog portion goes through a different set
>> of chips?
>
> Yes, the analog portion of the card has a completely separate tuner
> and demodulator.
>
> Don't get me wrong, it's possible that this is a driver issue, but
> given Andy has the exact same can tuner on his board it probably makes
> sense for you to do a sanity test of the hardware before any more time
> is spent investigating the software.
>
> Cheers,
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

I plugged it in to a windows machine and it has the same effect :(
I'm going to say the card is fubar and I'll need to find a
replacement.

Thanks for the help everyone!

-josh

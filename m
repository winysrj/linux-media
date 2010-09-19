Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51892 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0ISDGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 23:06:39 -0400
Received: by ewy23 with SMTP id 23so1333402ewy.19
        for <linux-media@vger.kernel.org>; Sat, 18 Sep 2010 20:06:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimAojFoi2=o=7REycqy9RowYsbZY=oB83Sb-pyV@mail.gmail.com>
References: <AANLkTimt5bs1fNp=+36VLaTy0Kwi1rDPcpUTeN4z+c35@mail.gmail.com>
	<1284677325.2056.17.camel@morgan.silverblock.net>
	<AANLkTinddFfzQtaW_gUqi18OSPn437JTFiRa1HKM8Nva@mail.gmail.com>
	<1284812434.2053.28.camel@morgan.silverblock.net>
	<AANLkTi=HzqGW6qLxhTXprNW03LsnGjZ4Cg_PC=Wspv1A@mail.gmail.com>
	<AANLkTimX0-oLk2j5YTE_WeU1SCz=k2dH6SsjP1PReyuK@mail.gmail.com>
	<AANLkTimAojFoi2=o=7REycqy9RowYsbZY=oB83Sb-pyV@mail.gmail.com>
Date: Sat, 18 Sep 2010 23:06:38 -0400
Message-ID: <AANLkTinAdXQ0Q9a8Z2ZP91ALh65CHBO2YSRAYVqEPE9f@mail.gmail.com>
Subject: Re: HVR 1600 Distortion
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Josh Borke <joshborke@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Sep 18, 2010 at 9:09 PM, Josh Borke <joshborke@gmail.com> wrote:
> It could be the tuner card, it is over 2 years old...Why would the
> analog tuner stop functioning while the digital tuner continues to
> work?  Is it because the analog portion goes through a different set
> of chips?

Yes, the analog portion of the card has a completely separate tuner
and demodulator.

Don't get me wrong, it's possible that this is a driver issue, but
given Andy has the exact same can tuner on his board it probably makes
sense for you to do a sanity test of the hardware before any more time
is spent investigating the software.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com

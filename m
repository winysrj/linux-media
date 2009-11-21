Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35760 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZKUTZE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 14:25:04 -0500
Received: by ewy19 with SMTP id 19so627783ewy.21
        for <linux-media@vger.kernel.org>; Sat, 21 Nov 2009 11:25:10 -0800 (PST)
Date: Sat, 21 Nov 2009 20:25:05 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: g_remlin <g_remlin@rocketmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: CH???, Bandwidth 8MHz, Fec_Hi 1/2, Modulation QAM64, Mode 8K,
 Guard 1/4, fails to tune\demux
In-Reply-To: <4B082F2B.6070700@rocketmail.com>
Message-ID: <alpine.DEB.2.01.0911211932420.6168@ybpnyubfg.ybpnyqbznva>
References: <4B06F484.5050700@rocketmail.com> <alpine.DEB.2.01.0911211443110.6168@ybpnyubfg.ybpnyqbznva> <4B082F2B.6070700@rocketmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Nov 2009, g_remlin wrote:

> Hi Barry, thanks for taking the time to reply (my previous more informative

Happy to have helped, even though I didn't help.


> This is the Terrestrial transmission standard being rolled out across the UK,

Ah.  I assumed `CH' referred to the country, and the FEC of 1/2
being that used for a robust yet low-bandwidth signal.

Actually, there are a couple steps to the DSO in the UK, with the
introduction in less than two weeks of the DVB-T2 standard at a
few places, to allow HD broadcasts with some 36 or so Mbit/sec.

This introduction will be taking place without any consumer
equipment until next year, and cannot be received by existing
hardware, as has been asked a few times on these lists.  In
the areas where this happens (apart from places like Crystal
Palace) this is happening by converting one multiplex from
DVB-T to -T2.

You probably are referring to the other part of DSO, which has
meant the conversion from 2k to 8k transmission mode, and the
use of 64QAM modulation.


> I live in one of the first areas to be upgraded to the new standard. Since the
> change, my DVB-T PCI card will no longer tune (despite the signal level being

Once again I'll point out what in your Subject: is likely wrong,
as these are not the values I know to be used in the UK:
``Subject : Re: CH???, Bandwidth 8MHz, Fec_Hi 1/2, Modulation QAM64, Mode 8K,
          Guard 1/4, fails to tune\demux''

First off, the 1/2 FEC isn't used as that is used for a robust
signal, as one would want from Handy-TV (DVB-H), and in the UK
with its history of over-the-air broadcasting and rooftop aerials
means that 2/3 and 3/4 are what I see listed (although the data
I'm looking at appears to be pre-8k switchover).

Also, the guard interval would not be 1/4 as the UK makes use of
MFN frequencies, and this appears reflected in the value of 1/32
listed in the old data.

You might try to re-scan with the above values corrected, if this
would be a reason why you can't lock onto a signal.


thanks,
barry bouwsma

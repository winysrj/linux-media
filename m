Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:39093 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473AbZLIWpa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 17:45:30 -0500
Received: by ewy1 with SMTP id 1so4954219ewy.28
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 14:45:36 -0800 (PST)
Date: Wed, 9 Dec 2009 23:45:26 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Newsy Paper <newspaperman_germany@yahoo.com>
cc: linux-media@vger.kernel.org
Subject: Re: no locking on dvb-s2 22000 2/3 8PSK transponder on Astra 19.2E
 with tt s2-3200
In-Reply-To: <211341.40316.qm@web23206.mail.ird.yahoo.com>
Message-ID: <alpine.DEB.2.01.0912092327210.1055@ybpnyubfg.ybpnyqbznva>
References: <211341.40316.qm@web23206.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 9 Dec 2009, Newsy Paper wrote:

> no matter if I use Igors or Manus driver, there's no lock on 11303 h 22000 2/3 8psk. Other users at vdr-portal report same problem.
> 
> The strange thing is that all other transponders that use 22000 2/3 8psk do work but this transponder doesn't. It worked fine until december 3rd when uplink moved to Vienna. I think they changed a parameter like rolloff or inversion and the dvb-s2 part of stb6100 is buggy.

Oh jeez, non-wrapping mail...  Anyway, without bothering to see
what I'm replying to, here's the value I get from parsing the
NIT table today:

                  Frequency: 18023029 (=  11.30275 GHz)
                  Orbital_position: 402 (=  19.2)
                  West_East_flag: 1 (0x01)  [= EAST]
                  Polarisation: 0 (0x00)  [= linear - horizontal]
                  Kind: 1 (0x01)  [= DVB-S2]
                  Roll Off Faktor: 0 (0x00)  [= Alpha 0.35]
                  Modulation_type: 2 (0x02)  [= 8PSK]
                  Symbol_rate: 2228224 (=  22.0000)
                  FEC_inner: 2 (0x02)  [= 2/3 conv. code rate]



Now, I get the following for a different transponder, with a
different roll-off:

                  Frequency: 17920117 (=  11.17075 GHz)
                  Orbital_position: 402 (=  19.2)
                  West_East_flag: 1 (0x01)  [= EAST]
                  Polarisation: 0 (0x00)  [= linear - horizontal]
                  Kind: 1 (0x01)  [= DVB-S2]
                  Roll Off Faktor: 1 (0x01)  [= Alpha 0.25]
                  Modulation_type: 2 (0x02)  [= 8PSK]
                  Symbol_rate: 2228224 (=  22.0000)
                  FEC_inner: 2 (0x02)  [= 2/3 conv. code rate]


But at the same time I see the same roll-off reported on all
but the 0,25 transponder within the limited NIT table I
nabbed, regardless of 9/10 FEC or 2/3+22000.

I don't know if the above NIT data is 100% accurate, or if
it reflects a change from what it was before.  Actually, I
don't know if I'm parsing everything, because I vaguely
recall there are other selectable options on a real receiver
(which I've never had in front of me) pertaining to pilot
on or off, which apparently affect tuning ability.


barry bouwsma

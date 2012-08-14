Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51448 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab2HNMF5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 08:05:57 -0400
Received: by weyx8 with SMTP id x8so187484wey.19
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 05:05:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502A1221.8020804@gmx.de>
References: <502A1221.8020804@gmx.de>
Date: Tue, 14 Aug 2012 17:35:55 +0530
Message-ID: <CAHFNz9KnwKuATLKwhH22znmWa8QP5tZN0KJHFu4fuf7RGES1Gw@mail.gmail.com>
Subject: Re: STV0299: reading property DTV_FREQUENCY -- what am I expected to get?
From: Manu Abraham <abraham.manu@gmail.com>
To: Reinhard Nissl <rnissl@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Aug 14, 2012 at 2:23 PM, Reinhard Nissl <rnissl@gmx.de> wrote:
> Hi,
>
> it seems that my 9 years old LNBs got some drift over time, as tuning takes
> quite a while until I get a lock. So I thought I could compensate this
> offset by adjusting VDR's diseqc.conf.
>
> Therefore I first hacked some logging into VDR's tuner code to read and
> output the above mentioned property once it got a lock after tuning. As
> VDR's EPG scanner travels over all transponders when idle, I get offset
> values for all transponders and can then try to find some average offset to
> put into diseqc.conf.
>
> So here are several "travel" results for a single transponder ordered by
> Delta:
>
> Sat.    Pol.    Band    Freq (MHz) Set  Freq (MHz) Get  Delta (MHz)
> S13,0E  H       H       11938   11930,528       -7,472
> S13,0E  H       H       11938   11936,294       -1,706
> S13,0E  H       H       11938   11938,917       0,917
> S13,0E  H       H       11938   11939,158       1,158
> S13,0E  H       H       11938   11939,906       1,906
> S13,0E  H       H       11938   11939,965       1,965
> S13,0E  H       H       11938   11940,029       2,029
> S13,0E  H       H       11938   11940,032       2,032
> S13,0E  H       H       11938   11940,103       2,103
> S13,0E  H       H       11938   11940,112       2,112
> S13,0E  H       H       11938   11940,167       2,167
> S13,0E  H       H       11938   11941,736       3,736
> S13,0E  H       H       11938   11941,736       3,736
> S13,0E  H       H       11938   11941,736       3,736
> S13,0E  H       H       11938   11942,412       4,412
> S13,0E  H       H       11938   11943,604       5,604
> S13,0E  H       H       11938   11943,604       5,604
> S13,0E  H       H       11938   11943,604       5,604
> S13,0E  H       H       11938   11945,472       7,472
> S13,0E  H       H       11938   11945,472       7,472
> S13,0E  H       H       11938   11945,472       7,472
> S13,0E  H       H       11938   11945,472       7,472
> S13,0E  H       H       11938   11945,472       7,472
> S13,0E  H       H       11938   11945,472       7,472
> S13,0E  H       H       11938   11945,472       7,472
> S13,0E  H       H       11938   11945,777       7,777
> S13,0E  H       H       11938   11945,777       7,777
> S13,0E  H       H       11938   11945,777       7,777
> S13,0E  H       H       11938   11945,777       7,777
>
> I really wonder why Delta varies that much, and there are other transponders
> in the same band which have no larger deltas then 3 MHz.


The LNB drift is due to the cheap RC oscillator in standard LNB's which are
temperature dependant. So, the oscillator frequency that you might experience
at mid-day, might not be same as that at midnight. The capacitors are ceramic
capacitors, so there isn't likely the chance of the capacitor changing
it's value
too much over time, but there exists other issues such as parasitic
capacitances
when the LNB shell looses it's hermetic seal.

I have seen the drift overlapping another transponder with the stv0299 in some
scenarios, but don't see how this can be fixed reliably.

>
> So is it at all possible to determine LNB drift in that way?
>
> My other device, a STB0899, always reports the set frequency. So it seems
> driver dependent whether it reports the actually locked frequency found by
> the zig-zag-algorithm or just the set frequency to tune to.


The STV0299 blindly sets the value based on a software zigzag (due to simpler
hardware), but this might not be accurate enough. On the other hand, the
STB0899 internally does zig-zag in hardware for DVB-S2, and partly in
software for DVB-S.

In any event, the get_frontend callback should return the value that is read
from the demodulator registers, rather than the cached original value that
which was requested to be tuned.

The stb0899 returns only the cached value IIRC. Maybe I will fix this soon,
or maybe you can send a patch.

Regards,
Manu

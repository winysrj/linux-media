Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab2HLBY7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 21:24:59 -0400
Message-ID: <502705E0.2050106@redhat.com>
Date: Sat, 11 Aug 2012 22:24:48 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Q: c->bandwidth_hz = (c->symbol_rate * rolloff) / 100
References: <5026F74F.5060606@iki.fi>
In-Reply-To: <5026F74F.5060606@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

Em 11-08-2012 21:22, Antti Palosaari escreveu:
> Hellou
> 
> I saw there is nowadays logic in dvb-frontend which calculates bandwidth_hz value in cache. Calculation formula seems to be correct. But that makes me wonder if that is wise as it gives occupied bandwidth instead of nominal. For example I have typical DVB-C annex A, 8 MHz bandwidth, symbol rate 6875000 and roll-off factor 0.15. That gives calculation result is 7 906 250 Hz for nominal 8 000 000 Hz channel.
> 
> This value is used only by tuner. Only visible effect is thus every tuner driver should use if statement to compare to find out nominal value as tuner chips usually configures low-pass filter steps of 8/7/6/5 MHz.
> 
> For me it sounds better if tuner just gets nominal bandwidth - maybe calculating real used bw could be nice too as it is possible to return userspace.
> 
> Shortly: I see it better to give nominal RF channel value for tuner.

That's a good point. I had the same kind of doubt when I fixed DVB-C with 6MHz
bandwidth.

On all tuners I know, the saw filter can be configured only with a multiple of 
1 MHz steps, but assuming that this will always be true seems a bad practice. 
For example one of the possible bandwidth ranges for DVB-T2 is now 1.712 MHz.

Also, it should be noticed that nothing prevents a cable operator to have low res 
channels using a 1.712 MHz bandwidth space, or some non-standard spacing.
If you take a look at the symbol rates used on w_scan, you'll see that there
are some weird values there (most of them using 1.15 roll-off factor):

       -S      set DVB-C symbol rate, see table:
                       0  = 6.9000 MSymbol/s
                       1  = 6.8750 MSymbol/s
                       2  = 6.9565 MSymbol/s
                       3  = 6.9560 MSymbol/s
                       4  = 6.9520 MSymbol/s
                       5  = 6.9500 MSymbol/s
                       6  = 6.7900 MSymbol/s
                       7  = 6.8110 MSymbol/s
                       8  = 6.2500 MSymbol/s
                       9  = 6.1110 MSymbol/s
                       10 = 6.0860 MSymbol/s
                       11 = 5.9000 MSymbol/s
                       12 = 5.4830 MSymbol/s
                       13 = 5.2170 MSymbol/s
                       14 = 5.1560 MSymbol/s
                       15 = 5.0000 MSymbol/s
                       16 = 4.0000 MSymbol/s
                       17 = 3.4500 MSymbol/s

On the above, you'll see bandwidths of 3.96 MHz, 4.6 MHz, 5,75 MHz, etc.
Just rounding it up to the next integer value might not be the right thing
to do, especially if the cable operator is not spacing channels on a multiple
of 1 MHz channel table.

So, a DVB-T2 capable tuner that supports such narrow bandwidth may allow 
using a fractional MHz stepping for the saw filter.

Thinking on theese, I opted to do the step rounding inside the drivers, and not
at the DVB core.

The way it is coded, userspace programs can round it up to the next closest
bandwidth, in order to show 7,9 MHz as 8 MHz, and Kernel drivers can round
it to the closest supported saw filter.

Regards,
Mauro

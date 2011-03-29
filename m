Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:33992 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752180Ab1C2UL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 16:11:57 -0400
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Tue, 29 Mar 2011 22:11:52 +0200
From: handygewinnspiel@gmx.de
In-Reply-To: <4D90D78F.7050308@redhat.com>
Message-ID: <20110329201152.282620@gmx.net>
MIME-Version: 1.0
References: <4D909B59.9040809@redhat.com> <20110328172045.64750@gmx.net>
 <4D90D78F.7050308@redhat.com>
Subject: Re: [w_scan PATCH] Add Brazil support on w_scan
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Em 28-03-2011 14:20, handygewinnspiel@gmx.de escreveu:
> > Hi Mauro,
> > 
> >> This patch adds support for both ISDB-T and DVB-C @6MHz used in
> >> Brazil, and adds a new bit rate of 5.2170 MSymbol/s, found on QAM256
> >> transmissions at some Brazilian cable operators.
> > 
> > Good. :)
> > 
> >> While here, fix compilation with kernels 2.6.39 and later, where the
> >> old V4L1 API were removed (so, linux/videodev.h doesn't exist anymore).
> >> This is needed to compile it on Fedora 15 beta.
> > 
> > videodev.h should have never been in there. Was already reported and
> will be removed instead.
> > 
> >> @@ -1985,6 +1986,10 @@
> >>  		dvbc_symbolrate_min=dvbc_symbolrate_max=0;
> >>  		break;
> >>  	case FE_QAM:
> >> +		// 6MHz DVB-C uses lower symbol rates
> >> +		if (freq_step(channel, this_channellist) == 6000000) {
> >> +			dvbc_symbolrate_min=dvbc_symbolrate_max=17;
> >> +		}
> >>  		break;
> >>  	case FE_QPSK:
> >>  		// channel means here: transponder,
> > 
> > This one causes me headache, because this one has side-effects to all
> other DVB-C cases using 6MHz bandwidth.
> > Are there *any cases* around, where some country may use DVB-C with
> symbolrates other than 5.217Mbit/s?
> 
> If you take a look at EN 300 429[1], The DVB-C roll-off factor (alpha) is
> defined as 0.15.
> 
> 	[1] EN 300 429 V1.2.1 (1998-04), chapter 9, page 16, and table B.1
> 
> So, the amount of the needed bandwidth (e. g. the Nyquist cut-off
> frequency) is given by:
>   Bw = Symbol_rate * (1 + 0.15)
> 
> E. g. the maximum symbol rate is given by:
> 
> 	Symbol_rate(6MHz) = 6000000/1.15 = 5217391.30434782608695652173
> 	Symbol_rate(7MHz) = 7000000/1.15 = 6086956.52173913043478260869
> 	Symbol_rate(8MHz) = 8000000/1.15 = 6956521.73913043478260869565
> 
> As you see, for Countries using 6MHz bandwidth, the maximum value is about
> 5.127 Mbauds.
> With the current w_scan logic of assuming 6.9 or 6.875 Mbauds by default
> for DVB-C, 
> w_scan will never find any channel, if the channel bandwidth fits into a
> 6MHz (or 7MHz)
> channel spacing.
> 
> So, the above change won't cause regressions, although it could be
> improved.



If w_scan assumes that every 6MHz cable network, also outside Brazil, will use it's maximum theoretical symbol rate *only* like your patch was implemented, it will probably fail as well, because in practice lower values are used.

Your patch disabled the looping through different symbol rates for any 6MHz network; therefore i was asking.

So I changed it now to scan any srate for 6MHz networks, but skip over those which are unsupported by bandwidth limitation.


> 
> IMHO, a different logic could be used instead, if the user doesn't use the
> -S parameter, like:
> 
> int dvbc_symbolrate[] = {
> 	7000000,
> 	6956500,		/* Max Symbol rate for 8 MHz channel bandwidth */
> 	6956000,
> 	6952000,
> 	6950000,
> 	6900000,
> 	6875000,
> 	6811000,
> 	6790000,
> 	6250000,
> 	6111000,
> 
> 	/* Weird: I would expect 6086 or 6086.5 here, as the max rate for 7MHz
> spacing */
> 			
> 	5900000,		/* Require at least 7 MHz channel bandwidth */
> 	5483000,
> 	5217000,		/* Max Symbol rate for 6 MHz channel bandwidth */
> 	5156000,
> 	5000000,
> 	4000000,
> 	3450000,
> };
> 
> for (i = 0; i < ARRAY_SIZE(dvbc_symbolrate)) {
> 	if (freq_step(channel, this_channellist) / 1.15 > dvbc_symbolrate[i])
> 		next;
> 
> 	/* Scan channel */
> ...
> }
> 

Doesnt look reasonable, since every DVB-C scan would take easily several hours this way.

Sorting into groups makes sense, one per bandwidth, but with the widely used first for each group is better. And still limit to common used srates -> done.


So, it's included now, but i changed the whole stuff a little. 
-- 
GMX DSL Doppel-Flat ab 19,99 Euro/mtl.! Jetzt mit 
gratis Handy-Flat! http://portal.gmx.net/de/go/dsl

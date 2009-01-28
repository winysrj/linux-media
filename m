Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:62389 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZA1CRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 21:17:09 -0500
Received: by ewy14 with SMTP id 14so2525116ewy.13
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 18:17:05 -0800 (PST)
Date: Wed, 28 Jan 2009 03:16:57 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Tobias Stoeber <tobi@to-st.de>
cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
In-Reply-To: <497F8EB1.2050004@to-st.de>
Message-ID: <alpine.DEB.2.00.0901280248130.15738@ybpnyubfg.ybpnyqbznva>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <497A27F7.8020201@to-st.de> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com> <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
 <497EC855.7050301@to-st.de> <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com> <497EF972.6090207@to-st.de> <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva> <497F8EB1.2050004@to-st.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Tobias Stoeber wrote:

> > In reality, when I've been in a new location and done a scan
> > without knowing transmitter site details, I've just used a
> > general purpose scanfile I've created which goes from 474 in
> > 8MHz steps up to 850 or so, like
> > ### Kanal 68 UHF
> > T 850000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
> 
> So why then not provide a generic scan file listing all freq with AUTO
> parameters?

It's a nice idea, but apparently there are some devices which
do require particular values and don't work with `AUTO'.

Also, it will take some time to scan all these frequencies,
so I prefer to limit it where possible to known and nearby
in-use frequencies, rather than waiting half an hour to see
that just one frequency tunes.

And third, while it's the case for germany and most if not
all nearby countries, that the actual frequency in MHz will
be divisible by two (except for the few remaining VHF) and
have no fractional MHz values, this is not the same in all
countries where DVB-T is in use.

That could be due to the pretty much hard switchover/off
having largely happened, with no or a coordinated simulcast,
while other areas have to play with offsets, but I'm not so
familiar with the status and progress of switchover
everywhere.

There are apparently also some devices which need to have
any offset specified precisely, or they can't tune to that
particular frequency.


Anyway, one of my reasons for creating my version of de-BW
was not only to list the frequencies, but also to provide
info as I absorbed it about the transmitter sites and more,
that you wouldn't get in a generic universal frequency list.
That was prompted by an interest in trying to get my head
around the GE06 frequency plan and allocations, which would
also mean I'd need to try and understand the planning of the
SFNs.  That file can be shrunk and expanded by the use of
comments to make it more relevant to a particular area --
if you're basking on the Bodensee, you don't need to know
anything about France, Hessen, or some 2/3 of all the
frequencies scattered throughout the B-W file, and my
comments should make that easy.

After all, it wasn't until you pointed me to the first pdf
list that I was aware that QAM64 was in use in germany, save
for bleed out of france, and it will be interesting once I
get around to noting the transmitter sites on a printed map.


barry bouwsma

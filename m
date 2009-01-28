Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:43769 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbZA1AME (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 19:12:04 -0500
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
From: hermann pitton <hermann-pitton@arcor.de>
To: tobi@to-st.de
Cc: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
In-Reply-To: <497F8EB1.2050004@to-st.de>
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>
	 <497A27F7.8020201@to-st.de>
	 <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva>
	 <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>
	 <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>
	 <497EC855.7050301@to-st.de>
	 <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com>
	 <497EF972.6090207@to-st.de>
	 <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
	 <497F8EB1.2050004@to-st.de>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 01:12:30 +0100
Message-Id: <1233101550.2687.53.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Dienstag, den 27.01.2009, 23:46 +0100 schrieb Tobias Stoeber:
> Hi all,
> 
> I've just conducted a little test using the de-Sachsen-Anhalt scan file. 
>   As expected, only 3 lines actually worked (those muxes transmitted 
> from Mt. Brocken).
> 
> The line for 498 Mhz (Ch24 Halle-Saale), which is
> 
> T 498000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH24: Das Erste, arte, 
> Phoenix, EinsFestival
> 
> does actually tune to the Ch 24 from Braunschweig, but fails to 
> recognize the stations there, because of QAM64:
> 
>  >>> tune to: 
> 498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010
> 
> Using the correct setting of QAM16 gives:
> 
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>  >>> tune to: 
> 498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> 0x0000 0x4015: pmt_pid 0x0150 RTL World -- RTL Television (running)
> 0x0000 0x4016: pmt_pid 0x0160 RTL World -- RTL2 (running)
> 0x0000 0x4017: pmt_pid 0x0170 RTL World -- Super RTL (running)
> 0x0000 0x4022: pmt_pid 0x0220 RTL World -- VOX (running)
> 
> Both testes 10 times....
> 
> BOUWSMA Barry schrieb:
> >>=> Does it matter, e.g. would instead of the unreceivable Ch24 from 
> >>Halle-Stadt the Braunschweig Ch24 be found? (I did not test this).
> > 
> > This all depends on the device.  At least some of my tuners
> > effectively will lock a signal as if I've specified `AUTO'
> > in place of everything, even when what I specify is wrong.
> 
> So for my Yakumo DVB-T stick it does matter :(
> 
> > In reality, when I've been in a new location and done a scan
> > without knowing transmitter site details, I've just used a
> > general purpose scanfile I've created which goes from 474 in
> > 8MHz steps up to 850 or so, like
> > ### Kanal 68 UHF
> > T 850000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO
> 
> So why then not provide a generic scan file listing all freq with AUTO 
> parameters?
> 
> Regards, Tobias

yes, that is to what Christoph pointed his hopes too.

But for what is on the markets, and no end in sight, some/many need it
exactly, some manage to come through a mixture of exactly and auto,
which also breaks such auto capable for more if something is wrong
there.

Currently I would give the so far last word on it to the maintainer of
that mess, but I'm not against Barry and would even consider a "all
known universe" scan file including neighboring countries, if this
doesn't mean Christoph has it on his back too.

The reverse effect will be, we have it already with federal state scan
files now, that we likely will see more questions about why the hell I
don't get this one and tuning failed ... 

To share a center frequency over several federal states under such
conditions seems to be plain wrong and I wonder if there was a rule.

Cheers,
Hermann
 


Return-path: <linux-media-owner@vger.kernel.org>
Received: from ayden.softclick-it.de ([217.160.202.102]:55802 "EHLO
	ayden.softclick-it.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZA0Wp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 17:45:29 -0500
Message-ID: <497F8EB1.2050004@to-st.de>
Date: Tue, 27 Jan 2009 23:46:09 +0100
From: Tobias Stoeber <tobi@to-st.de>
Reply-To: tobi@to-st.de
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
CC: linux-media@vger.kernel.org,
	"DVB mailin' list thingy" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva> <497A27F7.8020201@to-st.de> <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva> <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com> <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva> <497EC855.7050301@to-st.de> <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com> <497EF972.6090207@to-st.de> <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've just conducted a little test using the de-Sachsen-Anhalt scan file. 
  As expected, only 3 lines actually worked (those muxes transmitted 
from Mt. Brocken).

The line for 498 Mhz (Ch24 Halle-Saale), which is

T 498000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE # CH24: Das Erste, arte, 
Phoenix, EinsFestival

does actually tune to the Ch 24 from Braunschweig, but fails to 
recognize the stations there, because of QAM64:

 >>> tune to: 
498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010

Using the correct setting of QAM16 gives:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
 >>> tune to: 
498000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
0x0000 0x4015: pmt_pid 0x0150 RTL World -- RTL Television (running)
0x0000 0x4016: pmt_pid 0x0160 RTL World -- RTL2 (running)
0x0000 0x4017: pmt_pid 0x0170 RTL World -- Super RTL (running)
0x0000 0x4022: pmt_pid 0x0220 RTL World -- VOX (running)

Both testes 10 times....

BOUWSMA Barry schrieb:
>>=> Does it matter, e.g. would instead of the unreceivable Ch24 from 
>>Halle-Stadt the Braunschweig Ch24 be found? (I did not test this).
> 
> This all depends on the device.  At least some of my tuners
> effectively will lock a signal as if I've specified `AUTO'
> in place of everything, even when what I specify is wrong.

So for my Yakumo DVB-T stick it does matter :(

> In reality, when I've been in a new location and done a scan
> without knowing transmitter site details, I've just used a
> general purpose scanfile I've created which goes from 474 in
> 8MHz steps up to 850 or so, like
> ### Kanal 68 UHF
> T 850000000 8MHz AUTO AUTO AUTO AUTO AUTO AUTO

So why then not provide a generic scan file listing all freq with AUTO 
parameters?

Regards, Tobias

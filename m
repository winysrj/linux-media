Return-path: <mchehab@pedra>
Received: from auth-1.ukservers.net ([217.10.138.154]:43367 "EHLO
	auth-1.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0JLWI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 18:08:56 -0400
Message-ID: <DAB476FE34F842CE88B2D2387D4239EF@telstraclear.tclad>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: "Simon Baxter" <linuxtv@nzbaxters.com>,
	<linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
References: <4EF44B7309644C7BBF72C458CF8C4F43@telstraclear.tclad> <075927E995BF46F0AAC3D433821C7D9F@telstraclear.tclad>
Subject: Re: dm1105 scan but won't tune? [RESOLVED]
Date: Wed, 13 Oct 2010 11:08:51 +1300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> OK, progress (idiot error?)
>
> My problem was OptusB1 requires a 45 degree skew on the LNB on the dish 
> itself.
>
> So now I can do an szap as follows:
> TV3:12456:h:0:22500:512:650:1920
>
> ./szap -l 11300 -c channels-conf/dvb-s/OptusD1E160 TV3
> reading channels from file 'channels-conf/dvb-s/OptusD1E160'
> zapping to 1 'TV3':
> sat 0, frequency = 12456 MHz H, symbolrate 22500000, vpid = 0x0200, apid = 
> 0x028a sid = 0x0780
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f | signal cd82 | snr be5c | ber 0000ff00 | unc fffffffe | 
> FE_HAS_LOCK
> status 1f | signal cd07 | snr be9e | ber 00000000 | unc fffffffe | 
> FE_HAS_LOCK
> status 1f | signal cd07 | snr be4a | ber 00000000 | unc fffffffe | 
> FE_HAS_LOCK
>
>
> New problem though - I can now no longer scan with the LNB skewed!!
> S 12456000 V 22500000 AUTO
> S 12456000 H 22500000 AUTO
>
> ./scan dvb-s/OptusB1-NZ -l 11300
> scanning dvb-s/OptusB1-NZ
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12456000 V 22500000 9
> initial transponder 12456000 H 22500000 9
>>>> tune to: 12456:v:0:22500
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
>>>> tune to: 12456:v:0:22500 (tuning failed)
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
>>>> tune to: 12456:h:0:22500
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
>>>> tune to: 12456:h:0:22500 (tuning failed)
> DVB-S IF freq is 1156000
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
>
> Any ideas?

Things to note when you install your own satellite dish and card:
1) Make sure you understand the LNB requirements for your satellite.  I 
needed to skew mine on the dish by 45 degrees - wasted a lot of time getting 
odd results from a vertically mounted LNB
2) Understand your LNB specs.  Mine had a 11300Mhz LSOF, which needed 
allowance for when szapping, scanning and in VDR

My system:
Fedora 13 on a dual core intel platform.
combination of DVB-C (TT-1501 and TT-2300), PVR-500 and DVB-S (dm1105 based 
and TT-1401) cards
Used on New Zealand cable TV, Freeview TV and Sky TV

my most recent fixes:
Use the '-r' switch in szap, to set the front end up for TS recording.
Use the '-l 11300' in szap to configure for the LNB
Use diseqc.conf file and "setup>LNB>DiSeqc ON" in VDR to set the LNB 
settings




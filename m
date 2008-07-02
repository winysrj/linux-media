Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1KE41R-0002Wf-E9
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 17:13:29 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Wed, 2 Jul 2008 17:12:53 +0200
References: <486A6F0F.7090507@adslpipe.co.uk> <486B9630.1080100@adslpipe.co.uk>
In-Reply-To: <486B9630.1080100@adslpipe.co.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807021712.53659.zzam@gentoo.org>
Subject: Re: [linux-dvb] [PATCH] Shrink saa7134 mmio mapped size
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mittwoch, 2. Juli 2008, Andy Burns wrote:
> The saa7134 driver attempts to map 4K starting from the base address of
> its mmio area, although lspci shows the size of the area is only 1K. The
> excessive mapping goes un-noticed on bare-metal, but is detected and
> denied when the card is used with pci passthrough to a xen domU. If
> shared IRQ is used the "pollirq" kernel option may be required in dom0.
>

I have no real insight into the saa7134 core, but at least my card does have a 
memory region of 2K.

lspci -vvnn:
00:0b.0 Multimedia controller [0480]: Philips Semiconductors SAA7133/SAA7135 
Video Broadcast Decoder [1131:7133] (rev d1)
        Subsystem: Avermedia Technologies Inc Device [1461:a7a1]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (63750ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at dfffb800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=3 PME-
        Kernel driver in use: saa7134
        Kernel modules: saa7134

Regards
Matthias

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

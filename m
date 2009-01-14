Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp120.rog.mail.re2.yahoo.com ([68.142.224.75]:38807 "HELO
	smtp120.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750707AbZANFJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 00:09:42 -0500
Message-ID: <496D7204.6030501@rogers.com>
Date: Wed, 14 Jan 2009 00:03:00 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Catimimi <catimimi@libertysurf.fr>, linux-dvb@linuxtv.org,
	Linux-media <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
References: <496CB23D.6000606@libertysurf.fr>
In-Reply-To: <496CB23D.6000606@libertysurf.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Catimimi wrote:
> Hi,
>
> As I didn't yet subscribe to the list, I reply directly to your
> discussion with Romain

sorry, I don't recall it offhand.


> in ordezr to send you the result of :
>
> lspci -vvxxx
>
> for the Pinnacle PCTV Dual Hybrid Pro PCI Express (3010i)
>
> ______________________
>
> 04:00.0 Multimedia controller: Philips Semiconductors Device 7162
>         Subsystem: Pinnacle Systems Inc. Device 0100
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 16 bytes
>         Interrupt: pin A routed to IRQ 5
>         Region 0: Memory at dde00000 (64-bit, non-prefetchable) [size=1M]
>         Capabilities: [40] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/5 Enable-
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [50] Express (v1) Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <256ns, L1 <1us
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
> TransPend-
>                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <4us, L1 <64us
>                         ClockPM- Suprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain-
> CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk-
> DLActive- BWMgmt- ABWMgmt-
>         Capabilities: [74] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [80] Vendor Specific Information <?>
> 00: 31 11 62 71 07 00 10 00 00 00 80 04 04 00 00 00
> 10: 04 00 e0 dd 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 00 01
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 00 00
> 40: 05 50 8a 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 10 74 01 00 80 00 28 00 10 00 0a 00 11 6c 03 01
> 60: 08 00 11 00 00 0a 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 01 80 02 3e 00 00 00 00 00 00 00 00
> 80: 09 00 50 00 03 0c 00 00 02 02 00 00 00 00 00 00
> 90: 00 04 00 00 00 00 00 08 00 00 10 00 00 00 00 00
> a0: 01 00 00 04 03 18 00 00 00 00 01 04 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 20 01 2a 00 00
> c0: 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> I hope it'll help.

Could you put it in the wiki if its not already contained there.  Thanks.

> I tried the driver found here : http://jusst.de/hg/saa716x
> It compiles and install, but if I try : modprobe saa716x_hybrid.ko
> I get a fatal error : module not found.
>
> I can't find any message in dmesg.

try without the ".ko", i.e. instead, use:

modprobe saa716x_hybrid

> Ready for further trials.
> Michel.



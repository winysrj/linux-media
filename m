Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62749 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab1L2KZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 05:25:29 -0500
Received: by wibhm6 with SMTP id hm6so6176808wib.19
        for <linux-media@vger.kernel.org>; Thu, 29 Dec 2011 02:25:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJZeATR2RcbhH9zNQwkHRoy4hKTK02xzk8LBwCzvkSisoZePCg@mail.gmail.com>
References: <CAJZeATR2RcbhH9zNQwkHRoy4hKTK02xzk8LBwCzvkSisoZePCg@mail.gmail.com>
Date: Thu, 29 Dec 2011 12:25:28 +0200
Message-ID: <CAF0Ff2nEtqW4DVkjS00931izKHXsTu6Y-bG+BD1ez1UR7Tminw@mail.gmail.com>
Subject: Re: Mystique SaTiX-S2 Sky Xpress DUAL card
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Andreas Mair <amair.sob@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hello Andreas,

i've checked the Linux drivers for the card you referred to and
whoever made it is breaking all the rules claiming copyright over the
whole driver adding at the beginning:

"Copyright (C) 2010 Bestunar Inc."

when they just patched the driver very slightly adding only new
initialization values - if they wish they can claim copyright only
over those small changes (even they are just number constants provided
by the chip maker). in any case that's ridiculous, because i made that
driver and the copyright notice is:

http://git.linuxtv.org/media_tree.git/blob/61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf:/drivers/media/dvb/frontends/ds3000.c

    Montage Technology DS3000/TS2020 - DVBS/S2 Demodulator/Tuner driver
    Copyright (C) 2009 Konstantin Dimitrov <kosio.dimitrov@gmail.com>

    Copyright (C) 2009 TurboSight.com

and i strongly opposed that copyright massage can be changed in the
way like they did especially over the changes they made.

also, the whole 'ds3000' driver, even it's licensed under GPL, was
submitted to the Linux kernel without my formal permission that to be
done, i.e. you can think for that as it was leaked to the Linux kernel
from third-parties and not the driver author and copyright-holder.

so, it seems to me "Bestunar Inc" is some obscure Chinese company most
probably cloning hardware rather than spent any time doing
development, which or course also don't honor the work put in
development of open-source driver for the chips they're using and try
very hard to make it look like they did it or that they did something
more significant than what they actually did. i'm sure you can
understand my position and my opinion that such companies shouldn't be
supported in any possible way.

best regards,
konstantin

On Thu, Dec 29, 2011 at 11:07 AM, Andreas Mair <amair.sob@googlemail.com> wrote:
> Hello,
>
> I'm using that card in my Linux VDR box:
> http://www.dvbshop.net/product_info.php/info/p2440_Mystique-SaTiX-S2-Sky-Xpress-DUAL--USALS--DiseqC-1-2--Win-Linux.html
>
> That's the lspci output:
> =========== SNIP =========
> $ lspci -vvvnn
> 02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
> CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
>        Subsystem: Device [4254:0952]
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at fe400000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: [40] Express (v1) Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <64ns, L1 <1us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
> AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <2us, L1 <4us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
> SlotClk+ DLActive- BWMgmt- ABWMgmt-
>        Capabilities: [80] Power Management version 2
>                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [90] Vital Product Data
>                Product Name: "
>                End
>        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [100] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
> UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
>        Capabilities: [200] Virtual Channel <?>
>        Kernel driver in use: cx23885
>        Kernel modules: cx23885
> =========== SNAP =========
>
> So this is different to what's written at
> http://linuxtv.org/wiki/index.php/Mystique_SaTiX-S2_Dual
> I guess it's more like that card: http://linuxtv.org/wiki/index.php/DVBSKY_S952
>
> I'm using the drivers found at http://www.dvbsky.net/Support.html
> (http://www.dvbsky.net/download/linux-3.0-media-20111024-bst-111205.tar.gz).
> I didn't get that card running with kernel 3.0.6 and haven't seen
> support for that card in any linuxtv.org repository I've looked into.
>
> Now I wonder:
> - Who is responsible for that drivers? Someone at DVBSky.net?
> - Is there a chance to get that drivers into the kernel?
> - Has anybody else on this list this card running?
>
> Best regards,
> Andreas
> --
> http://andreas.vdr-developer.org --- VDRAdmin-AM & EnigmaNG & VDRSymbols
> VDR user #303
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

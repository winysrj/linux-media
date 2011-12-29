Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38112 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1L2JHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 04:07:53 -0500
Received: by vbbfc26 with SMTP id fc26so10107198vbb.19
        for <linux-media@vger.kernel.org>; Thu, 29 Dec 2011 01:07:52 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 29 Dec 2011 10:07:52 +0100
Message-ID: <CAJZeATR2RcbhH9zNQwkHRoy4hKTK02xzk8LBwCzvkSisoZePCg@mail.gmail.com>
Subject: Mystique SaTiX-S2 Sky Xpress DUAL card
From: Andreas Mair <amair.sob@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm using that card in my Linux VDR box:
http://www.dvbshop.net/product_info.php/info/p2440_Mystique-SaTiX-S2-Sky-Xpress-DUAL--USALS--DiseqC-1-2--Win-Linux.html

That's the lspci output:
=========== SNIP =========
$ lspci -vvvnn
02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
        Subsystem: Device [4254:0952]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fe400000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data
                Product Name: "
                End
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt-
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt-
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: cx23885
        Kernel modules: cx23885
=========== SNAP =========

So this is different to what's written at
http://linuxtv.org/wiki/index.php/Mystique_SaTiX-S2_Dual
I guess it's more like that card: http://linuxtv.org/wiki/index.php/DVBSKY_S952

I'm using the drivers found at http://www.dvbsky.net/Support.html
(http://www.dvbsky.net/download/linux-3.0-media-20111024-bst-111205.tar.gz).
I didn't get that card running with kernel 3.0.6 and haven't seen
support for that card in any linuxtv.org repository I've looked into.

Now I wonder:
- Who is responsible for that drivers? Someone at DVBSky.net?
- Is there a chance to get that drivers into the kernel?
- Has anybody else on this list this card running?

Best regards,
Andreas
-- 
http://andreas.vdr-developer.org --- VDRAdmin-AM & EnigmaNG & VDRSymbols
VDR user #303

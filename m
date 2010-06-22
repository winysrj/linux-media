Return-path: <linux-media-owner@vger.kernel.org>
Received: from vazy.pykota.com ([92.243.13.115]:39005 "EHLO vazy.pykota.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893Ab0FVC5m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 22:57:42 -0400
Date: Tue, 22 Jun 2010 04:37:15 +0200
To: linux-media@vger.kernel.org
Subject: About Viewcast Osprey 450e
Message-ID: <20100622023715.GC14792@vazy.pykota.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
From: alet@librelogiciel.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

Over the years I've used successfully several products from Viewcast to
do video capture, most notably Osprey 100, 210, 230 and 440, as part of
the Boxtream Free Software project (http://boxtream.unice.fr)

The 440 is a 4-inputs video capture card based on BT878, and it works
flawlessly for my needs.

Now when building an instance of Boxtream based on a motherboard with
PCI express bus, I've simply thought that the Osprey 450e was identical
to the 440 but with a PCI express slot, and purchased one without asking
first...

Unfortunately I was wrong, this card is based on a different chip than
the 440, and it doesn't seem to be supported.

Here's the output of lspci -vv :

07:00.0 Multimedia video controller: Micronas Semiconductor Holding AG
Device 0720
        Subsystem: Viewcast COM Device 0032
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
        ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
        <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 15
        Region 0: Memory at df3e0000 (32-bit, non-prefetchable)
        [size=64K]
        Region 1: Memory at df3f0000 (64-bit, non-prefetchable)
        [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
                PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+
        Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
                <64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal+
                Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
                TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
                Latency L0 unlimited, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
                CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
                DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Device Serial Number 00-11-3c-20-07-00-00-00
        Capabilities: [400] Virtual Channel <?>

08:00.0 Multimedia video controller: Micronas Semiconductor Holding AG
Device 0720
        Subsystem: Viewcast COM Device 0032
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
        ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
        <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 14
        Region 0: Memory at df2e0000 (32-bit, non-prefetchable)
        [size=64K]
        Region 1: Memory at df2f0000 (64-bit, non-prefetchable)
        [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
                PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+
        Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
                <64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal+
                Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
                TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s,
                Latency L0 unlimited, L1 unlimited
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
                CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
                DLActive- BWMgmt- ABWMgmt-
        Capabilities: [100] Device Serial Number 00-11-3c-20-07-00-00-00
        Capabilities: [400] Virtual Channel <?>

The commercial specs are available from :

  http://www.viewcast.com/products/osprey-cards/osprey-450e

Is there any chance this card will be supported by V4L in the future (or
is it already) ?

I'm not a kernel developper, but I'm more than willing to help and/or
test if I can be useful.

Thanks in advance for any help

Jerome Alet

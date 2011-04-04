Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57633 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1DDKcA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 06:32:00 -0400
Received: by eyx24 with SMTP id 24so1662640eyx.19
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2011 03:31:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl>
References: <mailman.466.1301890961.26790.linux-dvb@linuxtv.org>
	<SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl>
Date: Mon, 4 Apr 2011 20:31:58 +1000
Message-ID: <BANLkTimEtbx6HkqBQLBTc7XX_wEYgs7fJg@mail.gmail.com>
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Nick,

Could you post the output of
  lspci -vvv -nn
for the device in question - you'll also need to give the -s argument,
eg -s 02:00.0
or whatever.

This is so it is clear what chips your example of the card is using -
a given card may be implemented with different chipsets over time
depending on how organised the manufacturer is.

Some kernel output similar to that shown on the wiki page, showing
what happens at boot time, may be useful as well.

I have this card, and it is working reasonably well with recent
media_build code:

$ sudo lspci -vvv -nn -s 04:00.0
04:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23885 PCideo and Audio Decoder [14f1:8852] (rev 02)
        Subsystem: DViCO Corporation Device [18ac:db78]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Sping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbor<MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 32
        Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsuppod-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- Trannd-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latenc0 <2us, L1 <4us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommCl
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLAct- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data <?>
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0Enable+
                Address: 00000000fee0200c  Data: 41c9
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: cx23885
        Kernel modules: cx23885

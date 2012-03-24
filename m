Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59433 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874Ab2CXBO3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 21:14:29 -0400
Received: by lahj13 with SMTP id j13so2908029lah.19
        for <linux-media@vger.kernel.org>; Fri, 23 Mar 2012 18:14:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHtAJjpO_M27cm77Uf=23_TfeYvAR8CVcemVGDi9ZoEaEwTRtg@mail.gmail.com>
References: <CAHtAJjpO_M27cm77Uf=23_TfeYvAR8CVcemVGDi9ZoEaEwTRtg@mail.gmail.com>
Date: Fri, 23 Mar 2012 20:14:26 -0500
Message-ID: <CALzAhNWMv3cP=UutVD_oU+nQgcH4J4+dxijW5=dGw2--WrkMnQ@mail.gmail.com>
Subject: Re: ViXS XCode 2100 Series TV NTSC/ATSC FM Tuner Card
From: Steven Toth <stoth@kernellabs.com>
To: Vikas N Kumar <vikasnkumar@users.sourceforge.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's not supported by Linux and last I checked no technical
documentation is available for the silicon.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com

On Fri, Mar 23, 2012 at 3:17 PM, Vikas N Kumar
<vikasnkumar@users.sourceforge.net> wrote:
> Hi
> I am interested to know if there exists any support for the ViXS XCode
> 2100 Series cards ? I have looked and not found any viable support for
> the card chipset except for some forums mentioning "ivtv" as a driver.
>
> If there is anyone working on this or if there is some guidance I
> would like to help out and provide support for this TV tuner card.
>
> Below are the full details of the card that I have. Any help or
> information is appreciated ?
>
> Thanks.
>
>
> # lspci -vv -d 1745:
> 02:00.0 Multimedia controller: ViXS Systems, Inc. XCode 2100 Series
>        Subsystem: ASUSTeK Computer Inc. Device 48b0
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 10
>        Region 0: Memory at fdf00000 (64-bit, prefetchable) [size=1M]
>        Region 2: Memory at feaf0000 (32-bit, non-prefetchable) [size=64K]
>        Region 4: I/O ports at <unassigned>
>        Capabilities: [40] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [60] Express (v1) Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
> <4us, L1 <64us
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
> BWMgmt- ABWMgmt-
>        Capabilities: [100 v1] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
> MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
> MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
>        Capabilities: [140 v1] Virtual Channel
>                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>                Arb:    Fixed- WRR32- WRR64- WRR128-
>                Ctrl:   ArbSelect=Fixed
>                Status: InProgress-
>                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
>                        Status: NegoPending- InProgress-
>
>
> --
> http://www.vikaskumar.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55655 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0G0Th1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 15:37:27 -0400
Received: by gyg10 with SMTP id 10so1380404gyg.19
        for <linux-media@vger.kernel.org>; Tue, 27 Jul 2010 12:37:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C4F31A7.8060609@iversen-net.dk>
References: <4C4F31A7.8060609@iversen-net.dk>
Date: Tue, 27 Jul 2010 15:37:26 -0400
Message-ID: <AANLkTinqS6pWDf4cEsFz6_KFW2r1Yq-BPMzb0uewF_O_@mail.gmail.com>
Subject: Re: Unknown CX23885 device
From: Alex Deucher <alexdeucher@gmail.com>
To: Christian Iversen <chrivers@iversen-net.dk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 27, 2010 at 3:21 PM, Christian Iversen
<chrivers@iversen-net.dk> wrote:
> (please CC, I'm not subscribed yet)
>
> Hey Linux-DVB people
>
> I'm trying to make an as-of-yet unsupported CX23885 device work in Linux.
>
> I've tested that the device is not supported using the newest snapshot
> of the DVB drivers. They did support a bunch of extra devices compared
> to the standard ubuntu driver, but to no avail.
>
> This is what I know about the device:
>
> ### physical description ###
>
> The device is a small mini-PCIe device currently installed in my
> Thinkpad T61p notebook. It did not originate there, but I managed to fit it
> in.

How are you attaching the video/audio/antenna/etc. input to the pcie
card?  I don't imagine the card is much use without external
connectors.

Alex

>
> It has an "Avermedia" logo on top, but no other discernable markings.
> I've tried removing the chip cover, but I can't see any other major chips
> than the cx23885. I can take a second look, if I know what to look for.
>
> ### pci info ###
>
> $ sudo lspci -s 02:00.0 -vv
> 02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
> Video and Audio Decoder (rev 02)
>        Subsystem: Avermedia Technologies Inc Device c139
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: Memory at d7a00000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: [40] Express (v1) Endpoint, MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns,
> L1 <1us
>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr-
> TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> Latency L0 <2us, L1 <4us
>                        ClockPM- Suprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
>        Capabilities: [80] Power Management version 2
>                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [90] Vital Product Data <?>
>        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>                Address: 0000000000000000  Data: 0000
>        Capabilities: [100] Advanced Error Reporting <?>
>        Capabilities: [200] Virtual Channel <?>
>        Kernel driver in use: cx23885
>        Kernel modules: cx23885
>
>
> I've tried several different card=X settings for "modprobe cx23885", and a
> few of them result in creation of /dev/dvb devices, but none of them really
> seem towork.
>
> What can I try for a next step?
>
> --
> Med venlig hilsen
> Christian Iversen
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

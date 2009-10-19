Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58563 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZJSGSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 02:18:43 -0400
Received: by ewy4 with SMTP id 4so1205802ewy.37
        for <linux-media@vger.kernel.org>; Sun, 18 Oct 2009 23:18:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e425a9f30910130353o33871635hb7cbe7ebe294c1a9@mail.gmail.com>
References: <e425a9f30910130353o33871635hb7cbe7ebe294c1a9@mail.gmail.com>
Date: Mon, 19 Oct 2009 08:18:46 +0200
Message-ID: <e425a9f30910182318j4a804390lcd411785b2725d5@mail.gmail.com>
Subject: Re: Lifeview lv8h pci-e low profile
From: Oinatz Aspiazu <oaspiazu@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello:

Does anybody know anything about this?

Thanks



2009/10/13 Oinatz Aspiazu <oaspiazu@gmail.com>:
> Hello:
> I'm using an Arch Linux, kernel 2.6.30-ARCH.
> I've a Lifeview LV8H pci-e dvb-t (low profile card) , that says:
> # lspci -vv
>     03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI
> Video and Audio Decoder (rev 02)
>        Subsystem: Conexant Systems, Inc. Device ec80
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 17
>        Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: <access denied>
>        Kernel driver in use: cx23885
>        Kernel modules: cx23885
> cx23885 driver version 0.0.2 loaded
>
> The cx23885 module, is supported by the kernel but does not seem to work for
> this device. If i load the module without parameters, I get:
> # dmesg | grep cx23885
> ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 17
> cx23885 0000:03:00.0: PCI INT A -> Link[LNEA] -> GSI 17 (level, low) -> IRQ
> 17
> cx23885[0]: Your board isn't known (yet) to the driver.
> cx23885[0]: Try to pick one of the existing card configs via
> cx23885[0]: card=<n> insmod option.  Updating to the latest
> cx23885[0]: version might help as well.
> cx23885[0]: Here is a list of valid choices for the card=<n> insmod option:
> cx23885[0]:    card=0 -> UNKNOWN/GENERIC
> cx23885[0]:    card=1 -> Hauppauge WinTV-HVR1800lp
> cx23885[0]:    card=2 -> Hauppauge WinTV-HVR1800
> cx23885[0]:    card=3 -> Hauppauge WinTV-HVR1250
> cx23885[0]:    card=4 -> DViCO FusionHDTV5 Express
> cx23885[0]:    card=5 -> Hauppauge WinTV-HVR1500Q
> cx23885[0]:    card=6 -> Hauppauge WinTV-HVR1500
> cx23885[0]:    card=7 -> Hauppauge WinTV-HVR1200
> cx23885[0]:    card=8 -> Hauppauge WinTV-HVR1700
> cx23885[0]:    card=9 -> Hauppauge WinTV-HVR1400
> cx23885[0]:    card=10 -> DViCO FusionHDTV7 Dual Express
> cx23885[0]:    card=11 -> DViCO FusionHDTV DVB-T Dual Express
> cx23885[0]:    card=12 -> Leadtek Winfast PxDVR3200 H
> cx23885[0]:    card=13 -> Compro VideoMate E650F
> cx23885[0]:    card=14 -> TurboSight TBS 6920
> cx23885[0]:    card=15 -> TeVii S470
> cx23885[0]:    card=16 -> DVBWorld DVB-S2 2005
> cx23885[0]:    card=17 -> NetUP Dual DVB-S2 CI
> CORE cx23885[0]: subsystem: 14f1:ec80, board: UNKNOWN/GENERIC
> [card=0,autodetect
> ed]
> cx23885_dev_checkrevision() Hardware revision = 0xb0
> cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 17, latency: 0, mmio:
> 0xfe8000
> 00
> cx23885 0000:03:00.0: setting latency timer to 64
> IRQ 17/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
>
> Loading card=4, all the devices /dev/dvb/ are created (frontend,..). I get:
>
> # dmesg | grep cx23885
> Código: Seleccionar todo
>     cx23885 driver version 0.0.2 loaded
>     cx23885 0000:03:00.0: PCI INT A -> Link[LNEA] -> GSI 17 (level, low) ->
> IRQ 17
>     CORE cx23885[0]: subsystem: 14f1:ec80, board: DViCO FusionHDTV5 Express
> [card=4,insmod option]
>     cx23885_dvb_register() allocating 1 frontend(s)
>     cx23885[0]: cx23885 based dvb card
>     DVB: registering new adapter (cx23885[0])
>     cx23885_dev_checkrevision() Hardware revision = 0xb0
>     cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 17, latency: 0, mmio:
> 0xfe800000
>     cx23885 0000:03:00.0: setting latency timer to 64
>     IRQ 17/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
>
> Going to Kaffeine or making an scan from the console, it says that is in
> mode ATSC and that is not compatable.
> I'm living in Spain, and I have used this card as a PAL system.
>
>     initial transponder 546000000 0 3 9 1 0 0 0
>     initial transponder 578000000 0 2 9 3 0 0 0
>     initial transponder 625833000 0 2 9 3 0 0 0
>     initial transponder 705833000 0 3 9 1 0 0 0
>     initial transponder 649833000 0 3 9 1 0 0 0
>     initial transponder 673833000 0 3 9 1 0 0 0
>     WARNING: frontend type (ATSC) is not compatible with requested tuning
> type (OFDM)
>     WARNING: frontend type (ATSC) is not compatible with requested tuning
> type (OFDM)
>     WARNING: frontend type (ATSC) is not compatible with requested tuning
> type (OFDM)
>     WARNING: frontend type (ATSC) is not compatible with requested tuning
> type (OFDM)
>     WARNING: frontend type (ATSC) is not compatible with requested tuning
> type (OFDM)
>     WARNING: frontend type (ATSC) is not compatible with requested tuning
> type (OFDM)
>     ERROR: initial tuning failed
>
> I've tried all options from the driver from the list. Only card=4, seems to
> be valid.
> Anyone can help me?
> Thanks and sorry for my english,
> Oinatz Aspiazu

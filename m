Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:53917 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367Ab2HPNt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 09:49:29 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linuxtv-commits@linuxtv.org, "Igor M. Liplianin" <liplianin@me.by>
Subject: Re: [git:v4l-dvb/for_v3.7] [media] mantis: Terratec Cinergy C PCI HD (CI)
References: <E1SzvhW-0005hd-1S@www.linuxtv.org>
	<CAHFNz9Ju7dB-iz0mcGuNMLDwibFXZqGe73jpBk7RPqG_w+MmXg@mail.gmail.com>
Date: Thu, 16 Aug 2012 15:49:19 +0200
In-Reply-To: <CAHFNz9Ju7dB-iz0mcGuNMLDwibFXZqGe73jpBk7RPqG_w+MmXg@mail.gmail.com>
	(Manu Abraham's message of "Sat, 11 Aug 2012 05:25:37 +0530")
Message-ID: <87vcgjne00.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Manu Abraham <abraham.manu@gmail.com> writes:

> Terratec Cinregy C is VP-2033 and not VP-2040.

Can you please enlighten me on how to tell this difference?  I have two
of these cards:

bjorn@canardo:~$ lspci -vvnns 05:00
05:00.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device [153b:1178]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fdfff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis

bjorn@canardo:~$ lspci -vvnns 05:01
05:01.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device [153b:1178]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at fdffe000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis


Both of them appear to have a TDA10023 tuner:

[   35.626204] Mantis 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   35.847869] DVB: registering new adapter (Mantis DVB adapter)
[   37.358998] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
[   37.359079] Mantis 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   37.607414] DVB: registering new adapter (Mantis DVB adapter)
[   38.486159] DVB: registering adapter 1 frontend 0 (Philips TDA10023 DVB-C)...


But as both the VP-2033 and VP-2040 code support both TDA10021 and
TDA10023 there is obviously some other difference between these.  Bridge
version maybe?   Or something else?



Bjørn

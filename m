Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45167 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0FMNTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jun 2010 09:19:53 -0400
Message-ID: <4C14DAF0.6030704@gmail.com>
Date: Sun, 13 Jun 2010 15:19:44 +0200
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: "C. Hemsing" <C.Hemsing@gmx.net>
CC: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: was: af9015, af9013 DVB-T problems. now: Intermittent USB disconnects
 with many (2.0) high speed devices
References: <4C1484FB.8090806@gmx.net>
In-Reply-To: <4C1484FB.8090806@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.06.2010 09:12, schrieb C. Hemsing:
> To the maintainer of the af9015, af9013 modules:
>
> A recent kernel (but the problem had been the same with older kernels):
> 2.6.32-22-generic #36-Ubuntu SMP Thu Jun 3 22:02:19 UTC 2010 i686 GNU/Linux
>
> Latest (as of yesterday) checkout of v4l-dvb (but the problem had been
> the same with older checkouts).
>
> Dual channel USB DVB-T stick initialized ok,

which and on which usb hardware?

>  but
> regularly the stick does not tune properly on one of the two channels
> and the kernel shows these error messages at the same time:
>
> [14410.717905] af9015: command failed:2
> [14410.717913] af9013: I2C read failed reg:d330
> [18208.030546] af9015: command failed:2
> [18208.030554] af9013: I2C read failed reg:d2e6

Is the device really supported?

>
> I'm willing to help debug. Who is the maintainer of af9015, af9013?
>
> Cheers,
> Chris
>

State Your USB-Hardware with lsusb and lspci -nnvvv , pls.

I can confirm the intermittent disconnects and ehci force halts on debian x...2.6.32-5 and kernel.org x...2.6.34 for

Bus 001 Device 007: ID 04ca:f001 Lite-On Technology Corp. (dib3000mc)
Bus 001 Device 002: ID 1462:8807 Micro Star International DIGIVOX mini III [af9015]
Bus 004 Device 003: ID 148f:2573 Ralink Technology, Corp. RT2501USB Wireless Adapter (rt73usb)

on

00:10.4 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 86) (prog-if 20 [EHCI])
	Subsystem: Micro-Star International Co., Ltd. K8T NEO 2 motherboard [1462:7020]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 21
	Region 0: Memory at fbefd400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd


and

00:0e.2 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 63) (prog-if 20 [EHCI])
	Subsystem: VIA Technologies, Inc. USB 2.0 [1106:3104]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 10
	Region 0: Memory at febfe800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk+ DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd

suggest we subscribe and CC linux-usb@vger.kernel.org,
http://www.linux-usb.org/mailing.html

ehci-hcd is broken and halts silently or disconnects after hours or a few days, with the wlan usb adapter
I was able to catch a dmesg err message like "ehci...force halt... handshake failed" once only.

The rt73usb was reinitialized by uhci as full speed device then, but it did not work with wpa_supplicant, manual
device removal was necessary, so it should be of no use if we add dvb-usb driver reinits on i2c failures, too.

The disconnects with dvb-usb need reboot cause driver cannot be removed with modprobe.

This long standing bug is really nasty and makes permanent high speed usb connections unusable on Linux,
at least with this VIA hardware.

No debug parms in modules, we need to ask linux-usb how to debug this.

y
tom


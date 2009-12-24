Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:55270 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbZLXNjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2009 08:39:18 -0500
Received: by fxm25 with SMTP id 25so2790955fxm.21
        for <linux-media@vger.kernel.org>; Thu, 24 Dec 2009 05:39:16 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 24 Dec 2009 14:39:16 +0100
Message-ID: <2fa074bc0912240539x3cc8adfej64165e1e8adb6cce@mail.gmail.com>
Subject: Cx88 ( Hauppauge WinTV-HVR-4000 ): can't do zapping.
From: Luca Zorzo <lucazorzo@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
I've a Hauppauge WinTV-HVR-4000
(http://www.hauppauge.co.uk/site/products/data_hvr4000.html
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000), and i
use it mainly for DVB-T through vlc and kaffeine in a Gentoo x86_64
and x86 box. The first one is a bit faster in tuning but both have a
problem: if i'm watching something i can't change channel directly
without stopping the one i'm watching. This also happens with a tzap's
based script (http://www.linuxtv.org/wiki/index.php/Testing_reception_quality)
which tests signal quality.
So i think it is a driver problem (i'm using kernel's one):

uname -a :

Linux P4 2.6.31-gentoo-r6 #3 SMP PREEMPT Sun Dec 20 09:53:55 CET 2009
x86_64 Intel(R) Pentium(R) 4 CPU 3.00GHz GenuineIntel GNU/Linux

lspci -vnn :

02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6902]
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at f4000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx8800
        Kernel modules: cx8800

02:00.1 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [14f1:8801]
(rev 05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6902]
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx88_audio
        Kernel modules: cx88-alsa

02:00.2 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [14f1:8802] (rev
05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6902]
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx88-mpeg driver manager
        Kernel modules: cx8802

02:00.4 Multimedia controller [0480]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] [14f1:8804] (rev
05)
        Subsystem: Hauppauge computer works Inc. Device [0070:6902]
        Flags: bus master, medium devsel, latency 32, IRQ 9
        Memory at f7000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2


dmesg:

[    5.269734] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    5.269934] cx88[0]: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68,autodetected], frontend(s): 2
[    5.269939] cx88[0]: TV tuner type 63, Radio tuner type -1
[    5.286188] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    5.296136] cx2388x alsa driver version 0.0.7 loaded
[    5.384144] cx88[0]: i2c init: enabling analog demod on
HVR1300/3000/4000 tuner
[    5.837300] tuner 1-0043: chip found @ 0x86 (cx88[0])
[    5.837306] tda9887 1-0043: creating new instance
[    5.837309] tda9887 1-0043: tda988[5/6/7] found
[    5.843180] tuner 1-0061: chip found @ 0xc2 (cx88[0])
[    5.886173] tveeprom 1-0050: Hauppauge model 69009, rev B4D3, serial# 6520465
[    5.886180] tveeprom 1-0050: MAC address is 00-0D-FE-63-7E-91
[    5.886185] tveeprom 1-0050: tuner model is Philips FMD1216MEX (idx
133, type 78)
[    5.886190] tveeprom 1-0050: TV standards PAL(B/G) PAL(I)
SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    5.886195] tveeprom 1-0050: audio processor is CX880 (idx 30)
[    5.886199] tveeprom 1-0050: decoder processor is CX880 (idx 20)
[    5.886203] tveeprom 1-0050: has radio, has IR receiver, has no IR
transmitter
[    5.886206] cx88[0]: hauppauge eeprom: model=69009
[    5.886692] tuner-simple 1-0061: creating new instance
[    5.886697] tuner-simple 1-0061: type set to 78 (Philips FMD1216MEX
MK3 Hybrid Tuner)
[    5.891595] input: cx88 IR (Hauppauge WinTV-HVR400 as
/devices/pci0000:00/0000:00:1e.0/0000:02:00.2/input/input4
[    5.891726] cx88[0]/2: cx2388x 8802 Driver Manager
[    5.891748] cx88-mpeg driver manager 0000:02:00.2: PCI INT A -> GSI
20 (level, low) -> IRQ 20
[    5.891760] cx88[0]/2: found at 0000:02:00.2, rev: 5, irq: 20,
latency: 32, mmio: 0xf6000000
[    5.891768] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.891821] cx8800 0000:02:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.891830] cx88[0]/0: found at 0000:02:00.0, rev: 5, irq: 20,
latency: 32, mmio: 0xf4000000
[    5.891841] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.963166] wm8775 1-001b: chip found @ 0x36 (cx88[0])
[    5.970089] cx88[0]/0: registered device video0 [v4l2]
[    5.970137] cx88[0]/0: registered device vbi0
[    5.970184] cx88[0]/0: registered device radio0
[    5.986679] cx88_audio 0000:02:00.1: PCI INT A -> GSI 20 (level,
low) -> IRQ 20
[    5.986692] IRQ 20/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.986708] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    6.452453] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[    6.452459] cx88/2: registering cx8802 driver, type: dvb access: shared
[    6.452465] cx88[0]/2: subsystem: 0070:6902, board: Hauppauge
WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
[    6.452469] cx88[0]/2: cx2388x based DVB/ATSC card
[    6.452473] cx8802_alloc_frontends() allocating 2 frontend(s)
[    6.457871] tuner-simple 1-0061: attaching existing instance
[    6.457877] tuner-simple 1-0061: couldn't set type to 63. Using 78
(Philips FMD1216MEX MK3 Hybrid Tuner) instead
[    6.460236] DVB: registering new adapter (cx88[0])
[    6.460242] DVB: registering adapter 0 frontend 0 (Conexant
CX24116/CX24118)...
[    6.462326] DVB: registering adapter 0 frontend 1 (Conexant CX22702 DVB-T)...

The only strange thing is about "tuner-simple 1-0061: couldn't set
type to 63. Using 78 (Philips FMD1216MEX MK3 Hybrid Tuner) instead"
warning.

Thanks for the help.

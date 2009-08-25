Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36298 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbZHYSAD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 14:00:03 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mg0JP-000051-Mw
	for linux-media@vger.kernel.org; Tue, 25 Aug 2009 20:00:03 +0200
Received: from p5B3F863B.dip0.t-ipconnect.de ([91.63.134.59])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 20:00:03 +0200
Received: from linux by p5B3F863B.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 25 Aug 2009 20:00:03 +0200
To: linux-media@vger.kernel.org
From: Martin Kittel <linux@martin-kittel.de>
Subject: HVR 1300: DVB channel lock problems since 2.6.28
Date: Tue, 25 Aug 2009 17:49:05 +0000 (UTC)
Message-ID: <loom.20090825T192551-363@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently upgraded my Debian MythTV box with a Hauupauge HVR1300 from Debian
kernel 2.6.26 to 2.6.30 and could not get a channel lock for my DVB-T tv
channels any more.
I then did some quick testing with vanilla linux kernels starting with 2.6.27
with the following results:
2.6.27: seems to work fine
2.6.28: channel lock could not be acquired reliably; sometimes switching
channels worked fine, most of the time it failed
2.6.29: could not get any channel locks
2.6.30: the same, no channel lock
2.6.31-rc7: the same, no channel locks 

I also tried the v4l-dvb repository last week-end with no success either.
Has anyone an idea what to try next? I am willing to try patches.

Thanks and best wishes,

Martin.

Here's the dmesg output of 2.6.31-rc7:

[    5.309454] Linux video capture interface: v2.00
[    5.904394] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    5.906786] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    5.907339] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
[    5.907348]   alloc irq_desc for 17 on node 0
[    5.907351]   alloc kstat_irqs on node 0
[    5.907364] cx8800 0000:01:07.0: PCI INT A -> Link[LNKB] -> GSI 17 (level,
low) -> IRQ 17
[    5.907903] cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300

DVB-T/Hybrid MPEG Encoder [card=56,autodetected], frontend(s): 1
[    5.907907] cx88[0]: TV tuner type 63, Radio tuner type -1
[    5.955101] cx2388x alsa driver version 0.0.7 loaded
[    6.001579] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    6.001586] HDA Intel 0000:00:07.0: PCI INT A -> Link[LAZA] -> GSI 21 (level,

low) -> IRQ 21
[    6.001633] HDA Intel 0000:00:07.0: setting latency timer to 64
[    6.030099] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000
tuner
[    6.074239] tuner 2-0043: chip found @ 0x86 (cx88[0])
[    6.085269] tda9887 2-0043: creating new instance
[    6.085272] tda9887 2-0043: tda988[5/6/7] found
[    6.088655] tuner 2-0061: chip found @ 0xc2 (cx88[0])
[    6.126608] tveeprom 2-0050: Hauppauge model 96019, rev D6D3, serial# 3106328
[    6.126612] tveeprom 2-0050: MAC address is 00-0D-FE-2F-66-18
[    6.126615] tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133,
 type 78)
[    6.126619] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')

PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    6.126622] tveeprom 2-0050: audio processor is CX882 (idx 33)
[    6.126625] tveeprom 2-0050: decoder processor is CX882 (idx 25)
[    6.126627] tveeprom 2-0050: has radio, has IR receiver, has IR transmitter
[    6.126630] cx88[0]: hauppauge eeprom: model=96019
[    6.134285] tuner-simple 2-0061: creating new instance
[    6.134290] tuner-simple 2-0061: type set to 78 (Philips FMD1216MEX MK3
Hybrid Tuner)
[    6.138226] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 17, latency: 64,
mmio: 0xfd000000
[    6.138239] IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.145073] wm8775 2-001b: chip found @ 0x36 (cx88[0])
[    6.151387] cx88[0]/0: registered device video0 [v4l2]
[    6.151414] cx88[0]/0: registered device vbi0
[    6.151438] cx88[0]/0: registered device radio0
[    6.155653] cx88[0]/2: cx2388x 8802 Driver Manager
[    6.155670] cx88-mpeg driver manager 0000:01:07.2: PCI INT A -> Link[LNKB] ->
GSI 17 (level, low) -> IRQ 17
[    6.155679] cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 17, latency: 64,
mmio: 0xfb000000
[    6.155687] IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.155758] cx88_audio 0000:01:07.1: PCI INT A -> Link[LNKB] -> GSI 17
(level, low) -> IRQ 17
[    6.155763] IRQ 17/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    6.155793] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
[    6.195845] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[    6.195850] cx88/2: registering cx8802 driver, type: dvb access: shared
[    6.195854] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300
DVB-T/Hybrid MPEG Encoder [card=56]
[    6.195858] cx88[0]/2: cx2388x based DVB/ATSC card
[    6.195860] cx8802_alloc_frontends() allocating 1 frontend(s)
[    6.229199] tuner-simple 2-0061: attaching existing instance
[    6.229208] tuner-simple 2-0061: couldn't set type to 63. Using 78 (Philips
FMD1216MEX MK3 Hybrid Tuner) instead
[    6.233035] DVB: registering new adapter (cx88[0])
[    6.233039] DVB: registering adapter 0 frontend 0 (Conexant CX22702 DVB-T)...
[    6.256103] cx2388x blackbird driver version 0.0.7 loaded
[    6.256107] cx88/2: registering cx8802 driver, type: blackbird access: shared
[    6.256111] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300
DVB-T/Hybrid MPEG Encoder [card=56]
[    6.256116] cx88[0]/2: cx23416 based mpeg encoder (blackbird reference
design)
[    6.256335] cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized or
corrupted
[    6.260536] cx88-mpeg driver manager 0000:01:07.2: firmware: requesting
v4l-cx2341x-enc.fw
[    6.604124] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:07.0/input/input3
[    8.789850] cx88[0]/2-bb: Firmware upload successful.
[    8.798164] cx88[0]/2-bb: Firmware version is 0x02060039
[    8.804732] cx88[0]/2: registered device video1 [mpeg]



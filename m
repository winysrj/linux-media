Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48394 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682AbZDHTtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 15:49:36 -0400
Received: by bwz17 with SMTP id 17so287889bwz.37
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 12:49:33 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 20:49:32 +0100
Message-ID: <5d932cdc0904081249j59bccc7cg864753d22479d9a8@mail.gmail.com>
Subject: Re: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture
	Device
From: Thomas Horsten <thomas@horsten.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry for breaking in-reply-to-chain but I wasn't subscribed to the list.

> did build a 2.6.29.1 now and your report is correct!
>
> DVB-T on saa7134 is broken at least for all tda10046 and tda8275 stuff
> and it is not restricted to devices with LNA.
>
> For what I can see so far, it is not related to the IRQF_DISABLED print
> out, since only a warning for now and removing it from the driver
> doesn't change anything.
>
> saa7134 DVB-S, analog TV and saa7134-alsa are not affected.
>
> Installing the current mercurial v4l-dvb on 2.6.29.1 does fix it.
>
> If on that saa7134-dvb.ko and saa7134.ko are replaced with the ones from
> 2.6.29.1 the breakage is back again. The related dvb and tuner modules
> tolerate such exchange on a first rough test.
>
> As you reported, symptoms are tumbling signal and SNR between very low
> and 100%, as if tuning and AGC would never stabilize.
>
> I suspect failing i2c stuff is involved. Did not notice anything like
> that on various mercurial versions during the last months.

I have the same issue (I think) on a Hauppauge WinTV Nova-T DVB-T
card. Here is the output from my old kernel, 2.6.28.7 when everything
worked:

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:13:09.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T
[card=18,autodetected], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
dib0700: loaded with support for 8 different device-types
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will
try to load a firmware
usb 5-1: firmware: requesting dvb-usb-dib0700-1.20.fw
input: PC Speaker as /class/input/input3
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
Intel ICH 0000:00:04.0: PCI INT A -> Link[LACI] -> GSI 22 (level,
high) -> IRQ 22
Intel ICH 0000:00:04.0: setting latency timer to 64
tveeprom 2-0050: Hauppauge model 90002, rev C176, serial# 471851
tveeprom 2-0050: MAC address is 00-0D-FE-07-33-2B
tveeprom 2-0050: tuner model is Thompson DTT7592 (idx 76, type 4)
tveeprom 2-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 2-0050: audio processor is None (idx 0)
tveeprom 2-0050: decoder processor is CX882 (idx 25)
tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=90002
input: cx88 IR (Hauppauge Nova-T DVB-T as /class/input/input4
cx88[0]/0: found at 0000:13:09.0, rev: 5, irq: 29, latency: 165, mmio:
0xd9000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:13:09.2: PCI INT A -> GSI 29 (level,
low) -> IRQ 29
cx88[0]/2: found at 0000:13:09.2, rev: 5, irq: 29, latency: 64, mmio: 0xda000000
cx8802_probe() allocating 1 frontend(s)

With 2.6.29.1 I get this:

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:13:09.0: PCI INT A -> GSI 29 (level, low) -> IRQ 29
cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18,autodetect
ed], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
dib0700: loaded with support for 8 different device-types
dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-T 500 Dual DVB-T)
tveeprom 3-0050: Hauppauge model 90002, rev C176, serial# 471851
tveeprom 3-0050: MAC address is 00-0D-FE-07-33-2B
tveeprom 3-0050: tuner model is Thompson DTT7592 (idx 76, type 4)
tveeprom 3-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 3-0050: audio processor is None (idx 0)
tveeprom 3-0050: decoder processor is CX882 (idx 25)
tveeprom 3-0050: has no radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=90002
input: cx88 IR (Hauppauge Nova-T DVB-T as /class/input/input4
DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
MT2060: successfully identified (IF1 = 1222)
cx88[0]/0: found at 0000:13:09.0, rev: 5, irq: 29, latency: 165, mmio:
0xd9000000
IRQ 29/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 22
Intel ICH 0000:00:04.0: PCI INT A -> Link[LACI] -> GSI 22 (level,
high) -> IRQ 22
Intel ICH 0000:00:04.0: setting latency timer to 64
input: ImPS/2 Logitech Wheel Mouse as /class/input/input5
intel8x0_measure_ac97_clock: measured 54864 usecs
intel8x0: clocking to 46887
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:13:09.2: PCI INT A -> GSI 29 (level,
low) -> IRQ 29
cx88[0]/2: found at 0000:13:09.2, rev: 5, irq: 29, latency: 64, mmio: 0xda000000
IRQ 29/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)

I have the same symptoms as described previously in the thread, the
tuner is found but it will not get a lock in MythTV on any of the
channels and has seemingly random signal strength and SNR levels on
all the channels.

When the tuner is being used I get a lot of these messages from dmesg,
suggesting an i2c problem:

Apr  7 07:54:12 omega kernel: mt2060 I2C read failed
Apr  7 11:38:07 omega kernel: mt2060 I2C write failed
Apr  7 11:38:07 omega kernel: mt2060 I2C write failed (len=2)
Apr  7 11:38:07 omega kernel: mt2060 I2C write failed (len=6)
Apr  7 11:38:07 omega kernel: mt2060 I2C read failed
Apr  7 11:38:08 omega last message repeated 9 times

These seem to happen whenever MythTV attempts to access the tuner.

Thanks,
Thomas

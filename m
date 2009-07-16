Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:46181 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919AbZGPVRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2009 17:17:10 -0400
Received: by bwz28 with SMTP id 28so379430bwz.37
        for <linux-media@vger.kernel.org>; Thu, 16 Jul 2009 14:17:09 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Jul 2009 00:17:08 +0300
Message-ID: <88b49f150907161417r7d487078h3e27b514cf8dd5cf@mail.gmail.com>
Subject: AVerMedia AVerTV GO 007 FM, no radio sound (with routing enabled)
From: Laszlo Kustan <lkustan@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
I have problems with my AVerMedia AVerTV GO 007 FM tuner, kernel
version 2.6.28. TV and remote are working correctly, but the radio
does not have any sound.
I already tried the steps described in
http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_GO_007_FM but
still no success. According to this:
"The *latest revision*(PCI ID 1461:f31f) of the Avermedia AVerTV GO
007 FM works "out of the box" in recent kernels"
but it's not the case for me.
/dev/radio0 is created, but radio is not functional. I can tune to
different frequencies, but no change in the sound. The "antenna" icon
of gnomeradio does not show any signal.
If I try to scan with gnomeradio, it dies.
I tried different tuner=xx insmod options, the maximum I could achieve
was that gnomeradio finds some stations and the antenna icon shows
that there is a signal, but still cannot hear anything.
I enabled sound routing (that's how tvtime works correctly), but the
radio is not functional yet:
#!/bin/sh
sox -c 2 -s -r 32000 -t ossdsp /dev/dsp1 -t ossdsp -r 32000 /dev/dsp &
gnomeradio --mixer=/dev/mixer:pcm
wait gnomeradio
t=`pidof sox`;
kill $t;
amixer -c 0 sset PCM 80%,80%  unmute

dmesg output:
[ 1360.408481] saa7130/34: v4l2 driver version 0.2.15 loaded
[ 1360.408582] saa7133[0]: found at 0000:01:06.0, rev: 208, irq: 19,
latency: 64, mmio: 0xdffff800
[ 1360.408593] saa7133[0]: subsystem: 1461:f31f, board: Avermedia
AVerTV GO 007 FM [card=57,autodetected]
[ 1360.408663] saa7133[0]: board init: gpio is 80185
[ 1360.408793] input: saa7134 IR (Avermedia AVerTV GO as
/devices/pci0000:00/0000:00:04.0/0000:01:06.0/input/input7
[ 1360.568037] saa7133[0]: i2c eeprom 00: 61 14 1f f3 ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568054] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568068] saa7133[0]: i2c eeprom 20: ff d2 fe ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568082] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568094] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568107] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568120] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568133] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568146] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568159] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568172] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568185] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568198] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568211] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568224] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.568237] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[ 1360.608210] tuner 2-004b: chip found @ 0x96 (saa7133[0])
[ 1360.688029] tda829x 2-004b: setting tuner address to 61
[ 1360.752032] tda829x 2-004b: type set to tda8290+75
[ 1365.492142] saa7133[0]: registered device video0 [v4l2]
[ 1365.492181] saa7133[0]: registered device vbi0
[ 1365.492218] saa7133[0]: registered device radio0
[ 1365.502229] saa7134 ALSA driver for DMA sound loaded
[ 1365.502288] saa7133[0]/alsa: saa7133[0] at 0xdffff800 irq 19
registered as card -2

On the tuner I see a SAA7131 and a TDA8275 integrated circuit.
Please help me get my radio working.
Thanks, Laszlo

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59690 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab2ANTkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 14:40:17 -0500
Received: by vbmv11 with SMTP id v11so1898121vbm.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 11:40:16 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 14 Jan 2012 21:40:16 +0200
Message-ID: <CAEsXasEgJ48mqaDPfHA2BfhWvm1xcO=mKpMCMb0RyG_bcbxuVw@mail.gmail.com>
Subject: Medion 2819 (saa7134 card=22 tuner=28) minor problems with radio applications
From: Daftcho Tabakov <daftcho@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Some years ago I managed to use my old Medion 2819 with the help of
this maillist.
Recently I upgraded the computer and installed Fedora 16. I use
kradio4 for radio receiving. But after upgrade the radio plays in mono
and there is no signal strength indicator. If I use radio program from
xawtv the sound is stereo and there is indicator for the signal. But
if I start kradio4 and close it and then start radio from xawtv the
sound is again mono and there is no indicator. I can't understand what
is wrong.

This is dmesg | grep saa :

[   18.698710] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   18.909694] saa7134 0000:04:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   18.909702] saa7134[0]: found at 0000:04:01.0, rev: 1, irq: 17,
latency: 32, mmio: 0xfa910000
[   18.909711] saa7134[0]: subsystem: 1461:a70b, board: AverMedia M156
/ Medion 2819 [card=22,autodetected]
[   18.909746] saa7134[0]: board init: gpio is 3a8
[   18.931449] input: saa7134 IR (AverMedia M156 / Me as
/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/0000:04:01.0/rc/rc0/input5
[   18.931608] rc0: saa7134 IR (AverMedia M156 / Me as
/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/0000:04:01.0/rc/rc0
[   19.065327] saa7134[0]: i2c eeprom 00: 61 14 0b a7 ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065338] saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065348] saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065357] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065366] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065375] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065384] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065399] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065403] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065407] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065412] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065416] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065420] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065424] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065428] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.065433] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.116504] saa7134[0]: registered device video0 [v4l2]
[   19.116546] saa7134[0]: registered device vbi0
[   19.116606] saa7134[0]: registered device radio0
[   19.117760] saa7134 ALSA driver for DMA sound loaded
[   19.117782] saa7134[0]/alsa: saa7134[0] at 0xfa910000 irq 17
registered as card -1

and
dmesg | grep tuner

[   19.066416] i2c-core: driver [tuner] using legacy suspend method
[   19.066417] i2c-core: driver [tuner] using legacy resume method
[   19.088329] tuner 18-0043: Tuner 74 found with type(s) Radio TV.
[   19.091381] tuner 18-0061: Tuner -1 found with type(s) Radio TV.
[   19.096327] tuner-simple 18-0061: creating new instance
[   19.096331] tuner-simple 18-0061: type set to 38 (Philips PAL/SECAM
multi (FM1216ME MK3))

P.S.

Booted later a Kubuntu 11.10 from flash pen - the result from kradio4
is the same.

Thank you in advance and all the best!

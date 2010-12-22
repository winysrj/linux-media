Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45369 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0LVBHR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 20:07:17 -0500
Received: by wwa36 with SMTP id 36so4776807wwa.1
        for <linux-media@vger.kernel.org>; Tue, 21 Dec 2010 17:07:16 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 22 Dec 2010 01:07:14 +0000
Message-ID: <AANLkTim-GBA+q+-pMYz8HR5syHNPG_2EgS3cKy5H_geu@mail.gmail.com>
Subject: Avermedia A700 failing with 2.6.32, worked with 2.6.30
From: Mikhail Ramendik <mr@ramendik.ru>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello.

I have Avermedia A700, a DVB-S card. I also have Debian lenny, which,
with kernel
2.6.30 from backports.org, displayed satelite video successfully.

However, once I installed kernel 2.6.32 from backports.org (which I
needed for certain network hardware), DVB no longer works, even though
the card is unchanged.

/dev/dvb* does not exist, even though I load saa7134_dvb via /etc/modules .

$ dvbscan
Failed to open frontend

$  su
# dvbscan
Failed to open frontend

# lsmod | grep 7134
saa7134_dvb            16549  0
videobuf_dvb            3390  1 saa7134_dvb
saa7134_alsa            7867  0
snd_pcm                47202  4
snd_intel8x0,saa7134_alsa,snd_pcm_oss,snd_ac97_codec
saa7134               120032  2 saa7134_dvb,saa7134_alsa
ir_common              22187  1 saa7134
v4l2_common             9836  2 tuner,saa7134
videodev               25569  3 tuner,saa7134,v4l2_common
videobuf_dma_sg         7235  3 saa7134_dvb,saa7134_alsa,saa7134
videobuf_core          10484  3 videobuf_dvb,saa7134,videobuf_dma_sg
tveeprom                9393  1 saa7134
snd                    34395  10
snd_intel8x0,saa7134_alsa,snd_pcm_oss,snd_mixer_oss,snd_ac97_codec,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
i2c_core               12700  7
nvidia,saa7134_dvb,tuner,saa7134,v4l2_common,videodev,tveeprom

# dpkg -l | grep firmware
ii  firmware-linux-free                   2.6.32-28~bpo50+1
        Binary firmware for various drivers in the Linux kernel
ii  firmware-linux-nonfree                0.24~bpo50+1
        Binary firmware for various drivers in the Linux kernel
ii  firmware-ralink                       0.24~bpo50+1
        Binary firmware for Ralink RT2561, RT2571, RT2661 and RT2671
wir

/var/log/dmesg, the only mentioning of 7134:

[   10.569399] saa7134 0000:00:0a.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   10.569411] saa7133[0]: found at 0000:00:0a.0, rev: 209, irq: 19,
latency: 32, mmio: 0xeb034000
[   10.569422] saa7133[0]: subsystem: 1461:a7a1, board: AverMedia
AverTV/305 [card=52,insmod option]
[   10.569448] saa7133[0]: board init: gpio is 202b600
[   10.569602] input: saa7134 IR (AverMedia AverTV/30 as
/devices/pci0000:00/0000:00:0a.0/input/input6
[   10.569696] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   10.673687] parport_pc 00:0a: reported by Plug and Play ACPI
[   10.673754] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   11.020045] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020069] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020089] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020110] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020130] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020151] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020171] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020192] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020213] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020233] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020253] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020273] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020293] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020311] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020331] saa7133[0]: i2c eeprom e0: 00 01 81 b0 3e 3f ff ff ff
ff ff ff ff ff ff ff
[   11.020350] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   11.020374] i2c i2c-0: Invalid 7-bit address 0x7a
[   11.892321] saa7133[0]: registered device video0 [v4l2]
[   11.892373] saa7133[0]: registered device vbi0
[   13.298227] saa7134 ALSA driver for DMA sound loaded
[   13.298247] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   13.298287] saa7133[0]/alsa: saa7133[0] at 0xeb034000 irq 19
registered as card -2


I have set the following options in /etc/modprobe.d/saa7134 :

options saa7134 card=52 tuner=38
options saa7134-alsa index=-2

The first line is unchanged from the 2.6.30 setup where it worked. The
second line was added to make ALSA sound work, as under 2.6.32
saa7134-a;sa became the default device without it.

-- 
Yours, Mikhail Ramendik

Unless explicitly stated, all opinions in my mail are my own and do
not reflect the views of any organization

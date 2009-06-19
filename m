Return-path: <linux-media-owner@vger.kernel.org>
Received: from aneto.bordeaux.inserm.fr ([195.221.150.9]:52690 "EHLO
	aneto.bordeaux.inserm.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZFSIfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 04:35:37 -0400
Received: from localhost.localdomain (unknown [195.221.147.159])
	by aneto.bordeaux.inserm.fr (SrvInserm) with ESMTP id 70AA35F940
	for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 10:02:02 +0200 (CEST)
Message-ID: <4A3B45DD.8090509@inserm.fr>
Date: Fri, 19 Jun 2009 10:01:33 +0200
From: Yves Le Feuvre <yves.lefeuvre@inserm.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: request for help: Asus Europa2 OEM parity error
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As I reported before (i am sorry for insisting, and I understand that 
working without the card is not so easy), this card (Asus Europa2 OEM 
[card=100,autodetected]) does not work with kernel 2.6.26 and later 
(2.6.25 is OK, at least for DVB)
in 2.6.25,
 composite input, DVB are working. radio is not working . analog TV 
seems to be working (very poor antenna, hard to say)

in 2.6.26 (and later, up to 2.6.30)
composite input is working, DVB is not working (tzap does not lock), 
radio is not working (don't remember for analog TV). dmesg warns about 
parity error.

any help would be greatly appreciated...

many thanks in advance

Yves

here is what dmesg is saying with i2c_debug=1 and irq_debug=1
______________________________
______________________________
for 2.6.30, with latest v4l-dvb
[root@localhost v4l-dvb]# make unload && make &&make install && dmesg -c 
2>&1>/dev/null && modprobe saa7134 i2c_debug=1 irq_debug=1
[root@localhost v4l-dvb]# dmesg
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134[0]: found at 0000:02:03.0, rev: 1, irq: 19, latency: 32, mmio: 
0xf9ffe000
saa7134[0]: subsystem: 1043:4860, board: Asus Europa2 OEM 
[card=100,autodetected]
saa7134[0]: board init: gpio is 0
IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7134[0]: i2c xfer: < a0 00 >
saa7134[0]: i2c xfer: < a1 =43 =10 =60 =48 =54 =20 =1c =00 =43 =43 =a9 
=1c =55 =d2 =b2 =92 =00 =ff =86 =0f =ff =20 =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =01 =40 =01 =03 =03 =02 =03 =04 =08 =ff =00 =4c =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=1d =00 =c2 =86 =10 =01 =01 =0d =01 =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
saa7134[0]: i2c eeprom 00: 43 10 60 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 03 03 02 03 04 08 ff 00 4c ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 0d 01 ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
i2c-adapter i2c-1: Invalid 7-bit address 0x7a
saa7134[0]: i2c xfer: < 8e ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < e2 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 5a ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 10 07 02 >
saa7134[0]: i2c xfer: < 84 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 86 >
saa7134[0]: i2c xfer: < 86 00 >
saa7134[0]: i2c xfer: < 87 =11 =10 =10 =10 =10 =10 =10 =10 >
saa7134[0]: i2c xfer: < 86 1f >
saa7134[0]: i2c xfer: < 87 =10 >
saa7134[0]: i2c xfer: < 86 2f >
saa7134[0]: i2c xfer: < 87 =10 >
saa7134[0]: i2c xfer: < 86 01 02 >
saa7134[0]: i2c xfer: < 86 00 00 >
saa7134[0]: i2c xfer: < 86 07 >
saa7134[0]: i2c xfer: < 87 =10 >
saa7134[0]: i2c xfer: < 86 00 d6 30 >
tuner 1-0043: chip found @ 0x86 (saa7134[0])
tda9887 1-0043: creating new instance
tda9887 1-0043: tda988[5/6/7] found
saa7134[0]: i2c xfer: < 86 00 c0 00 00 >
saa7134[0]: i2c xfer: < c0 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < c2 >
tuner 1-0061: chip found @ 0xc2 (saa7134[0])
saa7134[0]: i2c xfer: < c2 0b dc 9c 60 >
saa7134[0]: i2c xfer: < c2 0b dc 86 54 >
saa7134[0]: i2c xfer: < c3 =30 >
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[0]: i2c xfer: < 86 00 00 00 00 >
saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[0]: i2c xfer: < 86 00 02 00 00 >
saa7134[0]: i2c xfer: < 86 00 00 00 00 >
saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[0]: i2c xfer: < 86 00 00 00 00 >
saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
saa7134[0]/irq[0,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[1,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[2,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[3,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[4,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[5,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[6,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[7,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[8,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[9,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq[10,4296555620]: r=0x20 s=0x00 PE
saa7134[0]/irq: looping -- clearing PE (parity error!) enable bit
saa7134[0]/irq[0,4296555620]: r=0x20 s=0x00 PE
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[0]: i2c xfer: < 86 00 a0 00 00 >
saa7134[0]: i2c xfer: < 86 00 a0 00 00 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
saa7134[0]: i2c xfer: < c2 07 ac 80 19 >
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
dvb_init() allocating 1 frontend
saa7134[0]: i2c xfer: < 10 00 [fe quirk] < 11 =46 >
saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =02 >
saa7134[0]: i2c xfer: < 10 07 02 >
saa7134[0]: i2c xfer: < c3 =70 >
saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =02 >
saa7134[0]: i2c xfer: < 10 07 00 >
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
saa7134[0]: i2c xfer: < 10 07 80 >
saa7134[0]: i2c xfer: < 10 3b [fe quirk] < 11 =ff >
saa7134[0]: i2c xfer: < 10 3b fe >
saa7134[0]: i2c xfer: < 10 2d f0 >
tda1004x: setting up plls for 53MHz sampling clock
saa7134[0]: i2c xfer: < 10 2f 08 >
saa7134[0]: i2c xfer: < 10 30 03 >
saa7134[0]: i2c xfer: < 10 3e 67 >
saa7134[0]: i2c xfer: < 10 4d d7 >
saa7134[0]: i2c xfer: < 10 4e 3f >
saa7134[0]: i2c xfer: < 10 31 5c >
saa7134[0]: i2c xfer: < 10 32 32 >
saa7134[0]: i2c xfer: < 10 33 c2 >
saa7134[0]: i2c xfer: < 10 34 96 >
saa7134[0]: i2c xfer: < 10 35 6d >
saa7134[0]: i2c xfer: < 10 37 [fe quirk] < 11 =34 >
saa7134[0]: i2c xfer: < 10 37 34 >
saa7134[0]: i2c xfer: < 10 06 [fe quirk] < 11 =b0 >
saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =80 >
saa7134[0]: i2c xfer: < 10 07 80 >
saa7134[0]: i2c xfer: < 10 11 67 >
saa7134[0]: i2c xfer: < 10 13 [fe quirk] < 11 =67 >
saa7134[0]: i2c xfer: < 10 14 [fe quirk] < 11 =29 >
tda1004x: found firmware revision 29 -- ok
saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =80 >
saa7134[0]: i2c xfer: < 10 07 80 >
saa7134[0]: i2c xfer: < 10 01 87 >
saa7134[0]: i2c xfer: < 10 16 88 >
saa7134[0]: i2c xfer: < 10 43 0a >
saa7134[0]: i2c xfer: < 10 3d [fe quirk] < 11 =00 >
saa7134[0]: i2c xfer: < 10 3d 60 >
saa7134[0]: i2c xfer: < 10 3b [fe quirk] < 11 =ff >
saa7134[0]: i2c xfer: < 10 3b 7f >
saa7134[0]: i2c xfer: < 10 3a [fe quirk] < 11 =00 >
saa7134[0]: i2c xfer: < 10 3a 00 >
saa7134[0]: i2c xfer: < 10 37 38 >
saa7134[0]: i2c xfer: < 10 3b [fe quirk] < 11 =7f >
saa7134[0]: i2c xfer: < 10 3b 79 >
saa7134[0]: i2c xfer: < 10 47 00 >
saa7134[0]: i2c xfer: < 10 48 ff >
saa7134[0]: i2c xfer: < 10 49 00 >
saa7134[0]: i2c xfer: < 10 4a ff >
saa7134[0]: i2c xfer: < 10 46 12 >
saa7134[0]: i2c xfer: < 10 4f 1a >
saa7134[0]: i2c xfer: < 10 1e 07 >
saa7134[0]: i2c xfer: < 10 1f c0 >
saa7134[0]: i2c xfer: < 10 3b ff >
saa7134[0]: i2c xfer: < 10 37 [fe quirk] < 11 =38 >
saa7134[0]: i2c xfer: < 10 37 f8 >
saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =80 >
saa7134[0]: i2c xfer: < 10 07 81 >
saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =81 >
saa7134[0]: i2c xfer: < 10 07 83 >
saa7134[0]: i2c xfer: < 10 07 [fe quirk] < 11 =83 >
saa7134[0]: i2c xfer: < 10 07 83 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
saa7134 ALSA driver for DMA sound loaded
IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7134[0]/alsa: saa7134[0] at 0xf9ffe000 irq 19 registered as card -1
[root@localhost v4l-dvb]# lsmod | grep saa
saa7134_alsa           13424  0
saa7134_dvb            24636  0
videobuf_dvb            7284  1 saa7134_dvb
saa7134               166180  2 saa7134_alsa,saa7134_dvb
ir_common              44164  1 saa7134
v4l2_common            15520  2 tuner,saa7134
videodev               35968  3 tuner,saa7134,v4l2_common
videobuf_dma_sg        12100  3 saa7134_alsa,saa7134_dvb,saa7134
videobuf_core          16436  3 videobuf_dvb,saa7134,videobuf_dma_sg
tveeprom               13748  1 saa7134
snd_pcm                80504  3 saa7134_alsa,snd_hda_intel,snd_hda_codec
i2c_core               23088  13 
tda1004x,saa7134_dvb,tuner_simple,tda9887,tda8290,tuner,saa7134,v4l2_common,videodev,tveeprom,nvidia,i2c_algo_bit,i2c_i801
snd                    66520  9 
saa7134_alsa,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer

______________________________
______________________________
for 2.6.25
[root@localhost ~]$ /sbin/modprobe saa7134 i2c_debug=1 irq_debug=1
[root@localhost ~]$ dmesg
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 19 (level, low) -> IRQ 19
saa7134[0]: found at 0000:02:03.0, rev: 1, irq: 19, latency: 32, mmio: 
0xf9ffe000
saa7134[0]: subsystem: 1043:4860, board: Asus Europa2 OEM 
[card=100,autodetected]
saa7134[0]: board init: gpio is 0
saa7134[0]: i2c xfer: < a0 >
saa7134[0]: i2c xfer: < a0 >
tveeprom i2c attach [addr=0x50,client=tveeprom]
saa7134[0]: i2c xfer: < f5 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < e3 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 5b ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < a0 00 >
saa7134[0]: i2c xfer: < a1 =43 =10 =60 =48 =54 =20 =1c =00 =43 =43 =a9 
=1c =55 =d2 =b2 =92 =00 =ff =86 =0f =ff =20 =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =01 =40 =01 =03 =03 =02 =03 =04 =08 =ff =00 =4c =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=1d =00 =c2 =86 =10 =01 =01 =0d =01 =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
saa7134[0]: i2c eeprom 00: 43 10 60 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 20: 01 40 01 03 03 02 03 04 08 ff 00 4c ff ff ff ff
saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 0d 01 ff ff ff ff ff ff
saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7134[0]: i2c xfer: < 20 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 84 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 86 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 94 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 96 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < c0 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < c2 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < c4 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < c6 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < c8 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < ca ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < cc ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < ce ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < d0 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < d2 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < d4 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < d6 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < d8 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < da ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < dc ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < de ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 10 07 02 >
saa7134[0]: registered device video1 [v4l2]
saa7134[0]: registered device vbi1
saa7134[0]: registered device radio0
saa7134[0]: i2c xfer: < 10 00 [fd quirk] < 11 =46 >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =02 >
saa7134[0]: i2c xfer: < 10 07 02 >
saa7134[0]: i2c xfer: < c3 =bc >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =02 >
saa7134[0]: i2c xfer: < 10 07 00 >
DVB: registering new adapter (saa7134[0])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
saa7134[0]: i2c xfer: < 10 07 80 >
saa7134[0]: i2c xfer: < 10 3b [fd quirk] < 11 =ff >
saa7134[0]: i2c xfer: < 10 3b fe >
saa7134[0]: i2c xfer: < 10 2d f0 >
tda1004x: setting up plls for 53MHz sampling clock
saa7134[0]: i2c xfer: < 10 2f 08 >
saa7134[0]: i2c xfer: < 10 30 03 >
saa7134[0]: i2c xfer: < 10 3e 67 >
saa7134[0]: i2c xfer: < 10 4d d7 >
saa7134[0]: i2c xfer: < 10 4e 3f >
saa7134[0]: i2c xfer: < 10 31 5c >
saa7134[0]: i2c xfer: < 10 32 32 >
saa7134[0]: i2c xfer: < 10 33 c2 >
saa7134[0]: i2c xfer: < 10 34 96 >
saa7134[0]: i2c xfer: < 10 35 6d >
saa7134[0]: i2c xfer: < 10 37 [fd quirk] < 11 =34 >
saa7134[0]: i2c xfer: < 10 37 34 >
saa7134[0]: i2c xfer: < 10 06 [fd quirk] < 11 =b0 >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =80 >
saa7134[0]: i2c xfer: < 10 07 80 >
saa7134[0]: i2c xfer: < 10 11 67 >
saa7134[0]: i2c xfer: < 10 13 [fd quirk] < 11 =67 >
saa7134[0]: i2c xfer: < 10 14 [fd quirk] < 11 =29 >
tda1004x: found firmware revision 29 -- ok
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =80 >
saa7134[0]: i2c xfer: < 10 07 80 >
saa7134[0]: i2c xfer: < 10 01 87 >
saa7134[0]: i2c xfer: < 10 16 88 >
saa7134[0]: i2c xfer: < 10 43 0a >
saa7134[0]: i2c xfer: < 10 3d [fd quirk] < 11 =00 >
saa7134[0]: i2c xfer: < 10 3d 60 >
saa7134[0]: i2c xfer: < 10 3b [fd quirk] < 11 =ff >
saa7134[0]: i2c xfer: < 10 3b 7f >
saa7134[0]: i2c xfer: < 10 3a [fd quirk] < 11 =00 >
saa7134[0]: i2c xfer: < 10 3a 00 >
saa7134[0]: i2c xfer: < 10 37 38 >
saa7134[0]: i2c xfer: < 10 3b [fd quirk] < 11 =7f >
saa7134[0]: i2c xfer: < 10 3b 79 >
saa7134[0]: i2c xfer: < 10 47 00 >
saa7134[0]: i2c xfer: < 10 48 ff >
saa7134[0]: i2c xfer: < 10 49 00 >
saa7134[0]: i2c xfer: < 10 4a ff >
saa7134[0]: i2c xfer: < 10 46 12 >
saa7134[0]: i2c xfer: < 10 4f 1a >
saa7134[0]: i2c xfer: < 10 1e 07 >
saa7134[0]: i2c xfer: < 10 1f c0 >
saa7134[0]: i2c xfer: < 10 3b ff >
saa7134[0]: i2c xfer: < 10 37 [fd quirk] < 11 =38 >
saa7134[0]: i2c xfer: < 10 37 f8 >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =80 >
saa7134[0]: i2c xfer: < 10 07 81 >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =81 >
saa7134[0]: i2c xfer: < 10 07 83 >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =83 >
saa7134[0]: i2c xfer: < 10 07 83 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
[root@localhost ~]$  lsmod | grep saa
saa7134_dvb            17164  0
saa7134               140884  1 saa7134_dvb
ir_kbd_i2c             11280  1 saa7134
videobuf_dvb            8068  2 saa7134_dvb,cx88_dvb
videodev               35072  4 tuner,saa7134,cx8800,cx88xx
compat_ioctl32          2432  2 saa7134,cx8800
v4l2_common            13312  3 tuner,saa7134,cx8800
ir_common              38532  3 saa7134,ir_kbd_i2c,cx88xx
tveeprom               16912  2 saa7134,cx88xx
videobuf_dma_sg        15236  7 
saa7134_dvb,saa7134,cx88_dvb,videobuf_dvb,cx8802,cx8800,cx88xx
videobuf_core          20356  6 
saa7134,videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg
i2c_core               26004  24 
tda1004x,saa7134_dvb,tuner,tea5767,tda8290,tda18271,tda827x,tuner_xc2028,xc5000,tda9887,tuner_simple,mt20xx,tea5761,saa7134,ir_kbd_i2c,dvb_pll,cx22702,cx88_vp3054_i2c,cx88xx,v4l2_common,i2c_algo_bit,tveeprom,nvidia,i2c_i801





composite input is working but not DVB.

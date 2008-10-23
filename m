Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1009.centrum.cz ([90.183.38.139])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan_kus@centrum.cz>) id 1KszwG-0005sT-Hk
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 15:09:23 +0200
Received: by mail1009.centrum.cz id S738258445AbYJWNJG (ORCPT
	<rfc822;linux-dvb@linuxtv.org>); Thu, 23 Oct 2008 15:09:06 +0200
Date: Thu, 23 Oct 2008 15:09:06 +0200
From: "Jan  =?UTF-8?Q?=20K=C5=AFs?=" <jan_kus@centrum.cz>
To: <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <200810231509.31804@centrum.cz>
Subject: [linux-dvb] MSI TV @nywhere A/D v1.1 - digital not working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
should anybody help me with MSI TV @nywhere A/D v1.1. Analog is working now, 
but digital not. Here is my lsmod and dmesg logs.

pat pat # dmesg
...
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:01:09.0, rev: 209, irq: 17, latency: 255, mmio: 
0xfdef
e000
saa7133[0]: subsystem: 1462:8625, board: MSI TV@nywhere A/D v1.1 
[card=135,autod
etected]
saa7133[0]: board init: gpio is 100
tuner' 2-004b: chip found @ 0x96 (saa7133[0])
saa7133[0]: i2c eeprom 00: 62 14 25 86 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tda829x 2-004b: setting tuner address to 61
tda829x 2-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfdefe000 irq 17 registered as card -1
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 29 -- ok

pat pat # lsmod
Module                  Size  Used by
saa7134_dvb            21900  0 
videobuf_dvb            7044  1 saa7134_dvb
dvb_core               75380  2 saa7134_dvb,videobuf_dvb
dvb_pll                11784  0 
saa7134_alsa           14368  0 
saa7134               148316  2 saa7134_dvb,saa7134_alsa
compat_ioctl32          9920  1 saa7134
videobuf_dma_sg        13508  3 saa7134_dvb,saa7134_alsa,saa7134
videobuf_core          18244  3 videobuf_dvb,saa7134,videobuf_dma_sg
ir_kbd_i2c             10448  1 saa7134
ir_common              38852  2 saa7134,ir_kbd_i2c
tveeprom               15364  1 saa7134
tuner                  26572  0 
videodev               34368  3 saa7134,compat_ioctl32,tuner
v4l1_compat            14852  1 videodev
v4l2_common            12352  2 saa7134,tuner
snd_seq_oss            30912  0 
snd_seq_device          8080  1 snd_seq_oss
snd_seq_midi_event      8768  1 snd_seq_oss
snd_seq                49824  4 snd_seq_oss,snd_seq_midi_event
snd_pcm_oss            39744  0 
snd_mixer_oss          16576  1 snd_pcm_oss
snd_intel8x0           33576  3 
snd_ac97_codec        111256  1 snd_intel8x0
snd_pcm                72328  5 
saa7134_alsa,snd_pcm_oss,snd_intel8x0,snd_ac97_codec
snd_timer              21648  3 snd_seq,snd_pcm
snd                    56136  14 
saa7134_alsa,snd_seq_oss,snd_seq_device,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
snd_page_alloc         10064  2 snd_intel8x0,snd_pcm
isl6421                 4096  0 
tda826x                 5572  0 
lirc_serial            12328  0 
lirc_dev               12936  1 lirc_serial
tda1004x               17284  1 
tda827x                12036  2 
tda9887                12484  0 
tda8290                15428  1 
tda18271               35976  0 
nvidia               8101328  24 
ac97_bus                3968  1 snd_ac97_codec
parport_pc             26024  0 
forcedeth              51344  0 
soundcore               8544  1 snd
psmouse                40028  0 
i2c_nforce2             8576  0 

But  dvbtune could not tune anything :( Can anybody help me with this?

Thanks,
Jan Kus


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

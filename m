Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1JVHN8-0000Nk-It
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 03:22:47 +0100
From: timf <timf@iinet.net.au>
To: linux-dvb@linuxtv.org
Date: Sat, 01 Mar 2008 11:22:39 +0900
Message-Id: <1204338159.6536.3.camel@ubuntu>
Mime-Version: 1.0
Subject: [linux-dvb] No Tuner installed - AVerMedia_AverTV_Hybrid_FM_PCI_A16D
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
Help, please.

My TV card: AVerMedia_AverTV_Hybrid_FM_PCI_A16D

uname -a:
Linux ubuntu 2.6.22-14-generic #1 SMP Sun Oct 14 21:45:15 GMT 2007
x86_64 GNU/Linux

I have successfuly installed this for DVB-T using the instructions at
Marcus's
http://mcentral.de/wiki/index.php5/AVerMedia_AverTV_Hybrid_FM_PCI_A16D

However, I also need to view analog TV (many places in remote areas of
Australia don't have DVB-T).

I can indeed see the video in tvtime, mplayer, but never hear any audio.
I have scoured hundreds of forums re tvtime, alsa oss, etc.
All these have many suggestions, for example using sox, mixers, etc.
I can not obtain any sound from my speakers.

Then I noticed that Mauro had included this card on the latest
saa7134-cardlist.c
So I reinstalled brand new ubuntu gutsy 7.10, used mercurial to install
v4l-dvb from linuxtv.org, extracted the xc3028 firmware
into /lib/firmware/2.6.22-14-generic, and rebooted.

The card is auto recognised, but no tuner, no dvb.
With no tuner, no tv at all.
There is no tuner or dvb found in dmesg.

The relevant msgs:

lspci:
..
00:05.0 VGA compatible controller: nVidia Corporation C51PV [GeForce
6150] (rev a2)
..
00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio
(rev a2)
..
04:08.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
Video Broadcast Decoder (rev d1)

lsmod:
Module                  Size  Used by
..
video                  21140  0 
..
saa7134_alsa           17440  0 
tuner                  30676  0 
tea5767                 8708  1 tuner
tda8290                15876  1 tuner
tda18271               34568  1 tda8290
tda827x                12548  1 tda8290
tuner_xc2028           22416  1 tuner
xc5000                 12932  1 tuner
tda9887                11652  1 tuner
tuner_simple           11528  1 tuner
tuner_types            15872  1 tuner_simple
mt20xx                 14600  1 tuner
tea5761                 6916  1 tuner
snd_hda_intel         337192  1 
snd_pcm_oss            50048  0 
snd_mixer_oss          20096  1 snd_pcm_oss
snd_pcm                94344  3 saa7134_alsa,snd_hda_intel,snd_pcm_oss
snd_seq_dummy           5380  0 
snd_seq_oss            36864  0 
snd_seq_midi           11008  0 
snd_rawmidi            29824  1 snd_seq_midi
snd_seq_midi_event      9984  2 snd_seq_oss,snd_seq_midi
saa7134               163164  1 saa7134_alsa
snd_seq                62496  6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
compat_ioctl32         11136  1 saa7134
videodev               37632  3 tuner,saa7134,compat_ioctl32
v4l1_compat            15364  1 videodev
v4l2_common            14464  2 tuner,saa7134
videobuf_dma_sg        16644  2 saa7134_alsa,saa7134
ide_cd                 35488  0 
cdrom                  41768  1 ide_cd
snd_timer              27272  2 snd_pcm,snd_seq
snd_seq_device         10260  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
videobuf_core          22660  2 saa7134,videobuf_dma_sg
ir_kbd_i2c             13456  1 saa7134
ir_common              41220  2 saa7134,ir_kbd_i2c
xpad                   11400  0 
serio_raw               9092  0 
tveeprom               20624  1 saa7134
snd                    69288  12
saa7134_alsa,snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
..
i2c_nforce2             7808  0 
soundcore              10272  1 snd
snd_page_alloc         12560  2 snd_hda_intel,snd_pcm
nvidia               7013492  34 
..
i2c_core               30208  17
tuner,tea5767,tda8290,tda18271,tda827x,tuner_xc2028,xc5000,tda9887,tuner_simple,mt20xx,tea5761,saa7134,v4l2_common,ir_kbd_i2c,tveeprom,i2c_nforce2,nvidia
evdev                  13056  4 
..

dmesg:
[    0.000000] Linux version 2.6.22-14-generic (buildd@crested) (gcc
version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP Sun
Oct 14 21:45:15 GMT 2007 (Ubuntu 2.6.22-14.46-generic)
..
[   37.293992] Linux video capture interface: v2.00
[   37.346621] saa7130/34: v4l2 driver version 0.2.14 loaded
..
[   37.347159] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
latency: 32, mmio: 0xfdbff000
[   37.347165] saa7133[0]: subsystem: 1461:f936, board: AVerMedia Hybrid
TV/Radio (A16D) [card=133,autodetected]
[   37.347174] saa7133[0]: board init: gpio is 2fa00
[   37.534631] saa7133[0]: i2c eeprom 00: 61 14 36 f9 00 00 00 00 00 00
00 00 00 00 00 00
[   37.534641] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
ff ff ff ff ff ff
[   37.534649] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 00 08 ff
00 0e ff ff ff ff
[   37.534657] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534665] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff
ff ff ff ff ff ff
[   37.534673] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534681] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534689] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534698] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534706] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534714] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534723] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534731] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534741] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534749] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.534758] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   37.580456] saa7133[0]: registered device video0 [v4l2]
[   37.580512] saa7133[0]: registered device vbi0
[   37.580545] saa7133[0]: registered device radio0
..
[   37.596282] saa7134 ALSA driver for DMA sound loaded
[   37.596317] saa7133[0]/alsa: saa7133[0] at 0xfdbff000 irq 16
registered as card -2
..

Note - no mention of tuner.

There is no /dev/dvb at all.

I have studied the discussion with Richard (MQ), he seemed to at least
have a tuner.

What suggestions for me to try next, please.

timf


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n16DS9ag006139
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 08:28:09 -0500
Received: from mtaout03-winn.ispmail.ntl.com (mtaout03-winn.ispmail.ntl.com
	[81.103.221.49])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n16DRp59010986
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 08:27:51 -0500
Received: from aamtaout01-winn.ispmail.ntl.com ([81.103.221.35])
	by mtaout03-winn.ispmail.ntl.com
	(InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP id
	<20090206132750.TFXS7670.mtaout03-winn.ispmail.ntl.com@aamtaout01-winn.ispmail.ntl.com>
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 13:27:50 +0000
Received: from gateway.localdomain ([86.10.68.236])
	by aamtaout01-winn.ispmail.ntl.com
	(InterMail vG.2.02.00.01 201-2161-120-102-20060912) with ESMTP id
	<20090206132750.MMVS19264.aamtaout01-winn.ispmail.ntl.com@gateway.localdomain>
	for <video4linux-list@redhat.com>; Fri, 6 Feb 2009 13:27:50 +0000
Message-ID: <498C3AD4.1070907@tesco.net>
Date: Fri, 06 Feb 2009 13:27:48 +0000
From: John Pilkington <J.Pilk@tesco.net>
MIME-Version: 1.0
To: v4l_list <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Hauppauge HVR-1110 analog audio problem 
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Hermann:  I last corresponded with you about a year ago.  That was 
very helpful to me. Now I am having difficulty getting the v4l list 
system to recognise me, so please forgive me for sending this direct.
----------------
(My apologies - it looks as if I had unsubscribed, not just disabled 
access.  It's working now.)
----------------
I have a new(ish) box made by Gateway fitted with a

  Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected].

It works well with DVD-T but I can get no analog audio from it.  I have 
tried both the antenna input and Composite.  The picture from tvtime is 
good.  I see that people have used sox as a workaround but if that is 
still needed I haven't found the right device name yet. The 'PulseAudio 
Volume Control' 'Show all input devices' shows only HDA Intel STAC92xx 
Analog and its Monitor. But there may also be a module problem - if I 
need the module.

'# modprobe saa7134-alsa'  puts

'saa7134_alsa: Unknown symbol snd_card_new' into dmesg

System is Fedora 10 x86_64 fully updated and with the ATrpms repo enabled.

The dmesg shows that my card differs from the v4l original.  What looks 
like the relevant part of mine follows.

I hope this info is useful for you, and hope that you can help me find 
the missing audio.  Post the message if you like, but please copy any 
reply to me.

Best Wishes,

John Pilkington
---------------------------
Linux video capture interface: v2.00
firewire_core: created device fw0: GUID 0090270001c0db68, S400
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7134 0000:07:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 21, latency: 32, mmio: 
0x92014800
saa7133[0]: subsystem: 0070:6700, board: Hauppauge WinTV-HVR1110 
DVB-T/Hybrid [card=104,autodetected]
saa7133[0]: board init: gpio is 400000
saa7133[0]: i2c eeprom 00: 70 00 00 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 08 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 a3 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00
saa7133[0]: i2c eeprom 90: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09
saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
saa7133[0]: i2c eeprom b0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom c0: 84 09 00 04 20 77 00 40 d9 7d 17 f0 73 05 29 00
saa7133[0]: i2c eeprom d0: 84 08 00 06 e7 07 01 00 94 18 89 72 07 70 73 09
saa7133[0]: i2c eeprom e0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 10 01 72
saa7133[0]: i2c eeprom f0: 11 ff 79 67 00 00 00 00 00 00 00 00 00 00 00 00
nvidia: module license 'NVIDIA' taints kernel.
tuner' 1-004b: chip found @ 0x96 (saa7133[0])
tveeprom 1-0050: Hauppauge model 67559, rev B1B4, serial# 1539545
tveeprom 1-0050: MAC address is 00-0D-FE-17-7D-D9
tveeprom 1-0050: tuner model is Philips 8275A (idx 114, type 4)
tveeprom 1-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') 
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
tveeprom 1-0050: audio processor is SAA7131 (idx 41)
tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
tveeprom 1-0050: has radio
saa7133[0]: hauppauge eeprom: model=67559
tda829x 1-004b: setting tuner address to 61
tda829x 1-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.22  Tue Jan  6 
09:15:58 PST 2009
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
input: HDA Intel at 0x92220000 irq 22 Line In at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/input/input7
input: HDA Intel at 0x92220000 irq 22 Mic at Ext Front Jack as 
/devices/pci0000:00/0000:00:1b.0/input/input8
tda1004x: setting up plls for 48MHz sampling clock
input: HDA Intel at 0x92220000 irq 22 Mic at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/input/input9
input: HDA Intel at 0x92220000 irq 22 Speaker at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/input/input10
input: HDA Intel at 0x92220000 irq 22 Speaker at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/input/input11
input: HDA Intel at 0x92220000 irq 22 Speaker at Ext Rear Jack as 
/devices/pci0000:00/0000:00:1b.0/input/input12
input: HDA Intel at 0x92220000 irq 22 HP Out at Ext Front Jack as 
/devices/pci0000:00/0000:00:1b.0/input/input13
-----
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: waiting for firmware upload...
firmware: requesting dvb-fe-tda10046.fw
----------
tda1004x: found firmware revision 20 -- ok
------------
etc




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

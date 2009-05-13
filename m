Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4D9WIRa017536
	for <video4linux-list@redhat.com>; Wed, 13 May 2009 05:32:18 -0400
Received: from smtp.inserm.fr (smtp.inserm.fr [195.98.252.37])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n4D9W1Fk032627
	for <video4linux-list@redhat.com>; Wed, 13 May 2009 05:32:02 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp.inserm.fr (SrvInserm) with ESMTP id 43E338970
	for <video4linux-list@redhat.com>;
	Wed, 13 May 2009 11:32:01 +0200 (CEST)
Received: from smtp.inserm.fr ([195.98.252.37])
	by localhost (potentille.inserm.fr [127.0.0.1]) (amavisd-new,
	port 10026)
	with ESMTP id wYGBHWFx1AH8 for <video4linux-list@redhat.com>;
	Wed, 13 May 2009 11:32:01 +0200 (CEST)
Received: from piment.inserm.fr (piment.inserm.fr [195.98.252.123])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.inserm.fr (SrvInserm) with ESMTP id 266E0896F
	for <video4linux-list@redhat.com>;
	Wed, 13 May 2009 11:32:01 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by piment.inserm.fr (Postfix) with ESMTP id 166EF2C003
	for <video4linux-list@redhat.com>;
	Wed, 13 May 2009 11:32:01 +0200 (CEST)
Received: from piment.inserm.fr ([127.0.0.1])
	by localhost (piment.inserm.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FhferW0Qa5Bk for <video4linux-list@redhat.com>;
	Wed, 13 May 2009 11:32:00 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by piment.inserm.fr (Postfix) with ESMTP id AC8892C002
	for <video4linux-list@redhat.com>;
	Wed, 13 May 2009 11:32:00 +0200 (CEST)
Message-ID: <20090513113200.vqu887149wosgk48@imp.inserm.fr>
Date: Wed, 13 May 2009 11:32:00 +0200
From: yves.lefeuvre@inserm.fr
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Philips FMD1216ME MK3 Hybrid Tuner
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

Hi all,

There has been lot of recent work concerning Philips FM1216 tuner  
series. Could it be the case that this work might help to bring my  
Asus Europa2 OEM card up again. This card has stopped working since  
kernel 2.6.26, and I have been unable to make it work with more recent  
kernels (there was a thread about this in January-ferbruary. The only  
progress is that now the tda9887 loads automatically)


Thanks for help!

Yves

some additional info: I switched to fedora 11 x86_64 (still beta), and  
use latest v4l-dvb tree on vanilla kernel

[root@localhost v4l-dvb]# uname -a
Linux localhost.localdomain 2.6.29.1 #1 SMP Tue Apr 21 09:44:00 CEST  
2009 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost v4l-dvb]# dmesg -c 2>&1>/dev/null
[root@localhost v4l-dvb]# lsmod | egrep "tda|v4l|video|saa|dvb"
[root@localhost v4l-dvb]# /sbin/modprobe saa7134 i2c_debug=1 irq_debug=1
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
=1c =55 =d2 =b2 =92 =00 =ff =86 =0f =ff =20 =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =01 =40 =01 =03 =03 =02 =03 =04 =08 =ff =00 =4c =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =1d =00 =c2 =86 =10 =01 =01 =0d =01 =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff  
=ff =ff =ff =ff =ff =ff =ff >
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
saa7134[0]: i2c xfer: < 10 07 02 >
saa7134[0]: i2c xfer: < 84 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < 86 >
saa7134[0]: i2c xfer: < 86 00 >
saa7134[0]: i2c xfer: < 87 =10 =10 =10 =10 =10 =10 =10 =10 >
tuner 1-0043: chip found @ 0x86 (saa7134[0])
tda9887 1-0043: creating new instance
tda9887 1-0043: tda988[5/6/7] found
saa7134[0]: i2c xfer: < 86 00 c0 00 00 >
tuner i2c attach [addr=0x43,client=tuner]
saa7134[0]: i2c xfer: < c0 ERROR: NO_DEVICE
saa7134[0]: i2c xfer: < c2 >
tuner 1-0061: chip found @ 0xc2 (saa7134[0])
tuner i2c attach [addr=0x61,client=tuner]
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
saa7134[0]: i2c xfer: < 86 00 a0 00 00 >
saa7134[0]: i2c xfer: < c2 07 ac 80 19 >
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 1b 6f 86 52 >
saa7134[0]: i2c xfer: < 86 00 20 00 00 >
saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
saa7134[0]/irq[0,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[1,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[2,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[3,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[4,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[5,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[6,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[7,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[8,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[9,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq[10,4303846133]: r=0x20 s=0x10 PE
saa7134[0]/irq: looping -- clearing PE (parity error!) enable bit
saa7134[0]/irq[0,4303846133]: r=0x20 s=0x10 PE
dvb_init() allocating 1 frontend
saa7134[0]: i2c xfer: < 10 00 [fd quirk] < 11 =46 >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =02 >
saa7134[0]: i2c xfer: < 10 07 02 >
saa7134[0]: i2c xfer: < c3 =30 >
saa7134[0]: i2c xfer: < 10 07 [fd quirk] < 11 =02 >
saa7134[0]: i2c xfer: < 10 07 00 >
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
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
saa7134 ALSA driver for DMA sound loaded
IRQ 19/saa7134[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7134[0]/alsa: saa7134[0] at 0xf9ffe000 irq 19 registered as card -1
[root@localhost v4l-dvb]# lsmod | egrep "tda|v4l|video|saa|dvb"
saa7134_alsa           13440  0
tda1004x               15604  1
saa7134_dvb            23484  0
videobuf_dvb            7092  1 saa7134_dvb
dvb_core               87724  1 videobuf_dvb
tda9887                10596  1
tda8290                11268  0
saa7134               165972  2 saa7134_alsa,saa7134_dvb
ir_common              44132  1 saa7134
v4l2_common            14816  2 tuner,saa7134
videodev               35760  3 tuner,saa7134,v4l2_common
v4l1_compat            13124  1 videodev
v4l2_compat_ioctl32    10432  1 videodev
videobuf_dma_sg        11748  3 saa7134_alsa,saa7134_dvb,saa7134
videobuf_core          16356  3 videobuf_dvb,saa7134,videobuf_dma_sg
tveeprom               13716  1 saa7134
snd_pcm                79336  3 saa7134_alsa,snd_hda_intel,snd_hda_codec
snd                    65496  9  
saa7134_alsa,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer
i2c_core               22608  13  
tda1004x,saa7134_dvb,tuner_simple,tda9887,tda8290,tuner,saa7134,v4l2_common,videodev,tveeprom,i2c_algo_bit,nvidia,i2c_i801




----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

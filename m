Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0MFiG2U025514
	for <video4linux-list@redhat.com>; Thu, 22 Jan 2009 10:44:16 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n0MFhxRE027748
	for <video4linux-list@redhat.com>; Thu, 22 Jan 2009 10:44:00 -0500
Message-ID: <4978943F.5090201@gmx.net>
Date: Thu, 22 Jan 2009 16:43:59 +0100
From: TCP/IP <t-cp@gmx.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <S1752508AbZAVNYE/20090122132404Z+405@vger.kernel.org>
In-Reply-To: <S1752508AbZAVNYE/20090122132404Z+405@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: saa7134-alsa.ko and alsa-driver-1.0.19
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

Hi everybody

Has anyone of you got the saa7134-alsa module running with
alsa-driver-1.0.19 ?


root@MythTV:~# modprobe -v saa7134-alsa
insmod
/lib/modules/2.6.27.8/kernel/drivers/media/video/saa7134/saa7134-alsa.ko
FATAL: Error inserting saa7134_alsa
(/lib/modules/2.6.27.8/kernel/drivers/media/video/saa7134/saa7134-alsa.ko):
Unknown symbol in module, or unknown parameter (see dmesg)


root@MythTV:~# dmesg |less
[ 7543.401381] Linux video capture interface: v2.00
[ 7543.412129] saa7130/34: v4l2 driver version 0.2.14 loaded
[ 7543.412157] saa7133[0]: found at 0000:04:00.0, rev: 209, irq: 16,
latency: 64, mmio: 0xfebff800
[ 7543.412162] saa7133[0]: subsystem: 1043:4845, board: ASUSTeK P7131
Analog [card=146,insmod option]
[ 7543.412170] saa7133[0]: board init: gpio is 0
[ 7543.412210] input: saa7134 IR (ASUSTeK P7131 Analo as
/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/input/input9
[ 7543.558005] saa7133[0]: i2c eeprom 00: 43 10 45 48 54 20 1c 00 43 43
a9 1c 55 d2 b2 92
[ 7543.558022] saa7133[0]: i2c eeprom 10: 00 ff e2 0f ff 20 ff ff ff ff
ff ff ff ff ff ff
[ 7543.558038] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff
00 88 ff ff ff ff
[ 7543.558054] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558071] saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 ff 02 30 15 ff
ff ff ff ff ff ff
[ 7543.558086] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558102] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558118] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558136] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558152] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558168] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558184] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558195] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558206] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558216] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.558227] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 7543.578071] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[ 7543.613005] tda829x 1-004b: setting tuner address to 61
[ 7543.649006] tda829x 1-004b: type set to tda8290+75a
[ 7546.226225] saa7133[0]: registered device video0 [v4l2]
[ 7546.226270] saa7133[0]: registered device vbi0
[ 7546.226312] saa7133[0]: registered device radio0
[ 7546.258185] saa7134_alsa: Unknown symbol snd_card_new


i needed to upgrade the alsa driver in order to get the
00:1b.0 Audio device: Intel Corporation ICH10 HD Audio Controller
soundcard propperly running, so using the alsa out of the kernel source
(using 2.6.27.8 right now) is not an option

do you have any ideas?
i have read somthing about editing the #ifdef-s in compat.h but i have
to admit that i don-t understand what to do there.


Thanks a lot in advance!

Ben


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

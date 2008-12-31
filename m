Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBVAaljt026746
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 05:36:47 -0500
Received: from patsy.thehobsons.co.uk (patsy.thehobsons.co.uk [81.174.135.208])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBVAaVAr031249
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 05:36:31 -0500
Received: from localhost (localhost [127.0.0.1])
	by patsy.thehobsons.co.uk (Postfix) with ESMTP id 42D111B4745
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 10:36:30 +0000 (GMT)
Received: from patsy.thehobsons.co.uk ([127.0.0.1])
	by localhost (patsy.thehobsons.co.uk [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id WuyindW1qZCn for <video4linux-list@redhat.com>;
	Wed, 31 Dec 2008 10:36:30 +0000 (GMT)
Received: from simon.thehobsons.co.uk (Simons-MacBookPro.thehobsons.co.uk
	[192.168.0.149])
	by patsy.thehobsons.co.uk (Postfix) with ESMTP id EF4DA1B4741
	for <video4linux-list@redhat.com>; Wed, 31 Dec 2008 10:36:29 +0000 (GMT)
Mime-Version: 1.0
Message-Id: <a06240804c580f44d7a48@simon.thehobsons.co.uk>
Date: Wed, 31 Dec 2008 10:36:26 +0000
To: video4linux-list@redhat.com
From: Simon Hobson <linux@thehobsons.co.uk>
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Subject: Problem setting up HVR-1110
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

I've got MythTV installed and bought a Hauppage HVR-1110 card for it. 
The card is detected and the saa7134 driver loaded - but that seems 
to be it. Everything I can find suggests that the card should be 
identified automatically (and the TDA1004X driver & firmware loaded), 
but it isn't.

What I get in dmesg is :

>saa7130/34: v4l2 driver version 0.2.14 loaded
>PCI: Enabling device 0000:00:00.0 (0000 -> 0002)
>saa7133[0]: found at 0000:00:00.0, rev: 209, irq: 17, latency: 32, 
>mmio: 0xf4100000
>saa7133[0]: subsystem: 0070:6701, board: UNKNOWN/GENERIC [card=0,autodetected]
>saa7133[0]: board init: gpio is 6400000
>saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
>saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 aa ff ff ff ff
>saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
>saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>saa7133[0]: registered device video0 [v4l2]
>saa7133[0]: registered device vbi0

and nothing at all about tda devices.

This doesn't change (apart from two lines referring to the ALSA 
driver) when I add a config file containing :
>install saa7134 /sbin/modprobe  --ignore-install saa7134 && { 
>/sbin/modprobe saa7134-alsa; } && { /sbin/modprobe saa7134-dvb;}
>options saa7134 card=104
to /etc/modprobe.d

uname -a reports :
>Linux eddi 2.6.18-6-xen-amd64 #1 SMP Fri Dec 12 07:02:03 UTC 2008 
>x86_64 GNU/Linux


Yes, this is running in a Xen guest - but I've also tried booting the 
machine into a non-Xen mode (with non-Xen kernel) and it behaves 
exactly the same. In both cases, the OS is Debian Lenny.

lspci says :
>00:00.0 Multimedia controller: Philips Semiconductors 
>SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)

lsmod | grep 'tda
>  saa' says :

>saa7134_dvb            19460  0
>dvb_pll                20612  1 saa7134_dvb
>mt352                  11780  1 saa7134_dvb
>video_buf_dvb          11396  1 saa7134_dvb
>nxt200x                18308  1 saa7134_dvb
>tda1004x               20100  1 saa7134_dvb
>firmware_class         15616  3 saa7134_dvb,nxt200x,tda1004x
>saa7134_alsa           18912  0
>snd_pcm                89352  2 saa7134_alsa,snd_pcm_oss
>snd                    65384  8 
>saa7134_alsa,snd_pcm_oss,snd_pcm,snd_mixer_oss,snd_seq_oss,snd_seq,snd_timer,snd_seq_device
>saa7134               130408  2 saa7134_dvb,saa7134_alsa
>video_buf              31108  4 saa7134_dvb,video_buf_dvb,saa7134_alsa,saa7134
>compat_ioctl32         13184  1 saa7134
>ir_kbd_i2c             14608  1 saa7134
>i2c_core               27776  7 
>saa7134_dvb,dvb_pll,mt352,nxt200x,tda1004x,saa7134,ir_kbd_i2c
>ir_common              34692  2 saa7134,ir_kbd_i2c
>videodev               29696  1 saa7134
>v4l1_compat            16260  2 saa7134,videodev
>v4l2_common            28672  3 saa7134,compat_ioctl32,videodev


Any suggestions ?

-- 
Simon Hobson

Visit http://www.magpiesnestpublishing.co.uk/ for books by acclaimed
author Gladys Hobson. Novels - poetry - short stories - ideal as
Christmas stocking fillers. Some available as e-books.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm19.bullet.mail.ukl.yahoo.com ([217.146.183.193]:20773 "HELO
	nm19.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752358Ab2DWLd2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:33:28 -0400
References: <1335179065.92781.YahooMailNeo@web28601.mail.ukl.yahoo.com>
Message-ID: <1335180408.87756.YahooMailNeo@web28616.mail.ukl.yahoo.com>
Date: Mon, 23 Apr 2012 12:26:48 +0100 (BST)
From: cb cb <chrbruno@yahoo.fr>
Reply-To: cb cb <chrbruno@yahoo.fr>
Subject: Re : em28xx on beagleboard with dazzle DVC100 + lsusb
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <1335179065.92781.YahooMailNeo@web28601.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, i forgot the lsusb output
Christian


root@aravis:~# lsusb
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 004: ID 2304:021a Pinnacle Systems, Inc. Dazzle DVC100 Audio Device
Bus 001 Device 003: ID 0424:ec00 Standard Microsystems Corp.
Bus 001 Device 002: ID 0424:9514 Standard Microsystems Corp.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub




----- Mail original -----
De : cb cb <chrbruno@yahoo.fr>
À : "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc : 
Envoyé le : Lundi 23 avril 2012 13h04
Objet : em28xx on beagleboard with dazzle DVC100

hello,

i'm trying to capture video using a Dazzle DVC 100 RCA to USB converter ( em28xx driver )

the program is the famous "capture.c" sample from the docs
It is running on a BeagleBoard Xm with kernel 3.2.11

i get timeout errors at the "select" call, either using mmap, read or userp access

the same program works fine on an x86 platform (kernel 2.6.32)

Could you help me figure out what is wrong ?

Thanks a lot for your help,
Best Regards,

Christian


below are the output from dmesg and capture sample program :

[ 1783.364410] em28xx: New device Pinnacle Systems GmbH DVC100 @ 480 Mbps (2304:021a, interface 0, class 0)
[ 1783.393707] em28xx #0: chip ID is em2820 (or em2710)
[ 1783.557861] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 1a 02 12 00 11 03 98 10 6a 2e
[ 1783.570831] em28xx #0: i2c eeprom 10: 00 00 06 57 4e 00 00 00 60 00 00 00 02 00 00 00
[ 1783.583557] em28xx #0: i2c eeprom 20: 02 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1783.596191] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00
[ 1783.608947] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1783.621582] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1783.634155] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2e 03 50 00 69 00
[ 1783.646667] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
[ 1783.659301] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 20 00 47 00
[ 1783.672119] em28xx #0: i2c eeprom 90: 6d 00 62 00 48 00 00 00 10 03 44 00 56 00 43 00
[ 1783.684600] em28xx #0: i2c eeprom a0: 31 00 30 00 30 00 00 00 32 00 30 00 33 00 35 00
[ 1783.697113] em28xx #0: i2c eeprom b0: 36 00 30 00 37 00 35 00 31 00 33 00 34 00 31 00
[ 1783.709716] em28xx #0: i2c eeprom c0: 30 00 32 00 30 00 30 00 30 00 31 00 00 00 32 00
[ 1783.722290] em28xx #0: i2c eeprom d0: 33 00 31 00 32 00 33 00 00 00 00 00 00 00 00 00
[ 1783.734619] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1783.746826] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 bc 6f ec 04 99 62 5d 0e
[ 1783.759155] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x30129684
[ 1783.769622] em28xx #0: EEPROM info:
[ 1783.776794] em28xx #0:       AC97 audio (5 sample rates)
[ 1783.785217] em28xx #0:       300mA max power
[ 1783.792541] em28xx #0:       Table at 0x06, strings=0x1098, 0x2e6a, 0x0000
[ 1783.804077] em28xx #0: Identified as Pinnacle Dazzle DVC 
90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 
(card=9)
[ 1784.313751] saa7115 4-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
[ 1785.320953] em28xx #0: Config register raw data: 0x12
[ 1785.359527] em28xx #0: AC97 vendor ID = 0xffffffff
[ 1785.382995] em28xx #0: AC97 features = 0x6a90
[ 1785.391174] em28xx #0: Empia 202 AC97 audio processor detected
[ 1785.999938] em28xx #0: v4l2 driver version 0.1.3
[ 1787.218750] em28xx #0: V4L2 video device registered as video0
[ 1787.228454] em28xx audio device (2304:021a): interface 1, class 1
[ 1787.238342] em28xx audio device (2304:021a): interface 2, class 1
[ 1787.248229] usbcore: registered new interface driver em28xx
[ 1787.257507] em28xx driver loaded
[ 1787.348968] ALSA sound/usb/mixer.c:846 2:1: cannot get min/max values for control 2 (id 2)

root@aravis:~# ./a.out -m -d /dev/video0
select timeout
root@aravis:~# ./a.out -r -d /dev/video0
select timeout
root@aravis:~# ./a.out -u -d /dev/video0
VIDIOC_QBUF error 22, Invalid argument
root@aravis:~#




[ 1787.367309] usbcore: registered new interface driver snd-usb-audio
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


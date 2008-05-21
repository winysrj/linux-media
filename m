Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4LJCINJ009566
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 15:12:18 -0400
Received: from monty.telenet-ops.be (monty.telenet-ops.be [195.130.132.56])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4LJC6rP028553
	for <video4linux-list@redhat.com>; Wed, 21 May 2008 15:12:06 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by monty.telenet-ops.be (Postfix) with SMTP id 8A58554058
	for <video4linux-list@redhat.com>;
	Wed, 21 May 2008 21:12:05 +0200 (CEST)
Received: from callisto.tagana.com (d54C1842C.access.telenet.be
	[84.193.132.44])
	by monty.telenet-ops.be (Postfix) with ESMTP id 6C9DE5402B
	for <video4linux-list@redhat.com>;
	Wed, 21 May 2008 21:12:05 +0200 (CEST)
Message-ID: <48347405.601@telenet.be>
Date: Wed, 21 May 2008 21:12:05 +0200
From: Marc Di Meo <marc.di.meo@telenet.be>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Pinnacle hybrid pro 320e problem
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

After using it successfully in the past and not having used it several 
months I tried to use my Pinnacle hybrid pro 320e on my new installed 
Fedora 9, and it no longer works, tvtime cannot find a tuner apparently 
and mplayer also does not show any channels, when checking dmesg I got this:

usb 1-3: new high speed USB device using ehci_hcd and address 18
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: New USB device found, idVendor=eb1a, idProduct=2881
usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-3: Product: USB 2881 Video
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (eb1a:2881): interface 0, class 255
em28xx Has usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: em28xx chip ID = 36
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17 98 01 00 00 00 00
em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
EEPROM ID= 0x9567eb1a, hash = 0xb8846b20
Vendor/Product ID= eb1a:2881
AC97 audio (5 sample rates)
USB Remote wakeup capable
500mA max power
Table at 0x04, strings=0x206a, 0x006a, 0x0000
em28xx #0: found i2c device @ 0xa0 [eeprom]
em28xx #0: found i2c device @ 0xb8 [tvp5150a]
em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
em28xx #0: Your board has no unique USB ID and thus need a hint to be 
detected.
em28xx #0: You may try to use card=<n> insmod option to workaround that.
em28xx #0: Please send an email with this log to:
em28xx #0:     V4L Mailing List <video4linux-list@redhat.com>
em28xx #0: Board eeprom hash is 0xb8846b20
em28xx #0: Board i2c devicelist hash is 0x27e10080
em28xx #0: Here is a list of valid choices for the card=<n> insmod option:
em28xx #0:     card=0 -> Unknown EM2800 video grabber
em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber
em28xx #0:     card=2 -> Terratec Cinergy 250 USB
em28xx #0:     card=3 -> Pinnacle PCTV USB 2
em28xx #0:     card=4 -> Hauppauge WinTV USB 2
em28xx #0:     card=5 -> MSI VOX USB 2.0
em28xx #0:     card=6 -> Terratec Cinergy 200 USB
em28xx #0:     card=7 -> Leadtek Winfast USB II
em28xx #0:     card=8 -> Kworld USB2800
em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/DVC 100
em28xx #0:     card=10 -> Hauppauge WinTV HVR 900
em28xx #0:     card=11 -> Terratec Hybrid XS
em28xx #0:     card=12 -> Kworld PVR TV 2800 RF
em28xx #0:     card=13 -> Terratec Prodigy XS
em28xx #0:     card=14 -> Pixelview Prolink PlayTV USB 2.0
em28xx #0:     card=15 -> V-Gear PocketTV
em28xx #0:     card=16 -> Hauppauge WinTV HVR 950
tvp5150 1-005c: tvp0050am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Unknown EM2750/28xx video grabber
em28xx audio device (eb1a:2881): interface 1, class 1
em28xx audio device (eb1a:2881): interface 2, class 1
usbcore: registered new interface driver em28xx
ALSA sound/usb/usbaudio.c:2798: 18:2:1: add audio endpoint 0x83
ALSA sound/usb/usbaudio.c:2798: 18:2:2: add audio endpoint 0x83
ALSA sound/usb/usbaudio.c:2798: 18:2:3: add audio endpoint 0x83
ALSA sound/usb/usbaudio.c:2798: 18:2:4: add audio endpoint 0x83
ALSA sound/usb/usbaudio.c:2798: 18:2:5: add audio endpoint 0x83
ALSA sound/usb/usbmixer.c:988: [2] FU [PCM Capture Switch] ch = 1, val = 
0/1/1
ALSA sound/usb/usbmixer.c:405: cannot set ctl value: req = 0x4, wValue = 
0x200, wIndex = 0x201, type = 4, data = 0x0/0x1
ALSA sound/usb/usbmixer.c:988: [2] FU [PCM Capture Volume] ch = 1, val = 
0/0/512
usbcore: registered new interface driver snd-usb-audio
ALSA sound/usb/usbaudio.c:1353: setting usb interface 2:2

lsusb output:

Bus 001 Device 018: ID eb1a:2881 eMPIA Technology, Inc.
Bus 001 Device 017: ID 049f:0081 Compaq Computer Corp.
Bus 001 Device 016: ID 046d:c50c Logitech, Inc.
Bus 001 Device 015: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 001 Device 014: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

cat /proc/version:

Linux version 2.6.25.3-18.fc9.i686 (mockbuild@) (gcc version 4.3.0 
20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Tue May 13 05:38:53 EDT 2008


Anyone have any ideas?
Regards,
Marc

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

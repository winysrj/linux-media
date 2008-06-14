Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5EAmBIf019546
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 06:48:11 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5EAlxqE024122
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 06:47:59 -0400
Received: from smtp4-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp4-g19.free.fr (Postfix) with ESMTP id EA5713EA0B3
	for <video4linux-list@redhat.com>;
	Sat, 14 Jun 2008 12:47:58 +0200 (CEST)
Received: from geekette.local (dou45-3-88-170-168-121.fbx.proxad.net
	[88.170.168.121])
	by smtp4-g19.free.fr (Postfix) with ESMTP id 9A86C3EA0BA
	for <video4linux-list@redhat.com>;
	Sat, 14 Jun 2008 12:47:58 +0200 (CEST)
Date: Sat, 14 Jun 2008 12:47:57 +0200
To: video4linux-list@redhat.com
Message-ID: <20080614104757.GA17928@geekette.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
From: thomas.harding@laposte.net (Thomas Harding)
Subject: dmesg output for Pinnacle TV for Mac DVB-T Stick
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


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


As says in dmesg output,
Here are the dmesg outputs for usb device
"Pinnacle TV for MAc DVB-T Stick"

usb 4-2: new high speed USB device using ehci_hcd and address 3
usb 4-2: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (1aeb:7028): interface 0, class 255
em28xx Doesn't have usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: em28xx chip ID = 35
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 78 4e 6b 48
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
EEPROM ID= 0x1aeb6795, hash = 0x00000000
Vendor/Product ID= 1aeb:7028
AC97 audio (5 sample rates)
300mA max power
Table at 0x04, strings=0x6a22, 0x0000, 0x0000
em28xx #0: found i2c device @ 0xa0 [eeprom]
em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
em28xx #0: You may try to use card=<n> insmod option to workaround that.
em28xx #0: Please send an email with this log to:
em28xx #0: 	V4L Mailing List <video4linux-list@redhat.com>
em28xx #0: Board eeprom hash is 0x00000000
em28xx #0: Board i2c devicelist hash is 0x4b800080
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
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Unknown EM2750/28xx video grabber
usbcore: registered new interface driver em28xx

-- 
Thomas Harding

--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dvbcard

usb 4-2: new high speed USB device using ehci_hcd and address 3
usb 4-2: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (1aeb:7028): interface 0, class 255
em28xx Doesn't have usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: em28xx chip ID = 35
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 70 28 c0 12 81 00 6a 22 00 00
em28xx #0: i2c eeprom 10: 00 00 04 57 02 0d 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 02 00 00 00 00 00 5b 00 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 78 4e 6b 48
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 37 00 30 00 20 00 44 00
em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
EEPROM ID= 0x1aeb6795, hash = 0x00000000
Vendor/Product ID= 1aeb:7028
AC97 audio (5 sample rates)
300mA max power
Table at 0x04, strings=0x6a22, 0x0000, 0x0000
em28xx #0: found i2c device @ 0xa0 [eeprom]
em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.
em28xx #0: You may try to use card=<n> insmod option to workaround that.
em28xx #0: Please send an email with this log to:
em28xx #0: 	V4L Mailing List <video4linux-list@redhat.com>
em28xx #0: Board eeprom hash is 0x00000000
em28xx #0: Board i2c devicelist hash is 0x4b800080
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
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Unknown EM2750/28xx video grabber
usbcore: registered new interface driver em28xx

--gKMricLos+KVdGMg
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--gKMricLos+KVdGMg--

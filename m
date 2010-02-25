Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1PIrA1F016233
	for <video4linux-list@redhat.com>; Thu, 25 Feb 2010 13:53:10 -0500
Received: from homiemail-a13.g.dreamhost.com (caiajhbdcaib.dreamhost.com
	[208.97.132.81])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1PIqsuq028682
	for <video4linux-list@redhat.com>; Thu, 25 Feb 2010 13:52:54 -0500
Received: from [2.3.4.139] (nat-216-240-30-23.netapp.com [216.240.30.23])
	by homiemail-a13.g.dreamhost.com (Postfix) with ESMTPA id 300116A806F
	for <video4linux-list@redhat.com>; Thu, 25 Feb 2010 10:52:53 -0800 (PST)
Message-ID: <4B86C704.3060709@swartzlander.org>
Date: Thu, 25 Feb 2010 13:52:52 -0500
From: Ben Swartzlander <ben@swartzlander.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Chronic USB disconnect events for Pinnacle Dazzle DVC 100 video
	capture device
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

I have a Pinnacle Dazzle DVC 100 USB video capture device hooked up to a 
security camera capturing video 24/7. A few times a month, my kernel 
suddenly decides that the USB device was disconnected and reconnected, 
resulting in the device getting a new number and causing my recording 
software to stop recording until I restart it with the new device 
number. Here is an example of the dmesg output when it happens:

[1126917.418424] usb 2-8: USB disconnect, address 3
[1126917.444413] em28xx #0: disconnecting em28xx #0 video
[1126917.445563] em28xx #0: device /dev/video4 is open! Deregistration 
and memory deallocation are deferred on close.
[1126917.701033] usb 2-8: new high speed USB device using ehci_hcd and 
address 4
[1126917.846251] usb 2-8: configuration #1 chosen from 1 choice
[1126917.847514] em28xx new video device (2304:021a): interface 0, class 255
[1126917.847552] em28xx Has usb audio class
[1126917.847554] em28xx #1: Alternate settings: 8
[1126917.847556] em28xx #1: Alternate setting 0, max size= 0
[1126917.847557] em28xx #1: Alternate setting 1, max size= 1024
[1126917.847559] em28xx #1: Alternate setting 2, max size= 1448
[1126917.847605] em28xx #1: Alternate setting 3, max size= 2048
[1126917.847607] em28xx #1: Alternate setting 4, max size= 2304
[1126917.847608] em28xx #1: Alternate setting 5, max size= 2580
[1126917.847610] em28xx #1: Alternate setting 6, max size= 2892
[1126917.847611] em28xx #1: Alternate setting 7, max size= 3072
[1126917.849350] em28xx #1: em28xx chip ID = 18
[1126918.507903] saa7115' 7-0025: saa7113 found (1f7113d0e100000) @ 0x4a 
(em28xx #1)
[1126919.323999] em28xx #1: i2c eeprom 00: 1a eb 67 95 04 23 1a 02 12 00 
11 03 98 10 6a 2e
[1126919.324013] em28xx #1: i2c eeprom 10: 00 00 06 57 4e 00 00 00 60 00 
00 00 02 00 00 00
[1126919.324022] em28xx #1: i2c eeprom 20: 02 00 01 00 00 00 00 00 00 00 
00 00 00 00 00 00
[1126919.324028] em28xx #1: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 
00 00 00 00 00 00
[1126919.324033] em28xx #1: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[1126919.324039] em28xx #1: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[1126919.324046] em28xx #1: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 
2e 03 50 00 69 00
[1126919.324058] em28xx #1: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 
65 00 20 00 53 00
[1126919.324070] em28xx #1: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 
73 00 20 00 47 00
[1126919.324083] em28xx #1: i2c eeprom 90: 6d 00 62 00 48 00 00 00 10 03 
44 00 56 00 43 00
[1126919.324096] em28xx #1: i2c eeprom a0: 31 00 30 00 30 00 00 00 32 00 
30 00 33 00 35 00
[1126919.324108] em28xx #1: i2c eeprom b0: 36 00 30 00 37 00 35 00 31 00 
33 00 34 00 31 00
[1126919.324121] em28xx #1: i2c eeprom c0: 30 00 32 00 30 00 30 00 30 00 
31 00 00 00 32 00
[1126919.324134] em28xx #1: i2c eeprom d0: 33 00 31 00 32 00 33 00 00 00 
00 00 00 00 00 00
[1126919.324147] em28xx #1: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00
[1126919.324159] em28xx #1: i2c eeprom f0: 00 00 00 00 00 00 00 00 69 4d 
74 05 ad 62 5d 0e
[1126919.324173] EEPROM ID= 0x9567eb1a, hash = 0x20810e85
[1126919.324175] Vendor/Product ID= 2304:021a
[1126919.324177] AC97 audio (5 sample rates)
[1126919.324179] 300mA max power
[1126919.324182] Table at 0x06, strings=0x1098, 0x2e6a, 0x0000
[1126919.917596] em28xx #1: V4L2 device registered as /dev/video5 and 
/dev/vbi5
[1126919.917606] em28xx #1: Found Pinnacle Dazzle DVC 90/DVC 100

This machine is running Ubuntu 8.10 with kernel 2.6.27-17-generic. Is 
this a known problem for this particular capture device or a potential 
driver issue? Should I be bugging the USB people instead of this list? 
Any ideas would be appreciated.

thanks,
-Ben Swartzlander

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

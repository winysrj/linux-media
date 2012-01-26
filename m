Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61622 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305Ab2AZTc7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 14:32:59 -0500
Received: by lagu2 with SMTP id u2so533140lag.19
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 11:32:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F21989A.9080300@iki.fi>
References: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
	<4F2117D6.20702@iki.fi>
	<CAGa-wNNnaJbrLdAGA9cX=wMBwZYtVp8JLseeTGevDJH-tyDpeQ@mail.gmail.com>
	<4F213FEF.8030309@iki.fi>
	<CAGa-wNO5GihQcxBF88yXC7B=PO3upw-pN5YGzJ5Rm_+Sji9iBg@mail.gmail.com>
	<4F21989A.9080300@iki.fi>
Date: Thu, 26 Jan 2012 20:25:19 +0100
Message-ID: <CAGa-wNNgaboTTOP8UgrrbDjJbrFokKhJ03wpwYWs+_9MVQh+-w@mail.gmail.com>
Subject: Re: 290e locking issue
From: Claus Olesen <ceolesen@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just came to think of my old 800e because also it is a em28xx device
and for what it is worth I just tried it and it does not exhibit the
issue. it's dmesg is

>inplug 800e
[  179.499370] usb 2-4: new high-speed USB device number 2 using ehci_hcd
[  179.622477] usb 2-4: New USB device found, idVendor=2304, idProduct=0227
[  179.622486] usb 2-4: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[  179.622494] usb 2-4: Product: PCTV 800e
[  179.622500] usb 2-4: Manufacturer: Pinnacle Systems
[  179.622505] usb 2-4: SerialNumber: 061101051592
[  179.915633] em28xx: New device Pinnacle Systems PCTV 800e @ 480
Mbps (2304:0227, interface 0, class 0)
[  179.915636] em28xx: Audio Vendor Class interface 0 found
[  179.915638] em28xx: Video interface 0 found
[  179.915639] em28xx: DVB interface 0 found
[  179.915749] em28xx #0: chip ID is em2882/em2883
[  180.058726] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 27 02 d0 12
5c 03 8e 16 a4 1c
[  180.058753] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00
00 00 00 00 00 00
[  180.058775] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00
00 00 5b 1c 00 00
[  180.058798] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
00 00 00 00 00 00
[  180.058820] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  180.058841] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  180.058862] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
24 03 50 00 69 00
[  180.058884] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00
65 00 20 00 53 00
[  180.058906] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00
73 00 00 00 16 03
[  180.058928] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00
38 00 30 00 30 00
[  180.058950] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 36 00
31 00 31 00 30 00
[  180.058972] em28xx #0: i2c eeprom b0: 31 00 30 00 35 00 31 00 35 00
39 00 32 00 00 00
[  180.058994] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  180.059079] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  180.059125] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  180.059170] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[  180.059219] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xd2e5aebf
[  180.059226] em28xx #0: EEPROM info:
[  180.059232] em28xx #0:	AC97 audio (5 sample rates)
[  180.059239] em28xx #0:	500mA max power
[  180.059247] em28xx #0:	Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[  180.060458] em28xx #0: Identified as Pinnacle PCTV HD Pro Stick (card=17)
[  180.091733] tvp5150 17-005c: chip found @ 0xb8 (em28xx #0)
[  180.140502] tvp5150 17-005c: tvp5150am1 detected.
[  180.147912] i2c-core: driver [tuner] using legacy suspend method
[  180.147919] i2c-core: driver [tuner] using legacy resume method
[  180.151227] tuner 17-0061: Tuner -1 found with type(s) Radio TV.
[  180.169032] xc2028 17-0061: creating new instance
[  180.169041] xc2028 17-0061: type set to XCeive xc2028/xc3028 tuner
[  180.174254] xc2028 17-0061: Error: firmware xc3028-v27.fw not found.
[  180.199094] Registered IR keymap rc-pinnacle-pctv-hd
[  180.199334] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc1/input19
[  180.200463] rc1: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc1
[  180.200895] em28xx #0: Config register raw data: 0xd0
[  180.202271] em28xx #0: AC97 vendor ID = 0xffffffff
[  180.202640] em28xx #0: AC97 features = 0x6a90
[  180.202644] em28xx #0: Empia 202 AC97 audio processor detected
[  180.366381] em28xx #0: v4l2 driver version 0.1.3
[  180.371937] xc2028 17-0061: Error: firmware xc3028-v27.fw not found.
[  180.441716] em28xx #0: V4L2 video device registered as video1
[  180.441723] em28xx #0: V4L2 VBI device registered as vbi0
[  180.444325] usbcore: registered new interface driver em28xx
[  180.469757] em28xx-audio.c: probing for em28xx Audio Vendor Class
[  180.469760] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  180.469761] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
[  180.470139] Em28xx: Initialized (Em28xx Audio Extension) extension
[  180.473969] WARNING: You are using an experimental version of the
media stack.
[  180.473971] 	As the driver is backported to an older kernel, it doesn't offer
[  180.473972] 	enough quality for its usage in production.
[  180.473973] 	Use it with care.
[  180.473973] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[  180.473975] 	59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge branch
'v4l_for_linus' into staging/for_v3.4
[  180.473976] 	72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
cxd2820r: sleep on DVB-T/T2 delivery system switch
[  180.473977] 	46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
anysee: fix CI init
[  180.669893] xc2028 17-0061: attaching existing instance
[  180.669901] xc2028 17-0061: type set to XCeive xc2028/xc3028 tuner
[  180.669906] em28xx #0: em28xx #0/2: xc3028 attached
[  180.669912] DVB: registering new adapter (em28xx #0)
[  180.669919] DVB: registering adapter 0 frontend 0 (LG Electronics
LGDT3303 VSB/QAM Frontend)...
[  180.672073] em28xx #0: Successfully loaded em28xx-dvb
[  180.672085] Em28xx: Initialized (Em28xx dvb Extension) extension
>inplug usb mem stick
[  208.445353] usb 2-1: new high-speed USB device number 3 using ehci_hcd
[  208.576550] usb 2-1: New USB device found, idVendor=0bda, idProduct=0120
[  208.576560] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  208.576568] usb 2-1: Product: USB2.0-CRW
[  208.576573] usb 2-1: Manufacturer: Generic
[  208.576578] usb 2-1: SerialNumber: 20060413092100000
[  208.876874] Initializing USB Mass Storage driver...
[  208.877477] scsi6 : usb-storage 2-1:1.0
[  208.877749] usbcore: registered new interface driver usb-storage
[  208.877754] USB Mass Storage support registered.
[  209.881690] scsi 6:0:0:0: Direct-Access     Generic- Card Reader
  1.00 PQ: 0 ANSI: 0 CCS
[  209.884211] sd 6:0:0:0: Attached scsi generic sg3 type 0
[  210.685592] sd 6:0:0:0: [sdc] 15661056 512-byte logical blocks:
(8.01 GB/7.46 GiB)
[  210.686415] sd 6:0:0:0: [sdc] Write Protect is off
[  210.686425] sd 6:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  210.687304] sd 6:0:0:0: [sdc] No Caching mode page present
[  210.687313] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  210.690785] sd 6:0:0:0: [sdc] No Caching mode page present
[  210.690793] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  210.691861]  sdc: sdc1
[  210.694644] sd 6:0:0:0: [sdc] No Caching mode page present
[  210.694652] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[  210.694659] sd 6:0:0:0: [sdc] Attached SCSI removable disk
>mount usb memstick sdc1
[  247.064778] SELinux: initialized (dev sdc1, type vfat), uses genfs_contexts



On Thu, Jan 26, 2012 at 7:16 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/26/2012 07:09 PM, Claus Olesen wrote:
>>
>> the behavior with the latest media_build.git is the same as that which
>> was with fedora stock.
>
>
> After all I am almost 100% sure it is em28xx (USB-interface driver used)
> or/and USB-bus related issue. Likely it will happen for other em28xx devices
> too. But as I do not have enough knowledge about that area I cannot do much
> for fixing it. Maybe it is better try to avoid using those devices same time
> and try use USB-hub, other USB-port, add new USB-controller, etc...
>
>
> regards
> Antti
> --
> http://palosaari.fi/

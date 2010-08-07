Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o77BwGcA005259
	for <video4linux-list@redhat.com>; Sat, 7 Aug 2010 07:58:16 -0400
Received: from keetweej.vanheusden.com (keetweej.vanheusden.com
	[83.163.219.98])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o77Bw5ci002766
	for <video4linux-list@redhat.com>; Sat, 7 Aug 2010 07:58:06 -0400
Received: from belle.intranet.vanheusden.com (belle.intranet.vanheusden.com
	[192.168.64.100])
	by keetweej.vanheusden.com (Postfix) with ESMTP id 4F1DE8058
	for <video4linux-list@redhat.com>;
	Sat,  7 Aug 2010 13:42:30 +0200 (CEST)
Date: Sat, 7 Aug 2010 13:42:30 +0200
From: folkert <folkert@vanheusden.com>
To: video4linux-list@redhat.com
Subject: Pinnacle Systems, Inc. PCTV 330e & 2.6.34 & /dev/dvb
Message-ID: <20100807114229.GH6126@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I have a:
Bus 001 Device 006: ID 2304:0226 Pinnacle Systems, Inc. PCTV 330e
inserted in a system with kernel 2.6.34.
When plugged in, I get:
[3639480.291662] em28xx: New device Pinnacle Systems PCTV 330e @ 480 Mbps (2304:0226, interface 0, class 0)
[3639480.291870] em28xx #0: chip ID is em2882/em2883
[3639480.500623] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 26 02 d0 12 5c 03 8e 16 a4 1c
[3639480.501148] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00 00 00 00 00 00 00
[3639480.501696] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b e0 00 00
[3639480.502241] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
[3639480.502739] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[3639480.503311] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[3639480.503839] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 50 00 69 00
[3639480.504279] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
[3639480.504730] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 00 00 16 03
[3639480.505182] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00 33 00 33 00 30 00
[3639480.505628] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 38 00 30 00 33 00 30 00
[3639480.506081] em28xx #0: i2c eeprom b0: 31 00 32 00 37 00 38 00 34 00 37 00 37 00 00 00
[3639480.506567] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[3639480.507060] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[3639480.507532] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[3639480.508003] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[3639480.508607] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x18b3a0bf
[3639480.508692] em28xx #0: EEPROM info:
[3639480.508769] em28xx #0:	AC97 audio (5 sample rates)
[3639480.508835] em28xx #0:	500mA max power
[3639480.508898] em28xx #0:	Table at 0x27, strings=0x168e, 0x1ca4, 0x246a
[3639480.518750] em28xx #0: Identified as Pinnacle Hybrid Pro (2) (card=56)
[3639480.518812] em28xx #0: 
[3639480.518813] 
[3639480.518900] em28xx #0: The support for this board weren't valid yet.
[3639480.518950] em28xx #0: Please send a report of having this working
[3639480.519003] em28xx #0: not to V4L mailing list (and/or to other addresses)
[3639480.519005] 
[3639480.530412] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[3639480.553938] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[3639480.574022] xc2028 1-0061: creating new instance
[3639480.574082] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[3639480.574148] usb 1-1: firmware: requesting xc3028-v27.fw
[3639480.602064] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[3639480.661299] xc2028 1-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[3639481.581015] xc2028 1-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[3639481.595642] xc2028 1-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[3639481.811392] em28xx #0: Config register raw data: 0xd0
[3639481.812138] em28xx #0: AC97 vendor ID = 0xffffffff
[3639481.812513] em28xx #0: AC97 features = 0x6a90
[3639481.812579] em28xx #0: Empia 202 AC97 audio processor detected
[3639481.981768] tvp5150 1-005c: tvp5150am1 detected.
[3639482.082272] em28xx #0: v4l2 driver version 0.1.2
[3639482.188623] em28xx #0: V4L2 video device registered as video1
[3639482.188700] em28xx #0: V4L2 VBI device registered as vbi0
[3639482.201320] usbcore: registered new interface driver em28xx
[3639482.201419] em28xx driver loaded
[3639482.203450] Em28xx: Initialized (Em28xx dvb Extension) extension
[3639482.229668] em28xx-audio.c: probing for em28x1 non standard usbaudio
[3639482.229731] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[3639482.230065] Em28xx: Initialized (Em28xx Audio Extension) extension
[3639482.341779] tvp5150 1-005c: tvp5150am1 detected.
[3639482.561905] tvp5150 1-005c: tvp5150am1 detected.

Now all kinds of devices appear then:
crw-rw----   1 root video    81,   2 Jul 28 20:59 vbi0
crw-rw-rw-   1 root video    81,   1 Jul 28 20:59 video1
crw-------   1 root root    189,   5 Jul 28 20:59 usbdev1.6
drwxr-xr-x   2 root root         240 Jul 28 20:59 snd
crw-rw----   1 root audio    14,  36 Jul 28 20:59 audio2
crw-rw----   1 root audio    14,  35 Jul 28 20:59 dsp2
crw-rw----   1 root audio    14,  32 Jul 28 20:59 mixer2

but one important thing is missing: /dev/dvb !
Also:
mauer:/var/spool/sms# alevt -vbi /dev/vbi0 
DMX_SET_FILTER: Invalid argument
alevt: v4l2: broken vbi format specification
alevt: cannot open device: /dev/vbi0

I think all appropriate modules are loaded:
em28xx_alsa             5606  0 
em28xx_dvb              6740  0 
tuner_xc2028           16229  1 
em28xx                 77411  2 em28xx_alsa,em28xx_dvb
dvb_ttusb_budget       14285  0 
saa7115                11969  0 
saa7134_dvb            19581  0 
videobuf_dvb            4282  1 saa7134_dvb
saa7134               142683  1 saa7134_dvb
videobuf_dma_sg         8315  2 saa7134_dvb,saa7134
dvb_usb                12569  0 
dvb_core               78791  4
em28xx_dvb,dvb_ttusb_budget,videobuf_dvb,dvb_usb
tuner                  17086  1 
tvp5150                13455  1 
v4l2_common            12320  5 em28xx,saa7115,saa7134,tuner,tvp5150
ir_common              27718  2 em28xx,saa7134
videobuf_vmalloc        4832  1 em28xx
videobuf_core          12156  5
em28xx,videobuf_dvb,saa7134,videobuf_dma_sg,videobuf_vmalloc
ir_core                 5021  3 em28xx,saa7134,ir_common
tveeprom               12225  2 em28xx,saa7134

and the firmware was also in place:
-rw-r--r-- 1 root root 66220 Jul 28 20:31 /lib/firmware/xc3028-v27.fw

So what can be going wrong? Do I need to tweak something in udev or so?


Thank you,

Folkert van Heusden

-- 
MultiTail is a versatile tool for watching logfiles and output of
commands. Filtering, coloring, merging, diff-view, etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

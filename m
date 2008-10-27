Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9R15DCo022940
	for <video4linux-list@redhat.com>; Sun, 26 Oct 2008 21:05:13 -0400
Received: from slim-2c.inet.it (slim-2c.inet.it [213.92.5.123])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9R14x3O026656
	for <video4linux-list@redhat.com>; Sun, 26 Oct 2008 21:04:59 -0400
Message-ID: <490513B9.4020403@bigfoot.com>
Date: Mon, 27 Oct 2008 02:04:57 +0100
From: Sebastiano Zabert <s.zabert@bigfoot.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Problem with Pinnacle Hybrid Pro 320E and kernel from 2.6.26
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

Hi, I've upgraded my kernel and then the tree of v4l to compile DVB-T 
support for new kernel.
No problem during compile, but the problems start when I plug my USB 
device (Pinnacle Hybrid Pro 320E)... now the device isn't recognized.
I've loaded the kernel module with modprove and the correct card ID, but 
it search for firmware xc3028-v27.fw; I've read the procedure to obtain 
it, I've done all and with new firmware the module load, but DVB-T don't 
work (em2880_dvb was not loaded).
With the previous configuration I've obtained the firmware from a file 
(firmware_v3.tgz)... another possibility was extract him from emBDA.sys, 
the windows driver.
I don't know what to do to get it working, I can report only difference 
between the kernel 2.6.25.14 with v4l tree (27 July 2008) and the kernel 
2.6.26.6 with the new updated v4l tree.

********** WORKING (kernel 2.6.25.14 and v4l of 24 July 2008 **********
[root@PC DVB-T] dmesg
usb 1-7: new high speed USB device using ehci_hcd and address 4
usb 1-7: configuration #1 chosen from 1 choice
usb 1-7: New USB device found, idVendor=eb1a, idProduct=2881
usb 1-7: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-7: Product: USB 2881 Video
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.0.1 loaded
em28xx new video device (eb1a:2881): interface 0, class 255
em28xx: device is attached to a USB 2.0 bus
em28xx: you're using the experimental/unstable tree from mcentral.de
em28xx: there's also a stable tree available but which is limited to
em28xx: linux <=2.6.19.2
em28xx: it's fine to use this driver but keep in mind that it will move
em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
em28xx: proved to be stable
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
input: em2880/em2870 remote control as /class/input/input12
em28xx-input.c: remote control handler attached
attach_inform: eeprom detected.
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
EEPROM ID= 0x9567eb1a
Vendor/Product ID= eb1a:2881
AC97 audio (5 sample rates)
USB Remote wakeup capable
500mA max power
Table at 0x04, strings=0x206a, 0x006a, 0x0000
tuner 0-0061: chip found @ 0xc2 (em28xx #0)
attach inform (default): detected I2C address c2
/home/seb/v4l-dvb-kernel-2.6.25.14/v4l/tuner-core.c: setting tuner callback
tuner 0x61: Configuration acknowledged
/home/seb/v4l-dvb-kernel-2.6.25.14/v4l/tuner-core.c: setting tuner callback
/home/seb/v4l-dvb-kernel-2.6.25.14/v4l/xc3028-tuner.c: attach request!
/home/seb/v4l-dvb-kernel-2.6.25.14/v4l/tuner-core.c: xc3028 tuner 
successfully loaded
attach_inform: tvp5150 detected.
tvp5150 0-005c: tvp5150am1 detected.
Loading base firmware: xc3028_init0.i2c.fw
Loading default analogue TV settings: xc3028_BG_PAL_A2_A.i2c.fw
xc3028-tuner.c: firmware 2.7
ANALOG TV REQUEST
em28xx #0: V4L2 VBI device registered as /dev/vbi0
em28xx #0: V4L2 device registered as /dev/video0
em28xx #0: Found Pinnacle Hybrid Pro
em28xx audio device (eb1a:2881): interface 1, class 1
em28xx audio device (eb1a:2881): interface 2, class 1
usbcore: registered new interface driver em28xx
usbcore: registered new interface driver snd-usb-audio
em2880-dvb.c: DVB Init
Loading base firmware: xc3028_8MHz_init0.i2c.fw
Loading specific dtv settings: xc3028_DTV8_2633.i2c.fw
xc3028-tuner.c: firmware 2.7
Sending extra call for Digital TV!
/home/seb/v4l-dvb-kernel-2.6.25.14/v4l/xc3028-tuner.c: attach request!
DVB: registering new adapter (em2880 DVB-T)
DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
Em28xx: Initialized (Em2880 DVB Extension) extension

[root@PC DVB-T] lsmod | grep em2
em2880_dvb             14980  0
dvb_core               69756  1 em2880_dvb
em28xx                 84276  1 em2880_dvb
compat_ioctl32          5248  1 em28xx
ir_common              37380  1 em28xx
videodev               27776  1 em28xx
v4l2_common            18304  4 tvp5150,tuner,em28xx,videodev
v4l1_compat            15748  2 em28xx,videodev
tveeprom               17040  1 em28xx
i2c_core               20948  9 
qt1010,mt2060,mt352,zl10353,xc3028_tuner,tvp5150,tuner,em28xx,tveeprom

********** NOT WORKING (kernel 2.6.26.6 and v4l of 24 July 2008 **********
[root@PC DVB-T] dmesg
usb 1-7: new high speed USB device using ehci_hcd and address 4
usb 1-7: configuration #1 chosen from 1 choice
usb 1-7: New USB device found, idVendor=eb1a, idProduct=2881
usb 1-7: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-7: Product: USB 2881 Video
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
em28xx #0: chip ID is em2882/em2883
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
em28xx #0:      V4L Mailing List <video4linux-list@redhat.com>
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
em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick
em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)
em28xx #0:     card=19 -> PointNix Intra-Oral Camera
em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600
em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder
em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam grabber
em28xx #0:     card=23 -> Huaqi DLCW-130
em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner
em28xx #0:     card=25 -> Gadmei UTV310
em28xx #0:     card=26 -> Hercules Smart TV USB 2.0
em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)
em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe
em28xx #0:     card=29 -> Pinnacle Dazzle DVC 100
em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0
em28xx #0:     card=31 -> Usbgear VD204v9
em28xx #0:     card=32 -> Supercomp USB 2.0 TV
em28xx #0:     card=33 -> SIIG AVTuner-PVR/Prolink PlayTV USB 2.0
em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS
em28xx #0:     card=35 -> Typhoon DVD Maker
em28xx #0:     card=36 -> NetGMBH Cam
em28xx #0:     card=37 -> Gadmei UTV330
em28xx #0:     card=38 -> Yakumo MovieMixer
em28xx #0:     card=39 -> KWorld PVRTV 300U
em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U
em28xx #0:     card=41 -> Kworld 350 U DVB-T
em28xx #0:     card=42 -> Kworld 355 U DVB-T
em28xx #0:     card=43 -> Terratec Cinergy T XS
em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
em28xx #0:     card=46 -> Compro, VideoMate U3
em28xx #0:     card=47 -> KWorld DVB-T 305U
em28xx #0:     card=48 -> KWorld DVB-T 310U
em28xx #0:     card=49 -> MSI DigiVox A/D
em28xx #0:     card=50 -> MSI DigiVox A/D II
em28xx #0:     card=51 -> Terratec Hybrid XS Secam
em28xx #0:     card=52 -> DNT DA2 Hybrid
em28xx #0:     card=53 -> Pinnacle Hybrid Pro
em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
tvp5150 0-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Unknown EM2750/28xx video grabber
em28xx audio device (eb1a:2881): interface 1, class 1
em28xx audio device (eb1a:2881): interface 2, class 1
usbcore: registered new interface driver em28xx
usbcore: registered new interface driver snd-usb-audio

[root@PC DVB-T] lsmod | grep em2
[root@PC DVB-T] lsmod | grep em2

usbcore: deregistering interface driver em28xx
em28xx #0: disconnecting em28xx #0 video
em28xx #0: V4L2 devices /dev/video0 and /dev/vbi0 deregistered
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
em28xx #0: chip ID is em2882/em2883
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
em28xx #0:

em28xx #0: The support for this board weren't valid yet.
em28xx #0: Please send a report of having this working
em28xx #0: not to V4L mailing list (and/or to other addresses)

tuner' 0-0061: chip found @ 0xc2 (em28xx #0)
xc2028 0-0061: creating new instance
xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
firmware: requesting xc3028-v27.fw
xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
xc2028 firmware, ver 2.7
xc2028 0-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 0-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 0-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), 
id 0000000000008000.
tvp5150 0-005c: tvp5150am1 detected.
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found Pinnacle Hybrid Pro
usbcore: registered new interface driver em28xx

[root@PC DVB-T] lsmod | grep em2
em28xx                 58024  0
videodev               34688  2 tuner,em28xx
compat_ioctl32          5248  1 em28xx
videobuf_vmalloc        9732  1 em28xx
videobuf_core          18052  2 em28xx,videobuf_vmalloc
ir_common              42244  1 em28xx
tveeprom               14852  1 em28xx
v4l2_common            15232  3 tuner,em28xx,tvp5150
i2c_core               20949  6 
tuner_xc2028,tuner,em28xx,tveeprom,tvp5150,v4l2_common

Can someone help me to get all working?
Thanks in advance.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

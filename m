Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4ANjnSO024156
	for <video4linux-list@redhat.com>; Sat, 10 May 2008 19:45:49 -0400
Received: from web36105.mail.mud.yahoo.com (web36105.mail.mud.yahoo.com
	[66.163.179.219])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4ANjZoZ014386
	for <video4linux-list@redhat.com>; Sat, 10 May 2008 19:45:35 -0400
Date: Sat, 10 May 2008 19:45:30 -0400 (EDT)
From: Jody Gugelhupf <knueffle@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <140248.59791.qm@web36105.mail.mud.yahoo.com>
Subject: problems with 4 port video capture card with conexant fusion 878a
	25878-132 chip, please help
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

Hi there :)
I got myself a 4 port low budget video capture card with a conexant fusion 878a 25878-132 chip. I
run ubuntu hardy with a 2.6.24-16-generic kernel. The manufacturer is call DSR. I have trouble
getting it installed. I want to be able to see all four inputs at the same time. 
lspci gives me this:

00:00.0 Host bridge: VIA Technologies, Inc. VT82C693A/694x [Apollo PRO133x] (rev 44)
00:01.0 PCI bridge: VIA Technologies, Inc. VT82C598/694x [Apollo MVP3/Pro133x AGP]
00:07.0 ISA bridge: VIA Technologies, Inc. VT82C596 ISA [Mobile South] (rev 12)
00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master
IDE (rev 06)
00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 08)
00:07.3 Host bridge: VIA Technologies, Inc. VT82C596 Power Management (rev 20)
00:0e.0 Ethernet controller: Davicom Semiconductor, Inc. 21x4x DEC-Tulip compatible 10/100
Ethernet (rev 31)
00:12.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
00:12.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
00:14.0 Multimedia audio controller: Ensoniq ES1371 [AudioPCI-97] (rev 08)
01:00.0 VGA compatible controller: nVidia Corporation NV5M64 [RIVA TNT2 Model 64/Model 64 Pro]
(rev 15)

lspci -vn | egrep -A5 '00:12' this:

00:12.0 0400: 109e:036e (rev 11)
	Flags: bus master, medium devsel, latency 64, IRQ 5
	Memory at e5801000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

00:12.1 0480: 109e:0878 (rev 11)
	Flags: medium devsel, IRQ 5
	Memory at e5802000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

during boot up, dmesg shows this:

[   59.335357] Linux video capture interface: v2.00
[   60.598115] bttv: driver version 0.9.17 loaded
[   60.598135] bttv: using 8 buffers with 2080k (520 pages) each for capture
[   60.601536] bttv: Bt8xx card found (0).
[   60.601609] PCI: setting IRQ 5 as level-triggered
[   60.601621] PCI: Found IRQ 5 for device 0000:00:12.0
[   60.601650] PCI: Sharing IRQ 5 with 0000:00:12.1
[   60.601686] bttv0: Bt878 (rev 17) at 0000:00:12.0, irq: 5, latency: 64, mmio: 0xe4800000
[   60.601732] bttv0: using:  *** UNKNOWN/GENERIC ***  [card=0,autodetected]
[   60.601811] bttv0: gpio: en=00000000, out=00000000 in=00f36fff [init]
[   60.634747] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[   63.254987] parport_pc 00:0d: reported by Plug and Play BIOS
[   63.255055] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
[   73.561472] tveeprom 1-0050: Huh, no eeprom present (err=-121)?
[   73.561503] bttv0: tuner type unset
[   73.561516] bttv0: i2c: checking for MSP34xx @ 0x80... not found
[   79.960699] bttv0: i2c: checking for TDA9875 @ 0xb0... not found
[   86.359932] bttv0: i2c: checking for TDA7432 @ 0x8a... not found
[   92.760126] bttv0: registered device video0
[   92.760784] bttv0: registered device vbi0
[   92.761440] PCI: setting IRQ 10 as level-triggered
[   92.761453] PCI: Found IRQ 10 for device 0000:00:14.0
[   93.815653] bt878: AUDIO driver version 0.0.0 loaded
[   93.815908] bt878: Bt878 AUDIO function found (0).
[   93.815992] PCI: Found IRQ 5 for device 0000:00:12.1
[   93.816031] PCI: Sharing IRQ 5 with 0000:00:12.0
[   93.816063] bt878_probe: card id=[0x0], Unknown card.
[   93.816069] Exiting..
[   93.816107] bt878: probe of 0000:00:12.1 failed with error -22
[   95.115363] lp0: using parport0 (interrupt-driven).

v4l-conf shows this:

v4l-conf: using X11 display :0.0
dga: version 2.0
mode: 1280x960, depth=24, bpp=32, bpl=5120, base=0xe2000000
/dev/video0 [v4l2]: configuration done
funky1@smarthome:~$ cat Desktop/v4l-conf 

"xawtv -hwscan" shows this:

This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.24-16-generic)
looking for available devices
port 65-96
    type : Xvideo, image scaler
    name : NV Video Blitter

/dev/video0: OK                         [ -device /dev/video0 ]
    type : v4l2
    name : BT878 video ( *** UNKNOWN/GENER
    flags: overlay capture tuner 

I also installed the card in windows, where it works fine, also viewing 4 inputs at the same time,
I used btspy to get some info, the output is displayed below:

##BtSpy Report ###

General Information:
 Name: DSR manufacturer, 4port, 017
 Chip: Bt878, Rev: 0x00
 Subsystem: 0x00000000
 Vendor: Gammagraphx, Inc.
 Values to MUTE audio:
  Mute_GPOE : 0xf00000
  Mute_GPDATA : 0xf00000
 Has TV Tuner: No
 Number of Composite Ins: 4
  Composite in #1
   Composite1_Mux : 2
   Composite1_GPOE : 0xf00000
   Composite1_GPDATA: 0xf00000
  Composite in #2
   Composite2_Mux : 3
   Composite2_GPOE : 0xf00000
   Composite2_GPDATA: 0xf00000
  Composite in #3
   Composite3_Mux : 1
   Composite3_GPOE : 0xf00000
   Composite3_GPDATA: 0xf00000
  Composite in #4
   Composite4_Mux : 0
   Composite4_GPOE : 0xf00000
   Composite4_GPDATA: 0xf00000
Has SVideo: No
Has Radio: No


Add here all the comments you want!
	If your card can decode Stereo TV, and 
your card does NOT use one of the following chips,
you will have to "peek" the right 
GPDATA and GPOE values to enable Stero and SAP audio.
The driver already supports the DPL3518, MSP34xx, PT2254,
TDA7432, TDA8425, TDA9840, TDA9850, TDA9855, TDA9873,
TDA9874, TDA9875, TEA6300 and TEA6420 and does not require
extra information to drive them!

BtSpy Realtime Peeker:
GPOE: 0xf00000
GPDATA: 0xF36FFF

At the current state when I try to view the inputs with e.g. xawtv i can change the "video source"
(the current option in xawtv are called Television,Composite1,SVideo,Composite3) it shows me some
very distored picture but also not all four resources, so what do i have to do to get it working,
please help, thank you ;)
jody




      __________________________________________________________________
Looking for the perfect gift? Give the gift of Flickr! 

http://www.flickr.com/gift/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6M5gd2A000367
	for <video4linux-list@redhat.com>; Wed, 22 Jul 2009 01:42:39 -0400
Received: from langos.tyrell.hu (langos.euedge.com [209.190.22.130])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n6M5gPvP031180
	for <video4linux-list@redhat.com>; Wed, 22 Jul 2009 01:42:25 -0400
Received: from localhost (unknown [127.0.0.1])
	by langos.tyrell.hu (Postfix) with ESMTP id 063771E4049
	for <video4linux-list@redhat.com>; Wed, 22 Jul 2009 05:42:25 +0000 (UTC)
Received: from langos.tyrell.hu ([127.0.0.1])
	by localhost (langos.euedge.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id oMu4zqOJOasF for <video4linux-list@redhat.com>;
	Wed, 22 Jul 2009 01:42:21 -0400 (EDT)
Received: from [192.168.1.100] (dsl4E5C5FBC.pool.t-online.hu [78.92.95.188])
	(Authenticated sender: akos@maroy.hu)
	by langos.tyrell.hu (Postfix) with ESMTPSA id CE0491E4009
	for <video4linux-list@redhat.com>; Wed, 22 Jul 2009 01:42:20 -0400 (EDT)
Message-ID: <4A66A6BB.2070905@maroy.hu>
Date: Wed, 22 Jul 2009 07:42:19 +0200
From: =?UTF-8?B?TWFyw7N5IMOBa29z?= <akos@maroy.hu>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: bttv driver sending bogus keyboard input for IR interface
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

Hi,

I'm having the issue that the bttv driver sends a lot of bogus keyboard 
events via its IR interface, even though no keys are pressed on the IR 
remote. This is so problematic that these events happen even throughout 
the boot process, and one can't even log in on the console, as these 
phantom keypresses overwhelm everything. the only workaround it to 
blacklist the bttv module, so that it is not loaded during boot.

This is on ubuntu 9.04, kernel 2.6.28, using an AverMedia TVPhone98 card

how could I solve this issue, and maybe make the IR remote even work 
properly?


Akos

some additional info:

# lsmod
Module                  Size  Used by
tuner_simple           22544  0
tuner_types            22400  1 tuner_simple
tuner                  32836  0
tvaudio                31036  0
videodev               41600  2 tuner,tvaudio
v4l1_compat            21764  1 videodev
ir_common              52228  0
compat_ioctl32          9344  0
i2c_algo_bit           14084  0
v4l2_common            20992  2 tuner,tvaudio
videobuf_dma_sg        20484  0
videobuf_core          26500  1 videobuf_dma_sg
btcx_risc              13064  0
tveeprom               20100  0
binfmt_misc            16776  1
bridge                 56340  0
stp                    10500  1 bridge
bnep                   20224  2
input_polldev          11912  0
video                  25360  0
output                 11008  1 video
reiserfs              236288  1
aes_i586               15744  1
aes_generic            35880  1 aes_i586
cbc                    11648  1
dm_crypt               20996  1
w83627hf               31632  0
w83781d                36264  0
hwmon_vid              11264  2 w83627hf,w83781d
lp                     17156  0
snd_intel8x0           37532  3
snd_ice1712            67876  1
snd_ice17xx_ak4xxx     11648  1 snd_ice1712
snd_ak4xxx_adda        16256  2 snd_ice1712,snd_ice17xx_ak4xxx
snd_cs8427             16000  1 snd_ice1712
snd_ac97_codec        112292  2 snd_intel8x0,snd_ice1712
snd_pcm_oss            46336  0
snd_mixer_oss          22656  1 snd_pcm_oss
snd_pcm                82948  5 
snd_intel8x0,snd_ice1712,snd_ac97_codec,snd_pcm_oss
ac97_bus                9856  1 snd_ac97_codec
snd_i2c                13312  2 snd_ice1712,snd_cs8427
snd_mpu401_uart        15104  1 snd_ice1712
snd_seq_dummy          10756  0
snd_seq_oss            37760  0
snd_seq_midi           14336  0
snd_rawmidi            29696  2 snd_mpu401_uart,snd_seq_midi
snd_seq_midi_event     15104  2 snd_seq_oss,snd_seq_midi
ppdev                  15620  0
snd_seq                56880  6 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              29704  2 snd_pcm,snd_seq
snd_seq_device         14988  5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
psmouse                61972  0
pcspkr                 10496  0
serio_raw              13316  0
snd                    62628  22 
snd_intel8x0,snd_ice1712,snd_ak4xxx_adda,snd_cs8427,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_i2c,snd_mpu401_uart,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
snd_page_alloc         16904  2 snd_intel8x0,snd_pcm
soundcore              15200  1 snd
iTCO_wdt               19108  0
iTCO_vendor_support    11652  1 iTCO_wdt
nvidia               4712596  42
intel_agp              34108  1
agpgart                42696  2 nvidia,intel_agp
parport_pc             40100  1
parport                42220  3 lp,ppdev,parport_pc
shpchp                 40212  0
usbhid                 42336  1
skge                   48272  0
floppy                 64324  0
raid10                 30336  0
raid456               134928  1
async_xor              11392  1 raid456
async_memcpy           10112  1 raid456
async_tx               15184  3 raid456,async_xor,async_memcpy
xor                    24072  2 raid456,async_xor
raid1                  29952  0
raid0                  15360  0
multipath              15232  0
linear                 13312  0
fbcon                  46112  0
tileblit               10752  1 fbcon
font                   16384  1 fbcon
bitblit                13824  1 fbcon
softcursor              9984  1 bitblit

# cat /proc/bus/input/devices
I: Bus=0019 Vendor=0000 Product=0002 Version=0000
N: Name="Power Button (FF)"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
U: Uniq=
H: Handlers=kbd event0
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button (CM)"
P: Phys=PNP0C0C/button/input0
S: Sysfs=/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
U: Uniq=
H: Handlers=kbd event1
B: EV=3
B: KEY=100000 0 0 0

I: Bus=0017 Vendor=0001 Product=0001 Version=0100
N: Name="Macintosh mouse button emulation"
P: Phys=
S: Sysfs=/devices/virtual/input/input2
U: Uniq=
H: Handlers=mouse0 event2
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/devices/platform/i8042/serio0/input/input3
U: Uniq=
H: Handlers=kbd event3
B: EV=120013
B: KEY=4 2000000 3803078 f800d001 feffffdf ffefffff ffffffff fffffffe
B: MSC=10
B: LED=7

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input4
U: Uniq=
H: Handlers=kbd event4
B: EV=40001
B: SND=6

I: Bus=0011 Vendor=0002 Product=0001 Version=0001
N: Name="PS/2 Logitech Mouse"
P: Phys=isa0060/serio1/input0
S: Sysfs=/devices/platform/i8042/serio1/input/input5
U: Uniq=
H: Handlers=mouse1 event5
B: EV=7
B: KEY=70000 0 0 0 0 0 0 0 0
B: REL=3


# cat /proc/bus/input/handlers
N: Number=0 Name=kbd
N: Number=1 Name=mousedev Minor=32
N: Number=2 Name=evdev Minor=64


syslog when loading the bttv module:

Jul 22 07:41:33 tower kernel: [ 3796.727018] bttv: driver version 0.9.17 
loaded
Jul 22 07:41:33 tower kernel: [ 3796.727023] bttv: using 8 buffers with 
2080k (520 pages) each for capture
Jul 22 07:41:33 tower kernel: [ 3796.727088] bttv: Bt8xx card found (0).
Jul 22 07:41:33 tower kernel: [ 3796.727102] bttv0: Bt878 (rev 2) at 
0000:02:0d.0, irq: 21, latency: 64, mmio: 0xf7efe000
Jul 22 07:41:33 tower kernel: [ 3796.727427] bttv0: detected: AVerMedia 
TVPhone98 [card=41], PCI subsystem ID is 1461:0001
Jul 22 07:41:33 tower kernel: [ 3796.727432] bttv0: using: AVerMedia 
TVPhone 98 [card=41,autodetected]
Jul 22 07:41:33 tower kernel: [ 3796.730749] tvaudio' 2-0042: tda9840 
found @ 0x84 (bt878 #0 [sw])
Jul 22 07:41:33 tower kernel: [ 3796.739572] tuner' 2-0061: chip found @ 
0xc2 (bt878 #0 [sw])
Jul 22 07:41:33 tower kernel: [ 3796.781013] bttv0: Avermedia 
eeprom[0x0a97]: tuner=5 radio:yes remote control:yes
Jul 22 07:41:33 tower kernel: [ 3796.781021] bttv0: tuner type=5
Jul 22 07:41:33 tower kernel: [ 3796.788903] tuner-simple 2-0061: 
creating new instance
Jul 22 07:41:33 tower kernel: [ 3796.788908] tuner-simple 2-0061: type 
set to 5 (Philips PAL_BG (FI1216 and compatibles))
Jul 22 07:41:33 tower kernel: [ 3796.789530] bttv0: i2c: checking for 
MSP34xx @ 0x80... not found
Jul 22 07:41:33 tower kernel: [ 3796.790119] bttv0: i2c: checking for 
TDA9875 @ 0xb0... not found
Jul 22 07:41:33 tower kernel: [ 3796.790706] bttv0: i2c: checking for 
TDA7432 @ 0x8a... not found
Jul 22 07:41:33 tower kernel: [ 3796.795548] bttv0: registered device video0
Jul 22 07:41:33 tower kernel: [ 3796.795581] bttv0: registered device vbi0
Jul 22 07:41:33 tower kernel: [ 3796.795615] bttv0: registered device radio0
Jul 22 07:41:33 tower kernel: [ 3796.796642] bttv0: PLL: 28636363 => 
35468950 . ok
Jul 22 07:41:33 tower kernel: [ 3796.812739] input: bttv IR (card=41) as 
/devices/pci0000:00/0000:00:1e.0/0000:02:0d.0/input/input7

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

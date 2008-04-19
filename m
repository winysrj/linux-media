Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nskntmtas02p.mx.bigpond.com ([61.9.168.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mickhowe@bigpond.net.au>) id 1Jn5hA-0003Ze-3P
	for linux-dvb@linuxtv.org; Sat, 19 Apr 2008 07:33:08 +0200
Received: from nskntotgx03p.mx.bigpond.com ([121.222.242.159])
	by nskntmtas02p.mx.bigpond.com with ESMTP id
	<20080419053227.WDNB649.nskntmtas02p.mx.bigpond.com@nskntotgx03p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Sat, 19 Apr 2008 05:32:27 +0000
Received: from fini.bareclan ([121.222.242.159])
	by nskntotgx03p.mx.bigpond.com with ESMTP
	id <20080419053226.UPZB9173.nskntotgx03p.mx.bigpond.com@fini.bareclan>
	for <linux-dvb@linuxtv.org>; Sat, 19 Apr 2008 05:32:26 +0000
From: mick <mickhowe@bigpond.net.au>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Date: Sat, 19 Apr 2008 15:31:12 +1000
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804191531.13191.mickhowe@bigpond.net.au>
Subject: [linux-dvb] Leadtek Winfast DTV1000 S and DTV2000 H rev J
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have recently bought the 2 tv cards listed below, the 1000 was cheap enuf to 
take a chance on, the 2000 I actually checked the supported hardwear list but 
got bitten by the later revision, wasn't mentioned on the box or in the list.

Neither of these cards appear to be correctly/fully supported. Help.

I did find a couple of patches on the web for the DTV2000H but all use already 
allocated card type numbers and the one I did try to add to the kernel failed 
to compile (invalid binary == ) so what can I do next, I can through a bit of 
rough code together and/or do simple testing.

Below is everything I could gather that I thought was relevant

/]/]ik

Gigabyte GA-945GCM-S2L motherboard
Intel Core2 Duo E4600 2.4GHz cpu
2GB ram (2 x 1GB interleaved)
Kubuntu 7.10 Gutsy Gibbon
Kernel 2.6.25

Leadtek Winfast DTV1000 S (NXP 18271 + 10048 + 7130)
Leadtek Winfast DTV2000 H rev J (Conexant CX23881 + Conexant CX22702, Philips 
FMD1216)

dmesg
Linux version 2.6.25-cave5 (root@cave) (gcc version 4.1.3 20070929 
(prerelease) (Ubuntu 4.1.2-16ubuntu2)) #2 SMP PREEMPT Fri Apr 18 11:52:58 EST 
2008
...snip...
Linux video capture interface: v2.00

************************************************
DTV2000H rev J
************************************************
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 19
cx88[0]: Your board isn't known (yet) to the driver.  You can
cx88[0]: try to pick one of the existing card configs via
cx88[0]: card=<n> insmod option.  Updating to the latest
cx88[0]: version might help as well.
cx88[0]: Here is a list of valid choices for the card=<n> insmod option:
cx88[0]:    card=0 -> UNKNOWN/GENERIC
cx88[0]:    card=1 -> Hauppauge WinTV 34xxx models
cx88[0]:    card=2 -> GDI Black Gold
cx88[0]:    card=3 -> PixelView
cx88[0]:    card=4 -> ATI TV Wonder Pro
cx88[0]:    card=5 -> Leadtek Winfast 2000XP Expert
cx88[0]:    card=6 -> AverTV Studio 303 (M126)
cx88[0]:    card=7 -> MSI TV-@nywhere Master
cx88[0]:    card=8 -> Leadtek Winfast DV2000
cx88[0]:    card=9 -> Leadtek PVR 2000
cx88[0]:    card=10 -> IODATA GV-VCP3/PCI
cx88[0]:    card=11 -> Prolink PlayTV PVR
cx88[0]:    card=12 -> ASUS PVR-416
cx88[0]:    card=13 -> MSI TV-@nywhere
cx88[0]:    card=14 -> KWorld/VStream XPert DVB-T
cx88[0]:    card=15 -> DViCO FusionHDTV DVB-T1
cx88[0]:    card=16 -> KWorld LTV883RF
cx88[0]:    card=17 -> DViCO FusionHDTV 3 Gold-Q
cx88[0]:    card=18 -> Hauppauge Nova-T DVB-T
cx88[0]:    card=19 -> Conexant DVB-T reference design
cx88[0]:    card=20 -> Provideo PV259
cx88[0]:    card=21 -> DViCO FusionHDTV DVB-T Plus
cx88[0]:    card=22 -> pcHDTV HD3000 HDTV
cx88[0]:    card=23 -> digitalnow DNTV Live! DVB-T
cx88[0]:    card=24 -> Hauppauge WinTV 28xxx (Roslyn) models
cx88[0]:    card=25 -> Digital-Logic MICROSPACE Entertainment Center (MEC)
cx88[0]:    card=26 -> IODATA GV/BCTV7E
cx88[0]:    card=27 -> PixelView PlayTV Ultra Pro (Stereo)
cx88[0]:    card=28 -> DViCO FusionHDTV 3 Gold-T
cx88[0]:    card=29 -> ADS Tech Instant TV DVB-T PCI
cx88[0]:    card=30 -> TerraTec Cinergy 1400 DVB-T
cx88[0]:    card=31 -> DViCO FusionHDTV 5 Gold
cx88[0]:    card=32 -> AverMedia UltraTV Media Center PCI 550
cx88[0]:    card=33 -> Kworld V-Stream Xpert DVD
cx88[0]:    card=34 -> ATI HDTV Wonder
cx88[0]:    card=35 -> WinFast DTV1000-T
cx88[0]:    card=36 -> AVerTV 303 (M126)
cx88[0]:    card=37 -> Hauppauge Nova-S-Plus DVB-S
cx88[0]:    card=38 -> Hauppauge Nova-SE2 DVB-S
cx88[0]:    card=39 -> KWorld DVB-S 100
cx88[0]:    card=40 -> Hauppauge WinTV-HVR1100 DVB-T/Hybrid
cx88[0]:    card=41 -> Hauppauge WinTV-HVR1100 DVB-T/Hybrid (Low Profile)
cx88[0]:    card=42 -> digitalnow DNTV Live! DVB-T Pro
cx88[0]:    card=43 -> KWorld/VStream XPert DVB-T with cx22702
cx88[0]:    card=44 -> DViCO FusionHDTV DVB-T Dual Digital
cx88[0]:    card=45 -> KWorld HardwareMpegTV XPert
cx88[0]:    card=46 -> DViCO FusionHDTV DVB-T Hybrid
cx88[0]:    card=47 -> pcHDTV HD5500 HDTV
cx88[0]:    card=48 -> Kworld MCE 200 Deluxe
cx88[0]:    card=49 -> PixelView PlayTV P7000
cx88[0]:    card=50 -> NPG Tech Real TV FM Top 10
cx88[0]:    card=51 -> WinFast DTV2000 H
cx88[0]:    card=52 -> Geniatech DVB-S
cx88[0]:    card=53 -> Hauppauge WinTV-HVR3000 TriMode Analog/DVB-S/DVB-T
cx88[0]:    card=54 -> Norwood Micro TV Tuner
cx88[0]:    card=55 -> Shenzhen Tungsten Ages Tech TE-DTV-250 / Swann OEM
cx88[0]:    card=56 -> Hauppauge WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder
cx88[0]:    card=57 -> ADS Tech Instant Video PCI
cx88[0]:    card=58 -> Pinnacle PCTV HD 800i
cx88[0]: subsystem: 107d:6f2b, board: UNKNOWN/GENERIC [card=0,autodetected]
cx88[0]: TV tuner type -1, Radio tuner type -1
saa7130/34: v4l2 driver version 0.2.14 loaded
usb 5-1: new full speed USB device using uhci_hcd and address 2
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
tuner' 0-0061: chip found @ 0xc2 (cx88[0])
tuner' 0-0063: chip found @ 0xc6 (cx88[0])
cx88[0]/0: found at 0000:03:01.0, rev: 5, irq: 19, latency: 64, mmio: 
0xd1000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
tuner' 0-0061: tuner type not set

************************************************
DTV1000 S
************************************************
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 20 (level, low) -> IRQ 20
saa7130[0]: found at 0000:03:00.0, rev: 1, irq: 20, latency: 64, mmio: 
0xd4000000
saa7130[0]: subsystem: 107d:6655, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7130[0]: board init: gpio is 22000
usb 5-1: configuration #1 chosen from 1 choice
hub 5-1:1.0: USB hub found
hub 5-1:1.0: 4 ports detected
Chip ID is not zero. It is not a TEA5767
tuner' 1-0060: chip found @ 0xc0 (saa7130[0])
saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: registered device video1 [v4l2]
saa7130[0]: registered device vbi1
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
saa7134 ALSA driver for DMA sound loaded
saa7130[0]/alsa: saa7130[0] at 0xd4000000 irq 20 registered as card -2
hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
cx88[0]/2: cx2388x 8802 Driver Manager

lsmod
Module                  Size  Used by
usbhid                 34656  0
hid                    49024  1 usbhid
saa7134_alsa           17056  0 
tuner                  42740  0 
tea5767                 7684  1 tuner
tda8290                15108  1 tuner
tda18271               34056  1 tda8290
tda827x                11780  1 tda8290
tuner_xc2028           21776  1 tuner
xc5000                 12228  1 tuner
snd_hda_intel         284020  0 
tda9887                11076  1 tuner
tuner_simple           10120  1 tuner
snd_pcm_oss            47232  0 
snd_mixer_oss          19520  1 snd_pcm_oss
snd_pcm                91272  3 saa7134_alsa,snd_hda_intel,snd_pcm_oss
cx8802                 21252  0 
snd_seq_dummy           4740  0 
snd_seq_oss            36352  0 
snd_seq_midi           10240  0 
snd_rawmidi            29376  1 snd_seq_midi
snd_seq_midi_event      9280  2 snd_seq_oss,snd_seq_midi
snd_seq                62304  6 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              27408  2 snd_pcm,snd_seq
saa7134               160348  1 saa7134_alsa
snd_seq_device          9492  5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
cx8800                 42188  0 
cx88xx                 72680  2 cx8802,cx8800
ir_kbd_i2c             12304  1 saa7134
compat_ioctl32         10496  2 saa7134,cx8800
snd                    70664  10 
saa7134_alsa,snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
videodev               37056  5 tuner,saa7134,cx8800,cx88xx,compat_ioctl32
v4l1_compat            14788  1 videodev
ir_common              41412  3 saa7134,cx88xx,ir_kbd_i2c
i2c_algo_bit            7684  1 cx88xx
v4l2_common            13696  3 tuner,saa7134,cx8800
videobuf_dma_sg        16068  5 saa7134_alsa,cx8802,saa7134,cx8800,cx88xx
tveeprom               19728  2 saa7134,cx88xx
btcx_risc               6024  3 cx8802,cx8800,cx88xx
soundcore              10016  1 snd
videobuf_core          21956  5 cx8802,saa7134,cx8800,cx88xx,videobuf_dma_sg
evdev                  14912  3
usbcore               161560  4 usbhid,uhci_hcd,ehci_hcd
i2c_core               28640  15 
tuner,tea5767,tda8290,tda18271,tda827x,tuner_xc2028,xc5000,tda9887,tuner_simple,saa7134,cx88xx,ir_kbd_i2c,i2c_algo_bit,v4l2_common,tveeprom
snd_page_alloc         11664  2 snd_hda_intel,snd_pcm

lspci -vnn

03:00.0 Multimedia controller [0480]: Philips Semiconductors SAA7130 Video 
Broadcast Decoder [1131:7130] (rev 01)
	Subsystem: LeadTek Research Inc. Unknown device [107d:6655]
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at d4000000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [40] Power Management version 1

03:01.0 Multimedia video controller [0400]: Conexant CX23880/1/2/3 PCI Video 
and Audio Decoder [14f1:8800] (rev 05)
	Subsystem: LeadTek Research Inc. Unknown device [107d:6f2b]
	Flags: bus master, medium devsel, latency 64, IRQ 19
	Memory at d1000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

03:01.1 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder [Audio Port] [14f1:8801] (rev 05)
	Subsystem: LeadTek Research Inc. Unknown device [107d:6f2b]
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2

03:01.2 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
	Subsystem: LeadTek Research Inc. Unknown device [107d:6f2b]
	Flags: bus master, medium devsel, latency 64, IRQ 11
	Memory at d3000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

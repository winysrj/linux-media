Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62879 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0I2RGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 13:06:50 -0400
Received: by wyb28 with SMTP id 28so945755wyb.19
        for <linux-media@vger.kernel.org>; Wed, 29 Sep 2010 10:06:48 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Sep 2010 19:06:48 +0200
Message-ID: <AANLkTik4NpV5C=Ct_8u=awZ-tthDC=ORJj8u1DHTNu+q@mail.gmail.com>
Subject: ASUS My Cinema-P7131 Hybrid (saa7134) and slow IR
From: Giorgio <mywing81@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I have an Asus P7131 Hybrid card, and it works like a charm with
Ubuntu 8.04 and stock kernel 2.6.24. But, after upgrading my system to
Ubuntu 10.04 x86-64, I noticed that the remote control was quite slow
to respond. Sometimes the keypresses aren't recognized, and you have
to keep pressing the same button two or three times until it works.
The remote feels slow, not very responsive.
So, to investigate the issue, I loaded the ir-common module with
debug=1 and looked at the logs. They report lots of "ir-common:
spurious timer_end". The funny thing is, I have tried the Ubuntu 10.04
i386 livecd (with the same kernel) and the problem is not present
there.

This is what lspci says about my card:

holden@holden-desktop:~$ sudo lspci -vvnn
02:07.0 Multimedia controller [0480]: Philips Semiconductors
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
	Subsystem: ASUSTeK Computer Inc. Device [1043:4876]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (21000ns min, 8000ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fbfff800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Kernel driver in use: saa7134
	Kernel modules: saa7134


And these are my tests so far:

1) First test: Ubuntu 10.04 x86_64, stock 2.6.32 kernel

holden@holden-desktop:~$ uname -a
Linux holden-desktop 2.6.32-24-generic #43-Ubuntu SMP Thu Sep 16
14:58:24 UTC 2010 x86_64 GNU/Linux
holden@holden-desktop:~$ lsmod
Module                  Size  Used by
saa7134_dvb            26179  0
videobuf_dvb            6203  1 saa7134_dvb
dvb_core              102993  1 videobuf_dvb
saa7134_alsa           12370  0
saa7134               166706  2 saa7134_dvb,saa7134_alsa
videobuf_dma_sg        12370  3 saa7134_dvb,saa7134_alsa,saa7134
videobuf_core          19301  3 videobuf_dvb,saa7134,videobuf_dma_sg
tveeprom               13882  1 saa7134
ir_common              43415  1 saa7134
binfmt_misc             7960  1
ppdev                   6375  0
tda1004x               16962  1
tda827x                10532  2
snd_intel8x0           31155  2
snd_ac97_codec        125394  1 snd_intel8x0
ac97_bus                1450  1 snd_ac97_codec
tda8290                14720  1
snd_pcm_oss            41394  0
snd_mixer_oss          16299  1 snd_pcm_oss
snd_pcm                87882  4
saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_seq_dummy           1782  0
tuner                  23256  1
snd_seq_oss            31219  0
snd_seq_midi            5829  0
snd_rawmidi            23420  1 snd_seq_midi
snd_seq_midi_event      7267  2 snd_seq_oss,snd_seq_midi
snd_seq                57481  6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              23649  2 snd_pcm,snd_seq
nvidia               8096262  24
v4l2_common            18357  2 saa7134,tuner
videodev               40518  3 saa7134,tuner,v4l2_common
v4l1_compat            15495  1 videodev
v4l2_compat_ioctl32    11956  1 videodev
fbcon                  39270  71
tileblit                2487  1 fbcon
font                    8053  1 fbcon
bitblit                 5811  1 fbcon
softcursor              1565  1 bitblit
snd_seq_device          6888  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
vga16fb                12757  1
edac_core              45423  0
snd                    71187  15
saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
vgastate                9857  1 vga16fb
soundcore               8052  1 snd
psmouse                64576  0
edac_mce_amd            9278  0
serio_raw               4918  0
shpchp                 33711  0
uli526x                15646  0
snd_page_alloc          8500  2 snd_intel8x0,snd_pcm
i2c_ali15x3             6046  0
i2c_ali1535             5665  0
k8temp                  3912  0
i2c_ali1563             6362  0
lp                      9336  0
parport                37160  2 ppdev,lp
floppy                 63156  0
pata_ali               10636  2

Sep 27 15:46:41 holden-desktop kernel: [  118.539638] saa7134 ALSA
driver for DMA sound unloaded
Sep 27 15:46:56 holden-desktop kernel: [  133.916688] saa7130/34: v4l2
driver version 0.2.15 loaded
Sep 27 15:46:56 holden-desktop kernel: [  133.916839] saa7133[0]:
found at 0000:02:07.0, rev: 209, irq: 20, latency: 64, mmio:
0xfbfff800
Sep 27 15:46:56 holden-desktop kernel: [  133.916850] saa7133[0]:
subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid
[card=112,autodetected]
Sep 27 15:46:56 holden-desktop kernel: [  133.916880] saa7133[0]:
board init: gpio is 40000
Sep 27 15:46:56 holden-desktop kernel: [  133.917711] input: saa7134
IR (ASUSTeK P7131 Hybri as
/devices/pci0000:00/0000:00:02.0/0000:02:07.0/input/input6
Sep 27 15:46:56 holden-desktop kernel: [  133.917954] IRQ
20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Sep 27 15:46:57 holden-desktop kernel: [  134.090044] saa7133[0]: i2c
eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Sep 27 15:46:57 holden-desktop kernel: [  134.090062] saa7133[0]: i2c
eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090078] saa7133[0]: i2c
eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090094] saa7133[0]: i2c
eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090108] saa7133[0]: i2c
eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090123] saa7133[0]: i2c
eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090138] saa7133[0]: i2c
eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090153] saa7133[0]: i2c
eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090168] saa7133[0]: i2c
eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090183] saa7133[0]: i2c
eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090198] saa7133[0]: i2c
eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090213] saa7133[0]: i2c
eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090227] saa7133[0]: i2c
eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090242] saa7133[0]: i2c
eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090257] saa7133[0]: i2c
eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090272] saa7133[0]: i2c
eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 27 15:46:57 holden-desktop kernel: [  134.090290] i2c i2c-1:
Invalid 7-bit address 0x7a
Sep 27 15:46:57 holden-desktop kernel: [  134.210231] tuner 1-004b:
chip found @ 0x96 (saa7133[0])
Sep 27 15:46:57 holden-desktop kernel: [  134.380032] tda829x 1-004b:
setting tuner address to 61
Sep 27 15:46:57 holden-desktop kernel: [  134.510034] tda829x 1-004b:
type set to tda8290+75a
Sep 27 15:47:03 holden-desktop kernel: [  140.230913] saa7133[0]:
registered device video0 [v4l2]
Sep 27 15:47:03 holden-desktop kernel: [  140.231788] saa7133[0]:
registered device vbi0
Sep 27 15:47:03 holden-desktop kernel: [  140.232359] saa7133[0]:
registered device radio0
Sep 27 15:47:03 holden-desktop kernel: [  140.252401] saa7134 ALSA
driver for DMA sound loaded
Sep 27 15:47:03 holden-desktop kernel: [  140.252423] IRQ
20/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
Sep 27 15:47:03 holden-desktop kernel: [  140.252464] saa7133[0]/alsa:
saa7133[0] at 0xfbfff800 irq 20 registered as card -2
Sep 27 15:47:03 holden-desktop kernel: [  140.382855] dvb_init()
allocating 1 frontend
Sep 27 15:47:03 holden-desktop kernel: [  140.620680] DVB: registering
new adapter (saa7133[0])
Sep 27 15:47:03 holden-desktop kernel: [  140.620691] DVB: registering
adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
Sep 27 15:47:04 holden-desktop kernel: [  141.360023] tda1004x:
setting up plls for 48MHz sampling clock
Sep 27 15:47:06 holden-desktop kernel: [  143.230031] tda1004x: found
firmware revision 20 -- ok
Sep 27 15:48:59 holden-desktop kernel: [  256.770031] ir-common:
spurious timer_end
Sep 27 15:48:59 holden-desktop kernel: [  256.880030] ir-common:
spurious timer_end
Sep 27 15:48:59 holden-desktop kernel: [  256.910022] ir-common: short code: 0
Sep 27 15:49:02 holden-desktop kernel: [  259.370029] ir-common:
spurious timer_end
Sep 27 15:49:02 holden-desktop kernel: [  259.400028] ir-common: short code: 0
Sep 27 15:49:02 holden-desktop kernel: [  259.490038] ir-common:
code=2de9, rc5=4915451, start=2, toggle=1, address=17, instr=29
Sep 27 15:49:02 holden-desktop kernel: [  259.490045] ir-common:
instruction 29, toggle 1
Sep 27 15:49:02 holden-desktop kernel: [  259.490051] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=1
Sep 27 15:49:02 holden-desktop kernel: [  259.610039] ir-common: key released
Sep 27 15:49:02 holden-desktop kernel: [  259.610049] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=0
Sep 27 15:49:05 holden-desktop kernel: [  262.920036] ir-common:
code=25e9, rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 27 15:49:05 holden-desktop kernel: [  262.920043] ir-common:
instruction 29, toggle 0
Sep 27 15:49:05 holden-desktop kernel: [  262.920049] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=1
Sep 27 15:49:05 holden-desktop kernel: [  263.030026] ir-common:
spurious timer_end
Sep 27 15:49:05 holden-desktop kernel: [  263.040019] ir-common: key released
Sep 27 15:49:05 holden-desktop kernel: [  263.040025] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=0
Sep 27 15:49:09 holden-desktop kernel: [  266.470017] ir-common:
spurious timer_end
Sep 27 15:49:09 holden-desktop kernel: [  266.500028] ir-common: short code: 0
Sep 27 15:49:09 holden-desktop kernel: [  266.590027] ir-common:
code=2de9, rc5=4915451, start=2, toggle=1, address=17, instr=29
Sep 27 15:49:09 holden-desktop kernel: [  266.590034] ir-common:
instruction 29, toggle 1
Sep 27 15:49:09 holden-desktop kernel: [  266.590040] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=1
Sep 27 15:49:09 holden-desktop kernel: [  266.710075] ir-common: key released
Sep 27 15:49:09 holden-desktop kernel: [  266.710084] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=0
Sep 27 15:49:14 holden-desktop kernel: [  271.800029] ir-common:
spurious timer_end
Sep 27 15:49:14 holden-desktop kernel: [  271.910036] ir-common:
spurious timer_end
Sep 27 15:49:14 holden-desktop kernel: [  272.020034] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.050025] ir-common: short code: 0
Sep 27 15:49:15 holden-desktop kernel: [  272.130029] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.160023] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.250037] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.360035] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.470016] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.580017] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.610025] ir-common: short code: 0
Sep 27 15:49:15 holden-desktop kernel: [  272.700036] ir-common:
code=25e9, rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 27 15:49:15 holden-desktop kernel: [  272.700043] ir-common:
instruction 29, toggle 0
Sep 27 15:49:15 holden-desktop kernel: [  272.700049] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=1
Sep 27 15:49:15 holden-desktop kernel: [  272.810037] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  272.820032] ir-common: key released
Sep 27 15:49:15 holden-desktop kernel: [  272.820041] saa7134 IR
(ASUSTeK P7131 Hybri: key event code=2 down=0
Sep 27 15:49:15 holden-desktop kernel: [  272.920038] ir-common:
spurious timer_end
Sep 27 15:49:15 holden-desktop kernel: [  273.030023] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.140029] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.170025] ir-common: short code: 0
Sep 27 15:49:16 holden-desktop kernel: [  273.260040] ir-common:
code=25e9, rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 27 15:49:16 holden-desktop kernel: [  273.370034] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.380016] ir-common: key released
Sep 27 15:49:16 holden-desktop kernel: [  273.480023] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.590016] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.620027] ir-common: short code: 0
Sep 27 15:49:16 holden-desktop kernel: [  273.700032] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.730022] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.820036] ir-common:
code=25e9, rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 27 15:49:16 holden-desktop kernel: [  273.930039] ir-common:
spurious timer_end
Sep 27 15:49:16 holden-desktop kernel: [  273.940016] ir-common: key released
Sep 27 15:49:17 holden-desktop kernel: [  274.040020] ir-common:
spurious timer_end
Sep 27 15:49:17 holden-desktop kernel: [  274.150030] ir-common:
spurious timer_end
Sep 27 15:49:17 holden-desktop kernel: [  274.180027] ir-common: short code: 0
Sep 27 15:49:17 holden-desktop kernel: [  274.270042] ir-common:
code=25e9, rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 27 15:49:17 holden-desktop kernel: [  274.380052] ir-common:
spurious timer_end
Sep 27 15:49:17 holden-desktop kernel: [  274.390017] ir-common: key released
Sep 27 15:49:17 holden-desktop kernel: [  274.490026] ir-common:
spurious timer_end
Sep 27 15:49:17 holden-desktop kernel: [  274.600022] ir-common:
spurious timer_end
Sep 27 15:49:17 holden-desktop kernel: [  274.710027] ir-common:
spurious timer_end
Sep 27 15:49:17 holden-desktop kernel: [  274.740026] ir-common: short code: 0
Sep 27 15:49:17 holden-desktop kernel: [  274.830029] ir-common:
code=25e9, rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 27 15:49:17 holden-desktop kernel: [  274.940032] ir-common:
spurious timer_end
Sep 27 15:49:17 holden-desktop kernel: [  274.950021] ir-common: key released
Sep 27 15:49:18 holden-desktop kernel: [  275.050021] ir-common:
spurious timer_end
Sep 27 15:49:18 holden-desktop kernel: [  275.160030] ir-common:
spurious timer_end
Sep 27 15:49:18 holden-desktop kernel: [  275.190025] ir-common: short code: 0
Sep 27 15:49:18 holden-desktop kernel: [  275.270023] ir-common:
spurious timer_end
Sep 27 15:49:18 holden-desktop kernel: [  275.300025] ir-common:
spurious timer_end



2) Second test: Ubuntu 10.04 i386, stock 2.6.32 kernel (as you can see
the remote works very well here!)

ubuntu@ubuntu:~$ uname -a
Linux ubuntu 2.6.32-24-generic #39-Ubuntu SMP Wed Jul 28 06:07:29 UTC
2010 i686 GNU/Linux
ubuntu@ubuntu:~$ lsmod
Module                  Size  Used by
saa7134_dvb            22167  0
videobuf_dvb            5175  1 saa7134_dvb
dvb_core               86142  1 videobuf_dvb
saa7134_alsa           10380  0
saa7134               143391  2 saa7134_dvb,saa7134_alsa
videobuf_dma_sg        10782  3 saa7134_dvb,saa7134_alsa,saa7134
videobuf_core          16356  3 videobuf_dvb,saa7134,videobuf_dma_sg
tveeprom               11102  1 saa7134
ir_common              38875  1 saa7134
binfmt_misc             6587  1
dm_crypt               11331  0
ppdev                   5259  0
lp                      7028  0
parport                32635  2 ppdev,lp
tda1004x               15070  1
tda827x                 9240  2
snd_intel8x0           25588  0
tda8290                12092  1
snd_ac97_codec        100646  1 snd_intel8x0
ac97_bus                1002  1 snd_ac97_codec
snd_pcm_oss            35308  0
snd_mixer_oss          13746  1 snd_pcm_oss
tuner                  20412  1
snd_pcm                70662  4
saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_seq_dummy           1338  0
snd_seq_oss            26726  0
snd_seq_midi            4557  0
snd_rawmidi            19056  1 snd_seq_midi
v4l2_common            15431  2 saa7134,tuner
snd_seq_midi_event      6003  2 snd_seq_oss,snd_seq_midi
videodev               34361  3 saa7134,tuner,v4l2_common
v4l1_compat            13251  1 videodev
snd_seq                47263  6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              19098  2 snd_pcm,snd_seq
snd_seq_device          5700  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
i2c_ali15x3             5050  0
psmouse                63245  0
i2c_ali1535             4725  0
i2c_ali1563             5438  0
snd                    54148  11
saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
uli526x                13126  0
shpchp                 28820  0
k8temp                  3024  0
serio_raw               3978  0
soundcore               6620  1 snd
snd_page_alloc          7076  2 snd_intel8x0,snd_pcm
squashfs               20680  1
aufs                  149050  1
nls_cp437               4919  1
isofs                  29250  1
dm_raid45              81647  0
xor                    15028  1 dm_raid45
fbcon                  35102  71
tileblit                2031  1 fbcon
font                    7557  1 fbcon
bitblit                 4707  1 fbcon
softcursor              1189  1 bitblit
vga16fb                11385  0
vgastate                8961  1 vga16fb
nouveau               467048  2
ttm                    49943  1 nouveau
drm_kms_helper         29297  1 nouveau
amd64_agp               7025  1
ali_agp                 3717  0
drm                   162377  4 nouveau,ttm,drm_kms_helper
floppy                 53016  0
i2c_algo_bit            5028  1 nouveau
agpgart                31724  4 ttm,amd64_agp,ali_agp,drm
pata_ali                7932  3

Sep 28 08:35:46 ubuntu kernel: [  244.966013] saa7134 ALSA driver for
DMA sound unloaded
Sep 28 08:36:08 ubuntu kernel: [  266.695795] saa7130/34: v4l2 driver
version 0.2.15 loaded
Sep 28 08:36:08 ubuntu kernel: [  266.695864] saa7133[0]: found at
0000:02:07.0, rev: 209, irq: 20, latency: 64, mmio: 0xfbfff800
Sep 28 08:36:08 ubuntu kernel: [  266.695875] saa7133[0]: subsystem:
1043:4876, board: ASUSTeK P7131 Hybrid [card=112,autodetected]
Sep 28 08:36:08 ubuntu kernel: [  266.695915] saa7133[0]: board init:
gpio is 40000
Sep 28 08:36:08 ubuntu kernel: [  266.697138] input: saa7134 IR
(ASUSTeK P7131 Hybri as
/devices/pci0000:00/0000:00:02.0/0000:02:07.0/input/input6
Sep 28 08:36:08 ubuntu kernel: [  266.697370] IRQ 20/saa7133[0]:
IRQF_DISABLED is not guaranteed on shared IRQs
Sep 28 08:36:08 ubuntu kernel: [  266.848023] saa7133[0]: i2c eeprom
00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Sep 28 08:36:08 ubuntu kernel: [  266.848043] saa7133[0]: i2c eeprom
10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848061] saa7133[0]: i2c eeprom
20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848079] saa7133[0]: i2c eeprom
30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848095] saa7133[0]: i2c eeprom
40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848112] saa7133[0]: i2c eeprom
50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848128] saa7133[0]: i2c eeprom
60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848145] saa7133[0]: i2c eeprom
70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848162] saa7133[0]: i2c eeprom
80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848178] saa7133[0]: i2c eeprom
90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848195] saa7133[0]: i2c eeprom
a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848211] saa7133[0]: i2c eeprom
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848228] saa7133[0]: i2c eeprom
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848245] saa7133[0]: i2c eeprom
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848261] saa7133[0]: i2c eeprom
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848278] saa7133[0]: i2c eeprom
f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 08:36:08 ubuntu kernel: [  266.848297] i2c i2c-3: Invalid 7-bit
address 0x7a
Sep 28 08:36:08 ubuntu kernel: [  266.896214] tuner 3-004b: chip found
@ 0x96 (saa7133[0])
Sep 28 08:36:09 ubuntu kernel: [  266.976033] tda829x 3-004b: setting
tuner address to 61
Sep 28 08:36:09 ubuntu kernel: [  267.040024] tda829x 3-004b: type set
to tda8290+75a
Sep 28 08:36:12 ubuntu kernel: [  270.960873] saa7133[0]: registered
device video0 [v4l2]
Sep 28 08:36:12 ubuntu kernel: [  270.961673] saa7133[0]: registered device vbi0
Sep 28 08:36:12 ubuntu kernel: [  270.962139] saa7133[0]: registered
device radio0
Sep 28 08:36:13 ubuntu kernel: [  270.985176] saa7134 ALSA driver for
DMA sound loaded
Sep 28 08:36:13 ubuntu kernel: [  270.985197] IRQ 20/saa7133[0]:
IRQF_DISABLED is not guaranteed on shared IRQs
Sep 28 08:36:13 ubuntu kernel: [  270.985232] saa7133[0]/alsa:
saa7133[0] at 0xfbfff800 irq 20 registered as card -2
Sep 28 08:36:13 ubuntu kernel: [  271.134051] dvb_init() allocating 1 frontend
Sep 28 08:36:13 ubuntu kernel: [  271.280288] DVB: registering new
adapter (saa7133[0])
Sep 28 08:36:13 ubuntu kernel: [  271.280295] DVB: registering adapter
0 frontend 0 (Philips TDA10046H DVB-T)...
Sep 28 08:36:13 ubuntu kernel: [  271.472053] tda1004x: setting up
plls for 48MHz sampling clock
Sep 28 08:36:13 ubuntu kernel: [  271.804024] tda1004x: found firmware
revision 20 -- ok
Sep 28 08:36:59 ubuntu kernel: [  317.728020] ir-common: code=2de9,
rc5=4915451, start=2, toggle=1, address=17, instr=29
Sep 28 08:36:59 ubuntu kernel: [  317.728028] ir-common: instruction
29, toggle 1
Sep 28 08:36:59 ubuntu kernel: [  317.728034] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=2 down=1
Sep 28 08:36:59 ubuntu kernel: [  317.840020] ir-common: code=2de9,
rc5=4915451, start=2, toggle=1, address=17, instr=29
Sep 28 08:36:59 ubuntu kernel: [  317.956022] ir-common: key released
Sep 28 08:36:59 ubuntu kernel: [  317.956031] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=2 down=0
Sep 28 08:37:03 ubuntu kernel: [  321.684018] ir-common: code=25e9,
rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 28 08:37:03 ubuntu kernel: [  321.684026] ir-common: instruction
29, toggle 0
Sep 28 08:37:03 ubuntu kernel: [  321.684032] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=2 down=1
Sep 28 08:37:03 ubuntu kernel: [  321.796026] ir-common: code=25e9,
rc5=4915449, start=2, toggle=0, address=17, instr=29
Sep 28 08:37:03 ubuntu kernel: [  321.912021] ir-common: key released
Sep 28 08:37:03 ubuntu kernel: [  321.912030] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=2 down=0
Sep 28 08:37:06 ubuntu kernel: [  324.524022] ir-common: code=2ded,
rc5=4515451, start=2, toggle=1, address=17, instr=2d
Sep 28 08:37:06 ubuntu kernel: [  324.524030] ir-common: instruction
2d, toggle 1
Sep 28 08:37:06 ubuntu kernel: [  324.524036] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=3 down=1
Sep 28 08:37:06 ubuntu kernel: [  324.640016] ir-common: key released
Sep 28 08:37:06 ubuntu kernel: [  324.640026] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=3 down=0
Sep 28 08:37:09 ubuntu kernel: [  327.824021] ir-common: code=25eb,
rc5=5115449, start=2, toggle=0, address=17, instr=2b
Sep 28 08:37:09 ubuntu kernel: [  327.824029] ir-common: instruction
2b, toggle 0
Sep 28 08:37:09 ubuntu kernel: [  327.824035] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=4 down=1
Sep 28 08:37:09 ubuntu kernel: [  327.940023] ir-common: key released
Sep 28 08:37:09 ubuntu kernel: [  327.940033] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=4 down=0
Sep 28 08:37:15 ubuntu kernel: [  333.688018] ir-common: code=2dc9,
rc5=4925451, start=2, toggle=1, address=17, instr=9
Sep 28 08:37:15 ubuntu kernel: [  333.688026] ir-common: instruction 9, toggle 1
Sep 28 08:37:15 ubuntu kernel: [  333.688032] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=5 down=1
Sep 28 08:37:15 ubuntu kernel: [  333.800028] ir-common: code=2dc9,
rc5=4925451, start=2, toggle=1, address=17, instr=9
Sep 28 08:37:15 ubuntu kernel: [  333.916021] ir-common: key released
Sep 28 08:37:15 ubuntu kernel: [  333.916030] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=5 down=0
Sep 28 08:37:18 ubuntu kernel: [  336.336021] ir-common: code=25cd,
rc5=4525449, start=2, toggle=0, address=17, instr=d
Sep 28 08:37:18 ubuntu kernel: [  336.336029] ir-common: instruction d, toggle 0
Sep 28 08:37:18 ubuntu kernel: [  336.336035] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=6 down=1
Sep 28 08:37:18 ubuntu kernel: [  336.448028] ir-common: code=25cd,
rc5=4525449, start=2, toggle=0, address=17, instr=d
Sep 28 08:37:18 ubuntu kernel: [  336.564021] ir-common: key released
Sep 28 08:37:18 ubuntu kernel: [  336.564030] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=6 down=0
Sep 28 08:37:22 ubuntu kernel: [  340.180019] ir-common: code=2dcb,
rc5=5125451, start=2, toggle=1, address=17, instr=b
Sep 28 08:37:22 ubuntu kernel: [  340.180026] ir-common: instruction b, toggle 1
Sep 28 08:37:22 ubuntu kernel: [  340.180033] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=7 down=1
Sep 28 08:37:22 ubuntu kernel: [  340.292027] ir-common: code=2dcb,
rc5=5125451, start=2, toggle=1, address=17, instr=b
Sep 28 08:37:22 ubuntu kernel: [  340.408021] ir-common: key released
Sep 28 08:37:22 ubuntu kernel: [  340.408030] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=7 down=0
Sep 28 08:37:25 ubuntu kernel: [  343.312023] ir-common: code=25f1,
rc5=4a55449, start=2, toggle=0, address=17, instr=31
Sep 28 08:37:25 ubuntu kernel: [  343.312031] ir-common: instruction
31, toggle 0
Sep 28 08:37:25 ubuntu kernel: [  343.312037] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=8 down=1
Sep 28 08:37:25 ubuntu kernel: [  343.424027] ir-common: code=25f1,
rc5=4a55449, start=2, toggle=0, address=17, instr=31
Sep 28 08:37:25 ubuntu kernel: [  343.540021] ir-common: key released
Sep 28 08:37:25 ubuntu kernel: [  343.540030] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=8 down=0
Sep 28 08:37:28 ubuntu kernel: [  346.452024] ir-common: code=2df5,
rc5=4455451, start=2, toggle=1, address=17, instr=35
Sep 28 08:37:28 ubuntu kernel: [  346.452032] ir-common: instruction
35, toggle 1
Sep 28 08:37:28 ubuntu kernel: [  346.452038] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=9 down=1
Sep 28 08:37:28 ubuntu kernel: [  346.568023] ir-common: key released
Sep 28 08:37:28 ubuntu kernel: [  346.568033] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=9 down=0
Sep 28 08:37:36 ubuntu kernel: [  354.176018] ir-common: code=25f3,
rc5=5255449, start=2, toggle=0, address=17, instr=33
Sep 28 08:37:36 ubuntu kernel: [  354.176026] ir-common: instruction
33, toggle 0
Sep 28 08:37:36 ubuntu kernel: [  354.176032] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=10 down=1
Sep 28 08:37:36 ubuntu kernel: [  354.288025] ir-common: code=25f3,
rc5=5255449, start=2, toggle=0, address=17, instr=33
Sep 28 08:37:36 ubuntu kernel: [  354.404021] ir-common: key released
Sep 28 08:37:36 ubuntu kernel: [  354.404030] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=10 down=0
Sep 28 08:37:42 ubuntu kernel: [  360.920021] ir-common: code=2dd5,
rc5=4445451, start=2, toggle=1, address=17, instr=15
Sep 28 08:37:42 ubuntu kernel: [  360.920029] ir-common: instruction
15, toggle 1
Sep 28 08:37:42 ubuntu kernel: [  360.920036] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=11 down=1
Sep 28 08:37:43 ubuntu kernel: [  361.032020] ir-common: code=2dd5,
rc5=4445451, start=2, toggle=1, address=17, instr=15
Sep 28 08:37:43 ubuntu kernel: [  361.148022] ir-common: key released
Sep 28 08:37:43 ubuntu kernel: [  361.148031] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=11 down=0
Sep 28 08:37:46 ubuntu kernel: [  364.924021] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:46 ubuntu kernel: [  364.924029] ir-common: instruction a, toggle 0
Sep 28 08:37:46 ubuntu kernel: [  364.924036] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=402 down=1
Sep 28 08:37:47 ubuntu kernel: [  365.036019] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.148026] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.260023] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.372025] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.484018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.596024] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.708018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.820030] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:47 ubuntu kernel: [  365.932018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.044020] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.156018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.268018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.380017] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.492018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.604020] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.716018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.828029] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:48 ubuntu kernel: [  366.940018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.052015] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.164011] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.276018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.388018] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.500020] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.612023] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.724020] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.836031] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:49 ubuntu kernel: [  367.948021] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:50 ubuntu kernel: [  368.060016] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:50 ubuntu kernel: [  368.172019] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:50 ubuntu kernel: [  368.284017] ir-common: code=25ca,
rc5=9125449, start=2, toggle=0, address=17, instr=a
Sep 28 08:37:50 ubuntu kernel: [  368.400013] ir-common: key released
Sep 28 08:37:50 ubuntu kernel: [  368.400022] saa7134 IR (ASUSTeK
P7131 Hybri: key event code=402 down=0



I talked to Mauro on irc, and he asked me to do another test:
<mchehab> western: try the latest stable kernel from kernel.org and
tell me if the problem happens there
<mchehab> there were some changes at IR core, including several fixes

3) Third test: Ubuntu 10.04 x86_64, with latest stable kernel from
kernel.org (2.6.35.6)

holden@holden-desktop:~$ uname -a
Linux holden-desktop 2.6.35.6-custom #1 SMP Mon Sep 27 21:46:32 CEST
2010 x86_64 GNU/Linux
holden@holden-desktop:~$ lsmod
Module                  Size  Used by
tda1004x               16795  1
saa7134_dvb            27289  0
videobuf_dvb            6204  1 saa7134_dvb
dvb_core              103617  1 videobuf_dvb
saa7134_alsa           12243  0
tda827x                10556  2
tda8290                15021  1
tuner                  23226  1
rc_asus_pc39            1316  0
saa7134               172729  2 saa7134_dvb,saa7134_alsa
v4l2_common            20603  2 tuner,saa7134
videodev               49231  3 tuner,saa7134,v4l2_common
v4l1_compat            15519  1 videodev
v4l2_compat_ioctl32    11850  1 videodev
videobuf_dma_sg        11094  3 saa7134_dvb,saa7134_alsa,saa7134
videobuf_core          19650  3 videobuf_dvb,saa7134,videobuf_dma_sg
ir_common               6155  1 saa7134
binfmt_misc             7686  1
ppdev                   6568  0
fbcon                  39263  71
tileblit                2511  1 fbcon
font                    8077  1 fbcon
bitblit                 5835  1 fbcon
softcursor              1589  1 bitblit
snd_intel8x0           30546  2
snd_ac97_codec        124716  1 snd_intel8x0
ac97_bus                1474  1 snd_ac97_codec
snd_pcm_oss            40889  0
snd_mixer_oss          16338  1 snd_pcm_oss
snd_pcm                88307  4
saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss
snd_seq_dummy           1806  0
snd_seq_oss            30694  0
ir_sony_decoder         3862  0
snd_seq_midi            5932  0
ir_jvc_decoder          3889  0
ir_rc6_decoder          4433  0
snd_rawmidi            23392  1 snd_seq_midi
nouveau               563400  2
ir_rc5_decoder          3953  0
snd_seq_midi_event      7291  2 snd_seq_oss,snd_seq_midi
ir_nec_decoder          3985  0
snd_seq                57011  6
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
ttm                    67332  1 nouveau
drm_kms_helper         32479  1 nouveau
drm                   204420  3 nouveau,ttm,drm_kms_helper
snd_timer              23180  2 snd_pcm,snd_seq
snd_seq_device          6912  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
it87                   35154  0
hwmon_vid               3154  1 it87
snd                    71150  15
saa7134_alsa,snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
ir_core                15890  9
rc_asus_pc39,saa7134,ir_common,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder
psmouse                60388  0
uli526x                15737  0
tveeprom               14098  1 saa7134
i2c_algo_bit            5912  1 nouveau
edac_core              46399  0
edac_mce_amd            9101  0
i2c_ali15x3             6116  0
i2c_ali1535             5735  0
soundcore               8091  1 snd
i2c_ali1563             6362  0
snd_page_alloc          8716  2 snd_intel8x0,snd_pcm
k8temp                  4051  0
lp                     10201  0
parport                36975  2 ppdev,lp
shpchp                 34487  0
serio_raw               4910  0
floppy                 62708  0
pata_ali               10692  2

Sep 28 00:08:12 holden-desktop kernel: [  265.680150] Linux video
capture interface: v2.00
Sep 28 00:08:12 holden-desktop kernel: [  265.770161] saa7130/34: v4l2
driver version 0.2.16 loaded
Sep 28 00:08:12 holden-desktop kernel: [  265.770268] saa7134
0000:02:07.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Sep 28 00:08:12 holden-desktop kernel: [  265.770275] saa7133[0]:
found at 0000:02:07.0, rev: 209, irq: 20, latency: 64, mmio:
0xfbfff800
Sep 28 00:08:12 holden-desktop kernel: [  265.770282] saa7133[0]:
subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid
[card=112,autodetected]
Sep 28 00:08:12 holden-desktop kernel: [  265.770303] saa7133[0]:
board init: gpio is 40000
Sep 28 00:08:12 holden-desktop kernel: [  265.810058] Registered IR
keymap rc-asus-pc39
Sep 28 00:08:12 holden-desktop kernel: [  265.810071]
__ir_input_register: Allocated space for 64 keycode entries (512
bytes)
Sep 28 00:08:12 holden-desktop kernel: [  265.810075]
ir_do_setkeycode: #0: New scan 0x0015 with key 0x000b
Sep 28 00:08:12 holden-desktop kernel: [  265.810078]
ir_do_setkeycode: #1: New scan 0x0029 with key 0x0002
Sep 28 00:08:12 holden-desktop kernel: [  265.810080]
ir_do_setkeycode: #2: New scan 0x002d with key 0x0003
Sep 28 00:08:12 holden-desktop kernel: [  265.810082]
ir_do_setkeycode: #2: New scan 0x002b with key 0x0004
Sep 28 00:08:12 holden-desktop kernel: [  265.810085]
ir_do_setkeycode: #0: New scan 0x0009 with key 0x0005
Sep 28 00:08:12 holden-desktop kernel: [  265.810087]
ir_do_setkeycode: #1: New scan 0x000d with key 0x0006
Sep 28 00:08:12 holden-desktop kernel: [  265.810090]
ir_do_setkeycode: #1: New scan 0x000b with key 0x0007
Sep 28 00:08:12 holden-desktop kernel: [  265.810092]
ir_do_setkeycode: #7: New scan 0x0031 with key 0x0008
Sep 28 00:08:12 holden-desktop kernel: [  265.810094]
ir_do_setkeycode: #8: New scan 0x0035 with key 0x0009
Sep 28 00:08:12 holden-desktop kernel: [  265.810097]
ir_do_setkeycode: #8: New scan 0x0033 with key 0x000a
Sep 28 00:08:12 holden-desktop kernel: [  265.810099]
ir_do_setkeycode: #10: New scan 0x003e with key 0x0181
Sep 28 00:08:12 holden-desktop kernel: [  265.810102]
ir_do_setkeycode: #0: New scan 0x0003 with key 0x008b
Sep 28 00:08:12 holden-desktop kernel: [  265.810104]
ir_do_setkeycode: #6: New scan 0x002a with key 0x0073
Sep 28 00:08:12 holden-desktop kernel: [  265.810107]
ir_do_setkeycode: #5: New scan 0x0019 with key 0x0072
Sep 28 00:08:12 holden-desktop kernel: [  265.810109]
ir_do_setkeycode: #13: New scan 0x0037 with key 0x0067
Sep 28 00:08:12 holden-desktop kernel: [  265.810112]
ir_do_setkeycode: #14: New scan 0x003b with key 0x006c
Sep 28 00:08:12 holden-desktop kernel: [  265.810114]
ir_do_setkeycode: #6: New scan 0x0027 with key 0x0069
Sep 28 00:08:12 holden-desktop kernel: [  265.810116]
ir_do_setkeycode: #11: New scan 0x002f with key 0x006a
Sep 28 00:08:12 holden-desktop kernel: [  265.810119]
ir_do_setkeycode: #6: New scan 0x0025 with key 0x0189
Sep 28 00:08:12 holden-desktop kernel: [  265.810121]
ir_do_setkeycode: #17: New scan 0x0039 with key 0x0188
Sep 28 00:08:12 holden-desktop kernel: [  265.810124]
ir_do_setkeycode: #6: New scan 0x0021 with key 0x0179
Sep 28 00:08:12 holden-desktop kernel: [  265.810126]
ir_do_setkeycode: #6: New scan 0x001d with key 0x00ae
Sep 28 00:08:12 holden-desktop kernel: [  265.810129]
ir_do_setkeycode: #2: New scan 0x000a with key 0x0192
Sep 28 00:08:12 holden-desktop kernel: [  265.810132]
ir_do_setkeycode: #7: New scan 0x001b with key 0x0193
Sep 28 00:08:12 holden-desktop kernel: [  265.810134]
ir_do_setkeycode: #7: New scan 0x001a with key 0x001c
Sep 28 00:08:12 holden-desktop kernel: [  265.810137]
ir_do_setkeycode: #1: New scan 0x0006 with key 0x0077
Sep 28 00:08:12 holden-desktop kernel: [  265.810139]
ir_do_setkeycode: #11: New scan 0x001e with key 0x019c
Sep 28 00:08:12 holden-desktop kernel: [  265.810142]
ir_do_setkeycode: #14: New scan 0x0026 with key 0x0197
Sep 28 00:08:12 holden-desktop kernel: [  265.810144]
ir_do_setkeycode: #6: New scan 0x000e with key 0x00a8
Sep 28 00:08:12 holden-desktop kernel: [  265.810147]
ir_do_setkeycode: #27: New scan 0x003a with key 0x00d0
Sep 28 00:08:12 holden-desktop kernel: [  265.810150]
ir_do_setkeycode: #25: New scan 0x0036 with key 0x0080
Sep 28 00:08:12 holden-desktop kernel: [  265.810152]
ir_do_setkeycode: #21: New scan 0x002e with key 0x00a7
Sep 28 00:08:12 holden-desktop kernel: [  265.810154]
ir_do_setkeycode: #8: New scan 0x0016 with key 0x0074
Sep 28 00:08:12 holden-desktop kernel: [  265.810157]
ir_do_setkeycode: #7: New scan 0x0011 with key 0x0174
Sep 28 00:08:12 holden-desktop kernel: [  265.810160]
ir_do_setkeycode: #8: New scan 0x0013 with key 0x0070
Sep 28 00:08:12 holden-desktop kernel: [  265.810162]
ir_do_setkeycode: #17: New scan 0x0023 with key 0x0066
Sep 28 00:08:12 holden-desktop kernel: [  265.810165]
ir_do_setkeycode: #1: New scan 0x0005 with key 0x016e
Sep 28 00:08:12 holden-desktop kernel: [  265.810168]
ir_do_setkeycode: #36: New scan 0x003d with key 0x0071
Sep 28 00:08:12 holden-desktop kernel: [  265.810170]
ir_do_setkeycode: #0: New scan 0x0001 with key 0x0185
Sep 28 00:08:12 holden-desktop kernel: [  265.810265] input: saa7134
IR (ASUSTeK P7131 Hybri as
/devices/pci0000:00/0000:00:02.0/0000:02:07.0/rc/rc0/input4
Sep 28 00:08:12 holden-desktop kernel: [  265.810343] rc0: saa7134 IR
(ASUSTeK P7131 Hybri as
/devices/pci0000:00/0000:00:02.0/0000:02:07.0/rc/rc0
Sep 28 00:08:12 holden-desktop kernel: [  265.810346]
__ir_input_register: Registered input device on saa7134 for
rc-asus-pc39 remote.
Sep 28 00:08:12 holden-desktop kernel: [  265.990029] saa7133[0]: i2c
eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Sep 28 00:08:12 holden-desktop kernel: [  265.990048] saa7133[0]: i2c
eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990065] saa7133[0]: i2c
eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990081] saa7133[0]: i2c
eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990096] saa7133[0]: i2c
eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990112] saa7133[0]: i2c
eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990128] saa7133[0]: i2c
eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990143] saa7133[0]: i2c
eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990159] saa7133[0]: i2c
eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990174] saa7133[0]: i2c
eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990190] saa7133[0]: i2c
eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990205] saa7133[0]: i2c
eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990221] saa7133[0]: i2c
eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990236] saa7133[0]: i2c
eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990252] saa7133[0]: i2c
eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990267] saa7133[0]: i2c
eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 28 00:08:12 holden-desktop kernel: [  265.990284] saa7133[0]/ir:
No I2C IR support for board 70
Sep 28 00:08:12 holden-desktop kernel: [  266.160235] tuner 3-004b:
chip found @ 0x96 (saa7133[0])
Sep 28 00:08:13 holden-desktop kernel: [  266.330045] tda829x 3-004b:
setting tuner address to 61
Sep 28 00:08:13 holden-desktop kernel: [  266.480022] tda829x 3-004b:
type set to tda8290+75a
Sep 28 00:08:18 holden-desktop kernel: [  272.200946] saa7133[0]:
registered device video0 [v4l2]
Sep 28 00:08:18 holden-desktop kernel: [  272.201866] saa7133[0]:
registered device vbi0
Sep 28 00:08:18 holden-desktop kernel: [  272.202439] saa7133[0]:
registered device radio0
Sep 28 00:08:19 holden-desktop kernel: [  272.230766] saa7134 ALSA
driver for DMA sound loaded
Sep 28 00:08:19 holden-desktop kernel: [  272.230824] saa7133[0]/alsa:
saa7133[0] at 0xfbfff800 irq 20 registered as card -2
Sep 28 00:08:19 holden-desktop kernel: [  272.383286] dvb_init()
allocating 1 frontend
Sep 28 00:08:19 holden-desktop kernel: [  273.160231] DVB: registering
new adapter (saa7133[0])
Sep 28 00:08:19 holden-desktop kernel: [  273.160241] DVB: registering
adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
Sep 28 00:08:20 holden-desktop kernel: [  274.100026] tda1004x:
setting up plls for 48MHz sampling clock
Sep 28 00:08:23 holden-desktop kernel: [  276.220043] tda1004x: found
firmware revision 20 -- ok
Sep 28 00:08:25 holden-desktop kernel: [  278.370041]
tda827x_probe_version: could not read from tuner at addr: 0xc2
Sep 28 00:08:39 holden-desktop kernel: [  292.590046] tda1004x:
setting up plls for 48MHz sampling clock
Sep 28 00:08:39 holden-desktop kernel: [  293.120029] tda1004x: found
firmware revision 20 -- ok
Sep 28 00:09:16 holden-desktop kernel: [  330.000040] tda1004x:
setting up plls for 48MHz sampling clock
Sep 28 00:09:17 holden-desktop kernel: [  330.530027] tda1004x: found
firmware revision 20 -- ok
Sep 28 00:09:36 holden-desktop kernel: [  349.680226] tda1004x:
setting up plls for 48MHz sampling clock
Sep 28 00:09:37 holden-desktop kernel: [  350.210027] tda1004x: found
firmware revision 20 -- ok
Sep 28 00:10:16 holden-desktop kernel: [  389.920019] tda1004x:
setting up plls for 48MHz sampling clock
Sep 28 00:10:17 holden-desktop kernel: [  390.450020] tda1004x: found
firmware revision 20 -- ok
Sep 28 00:10:58 holden-desktop kernel: [  431.830034]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:01 holden-desktop kernel: [  435.150045]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:02 holden-desktop kernel: [  435.260027]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:03 holden-desktop kernel: [  436.740023]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:03 holden-desktop kernel: [  436.850020]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:04 holden-desktop kernel: [  437.860025]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:04 holden-desktop kernel: [  437.890023]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:04 holden-desktop kernel: [  437.980024] ir_rc5_decode:
ir-common: code=25ed, rc5=4515449, start=2, toggle=0, address=17,
instr=2d
Sep 28 00:11:04 holden-desktop kernel: [  437.980033]
ir_rc5_timer_end: ir-common: instruction 2d, toggle 0
Sep 28 00:11:04 holden-desktop kernel: [  437.980040]
ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode
0x002d keycode 0x03
Sep 28 00:11:04 holden-desktop kernel: [  437.980046]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=3
down=1
Sep 28 00:11:04 holden-desktop kernel: [  438.100020]
ir_rc5_timer_keyup: ir-common: key released
Sep 28 00:11:04 holden-desktop kernel: [  438.100029]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=3
down=0
Sep 28 00:11:05 holden-desktop kernel: [  439.200022]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:06 holden-desktop kernel: [  439.310056]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:07 holden-desktop kernel: [  441.170020]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:07 holden-desktop kernel: [  441.200027]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:08 holden-desktop kernel: [  441.290035] ir_rc5_decode:
ir-common: code=25eb, rc5=5115449, start=2, toggle=0, address=17,
instr=2b
Sep 28 00:11:08 holden-desktop kernel: [  441.290044]
ir_rc5_timer_end: ir-common: instruction 2b, toggle 0
Sep 28 00:11:08 holden-desktop kernel: [  441.290051]
ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode
0x002b keycode 0x04
Sep 28 00:11:08 holden-desktop kernel: [  441.290057]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=4
down=1
Sep 28 00:11:08 holden-desktop kernel: [  441.410020]
ir_rc5_timer_keyup: ir-common: key released
Sep 28 00:11:08 holden-desktop kernel: [  441.410029]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=4
down=0
Sep 28 00:11:11 holden-desktop kernel: [  444.280048]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:11 holden-desktop kernel: [  444.390041]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:12 holden-desktop kernel: [  446.050022]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:12 holden-desktop kernel: [  446.080029]
ir_rc5_timer_end: ir-common: short code: 2
Sep 28 00:11:12 holden-desktop kernel: [  446.170022]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:13 holden-desktop kernel: [  446.920024]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:13 holden-desktop kernel: [  447.030043]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:16 holden-desktop kernel: [  449.260021]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:16 holden-desktop kernel: [  449.370022]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:16 holden-desktop kernel: [  449.480035]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:16 holden-desktop kernel: [  449.510025]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:16 holden-desktop kernel: [  449.600044] ir_rc5_decode:
ir-common: code=25e9, rc5=4915449, start=2, toggle=0, address=17,
instr=29
Sep 28 00:11:16 holden-desktop kernel: [  449.600053]
ir_rc5_timer_end: ir-common: instruction 29, toggle 0
Sep 28 00:11:16 holden-desktop kernel: [  449.600061]
ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode
0x0029 keycode 0x02
Sep 28 00:11:16 holden-desktop kernel: [  449.600067]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=2
down=1
Sep 28 00:11:16 holden-desktop kernel: [  449.720040]
ir_rc5_timer_keyup: ir-common: key released
Sep 28 00:11:16 holden-desktop kernel: [  449.720050]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=2
down=0
Sep 28 00:11:17 holden-desktop kernel: [  450.820021]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:17 holden-desktop kernel: [  450.930021]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:17 holden-desktop kernel: [  451.040030]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:17 holden-desktop kernel: [  451.070027]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:17 holden-desktop kernel: [  451.160044] ir_rc5_decode:
ir-common: code=2de9, rc5=4915451, start=2, toggle=1, address=17,
instr=29
Sep 28 00:11:17 holden-desktop kernel: [  451.160053]
ir_rc5_timer_end: ir-common: instruction 29, toggle 1
Sep 28 00:11:17 holden-desktop kernel: [  451.160061]
ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode
0x0029 keycode 0x02
Sep 28 00:11:17 holden-desktop kernel: [  451.160067]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=2
down=1
Sep 28 00:11:18 holden-desktop kernel: [  451.280035]
ir_rc5_timer_keyup: ir-common: key released
Sep 28 00:11:18 holden-desktop kernel: [  451.280045]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=2
down=0
Sep 28 00:11:19 holden-desktop kernel: [  452.310022]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:19 holden-desktop kernel: [  452.340024]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:19 holden-desktop kernel: [  452.430027] ir_rc5_decode:
ir-common: code=25e9, rc5=4915449, start=2, toggle=0, address=17,
instr=29
Sep 28 00:11:19 holden-desktop kernel: [  452.430036]
ir_rc5_timer_end: ir-common: instruction 29, toggle 0
Sep 28 00:11:19 holden-desktop kernel: [  452.430043]
ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode
0x0029 keycode 0x02
Sep 28 00:11:19 holden-desktop kernel: [  452.430049]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=2
down=1
Sep 28 00:11:19 holden-desktop kernel: [  452.540025]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:19 holden-desktop kernel: [  452.550029]
ir_rc5_timer_keyup: ir-common: key released
Sep 28 00:11:19 holden-desktop kernel: [  452.550038]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=2
down=0
Sep 28 00:11:20 holden-desktop kernel: [  453.520048]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:20 holden-desktop kernel: [  453.630024]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:20 holden-desktop kernel: [  453.740023]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:20 holden-desktop kernel: [  453.770022]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:21 holden-desktop kernel: [  454.810021]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:21 holden-desktop kernel: [  454.920039]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:21 holden-desktop kernel: [  454.950030]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:22 holden-desktop kernel: [  456.160048]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:22 holden-desktop kernel: [  456.190024]
ir_rc5_timer_end: ir-common: short code: 0
Sep 28 00:11:23 holden-desktop kernel: [  456.280046] ir_rc5_decode:
ir-common: code=2ded, rc5=4515451, start=2, toggle=1, address=17,
instr=2d
Sep 28 00:11:23 holden-desktop kernel: [  456.280054]
ir_rc5_timer_end: ir-common: instruction 2d, toggle 1
Sep 28 00:11:23 holden-desktop kernel: [  456.280062]
ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode
0x002d keycode 0x03
Sep 28 00:11:23 holden-desktop kernel: [  456.280068]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=3
down=1
Sep 28 00:11:23 holden-desktop kernel: [  456.390025]
ir_rc5_timer_end: ir-common: spurious timer_end
Sep 28 00:11:23 holden-desktop kernel: [  456.400044]
ir_rc5_timer_keyup: ir-common: key released
Sep 28 00:11:23 holden-desktop kernel: [  456.400053]
ir_input_key_event: saa7134 IR (ASUSTeK P7131 Hybri: key event code=3
down=0



So, to sum this up:

Distribution      Kernel              Remote works?

Ubuntu 10.04      2.6.32 i386         yes
Ubuntu 10.04      2.6.32 x86_64       no
Ubuntu 10.04      2.6.35.6 x86_64     no


Does anyone else have the same card? It would be nice if someone could
confirm this issue, just to be sure it's not something on my side.
Thanks.

Giorgio Vazzana

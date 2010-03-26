Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60360 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0CZLKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Mar 2010 07:10:04 -0400
Received: by wyb38 with SMTP id 38so3912604wyb.19
        for <linux-media@vger.kernel.org>; Fri, 26 Mar 2010 04:10:02 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Mar 2010 13:10:01 +0200
Message-ID: <56dc2e761003260410t70ef8e39w6f45468ecf84ba40@mail.gmail.com>
Subject: Avermedia AVerTV GO 007 FM composite input problem
From: Andras Barna <andras.barna@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi i have a Avermedia AVerTV GO 007 FM card , the problem is that i
get nothing from Composite, i tried different apps (mplayer, tvtime,
etc) none works. ("television" input works)
ideas?

here're some infos

[    9.361212] saa7130/34: v4l2 driver version 0.2.15 loaded
[    9.361631]   alloc irq_desc for 17 on node -1
[    9.361635]   alloc kstat_irqs on node -1
[    9.361648] saa7134 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.361768] saa7133[0]: found at 0000:00:09.0, rev: 208, irq: 17,
latency: 32, mmio: 0xcfffc800
[    9.361955] saa7133[0]: subsystem: 1461:f31f, board: Avermedia
AVerTV GO 007 FM [card=57,autodetected]
[    9.362198] saa7133[0]: board init: gpio is 80000
[    9.362424] input: saa7134 IR (Avermedia AVerTV GO as
/devices/pci0000:00/0000:00:09.0/input/input6
[    9.362713] IRQ 17/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    9.501011] saa7133[0]: i2c eeprom 00: 61 14 1f f3 ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.501838] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.502592] saa7133[0]: i2c eeprom 20: ff d2 fe ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.503343] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.504095] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.504842] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.505593] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.506345] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.507097] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.507846] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.508600] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.509354] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.510107] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.510920] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.511672] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[    9.512423] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   10.780106] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[   10.815008] tda829x 0-004b: setting tuner address to 61
[   11.349012] tda829x 0-004b: type set to tda8290+75
[   14.869150] saa7133[0]: registered device video0 [v4l2]
[   14.869305] saa7133[0]: registered device vbi0
[   14.869447] saa7133[0]: registered device radio0
[   14.968864] saa7134 ALSA driver for DMA sound loaded
[   14.970728] IRQ 17/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   14.970892] saa7133[0]/alsa: saa7133[0] at 0xcfffc800 irq 17
registered as card -1

$ v4l-info

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
	driver                  : "saa7134"
	card                    : "Avermedia AVerTV GO 007 FM"
	bus_info                : "PCI:0000:00:09.0"
	version                 : 0.2.15
	capabilities            : 0x5010015
[VIDEO_CAPTURE,VIDEO_OVERLAY,VBI_CAPTURE,TUNER,READWRITE,STREAMING]

standards
    VIDIOC_ENUMSTD(0)
	index                   : 0
	id                      : 0xb000 [NTSC_M,NTSC_M_JP,?]
	name                    : "NTSC"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(1)
	index                   : 1
	id                      : 0x1000 [NTSC_M]
	name                    : "NTSC-M"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(2)
	index                   : 2
	id                      : 0x2000 [NTSC_M_JP]
	name                    : "NTSC-M-JP"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(3)
	index                   : 3
	id                      : 0x8000 [?]
	name                    : "NTSC-M-KR"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(4)
	index                   : 4
	id                      : 0xff
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K]
	name                    : "PAL"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(5)
	index                   : 5
	id                      : 0x7 [PAL_B,PAL_B1,PAL_G]
	name                    : "PAL-BG"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(6)
	index                   : 6
	id                      : 0x8 [PAL_H]
	name                    : "PAL-H"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(7)
	index                   : 7
	id                      : 0x10 [PAL_I]
	name                    : "PAL-I"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(8)
	index                   : 8
	id                      : 0xe0 [PAL_D,PAL_D1,PAL_K]
	name                    : "PAL-DK"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(9)
	index                   : 9
	id                      : 0x100 [PAL_M]
	name                    : "PAL-M"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(10)
	index                   : 10
	id                      : 0x200 [PAL_N]
	name                    : "PAL-N"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(11)
	index                   : 11
	id                      : 0x400 [PAL_Nc]
	name                    : "PAL-Nc"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(12)
	index                   : 12
	id                      : 0x800 [PAL_60]
	name                    : "PAL-60"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(13)
	index                   : 13
	id                      : 0xff0000
[SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	name                    : "SECAM"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(14)
	index                   : 14
	id                      : 0x10000 [SECAM_B]
	name                    : "SECAM-B"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(15)
	index                   : 15
	id                      : 0x40000 [SECAM_G]
	name                    : "SECAM-G"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(16)
	index                   : 16
	id                      : 0x80000 [SECAM_H]
	name                    : "SECAM-H"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(17)
	index                   : 17
	id                      : 0x320000 [SECAM_D,SECAM_K,SECAM_K1]
	name                    : "SECAM-DK"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(18)
	index                   : 18
	id                      : 0x400000 [SECAM_L]
	name                    : "SECAM-L"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625
    VIDIOC_ENUMSTD(19)
	index                   : 19
	id                      : 0x800000 [?ATSC_8_VSB]
	name                    : "SECAM-Lc"
	frameperiod.numerator   : 1
	frameperiod.denominator : 25
	framelines              : 625

inputs
    VIDIOC_ENUMINPUT(0)
	index                   : 0
	name                    : "Television"
	type                    : TUNER
	audioset                : 1
	tuner                   : 0
	std                     : 0xffbfff
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []
    VIDIOC_ENUMINPUT(1)
	index                   : 1
	name                    : "Composite1"
	type                    : CAMERA
	audioset                : 1
	tuner                   : 0
	std                     : 0xffbfff
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x10100 [NO_H_LOCK,NO_SYNC]
    VIDIOC_ENUMINPUT(2)
	index                   : 2
	name                    : "S-Video"
	type                    : CAMERA
	audioset                : 1
	tuner                   : 0
	std                     : 0xffbfff
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []

tuners
    VIDIOC_G_TUNER(0)
	index                   : 0
	name                    : "Television"
	type                    : ANALOG_TV
	capability              : 0x72 [NORM,STEREO,LANG2,LANG1]
	rangelow                : 0
	rangehigh               : 4294967295
	rxsubchans              : 0x1 [MONO]
	audmode                 : MONO
	signal                  : 0
	afc                     : 0

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
	index                   : 0
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "8 bpp gray"
	pixelformat             : 0x59455247 [GREY]
    VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
	index                   : 1
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "15 bpp RGB, le"
	pixelformat             : 0x4f424752 [RGBO]
    VIDIOC_ENUM_FMT(2,VIDEO_CAPTURE)
	index                   : 2
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "15 bpp RGB, be"
	pixelformat             : 0x51424752 [RGBQ]
    VIDIOC_ENUM_FMT(3,VIDEO_CAPTURE)
	index                   : 3
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "16 bpp RGB, le"
	pixelformat             : 0x50424752 [RGBP]
    VIDIOC_ENUM_FMT(4,VIDEO_CAPTURE)
	index                   : 4
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "16 bpp RGB, be"
	pixelformat             : 0x52424752 [RGBR]
    VIDIOC_ENUM_FMT(5,VIDEO_CAPTURE)
	index                   : 5
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "24 bpp RGB, le"
	pixelformat             : 0x33524742 [BGR3]
    VIDIOC_ENUM_FMT(6,VIDEO_CAPTURE)
	index                   : 6
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "24 bpp RGB, be"
	pixelformat             : 0x33424752 [RGB3]
    VIDIOC_ENUM_FMT(7,VIDEO_CAPTURE)
	index                   : 7
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "32 bpp RGB, le"
	pixelformat             : 0x34524742 [BGR4]
    VIDIOC_ENUM_FMT(8,VIDEO_CAPTURE)
	index                   : 8
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "32 bpp RGB, be"
	pixelformat             : 0x34424752 [RGB4]
    VIDIOC_ENUM_FMT(9,VIDEO_CAPTURE)
	index                   : 9
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2 packed, YUYV"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(10,VIDEO_CAPTURE)
	index                   : 10
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2 packed, UYVY"
	pixelformat             : 0x59565955 [UYVY]
    VIDIOC_ENUM_FMT(11,VIDEO_CAPTURE)
	index                   : 11
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2 planar, Y-Cb-Cr"
	pixelformat             : 0x50323234 [422P]
    VIDIOC_ENUM_FMT(12,VIDEO_CAPTURE)
	index                   : 12
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:0 planar, Y-Cb-Cr"
	pixelformat             : 0x32315559 [YU12]
    VIDIOC_ENUM_FMT(13,VIDEO_CAPTURE)
	index                   : 13
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:0 planar, Y-Cb-Cr"
	pixelformat             : 0x32315659 [YV12]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
	type                    : VIDEO_CAPTURE
	fmt.pix.width           : 720
	fmt.pix.height          : 576
	fmt.pix.pixelformat     : 0x33524742 [BGR3]
	fmt.pix.field           : INTERLACED
	fmt.pix.bytesperline    : 2160
	fmt.pix.sizeimage       : 1244160
	fmt.pix.colorspace      : unknown
	fmt.pix.priv            : 0

video overlay
    VIDIOC_ENUM_FMT(0,VIDEO_OVERLAY)
	index                   : 0
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "8 bpp gray"
	pixelformat             : 0x59455247 [GREY]
    VIDIOC_ENUM_FMT(1,VIDEO_OVERLAY)
	index                   : 1
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "15 bpp RGB, le"
	pixelformat             : 0x4f424752 [RGBO]
    VIDIOC_ENUM_FMT(2,VIDEO_OVERLAY)
	index                   : 2
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "15 bpp RGB, be"
	pixelformat             : 0x51424752 [RGBQ]
    VIDIOC_ENUM_FMT(3,VIDEO_OVERLAY)
	index                   : 3
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "16 bpp RGB, le"
	pixelformat             : 0x50424752 [RGBP]
    VIDIOC_ENUM_FMT(4,VIDEO_OVERLAY)
	index                   : 4
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "16 bpp RGB, be"
	pixelformat             : 0x52424752 [RGBR]
    VIDIOC_ENUM_FMT(5,VIDEO_OVERLAY)
	index                   : 5
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "24 bpp RGB, le"
	pixelformat             : 0x33524742 [BGR3]
    VIDIOC_ENUM_FMT(6,VIDEO_OVERLAY)
	index                   : 6
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "24 bpp RGB, be"
	pixelformat             : 0x33424752 [RGB3]
    VIDIOC_ENUM_FMT(7,VIDEO_OVERLAY)
	index                   : 7
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "32 bpp RGB, le"
	pixelformat             : 0x34524742 [BGR4]
    VIDIOC_ENUM_FMT(8,VIDEO_OVERLAY)
	index                   : 8
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "32 bpp RGB, be"
	pixelformat             : 0x34424752 [RGB4]
    VIDIOC_ENUM_FMT(9,VIDEO_OVERLAY)
	index                   : 9
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "4:2:2 packed, YUYV"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(10,VIDEO_OVERLAY)
	index                   : 10
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "4:2:2 packed, UYVY"
	pixelformat             : 0x59565955 [UYVY]
    VIDIOC_G_FMT(VIDEO_OVERLAY)
	type                    : VIDEO_OVERLAY
	fmt.win.w.left          : 0
	fmt.win.w.top           : 0
	fmt.win.w.width         : 0
	fmt.win.w.height        : 0
	fmt.win.field           : ANY
	fmt.win.chromakey       : 0
	fmt.win.clips           : (nil)
	fmt.win.clipcount       : 0
	fmt.win.bitmap          : (nil)
    VIDIOC_G_FBUF
	capability              : 0x4 [LIST_CLIPPING]
	flags                   : 0x0 []
	base                    : (nil)
	fmt.width               : 0
	fmt.height              : 0
	fmt.pixelformat         : 0x00000000 [....]
	fmt.field               : ANY
	fmt.bytesperline        : 0
	fmt.sizeimage           : 0
	fmt.colorspace          : unknown
	fmt.priv                : 0

vbi capture
    VIDIOC_G_FMT(VBI_CAPTURE)
	type                    : VBI_CAPTURE
	fmt.vbi.sampling_rate   : 27000000
	fmt.vbi.offset          : 256
	fmt.vbi.samples_per_line: 2048
	fmt.vbi.sample_format   : 0x59455247 [GREY]
	fmt.vbi.start[0]        : 7
	fmt.vbi.start[1]        : 319
	fmt.vbi.count[0]        : 16
	fmt.vbi.count[1]        : 16
	fmt.vbi.flags           : 0

controls
    VIDIOC_QUERYCTRL(BASE+0)
	id                      : 9963776
	type                    : INTEGER
	name                    : "Brightness"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 128
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+1)
	id                      : 9963777
	type                    : INTEGER
	name                    : "Contrast"
	minimum                 : 0
	maximum                 : 127
	step                    : 1
	default_value           : 68
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+2)
	id                      : 9963778
	type                    : INTEGER
	name                    : "Saturation"
	minimum                 : 0
	maximum                 : 127
	step                    : 1
	default_value           : 64
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+3)
	id                      : 9963779
	type                    : INTEGER
	name                    : "Hue"
	minimum                 : -128
	maximum                 : 127
	step                    : 1
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+5)
	id                      : 9963781
	type                    : INTEGER
	name                    : "Volume"
	minimum                 : -15
	maximum                 : 15
	step                    : 1
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+9)
	id                      : 9963785
	type                    : BOOLEAN
	name                    : "Mute"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+20)
	id                      : 9963796
	type                    : BOOLEAN
	name                    : "Mirror"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+0)
	id                      : 134217728
	type                    : BOOLEAN
	name                    : "Invert"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+1)
	id                      : 134217729
	type                    : INTEGER
	name                    : "y offset odd field"
	minimum                 : 0
	maximum                 : 128
	step                    : 1
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+2)
	id                      : 134217730
	type                    : INTEGER
	name                    : "y offset even field"
	minimum                 : 0
	maximum                 : 128
	step                    : 1
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+3)
	id                      : 134217731
	type                    : BOOLEAN
	name                    : "automute"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 1
	flags                   : 0

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
	name                    : "Avermedia AVerTV GO 007 FM"
	type                    : 0x2f [CAPTURE,TUNER,TELETEXT,OVERLAY,CLIPPING]
	channels                : 3
	audios                  : 0
	maxwidth                : 720
	maxheight               : 578
	minwidth                : 48
	minheight               : 32

channels
    VIDIOCGCHAN(0)
	channel                 : 0
	name                    : "Television"
	tuners                  : 1
	flags                   : 0x1 [TUNER]
	type                    : TV
	norm                    : 0
    VIDIOCGCHAN(1)
	channel                 : 1
	name                    : "Composite1"
	tuners                  : 0
	flags                   : 0x0 []
	type                    : CAMERA
	norm                    : 0
    VIDIOCGCHAN(2)
	channel                 : 2
	name                    : "S-Video"
	tuners                  : 0
	flags                   : 0x0 []
	type                    : CAMERA
	norm                    : 0

tuner
    VIDIOCGTUNER
	tuner                   : 0
	name                    : "Television"
	rangelow                : 0
	rangehigh               : 4294967295
	flags                   : 0x7 [PAL,NTSC,SECAM]
	mode                    : PAL
	signal                  : 0

audio
    VIDIOCGAUDIO
	audio                   : 0
	volume                  : 32768
	bass                    : 0
	treble                  : 0

picture
    VIDIOCGPICT
	brightness              : 32896
	hue                     : 32896
	colour                  : 33026
	contrast                : 35090
	whiteness               : 0
	depth                   : 24
	palette                 : RGB24

buffer
    VIDIOCGFBUF
	base                    : (nil)
	height                  : 0
	width                   : 0
	depth                   : 0
	bytesperline            : 0

window
    VIDIOCGWIN
	x                       : 0
	y                       : 0
	width                   : 0
	height                  : 0
	chromakey               : 0
	flags                   : 0

$
Linux suse 2.6.33-ck1 #2 SMP PREEMPT Thu Mar 18 02:41:20 EET 2010 i686
athlon i386 GNU/Linux

the same with the stock kernel 2.6.31.12-0.2-default

-- 
http://blog.sartek.net | http://twitter.com/sartek

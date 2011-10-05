Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49663 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab1JESc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 14:32:59 -0400
Received: by wwf22 with SMTP id 22so2988591wwf.1
        for <linux-media@vger.kernel.org>; Wed, 05 Oct 2011 11:32:58 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Oct 2011 13:32:58 -0500
Message-ID: <CANut7vBzVpOdqKHxWeZbV1r+9cfBJ3r01i6LKFCoTCTeu55Zpg@mail.gmail.com>
Subject: fm player for v4l2
From: Will Milspec <will.milspec@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi all,

After recent-ish kernel updates, "fmtools" no longer works.  (I'm
running gentoo currently on kernel 3.0.6)

I believe the changes pertain to V4L1 vs L2 api changes. I am not a
linux developer, however, and can't speak w/ authority.

I've appended my v4l-info at the end of this email

Example Failing Command
==================
$fm 91.5
ioctl VIDIOCGAUDIO: Invalid argument

Kernel V4L options
==================
Here's my kernel configuration:

CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_V4L2=y
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_V4L_MEM2MEM_DRIVERS is not set


Can anyone recommend:
- any fm software that works w/ V4L2?
- any kernel tweaks I can make to keep the old fmtools app working?
- any other "next steps"


thanks,

will


Appendix: V4L-info
===============

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
	driver                  : "bttv"
	card                    : "BT878 video (Hauppauge (bt878))"
	bus_info                : "PCI:0000:05:0a.0"
	version                 : 0.9.18
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
	status                  : 0x100 [NO_H_LOCK]
    VIDIOC_ENUMINPUT(1)
	index                   : 1
	name                    : "Composite1"
	type                    : CAMERA
	audioset                : 1
	tuner                   : 0
	std                     : 0xffbfff
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []
    VIDIOC_ENUMINPUT(2)
	index                   : 2
	name                    : "S-Video"
	type                    : CAMERA
	audioset                : 1
	tuner                   : 0
	std                     : 0xffbfff
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
	status                  : 0x0 []
    VIDIOC_ENUMINPUT(3)
	index                   : 3
	name                    : "Composite3"
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
	capability              : 0x2 [NORM]
	rangelow                : 704
	rangehigh               : 15328
	rxsubchans              : 0x0 []
	audmode                 : LANG1
	signal                  : 0
	afc                     : 0

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
	index                   : 0
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "8 bpp, gray"
	pixelformat             : 0x59455247 [GREY]
    VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
	index                   : 1
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "8 bpp, dithered color"
	pixelformat             : 0x34324948 [HI24]
    VIDIOC_ENUM_FMT(2,VIDEO_CAPTURE)
	index                   : 2
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "15 bpp RGB, le"
	pixelformat             : 0x4f424752 [RGBO]
    VIDIOC_ENUM_FMT(3,VIDEO_CAPTURE)
	index                   : 3
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "15 bpp RGB, be"
	pixelformat             : 0x51424752 [RGBQ]
    VIDIOC_ENUM_FMT(4,VIDEO_CAPTURE)
	index                   : 4
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "16 bpp RGB, le"
	pixelformat             : 0x50424752 [RGBP]
    VIDIOC_ENUM_FMT(5,VIDEO_CAPTURE)
	index                   : 5
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "16 bpp RGB, be"
	pixelformat             : 0x52424752 [RGBR]
    VIDIOC_ENUM_FMT(6,VIDEO_CAPTURE)
	index                   : 6
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "24 bpp RGB, le"
	pixelformat             : 0x33524742 [BGR3]
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
	description             : "4:2:2, packed, YUYV"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(10,VIDEO_CAPTURE)
	index                   : 10
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2, packed, YUYV"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(11,VIDEO_CAPTURE)
	index                   : 11
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2, packed, UYVY"
	pixelformat             : 0x59565955 [UYVY]
    VIDIOC_ENUM_FMT(12,VIDEO_CAPTURE)
	index                   : 12
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2, planar, Y-Cb-Cr"
	pixelformat             : 0x50323234 [422P]
    VIDIOC_ENUM_FMT(13,VIDEO_CAPTURE)
	index                   : 13
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:0, planar, Y-Cb-Cr"
	pixelformat             : 0x32315559 [YU12]
    VIDIOC_ENUM_FMT(14,VIDEO_CAPTURE)
	index                   : 14
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:0, planar, Y-Cr-Cb"
	pixelformat             : 0x32315659 [YV12]
    VIDIOC_ENUM_FMT(15,VIDEO_CAPTURE)
	index                   : 15
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:1:1, planar, Y-Cb-Cr"
	pixelformat             : 0x50313134 [411P]
    VIDIOC_ENUM_FMT(16,VIDEO_CAPTURE)
	index                   : 16
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:1:0, planar, Y-Cb-Cr"
	pixelformat             : 0x39565559 [YUV9]
    VIDIOC_ENUM_FMT(17,VIDEO_CAPTURE)
	index                   : 17
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:1:0, planar, Y-Cr-Cb"
	pixelformat             : 0x39555659 [YVU9]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
	type                    : VIDEO_CAPTURE
	fmt.pix.width           : 320
	fmt.pix.height          : 240
	fmt.pix.pixelformat     : 0x33524742 [BGR3]
	fmt.pix.field           : INTERLACED
	fmt.pix.bytesperline    : 960
	fmt.pix.sizeimage       : 230400
	fmt.pix.colorspace      : unknown
	fmt.pix.priv            : 0

video overlay
    VIDIOC_ENUM_FMT(0,VIDEO_OVERLAY)
	index                   : 0
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "8 bpp, gray"
	pixelformat             : 0x59455247 [GREY]
    VIDIOC_ENUM_FMT(1,VIDEO_OVERLAY)
	index                   : 1
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "8 bpp, dithered color"
	pixelformat             : 0x34324948 [HI24]
    VIDIOC_ENUM_FMT(2,VIDEO_OVERLAY)
	index                   : 2
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "15 bpp RGB, le"
	pixelformat             : 0x4f424752 [RGBO]
    VIDIOC_ENUM_FMT(3,VIDEO_OVERLAY)
	index                   : 3
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "15 bpp RGB, be"
	pixelformat             : 0x51424752 [RGBQ]
    VIDIOC_ENUM_FMT(4,VIDEO_OVERLAY)
	index                   : 4
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "16 bpp RGB, le"
	pixelformat             : 0x50424752 [RGBP]
    VIDIOC_ENUM_FMT(5,VIDEO_OVERLAY)
	index                   : 5
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "16 bpp RGB, be"
	pixelformat             : 0x52424752 [RGBR]
    VIDIOC_ENUM_FMT(6,VIDEO_OVERLAY)
	index                   : 6
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "24 bpp RGB, le"
	pixelformat             : 0x33524742 [BGR3]
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
	description             : "4:2:2, packed, YUYV"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(10,VIDEO_OVERLAY)
	index                   : 10
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "4:2:2, packed, YUYV"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_ENUM_FMT(11,VIDEO_OVERLAY)
	index                   : 11
	type                    : VIDEO_OVERLAY
	flags                   : 0
	description             : "4:2:2, packed, UYVY"
	pixelformat             : 0x59565955 [UYVY]
    VIDIOC_G_FMT(VIDEO_OVERLAY)
	type                    : VIDEO_OVERLAY
	fmt.win.w.left          : 0
	fmt.win.w.top           : 0
	fmt.win.w.width         : 320
	fmt.win.w.height        : 240
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
	fmt.vbi.sampling_rate   : 35468950
	fmt.vbi.offset          : 244
	fmt.vbi.samples_per_line: 2048
	fmt.vbi.sample_format   : 0x59455247 [GREY]
	fmt.vbi.start[0]        : 7
	fmt.vbi.start[1]        : 320
	fmt.vbi.count[0]        : 16
	fmt.vbi.count[1]        : 16
	fmt.vbi.flags           : 0

controls
    VIDIOC_QUERYCTRL(BASE+0)
	id                      : 9963776
	type                    : INTEGER
	name                    : "Brightness"
	minimum                 : 0
	maximum                 : 65535
	step                    : 256
	default_value           : 32768
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+1)
	id                      : 9963777
	type                    : INTEGER
	name                    : "Contrast"
	minimum                 : 0
	maximum                 : 65535
	step                    : 128
	default_value           : 32768
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+2)
	id                      : 9963778
	type                    : INTEGER
	name                    : "Saturation"
	minimum                 : 0
	maximum                 : 65535
	step                    : 128
	default_value           : 32768
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+3)
	id                      : 9963779
	type                    : INTEGER
	name                    : "Hue"
	minimum                 : 0
	maximum                 : 65535
	step                    : 256
	default_value           : 32768
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+6)
	id                      : 9963782
	type                    : INTEGER
	name                    : "Balance"
	minimum                 : 0
	maximum                 : 65535
	step                    : 655
	default_value           : 32768
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+7)
	id                      : 9963783
	type                    : INTEGER
	name                    : "Bass"
	minimum                 : 0
	maximum                 : 65535
	step                    : 655
	default_value           : 32768
	flags                   : 0
    VIDIOC_QUERYCTRL(BASE+8)
	id                      : 9963784
	type                    : INTEGER
	name                    : "Treble"
	minimum                 : 0
	maximum                 : 65535
	step                    : 655
	default_value           : 32768
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
    VIDIOC_QUERYCTRL(PRIVATE_BASE+0)
	id                      : 134217728
	type                    : BOOLEAN
	name                    : "chroma agc"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+1)
	id                      : 134217729
	type                    : BOOLEAN
	name                    : "combfilter"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+2)
	id                      : 134217730
	type                    : BOOLEAN
	name                    : "automute"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+3)
	id                      : 134217731
	type                    : BOOLEAN
	name                    : "luma decimation filter"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+4)
	id                      : 134217732
	type                    : BOOLEAN
	name                    : "agc crush"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+5)
	id                      : 134217733
	type                    : BOOLEAN
	name                    : "vcr hack"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+6)
	id                      : 134217734
	type                    : INTEGER
	name                    : "whitecrush upper"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 207
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+7)
	id                      : 134217735
	type                    : INTEGER
	name                    : "whitecrush lower"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 127
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+8)
	id                      : 134217736
	type                    : INTEGER
	name                    : "uv ratio"
	minimum                 : 0
	maximum                 : 100
	step                    : 1
	default_value           : 50
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+9)
	id                      : 134217737
	type                    : BOOLEAN
	name                    : "full luma range"
	minimum                 : 0
	maximum                 : 1
	step                    : 0
	default_value           : 0
	flags                   : 0
    VIDIOC_QUERYCTRL(PRIVATE_BASE+10)
	id                      : 134217738
	type                    : INTEGER
	name                    : "coring"
	minimum                 : 0
	maximum                 : 3
	step                    : 1
	default_value           : 0
	flags                   : 0

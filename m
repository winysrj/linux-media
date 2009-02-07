Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n17KExNZ011509
	for <video4linux-list@redhat.com>; Sat, 7 Feb 2009 15:14:59 -0500
Received: from smtp-out4.blueyonder.co.uk (smtp-out4.blueyonder.co.uk
	[195.188.213.7])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n17KEfQ6007928
	for <video4linux-list@redhat.com>; Sat, 7 Feb 2009 15:14:41 -0500
Received: from [172.23.170.144] (helo=anti-virus03-07)
	by smtp-out4.blueyonder.co.uk with smtp (Exim 4.52)
	id 1LVtZZ-00074O-67
	for video4linux-list@redhat.com; Sat, 07 Feb 2009 20:14:41 +0000
Received: from [82.46.193.134] (helo=[82.46.193.134])
	by asmtp-out1.blueyonder.co.uk with esmtpa (Exim 4.52)
	id 1LVtZS-0003qO-Oe
	for video4linux-list@redhat.com; Sat, 07 Feb 2009 20:14:35 +0000
Message-ID: <498DEBAB.2090808@blueyonder.co.uk>
Date: Sat, 07 Feb 2009 20:14:35 +0000
From: Ian Davidson <id012c3076@blueyonder.co.uk>
MIME-Version: 1.0
To: Video 4 Linux <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Recording problems
Reply-To: ian.davidson@bigfoot.com
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

I seem to have messed up my system again.

I have tried to record - but it seems that I cannot see my camera or 
video hardware.

I ran xawtv (with debugging turned on) and streamer.

Here is the output from xawtv.
[Sound@localhost ~]$ xawtv -remote -nodga -debug 2
This is xawtv-3.95, running on Linux/i686 (2.6.27.12-78.2.8.fc9.i686)
visual: id=0x21 class=4 (TrueColor), depth=24
visual: id=0x22 class=5 (DirectColor), depth=24
visual: id=0x5b class=4 (TrueColor), depth=32
x11: color depth: 24 bits, 3 bytes - pixmap: 4 bytes
x11: color masks: red=0x00ff0000 green=0x0000ff00 blue=0x000000ff
x11: server byte order: little endian
x11: client byte order: little endian
main: dga extention...
main: xinerama extention...
xinerama 0: 1440x900+0+0
main: xvideo extention [video]...
Xvideo: 0 adaptors available.
Xvideo: no usable video port found
main: xvideo extention [image]...
main: init main window...
main: install signal handlers...
main thread [pid=3362]
main: open grabber device...
x11: remote display (overlay disabled)
vid-open: trying: v4l2-old...
vid-open: failed: v4l2-old
vid-open: trying: v4l2...
ioctl: VIDIOC_QUERYCAP(driver="bttv";card="BT878 video ( *** 
UNKNOWN/GENER";bus_info="PCI:0000:04:02.0";version=0.9.17;capabilities=0x5010015 
[VIDEO_CAPTURE,VIDEO_OVERLAY,VBI_CAPTURE,TUNER,READWRITE,STREAMING]): ok
v4l2: open
v4l2: device info:
  bttv 0.9.17 / BT878 video ( *** UNKNOWN/GENER @ PCI:0000:04:02.0
ioctl: 
VIDIOC_ENUMINPUT(index=0;name="Television";type=TUNER;audioset=1;tuner=0;std=0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB];status=0x0 
[]): ok
ioctl: 
VIDIOC_ENUMINPUT(index=1;name="Composite1";type=CAMERA;audioset=1;tuner=0;std=0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB];status=0x100 
[NO_H_LOCK]): ok
ioctl: 
VIDIOC_ENUMINPUT(index=2;name="S-Video";type=CAMERA;audioset=1;tuner=0;std=0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB];status=0x0 
[]): ok
ioctl: 
VIDIOC_ENUMINPUT(index=3;name="Composite3";type=CAMERA;audioset=1;tuner=0;std=0xffbfff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,PAL_M,PAL_N,PAL_Nc,PAL_60,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB];status=0x0 
[]): ok
ioctl: 
VIDIOC_ENUMINPUT(index=4;name="";type=unknown;audioset=0;tuner=0;std=0x0 
[];status=0x0 []): Invalid argument
ioctl: VIDIOC_ENUMSTD(index=0;id=0xb000 
[NTSC_M,NTSC_M_JP,?];name="NTSC";frameperiod.numerator=1001;frameperiod.denominator=30000;framelines=525): 
ok
ioctl: VIDIOC_ENUMSTD(index=1;id=0x1000 
[NTSC_M];name="NTSC-M";frameperiod.numerator=1001;frameperiod.denominator=30000;framelines=525): 
ok
ioctl: VIDIOC_ENUMSTD(index=2;id=0x2000 
[NTSC_M_JP];name="NTSC-M-JP";frameperiod.numerator=1001;frameperiod.denominator=30000;framelines=525): 
ok
ioctl: VIDIOC_ENUMSTD(index=3;id=0x8000 
[?];name="NTSC-M-KR";frameperiod.numerator=1001;frameperiod.denominator=30000;framelines=525): 
ok
ioctl: VIDIOC_ENUMSTD(index=4;id=0xff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K];name="PAL";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=5;id=0x7 
[PAL_B,PAL_B1,PAL_G];name="PAL-BG";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=6;id=0x8 
[PAL_H];name="PAL-H";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=7;id=0x10 
[PAL_I];name="PAL-I";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=8;id=0xe0 
[PAL_D,PAL_D1,PAL_K];name="PAL-DK";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=9;id=0x100 
[PAL_M];name="PAL-M";frameperiod.numerator=1001;frameperiod.denominator=30000;framelines=525): 
ok
ioctl: VIDIOC_ENUMSTD(index=10;id=0x200 
[PAL_N];name="PAL-N";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=11;id=0x400 
[PAL_Nc];name="PAL-Nc";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=12;id=0x800 
[PAL_60];name="PAL-60";frameperiod.numerator=1001;frameperiod.denominator=30000;framelines=525): 
ok
ioctl: VIDIOC_ENUMSTD(index=13;id=0xff0000 
[SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB];name="SECAM";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=14;id=0x10000 
[SECAM_B];name="SECAM-B";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUMSTD(index=15;id=0x40000 
[SECAM_G];name="SECAM-G";frameperiod.numerator=1;frameperiod.denominator=25;framelines=625): 
ok
ioctl: VIDIOC_ENUM_FMT(index=0;type=VIDEO_CAPTURE;flags=0;description="8 
bpp, gray";pixelformat=0x59455247 [GREY]): ok
ioctl: VIDIOC_ENUM_FMT(index=1;type=VIDEO_CAPTURE;flags=0;description="8 
bpp, dithered color";pixelformat=0x34324948 [HI24]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=2;type=VIDEO_CAPTURE;flags=0;description="15 bpp 
RGB, le";pixelformat=0x4f424752 [RGBO]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=3;type=VIDEO_CAPTURE;flags=0;description="15 bpp 
RGB, be";pixelformat=0x51424752 [RGBQ]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=4;type=VIDEO_CAPTURE;flags=0;description="16 bpp 
RGB, le";pixelformat=0x50424752 [RGBP]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=5;type=VIDEO_CAPTURE;flags=0;description="16 bpp 
RGB, be";pixelformat=0x52424752 [RGBR]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=6;type=VIDEO_CAPTURE;flags=0;description="24 bpp 
RGB, le";pixelformat=0x33524742 [BGR3]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=7;type=VIDEO_CAPTURE;flags=0;description="32 bpp 
RGB, le";pixelformat=0x34524742 [BGR4]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=8;type=VIDEO_CAPTURE;flags=0;description="32 bpp 
RGB, be";pixelformat=0x34424752 [RGB4]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=9;type=VIDEO_CAPTURE;flags=0;description="4:2:2, 
packed, YUYV";pixelformat=0x56595559 [YUYV]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=10;type=VIDEO_CAPTURE;flags=0;description="4:2:2, 
packed, YUYV";pixelformat=0x56595559 [YUYV]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=11;type=VIDEO_CAPTURE;flags=0;description="4:2:2, 
packed, UYVY";pixelformat=0x59565955 [UYVY]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=12;type=VIDEO_CAPTURE;flags=0;description="4:2:2, 
planar, Y-Cb-Cr";pixelformat=0x50323234 [422P]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=13;type=VIDEO_CAPTURE;flags=0;description="4:2:0, 
planar, Y-Cb-Cr";pixelformat=0x32315559 [YU12]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=14;type=VIDEO_CAPTURE;flags=0;description="4:2:0, 
planar, Y-Cr-Cb";pixelformat=0x32315659 [YV12]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=15;type=VIDEO_CAPTURE;flags=0;description="4:1:1, 
planar, Y-Cb-Cr";pixelformat=0x50313134 [411P]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=16;type=VIDEO_CAPTURE;flags=0;description="4:1:0, 
planar, Y-Cb-Cr";pixelformat=0x39565559 [YUV9]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=17;type=VIDEO_CAPTURE;flags=0;description="4:1:0, 
planar, Y-Cr-Cb";pixelformat=0x39555659 [YVU9]): ok
ioctl: 
VIDIOC_ENUM_FMT(index=18;type=VIDEO_CAPTURE;flags=0;description="";pixelformat=0x00000000 
[....]): Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=9963776;type=INTEGER;name="Brightness";minimum=0;maximum=65535;step=256;default_value=32768;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963777;type=INTEGER;name="Contrast";minimum=0;maximum=65535;step=128;default_value=32768;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963778;type=INTEGER;name="Saturation";minimum=0;maximum=65535;step=128;default_value=32768;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963779;type=INTEGER;name="Hue";minimum=0;maximum=65535;step=256;default_value=32768;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963782;type=INTEGER;name="Balance";minimum=0;maximum=65535;step=655;default_value=32768;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963783;type=INTEGER;name="Bass";minimum=0;maximum=65535;step=655;default_value=32768;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963784;type=INTEGER;name="Treble";minimum=0;maximum=65535;step=655;default_value=32768;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963785;type=BOOLEAN;name="Mute";minimum=0;maximum=1;step=0;default_value=0;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=0;type=unknown;name="42";minimum=0;maximum=0;step=0;default_value=0;flags=1): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=9963807;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: VIDIOC_QUERYCTRL(id=134217728;type=BOOLEAN;name="chroma 
agc";minimum=0;maximum=1;step=0;default_value=0;flags=0): ok
ioctl: 
VIDIOC_QUERYCTRL(id=134217729;type=BOOLEAN;name="combfilter";minimum=0;maximum=1;step=0;default_value=0;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=134217730;type=BOOLEAN;name="automute";minimum=0;maximum=1;step=0;default_value=0;flags=0): 
ok
ioctl: VIDIOC_QUERYCTRL(id=134217731;type=BOOLEAN;name="luma decimation 
filter";minimum=0;maximum=1;step=0;default_value=0;flags=0): ok
ioctl: VIDIOC_QUERYCTRL(id=134217732;type=BOOLEAN;name="agc 
crush";minimum=0;maximum=1;step=0;default_value=0;flags=0): ok
ioctl: VIDIOC_QUERYCTRL(id=134217733;type=BOOLEAN;name="vcr 
hack";minimum=0;maximum=1;step=0;default_value=0;flags=0): ok
ioctl: VIDIOC_QUERYCTRL(id=134217734;type=INTEGER;name="whitecrush 
upper";minimum=0;maximum=255;step=1;default_value=207;flags=0): ok
ioctl: VIDIOC_QUERYCTRL(id=134217735;type=INTEGER;name="whitecrush 
lower";minimum=0;maximum=255;step=1;default_value=127;flags=0): ok
ioctl: VIDIOC_QUERYCTRL(id=134217736;type=INTEGER;name="uv 
ratio";minimum=0;maximum=100;step=1;default_value=50;flags=0): ok
ioctl: VIDIOC_QUERYCTRL(id=134217737;type=BOOLEAN;name="full luma 
range";minimum=0;maximum=1;step=0;default_value=0;flags=0): ok
ioctl: 
VIDIOC_QUERYCTRL(id=134217738;type=INTEGER;name="coring";minimum=0;maximum=3;step=1;default_value=0;flags=0): 
ok
ioctl: 
VIDIOC_QUERYCTRL(id=134217739;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217740;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217741;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217742;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217743;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217744;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217745;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217746;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217747;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217748;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217749;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217750;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217751;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217752;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217753;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217754;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217755;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217756;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217757;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217758;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
ioctl: 
VIDIOC_QUERYCTRL(id=134217759;type=unknown;name="";minimum=0;maximum=0;step=0;default_value=0;flags=0): 
Invalid argument
vid-open: ok: v4l2
main: checking wm...
wm cap: _NET_WM_NAME
wm cap: _NET_CLOSE_WINDOW
wm cap: _NET_WM_STATE
wm cap: _NET_WM_STATE_SHADED
wm cap: _NET_WM_STATE_MAXIMIZED_VERT
wm cap: _NET_WM_STATE_MAXIMIZED_HORZ
wm cap: _NET_WM_DESKTOP
wm cap: _NET_NUMBER_OF_DESKTOPS
wm cap: _NET_CURRENT_DESKTOP
wm cap: _NET_WM_WINDOW_TYPE
wm cap: _NET_WM_WINDOW_TYPE_DESKTOP
wm cap: _NET_WM_WINDOW_TYPE_DOCK
wm cap: _NET_WM_WINDOW_TYPE_TOOLBAR
wm cap: _NET_WM_WINDOW_TYPE_MENU
wm cap: _NET_WM_WINDOW_TYPE_DIALOG
wm cap: _NET_WM_WINDOW_TYPE_NORMAL
wm cap: _NET_WM_STATE_MODAL
wm cap: _NET_CLIENT_LIST
wm cap: _NET_CLIENT_LIST_STACKING
wm cap: _NET_WM_STATE_SKIP_TASKBAR
wm cap: _NET_WM_STATE_SKIP_PAGER
wm cap: _NET_WM_ICON_NAME
wm cap: _NET_WM_ICON
wm cap: _NET_WM_ICON_GEOMETRY
wm cap: _NET_WM_MOVERESIZE
wm cap: _NET_ACTIVE_WINDOW
wm cap: _NET_WM_STRUT
wm cap: _NET_WM_STATE_HIDDEN
wm cap: _NET_WM_WINDOW_TYPE_UTILITY
wm cap: _NET_WM_WINDOW_TYPE_SPLASH
wm cap: _NET_WM_STATE_FULLSCREEN
wm cap: _NET_WM_PING
wm cap: _NET_WM_PID
wm cap: _NET_WORKAREA
wm cap: _NET_SHOWING_DESKTOP
wm cap: _NET_DESKTOP_LAYOUT
wm cap: _NET_DESKTOP_NAMES
wm cap: _NET_WM_ALLOWED_ACTIONS
wm cap: _NET_WM_ACTION_MOVE
wm cap: _NET_WM_ACTION_RESIZE
wm cap: _NET_WM_ACTION_SHADE
wm cap: _NET_WM_ACTION_STICK
wm cap: _NET_WM_ACTION_MAXIMIZE_HORZ
wm cap: _NET_WM_ACTION_MAXIMIZE_VERT
wm cap: _NET_WM_ACTION_CHANGE_DESKTOP
wm cap: _NET_WM_ACTION_CLOSE
wm cap: _NET_WM_STATE_ABOVE
wm cap: _NET_WM_STATE_BELOW
wm cap: _NET_STARTUP_ID
wm cap: _NET_WM_STRUT_PARTIAL
wm cap: _NET_WM_ACTION_FULLSCREEN
wm cap: _NET_WM_ACTION_MINIMIZE
wm cap: _NET_FRAME_EXTENTS
wm cap: _NET_REQUEST_FRAME_EXTENTS
wm cap: _NET_WM_USER_TIME
wm cap: _NET_WM_STATE_DEMANDS_ATTENTION
wm cap: _NET_DESKTOP_GEOMETRY
wm cap: _NET_DESKTOP_VIEWPORT
wm cap: _NET_WM_USER_TIME_WINDOW
wm cap: _NET_MOVERESIZE_WINDOW
wm cap: _NET_WM_ACTION_ABOVE
wm cap: _NET_WM_ACTION_BELOW
wmhooks: netwm state above
wm cap: _NET_WM_NAME
wm cap: _NET_CLOSE_WINDOW
wm cap: _NET_WM_STATE
wm cap: _NET_WM_STATE_SHADED
wm cap: _NET_WM_STATE_MAXIMIZED_VERT
wm cap: _NET_WM_STATE_MAXIMIZED_HORZ
wm cap: _NET_WM_DESKTOP
wm cap: _NET_NUMBER_OF_DESKTOPS
wm cap: _NET_CURRENT_DESKTOP
wm cap: _NET_WM_WINDOW_TYPE
wm cap: _NET_WM_WINDOW_TYPE_DESKTOP
wm cap: _NET_WM_WINDOW_TYPE_DOCK
wm cap: _NET_WM_WINDOW_TYPE_TOOLBAR
wm cap: _NET_WM_WINDOW_TYPE_MENU
wm cap: _NET_WM_WINDOW_TYPE_DIALOG
wm cap: _NET_WM_WINDOW_TYPE_NORMAL
wm cap: _NET_WM_STATE_MODAL
wm cap: _NET_CLIENT_LIST
wm cap: _NET_CLIENT_LIST_STACKING
wm cap: _NET_WM_STATE_SKIP_TASKBAR
wm cap: _NET_WM_STATE_SKIP_PAGER
wm cap: _NET_WM_ICON_NAME
wm cap: _NET_WM_ICON
wm cap: _NET_WM_ICON_GEOMETRY
wm cap: _NET_WM_MOVERESIZE
wm cap: _NET_ACTIVE_WINDOW
wm cap: _NET_WM_STRUT
wm cap: _NET_WM_STATE_HIDDEN
wm cap: _NET_WM_WINDOW_TYPE_UTILITY
wm cap: _NET_WM_WINDOW_TYPE_SPLASH
wm cap: _NET_WM_STATE_FULLSCREEN
wm cap: _NET_WM_PING
wm cap: _NET_WM_PID
wm cap: _NET_WORKAREA
wm cap: _NET_SHOWING_DESKTOP
wm cap: _NET_DESKTOP_LAYOUT
wm cap: _NET_DESKTOP_NAMES
wm cap: _NET_WM_ALLOWED_ACTIONS
wm cap: _NET_WM_ACTION_MOVE
wm cap: _NET_WM_ACTION_RESIZE
wm cap: _NET_WM_ACTION_SHADE
wm cap: _NET_WM_ACTION_STICK
wm cap: _NET_WM_ACTION_MAXIMIZE_HORZ
wm cap: _NET_WM_ACTION_MAXIMIZE_VERT
wm cap: _NET_WM_ACTION_CHANGE_DESKTOP
wm cap: _NET_WM_ACTION_CLOSE
wm cap: _NET_WM_STATE_ABOVE
wm cap: _NET_WM_STATE_BELOW
wm cap: _NET_STARTUP_ID
wm cap: _NET_WM_STRUT_PARTIAL
wm cap: _NET_WM_ACTION_FULLSCREEN
wm cap: _NET_WM_ACTION_MINIMIZE
wm cap: _NET_FRAME_EXTENTS
wm cap: _NET_REQUEST_FRAME_EXTENTS
wm cap: _NET_WM_USER_TIME
wm cap: _NET_WM_STATE_DEMANDS_ATTENTION
wm cap: _NET_DESKTOP_GEOMETRY
wm cap: _NET_DESKTOP_VIEWPORT
wm cap: _NET_WM_USER_TIME_WINDOW
wm cap: _NET_MOVERESIZE_WINDOW
wm cap: _NET_WM_ACTION_ABOVE
wm cap: _NET_WM_ACTION_BELOW
wmhooks: netwm state fullscreen
main: creating windows ...
main: init frequency tables ...
freq: reading /usr/share/xawtv/Index.map
main: read config file ...
xt: checking for randr extention ...
xrandr: 1440x900 1400x1050 1280x1024 1280x960 1152x864 1024x768 832x624 
800x600 640x480 720x400
xt: checking for vidmode extention ...
xt: checking for lirc ...
lirc: not enabled at compile time
xt: checking for joystick ...
xt: checking for midi ...
xt: adding kbd hooks ...
main: mapping main window ...
xt: pointer show
main: initialize hardware ...
ioctl: VIDIOC_G_STD(std=0xff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K]): ok
ioctl: VIDIOC_G_INPUT(int=1): ok
ioctl: 
VIDIOC_G_TUNER(index=0;name="Television";type=ANALOG_TV;capability=0x2 
[NORM];rangelow=0;rangehigh=0;rxsubchans=0x1 
[MONO];audmode=MONO;signal=0;afc=0): ok
v4l2:   tuner cap:
v4l2:   tuner rxs: MONO
v4l2:   tuner cur: MONO
ioctl: VIDIOC_G_CTRL(id=9963776;value=32768): ok
ioctl: VIDIOC_G_CTRL(id=9963777;value=32768): ok
ioctl: VIDIOC_G_CTRL(id=9963778;value=32768): ok
ioctl: VIDIOC_G_CTRL(id=9963779;value=32768): ok
ioctl: VIDIOC_G_CTRL(id=9963782;value=1): ok
ioctl: VIDIOC_G_CTRL(id=9963783;value=1): ok
ioctl: VIDIOC_G_CTRL(id=9963784;value=1): ok
ioctl: VIDIOC_G_CTRL(id=134217728;value=0): ok
ioctl: VIDIOC_G_CTRL(id=134217729;value=0): ok
ioctl: VIDIOC_G_CTRL(id=134217730;value=1): ok
ioctl: VIDIOC_G_CTRL(id=134217731;value=0): ok
ioctl: VIDIOC_G_CTRL(id=134217732;value=1): ok
ioctl: VIDIOC_G_CTRL(id=134217733;value=0): ok
ioctl: VIDIOC_G_CTRL(id=134217734;value=207): ok
ioctl: VIDIOC_G_CTRL(id=134217735;value=127): ok
ioctl: VIDIOC_G_CTRL(id=134217736;value=50): ok
ioctl: VIDIOC_G_CTRL(id=134217737;value=0): ok
ioctl: VIDIOC_G_CTRL(id=134217738;value=0): ok
ioctl: VIDIOC_S_CTRL(id=9963785;value=0): ok
ioctl: VIDIOC_G_CTRL(id=9963785;value=1769171318): ok
main: parse channels from config file ...
xt: handle_pending:  start ...
video: tv(+root): DestroyNotify
video: tv(+root): DestroyNotify
PropertyNotify WM_NAME
PropertyNotify WM_ICON_NAME
PropertyNotify WM_COMMAND
PropertyNotify WM_CLIENT_MACHINE
PropertyNotify WM_NORMAL_HINTS
PropertyNotify WM_HINTS
PropertyNotify WM_CLASS
PropertyNotify WM_LOCALE_NAME
PropertyNotify WM_LOCALE_NAME
PropertyNotify WM_CLIENT_LEADER
video: shell: size 384x288+0+0
gd: init
blit: init
blit: gl: init
blit: gl: DRI=Yes
blit: gl: texture max size: 2048
blit: resize 384x288
gd: config 384x288 win=3a00060
blit: gl: extention GL_EXT_bgra is available
blit: gl: extention GL_EXT_bgra is available
ioctl: 
VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=384;fmt.pix.height=288;fmt.pix.pixelformat=0x33524742 
[BGR3];fmt.pix.field=BOTTOM;fmt.pix.bytesperline=1152;fmt.pix.sizeimage=331776;fmt.pix.colorspace=unknown;fmt.pix.priv=0): 
ok
v4l2: new capture params (384x288, BGR3, 331776 byte)
setformat: 24 bit TrueColor (LE: bgr) (384x288): ok
grabdisplay: using "24 bit TrueColor (LE: bgr)"
video: root: ConfigureNotify
PropertyNotify _NET_WM_ALLOWED_ACTIONS
PropertyNotify _NET_WM_ALLOWED_ACTIONS
video: shell: ReparentNotify
video: tv(+root): ReparentNotify
PropertyNotify _NET_WM_DESKTOP
PropertyNotify _NET_WM_DESKTOP
PropertyNotify _NET_FRAME_EXTENTS
video: root: ConfigureNotify
video: shell: size 384x288+3+48
PropertyNotify WM_STATE
PropertyNotify _NET_WM_STATE
video: root: ConfigureNotify
video: root: MapNotify
video: shell: map
video: tv: visibility 0
PropertyNotify _NET_WM_STATE
PropertyNotify _NET_WM_STATE
video: root: UnmapNotify
video: root: UnmapNotify
PropertyNotify _NET_WM_ICON_GEOMETRY
PropertyNotify WM_PROTOCOLS
PropertyNotify WM_NORMAL_HINTS
PropertyNotify XKLAVIER_STATE
xt: handle_pending:  ... done
cmd: "setfreqtab" "europe-west"
freq: newtab 5
freq: reading /usr/share/xawtv/europe-west.list
freq: reading /usr/share/xawtv/ccir-i-iii.list
freq: reading /usr/share/xawtv/ccir-sl-sh.list
freq: reading /usr/share/xawtv/ccir-h.list
freq: reading /usr/share/xawtv/uhf.list
cmd: "capture" "overlay"
gd: start [7]
ioctl: 
VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=384;fmt.pix.height=288;fmt.pix.pixelformat=0x33524742 
[BGR3];fmt.pix.field=BOTTOM;fmt.pix.bytesperline=1152;fmt.pix.sizeimage=331776;fmt.pix.colorspace=unknown;fmt.pix.priv=0): 
ok
v4l2: new capture params (384x288, BGR3, 331776 byte)
setformat: 24 bit TrueColor (LE: bgr) (384x288): ok
ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success
ioctl: VIDIOC_QUERYBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
v4l2: buf 0: video-cap 0x0+331776, used 0
ioctl: VIDIOC_QUERYBUF(index=1;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
v4l2: buf 1: video-cap 0x51000+331776, used 0
ioctl: VIDIOC_QBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
ioctl: VIDIOC_QBUF(index=1;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
ioctl: VIDIOC_STREAMON(int=1): ok
ioctl: VIDIOC_G_FREQUENCY(tuner=0;type=ANALOG_TV;frequency=13172): ok
cmd: "setchannel" "65"
gd: stop
v4l2: buf 0: video-cap 0x0+331776, used 0
v4l2: buf 1: video-cap 0x51000+331776, used 0
v4l2: freq: 823.250
ioctl: VIDIOC_S_FREQUENCY(tuner=0;type=ANALOG_TV;frequency=13172): ok
gd: start [7]
ioctl: 
VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=384;fmt.pix.height=288;fmt.pix.pixelformat=0x33524742 
[BGR3];fmt.pix.field=BOTTOM;fmt.pix.bytesperline=1152;fmt.pix.sizeimage=331776;fmt.pix.colorspace=unknown;fmt.pix.priv=0): 
ok
v4l2: new capture params (384x288, BGR3, 331776 byte)
setformat: 24 bit TrueColor (LE: bgr) (384x288): ok
ioctl: VIDIOC_REQBUFS(count=2;type=VIDEO_CAPTURE;memory=MMAP): Success
ioctl: VIDIOC_QUERYBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
v4l2: buf 0: video-cap 0x0+331776, used 0
ioctl: VIDIOC_QUERYBUF(index=1;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
v4l2: buf 1: video-cap 0x51000+331776, used 0
ioctl: VIDIOC_QBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
ioctl: VIDIOC_QBUF(index=1;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=MMAP): 
ok
ioctl: VIDIOC_STREAMON(int=1): ok
main: known station tuned, not changing
xt: enter main event loop...
PropertyNotify _XAWTV_STATION
expose count=0
PropertyNotify WM_NAME
PropertyNotify WM_ICON_NAME
PropertyNotify _XAWTV_STATION
PropertyNotify WM_NAME
video: shell: size 384x288+3+48
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
v4l2: buf 0: video-cap 0x0+331776, used 0
v4l2: buf 1: video-cap 0x51000+331776, used 0
video: root: ConfigureNotify
video: tv(+root): ReparentNotify
video: root: ConfigureNotify
video: root: ConfigureNotify
video: root: MapNotify
video: root: UnmapNotify
video: root: UnmapNotify
xt: pointer hide
keypad: timeout
PropertyNotify WM_NAME
video: root: ConfigureNotify
video: root: ConfigureNotify
video: root: ConfigureNotify
video: root: ConfigureNotify
video: root: UnmapNotify
video: tv(+root): DestroyNotify
video: shell: ClientMessage
CloseMainAction: received WM_DELETE_WINDOW message
ioctl: VIDIOC_S_CTRL(id=9963785;value=1): ok
cmd: "capture" "off"
gd: stop
ioctl: 
VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=384;fmt.pix.height=288;fmt.pix.pixelformat=0x34524742 
[BGR4];fmt.pix.field=BOTTOM;fmt.pix.bytesperline=1536;fmt.pix.sizeimage=442368;fmt.pix.colorspace=unknown;fmt.pix.priv=0): 
ok
v4l2: new capture params (384x288, BGR4, 442368 byte)
setformat: 32 bit TrueColor (LE: bgr-) (384x288): ok
ioctl: 
VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=384;fmt.pix.height=288;fmt.pix.pixelformat=0x34524742 
[BGR4];fmt.pix.field=BOTTOM;fmt.pix.bytesperline=1536;fmt.pix.sizeimage=442368;fmt.pix.colorspace=unknown;fmt.pix.priv=0): 
ok
v4l2: new capture params (384x288, BGR4, 442368 byte)
v4l2: read: Input/output error
v4l2: close
[Sound@localhost ~]$


And, here is the output from streamer.  Note that at the end, I pressed 
Ctrl-C and it said "one moment please" - but it appeared to hang and I 
had to close the terminal window.
[Sound@localhost ~]$ streamer -o "test.avi" -f mjpeg -F mono16 -t 
00:40:00 -i Composite1 -r 25.0 -n pal -s 352x288
avi / video: MJPEG (AVI) / audio: 16bit mono (LE)
ioctl: VIDIOC_REQBUFS(count=16;type=VIDEO_CAPTURE;memory=MMAP): Resource 
temporarily unavailable
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
ioctl: VIDIOC_DQBUF(index=0;type=VIDEO_CAPTURE;bytesused=0;flags=0x0 
[];field=ANY;;timecode.type=0;timecode.flags=0;timecode.frames=0;timecode.seconds=0;timecode.minutes=0;timecode.hours=0;timecode.userbits="";sequence=0;memory=unknown): 
Input/output error
^C^C - one moment please

I did have a camera plugged into the Video socket of the card for both 
tests, but I did not get a picture.

I hope you can help.

Ian


-- 
Ian Davidson
239 Streetsbrook Road, Solihull, West Midlands, B91 1HE
-- 
Facts used in this message may or may not reflect an underlying objective reality. 
Facts are supplied for personal use only. 
Recipients quoting supplied information do so at their own risk. 
Facts supplied may vary in whole or part from widely accepted standards. 
While painstakingly researched, facts may or may not be indicative of actually occurring events or natural phenomena. 
The author accepts no responsibility for personal loss or injury resulting from memorisation and subsequent use.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

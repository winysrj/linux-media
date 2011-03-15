Return-path: <mchehab@pedra>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47615 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1COWrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 18:47:08 -0400
Received: from mfilter3-v.gandi.net (mfilter3-v.gandi.net [217.70.178.37])
	by relay1-d.mail.gandi.net (Postfix) with ESMTP id 7F3722552FC
	for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 23:47:05 +0100 (CET)
Received: from relay1-d.mail.gandi.net ([217.70.183.193])
	by mfilter3-v.gandi.net (mfilter3-v.gandi.net [217.70.178.37]) (amavisd-new, port 10024)
	with ESMTP id LkJoKDbp8pTG for <linux-media@vger.kernel.org>;
	Tue, 15 Mar 2011 23:47:03 +0100 (CET)
Received: from indiana.localnet (81.184.29.2.dyn.user.ono.com [81.184.29.2])
	(Authenticated sender: leo@alaxarxa.net)
	by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id EB75A2552FA
	for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 23:47:02 +0100 (CET)
From: Leopold Palomo Avellaneda <leo@alaxarxa.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: wis go7007 driver
Date: Tue, 15 Mar 2011 23:47:01 +0100
References: <201103150940.57931.leo@alaxarxa.net>
In-Reply-To: <201103150940.57931.leo@alaxarxa.net>
MIME-Version: 1.0
Message-Id: <201103152347.01847.leo@alaxarxa.net>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

A Dimarts 15 Març 2011, Leopold Palomo-Avellaneda va escriure:
> Hi,
> 
> I have asked to some people and they have point me to this list to ask. I
> hope this is the right place. :-)
> 
> We have a card Addlink PCI-MPG24 that has 4 bt878 and 4 wis go7007. We have
> used the driver from [1] and [2].
> 
> Also, I have compiled the kernel source staged (2.6.32) and
> although it compiles without problem, the driver doesn't works. I'm testing
> it with two application spook (rtsp server)  and gorecord: both complains
> about Unable to set compression params.
> 
> This driver have been working with an stock debian kernel 2.6.26 without
> problems. Now, I would like to make it works with the current stock kernel
> (2.6.32) and up.
> 
> So, please, could you help me to try to see what's happening and try to
> solve this issue?


playing a bit with the current driver, if I try to play I got:

mplayer tv:// -tv 
driver=v4l2:device=/dev/video0:input=1:norm=pal:adevice=/dev/null
MPlayer SVN-r31918 (C) 2000-2010 MPlayer Team
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not connect to socket
mplayer: No such file or directory
Failed to open LIRC support. You will not be able to use your remote control.

Playing tv://.
TV file format detected.
Selected driver: v4l2
 name: Video 4 Linux 2 input
 author: Martin Olschewski <olschewski@zpr.uni-koeln.de>
 comment: first try, more to come ;-)
v4l2: your device driver does not support VIDIOC_G_STD ioctl, VIDIOC_G_PARM 
was used instead.
Selected device: Adlink PCI-MPG24, channel #0
 Capabilities:  video capture  streaming
 supported norms: 0 = NTSC; 1 = NTSC-M; 2 = NTSC-M-JP; 3 = NTSC-M-KR; 4 = 
NTSC-443; 5 = PAL; 6 = PAL-BG; 7 = PAL-H; 8 = PAL-I; 9 = PAL-DK; 10 = PAL-M; 
11 = PAL-N; 12 = PAL-Nc; 13 = PAL-60; 14 = SECAM; 15 = SECAM-B; 16 = SECAM-G; 
17 = SECAM-H; 18 = SECAM-DK; 19 = SECAM-L; 20 = SECAM-Lc;
 inputs: 0 = Composite;
 Current input: 0
 Current format: MJPEG
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl set format failed: Invalid argument
v4l2: ioctl enum input failed: Invalid argument
Selected input hasn't got a tuner!
v4l2: ioctl set mute failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
v4l2: ioctl query control failed: Invalid argument
Xlib:  extension "XFree86-VidModeExtension" missing on display 
"localhost:10.0".
==========================================================================
Opening video decoder: [ffmpeg] FFmpeg's libavcodec codec family
Selected video codec: [ffmjpeg] vfm: ffmpeg (FFmpeg MJPEG)
==========================================================================
Audio: no sound
Starting playback...
v4l2: select timeout
v4l2: select timeout
v4l2: select timeout
v4l2: select timeout
v4l2: select timeout
V:   0.0  10/ 10 ??% ??% ??,?% 0 0 
v4l2: select timeout
V:   0.0  12/ 12 ??% ??% ??,?% 0 0 
v4l2: select timeout
V:   0.0  14/ 14 ??% ??% ??,?% 0 0 
v4l2: select timeout
V:   0.0  16/ 16 ??% ??% ??,?% 0 0 




this means that it's not working, no?

the v4l-info shows this:



v4l-info 

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
        driver                  : "go7007"
        card                    : "Adlink PCI-MPG24, channel #0"
        bus_info                : ""
        version                 : 0.9.8
        capabilities            : 0x4000001 [VIDEO_CAPTURE,STREAMING]

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
        id                      : 0x4000 [?]
        name                    : "NTSC-443"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(5)
        index                   : 5
        id                      : 0xff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K]
        name                    : "PAL"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(6)
        index                   : 6
        id                      : 0x7 [PAL_B,PAL_B1,PAL_G]
        name                    : "PAL-BG"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(7)
        index                   : 7
        id                      : 0x8 [PAL_H]
        name                    : "PAL-H"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(8)
        index                   : 8
        id                      : 0x10 [PAL_I]
        name                    : "PAL-I"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(9)
        index                   : 9
        id                      : 0xe0 [PAL_D,PAL_D1,PAL_K]
        name                    : "PAL-DK"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(10)
        index                   : 10
        id                      : 0x100 [PAL_M]
        name                    : "PAL-M"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(11)
        index                   : 11
        id                      : 0x200 [PAL_N]
        name                    : "PAL-N"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(12)
        index                   : 12
        id                      : 0x400 [PAL_Nc]
        name                    : "PAL-Nc"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(13)
        index                   : 13
        id                      : 0x800 [PAL_60]
        name                    : "PAL-60"
        frameperiod.numerator   : 1001
        frameperiod.denominator : 30000
        framelines              : 525
    VIDIOC_ENUMSTD(14)
        index                   : 14
        id                      : 0xff0000 
[SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
        name                    : "SECAM"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(15)
        index                   : 15
        id                      : 0x10000 [SECAM_B]
        name                    : "SECAM-B"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(16)
        index                   : 16
        id                      : 0x40000 [SECAM_G]
        name                    : "SECAM-G"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(17)
        index                   : 17
        id                      : 0x80000 [SECAM_H]
        name                    : "SECAM-H"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(18)
        index                   : 18
        id                      : 0x320000 [SECAM_D,SECAM_K,SECAM_K1]
        name                    : "SECAM-DK"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(19)
        index                   : 19
        id                      : 0x400000 [SECAM_L]
        name                    : "SECAM-L"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625
    VIDIOC_ENUMSTD(20)
        index                   : 20
        id                      : 0x800000 [?ATSC_8_VSB]
        name                    : "SECAM-Lc"
        frameperiod.numerator   : 1
        frameperiod.denominator : 25
        framelines              : 625

inputs
    VIDIOC_ENUMINPUT(0)
        index                   : 0
        name                    : "Composite"
        type                    : CAMERA
        audioset                : 0
        tuner                   : 0
        std                     : 0xffb0ff 
[PAL_B,PAL_B1,PAL_G,PAL_H,PAL_I,PAL_D,PAL_D1,PAL_K,NTSC_M,NTSC_M_JP,?,SECAM_B,SECAM_D,SECAM_G,SECAM_H,SECAM_K,SECAM_K1,SECAM_L,?ATSC_8_VSB]
        status                  : 0x0 []

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
        index                   : 0
        type                    : VIDEO_CAPTURE
        flags                   : 1
        description             : "Motion-JPEG"
        pixelformat             : 0x47504a4d [MJPG]
    VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
        index                   : 1
        type                    : VIDEO_CAPTURE
        flags                   : 1
        description             : "MPEG1/MPEG2/MPEG4"
        pixelformat             : 0x4745504d [MPEG]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
        type                    : VIDEO_CAPTURE
        fmt.pix.width           : 720
        fmt.pix.height          : 576
        fmt.pix.pixelformat     : 0x47504a4d [MJPG]
        fmt.pix.field           : NONE
        fmt.pix.bytesperline    : 0
        fmt.pix.sizeimage       : 131072
        fmt.pix.colorspace      : SMPTE170M
        fmt.pix.priv            : 0

controls

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "Adlink PCI-MPG24, channel #0"
        type                    : 0x1 [CAPTURE]
        channels                : 1
        audios                  : 0
        maxwidth                : 720
        maxheight               : 576
        minwidth                : 48
        minheight               : 32

channels
    VIDIOCGCHAN(0)
        channel                 : 0
        name                    : "Composite"
        tuners                  : 0
        flags                   : 0x0 []
        type                    : CAMERA
        norm                    : 0

tuner
ioctl VIDIOCGTUNER: Invalid argument

audio
ioctl VIDIOCGAUDIO: Invalid argument

picture
    VIDIOCGPICT
        brightness              : 0
        hue                     : 0
        colour                  : 0
        contrast                : 0
        whiteness               : 0
        depth                   : 0
        palette                 : unknown

buffer
ioctl VIDIOCGFBUF: Invalid argument

window
    VIDIOCGWIN
        x                       : 0
        y                       : 0
        width                   : 720
        height                  : 576
        chromakey               : 0
        flags                   : 0




any idea?

thanks.

Leo


-- 
--
Linux User 152692     PGP: 0xF944807E
Catalonia
-------------------------------------
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

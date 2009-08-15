Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail00a.mail.t-online.hu ([84.2.40.5]:54415 "EHLO
	mail00a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbZHOHBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 03:01:01 -0400
Message-ID: <4A865B7A.7010208@freemail.hu>
Date: Sat, 15 Aug 2009 08:53:46 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: =?UTF-8?B?SmVhbi1GcmFuw6dvaXMgTW9pbmU=?= <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: libv4l: problem with 2x downscaling + Labtec Webcam 2200
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

I am using your libv4l 0.6.0 [1] together with the driver gspca_pac7311
from Linux kernel 2.6.31-rc4 and with Labtec Webcam 2200 hardware [2]. I
am using the svv.c [3] to display the webcam image.

When I'm using the webcam in 640x480 the image is displayed correctly.
However, when I set the resolution to 320x240, the image is not correct:
the image contains horizontal lines and doubled vertically. I guess the
conversion from 640x480 is not done just the pixels are shown as it would
be 320x240.

$ ./svv -f 320x240
raw pixfmt: PJPG 640x480
pixfmt: RGB3 320x240
mmap method

What do you think the problem could be?

References:
[1] libv4l
http://freshmeat.net/projects/libv4l

[2] Labtec Webcam 2200
http://labtec.com/index.cfm/service/listing/EUR/EN,crid=68,crid2=1764

[3] svv.c
http://moinejf.free.fr/svv.c


$ v4l-info

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
        driver                  : "pac7311"
        card                    : "USB Camera (093a:2626)"
        bus_info                : "usb-0000:00:10.1-1"
        version                 : 2.6.0
        capabilities            : 0x5000001 [VIDEO_CAPTURE,READWRITE,STREAMING]

standards

inputs
    VIDIOC_ENUMINPUT(0)
        index                   : 0
        name                    : "pac7311"
        type                    : CAMERA
        audioset                : 0
        tuner                   : 0
        std                     : 0x0 []
        status                  : 0x0 []

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
        index                   : 0
        type                    : VIDEO_CAPTURE
        flags                   : 0
        description             : "PJPG"
        pixelformat             : 0x47504a50 [PJPG]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
        type                    : VIDEO_CAPTURE
        fmt.pix.width           : 640
        fmt.pix.height          : 480
        fmt.pix.pixelformat     : 0x47504a50 [PJPG]
        fmt.pix.field           : NONE
        fmt.pix.bytesperline    : 640
        fmt.pix.sizeimage       : 115790
        fmt.pix.colorspace      : JPEG
        fmt.pix.priv            : 0

controls
    VIDIOC_QUERYCTRL(BASE+0)
        id                      : 9963776
        type                    : INTEGER
        name                    : "Brightness"
        minimum                 : 0
        maximum                 : 32
        step                    : 1
        default_value           : 16
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+1)
        id                      : 9963777
        type                    : INTEGER
        name                    : "Contrast"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 127
        flags                   : 0
    VIDIOC_QUERYCTRL(BASE+2)
        id                      : 9963778
        type                    : INTEGER
        name                    : "Saturation"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 127
        flags                   : 0

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "USB Camera (093a:2626)"
        type                    : 0x1 [CAPTURE]
        channels                : 1
        audios                  : 0
        maxwidth                : 640
        maxheight               : 480
        minwidth                : 48
        minheight               : 32

channels
    VIDIOCGCHAN(0)
        channel                 : 0
        name                    : "pac7311"
        tuners                  : 0
        flags                   : 0x0 []
        type                    : CAMERA
        norm                    : 0

tuner
ioctl VIDIOCGTUNER: Invalid argument

audio
    VIDIOCGAUDIO
        audio                   : 0
        volume                  : 0
        bass                    : 0
        treble                  : 0

picture
    VIDIOCGPICT
        brightness              : 32768
        hue                     : 0
        colour                  : 32639
        contrast                : 32639
        whiteness               : 0
        depth                   : 8
        palette                 : unknown

buffer
ioctl VIDIOCGFBUF: Invalid argument

window
    VIDIOCGWIN
        x                       : 0
        y                       : 0
        width                   : 640
        height                  : 480
        chromakey               : 0
        flags                   : 0

Regards,

	Márton Németh

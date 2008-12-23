Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBN5q51v024705
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 00:52:05 -0500
Received: from mta03.xtra.co.nz (mta03.xtra.co.nz [210.54.141.252])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBN5pgXI007846
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 00:51:43 -0500
Received: from goofy.kelhome.nz ([125.239.250.107]) by mta03.xtra.co.nz
	with ESMTP
	id <20081223055141.XSJG26672.mta03.xtra.co.nz@goofy.kelhome.nz>
	for <video4linux-list@redhat.com>; Tue, 23 Dec 2008 18:51:41 +1300
Received: from [192.168.9.1] (unknown [192.168.9.1])
	by goofy.kelhome.nz (Postfix) with ESMTP id D283550D03EB
	for <video4linux-list@redhat.com>;
	Tue, 23 Dec 2008 18:51:40 +1300 (NZDT)
From: Kelvin Smith <kelvins@kelhome.dyndns.org>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Tue, 23 Dec 2008 18:51:40 +1300
Message-Id: <1230011500.30985.8.camel@goofy.kelhome.nz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: cannot get pac7311 data viewed by anything....
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

Not sure where to post this, so if this is the wrong list, can someone
point me in the corect direction.

Have a Philips SPC610NC webcam.  I have installed the snapshots from the
linuxtv.org website, and plugging in my camera.  Below is the output
from v4l-info.  I used to be able to go xawtv -d /dev/video0 and see a
picture, now it is corrupt/missing.  I gather because the picture format
is in PJPG is the reason why I cannot see any picture (just black
screen, or black with random dots down 1/3 of the image).  

How do I get this to work with applications like XAWTV and zoneminder. 



### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
        driver                  : "pac7311"
        card                    : "VGA Single Chip"
        bus_info                : "0000:00:02.0"
        version                 : 2.4.0
        capabilities            : 0x5000001
[VIDEO_CAPTURE,READWRITE,STREAMING]

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
        fmt.pix.width           : 320
        fmt.pix.height          : 240
        fmt.pix.pixelformat     : 0x47504a50 [PJPG]
        fmt.pix.field           : NONE
        fmt.pix.bytesperline    : 320
        fmt.pix.sizeimage       : 29390
        fmt.pix.colorspace      : JPEG
        fmt.pix.priv            : 1

controls
    VIDIOC_QUERYCTRL(BASE+1)
        id                      : 9963777
        type                    : INTEGER
        name                    : "Contrast"
        minimum                 : 0
        maximum                 : 255
        step                    : 1
        default_value           : 127
        flags                   : 0

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
        name                    : "VGA Single Chip"
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
        brightness              : 0
        hue                     : 0
        colour                  : 0
        contrast                : 65535
        whiteness               : 0
        depth                   : 8
        palette                 : unknown

buffer
ioctl VIDIOCGFBUF: Invalid argument

window
    VIDIOCGWIN
        x                       : 0
        y                       : 0
        width                   : 320
        height                  : 240
        chromakey               : 0
        flags                   : 0


-- 
Kelvin Smith <kelvins@kelhome.dyndns.org>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

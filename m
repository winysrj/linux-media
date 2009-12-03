Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nB3EN6CR024134
	for <video4linux-list@redhat.com>; Thu, 3 Dec 2009 09:23:06 -0500
Received: from gerard.telenet-ops.be (gerard.telenet-ops.be [195.130.132.48])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nB3EMo3a031495
	for <video4linux-list@redhat.com>; Thu, 3 Dec 2009 09:22:51 -0500
From: Christophe Lermytte <v4l@lermytte.be>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 03 Dec 2009 15:22:11 +0100
Message-ID: <1259850131.3811.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: O511 pixel format: what is it?
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

Hello,

Although I have no experience with v4l, I find myself in the situation
of having to grab frames off an old webcam.

The problem is that I don't seem to have any media player that knows how
to handle the adverted pixel format "O511". I seem to remember being
able to use it with mplayer and v4l1 though. What do I do next?

Regards,
Christophe L.

FYI: I am running 2.6.32 with gspca_main and gspca_ov519 loaded. The
device itself is identified as: "Bus 005 Device 002: ID 05a9:a511
OmniVision Technologies, Inc. OV511+ Webcam".

The v4l2 device info part is

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
	driver                  : "ov519"
	card                    : "USB Camera (05a9:a511)"
	bus_info                : "usb-0000:00:1d.3-1"
	version                 : 2.7.0
	capabilities            : 0x5000001 [VIDEO_CAPTURE,READWRITE,STREAMING]

standards

inputs
    VIDIOC_ENUMINPUT(0)
	index                   : 0
	name                    : "ov519"
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
	description             : "O511"
	pixelformat             : 0x3131354f [O511]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
	type                    : VIDEO_CAPTURE
	fmt.pix.width           : 640
	fmt.pix.height          : 480
	fmt.pix.pixelformat     : 0x3131354f [O511]
	fmt.pix.field           : NONE
	fmt.pix.bytesperline    : 640
	fmt.pix.sizeimage       : 614400
	fmt.pix.colorspace      : JPEG
	fmt.pix.priv            : 0

controls
    VIDIOC_QUERYCTRL(BASE+0)
	id                      : 9963776
	type                    : INTEGER
	name                    : "Brightness"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 127
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
	name                    : "Color"
	minimum                 : 0
	maximum                 : 255
	step                    : 1
	default_value           : 127
	flags                   : 0







--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

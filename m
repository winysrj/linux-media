Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9TKit2S010589
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 16:44:55 -0400
Received: from QMTA01.emeryville.ca.mail.comcast.net
	(qmta01.emeryville.ca.mail.comcast.net [76.96.30.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9TKiawb002965
	for <video4linux-list@redhat.com>; Wed, 29 Oct 2008 16:44:39 -0400
Message-ID: <4908CB31.6040707@personnelware.com>
Date: Wed, 29 Oct 2008 15:44:33 -0500
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: how solid is vivi?
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

I am trying to use vivi to test some v4l2 apps, but I am wondering how many of
the problems are really bugs in vivi that can be fixed so that the remaining
bugs are really bugs in the client app.

Here is the result of using it with some popular apps.  If anyone knows any more
like this, please let me know - I am collecting tools to help with testing.

camorama just errors.

xawtv and tvtime both display the test patteren, but also log a bunch of stuff
to stderr.  I am guessing they are trying to do things without checking to make
sure the driver supports it, but given that I can't find anything that works
witout some error, I have to wonder.

I am working with
http://code.google.com/p/python-video4linux2/
and getting segfaults.  I am reporting them, but it would be nice to be a bit
more confident in knowing what we can rely on.

++ sudo modprobe vivi
++ dmesg
++ grep vivi
[ 1967.326840] vivi: V4L2 device registered as /dev/video0

++ camorama -d /dev/video0

gui error dialog:  "Could not connect to the video device (/dev/video0)  Please
check the connection."

++ xawtv -device /dev/video0
This is xawtv-3.95.dfsg.1, running on Linux/i686 (2.6.27-7-generic)
xinerama 0: 1024x768+0+0
/dev/video0 [v4l2]: no overlay support
v4l-conf had some trouble, trying to continue anyway
Warning: Cannot convert string "-*-ledfixed-medium-r-*--39-*-*-*-c-*-*-*" to
type FontStruct


++ tvtime --device /dev/video0
Running tvtime 1.0.2.
Reading configuration from /etc/tvtime/tvtime.xml
I/O warning : failed to load external entity "/home/juser/.tvtime/tvtime.xml"
I/O error : Permission denied
I/O error : Permission denied
Cannot change owner of /home/juser/.tvtime/tvtime.xml: Permission denied.
videoinput: Can't get tuner info: Invalid argument
videoinput: Can't get tuner info: Invalid argument
videoinput: Can't mute card.  Post a bug report with your
videoinput: driver info to http://tvtime.net/
videoinput: Include this error: 'Invalid argument'
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
I/O error : Permission denied
videoinput: Can't mute card.  Post a bug report with your
videoinput: driver info to http://tvtime.net/
videoinput: Include this error: 'Invalid argument'
I/O warning : failed to load external entity "/home/juser/.tvtime/stationlist.xml"
station: No station file found, creating a new one.
I/O error : Permission denied
I/O error : Permission denied
Thank you for using tvtime.


++ v4l-info /dev/video0
ioctl VIDIOCGTUNER: Invalid argument
ioctl VIDIOCGAUDIO: Invalid argument
ioctl VIDIOCGFBUF: Invalid argument

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
	driver                  : "vivi"
	card                    : "vivi"
	bus_info                : ""
	version                 : 0.5.0
	capabilities            : 0x5000001 [VIDEO_CAPTURE,READWRITE,STREAMING]

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
	id                      : 0x100 [PAL_M]
	name                    : "PAL-M"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525
    VIDIOC_ENUMSTD(6)
	index                   : 6
	id                      : 0x800 [PAL_60]
	name                    : "PAL-60"
	frameperiod.numerator   : 1001
	frameperiod.denominator : 30000
	framelines              : 525

inputs
    VIDIOC_ENUMINPUT(0)
	index                   : 0
	name                    : "Camera"
	type                    : CAMERA
	audioset                : 0
	tuner                   : 0
	std                     : 0xf900 [PAL_M,PAL_60,NTSC_M,NTSC_M_JP,?,?]
	status                  : 0x0 []

video capture
    VIDIOC_ENUM_FMT(0,VIDEO_CAPTURE)
	index                   : 0
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "4:2:2, packed, YUYV"
	pixelformat             : 0x56595559 [YUYV]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
	type                    : VIDEO_CAPTURE
	fmt.pix.width           : 640
	fmt.pix.height          : 480
	fmt.pix.pixelformat     : 0x56595559 [YUYV]
	fmt.pix.field           : INTERLACED
	fmt.pix.bytesperline    : 1280
	fmt.pix.sizeimage       : 614400
	fmt.pix.colorspace      : unknown
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
	default_value           : 16
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
    VIDIOC_QUERYCTRL(BASE+3)
	id                      : 9963779
	type                    : INTEGER
	name                    : "Hue"
	minimum                 : -128
	maximum                 : 127
	step                    : 1
	default_value           : 0
	flags                   : 0

### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
	name                    : "vivi"
	type                    : 0x1 [CAPTURE]
	channels                : 1
	audios                  : 0
	maxwidth                : 1024
	maxheight               : 768
	minwidth                : 48
	minheight               : 32

channels
    VIDIOCGCHAN(0)
	channel                 : 0
	name                    : "Camera"
	tuners                  : 0
	flags                   : 0x0 []
	type                    : CAMERA
	norm                    : 1

tuner

audio

picture
    VIDIOCGPICT
	brightness              : 32639
	hue                     : 32896
	colour                  : 32639
	contrast                : 4112
	whiteness               : 0
	depth                   : 16
	palette                 : YUYV

buffer

window
    VIDIOCGWIN
	x                       : 0
	y                       : 0
	width                   : 640
	height                  : 480
	chromakey               : 0
	flags                   : 0




Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

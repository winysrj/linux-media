Return-path: <linux-media-owner@vger.kernel.org>
Received: from pne-smtpout1-sn2.hy.skanova.net ([81.228.8.83]:61913 "EHLO
	pne-smtpout1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbZDQT1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 15:27:30 -0400
Message-ID: <49E8D808.9070804@gmail.com>
Date: Fri, 17 Apr 2009 21:27:04 +0200
From: =?windows-1252?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Adam Baker <linux@baker-net.org.uk>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l release: 0.5.97: the whitebalance release!
References: <49E5D4DE.6090108@hhs.nl> <200904152326.59464.linux@baker-net.org.uk> <49E66787.2080301@hhs.nl> <200904162146.59742.linux@baker-net.org.uk> <49E843CB.6050306@redhat.com>
In-Reply-To: <49E843CB.6050306@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------090507030909000702000906"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090507030909000702000906
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit



Hans de Goede wrote:
> 
> 
> On 04/16/2009 10:46 PM, Adam Baker wrote:
>> On Thursday 16 Apr 2009, Hans de Goede wrote:
>>> On 04/16/2009 12:26 AM, Adam Baker wrote:
>>>> On Wednesday 15 Apr 2009, Hans de Goede wrote:
>>>>> Currently only whitebalancing is enabled and only on Pixarts (pac)
>>>>> webcams (which benefit tremendously from this). To test this with
>>>>> other
>>>>> webcams (after instaling this release) do:
>>>>>
>>>>> export LIBV4LCONTROL_CONTROLS=15
>>>>> LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp&
>>>> Strangely while those instructions give me a whitebalance control
>>>> for the
>>>> sq905 based camera I can't get it to appear for a pac207 based camera
>>>> regardless of whether LIBV4LCONTROL_CONTROLS is set.
>>> Thats weird, there is a small bug in the handling of pac207
>>> cams with usb id 093a:2476 causing libv4l to not automatically
>>> enable whitebalancing (and the control) for cams with that id,
>>> but if you have LIBV4LCONTROL_CONTROLS set (exported!) both
>>> when loading v4l2ucp (you must preload v4l2convert.so!) and
>>> when loading your viewer, then it should work.
>>>
>>
>> I've tested it by plugging in the sq905 camera, verifying the
>> whitebablance
>> control is present and working, unplugging the sq905 and plugging in the
>> pac207 and using up arrow to restart v4l2ucp and svv so I think I've
>> eliminated most finger trouble possibilities. The pac207 is id
>> 093a:2460 so
>> not the problem id. I'll have to investigate more thoroughly later.
>>
> 
> Does the pac207 perhaps have a / in its "card" string (see v4l-info
> output) ?
> if so try out this patch:
> http://linuxtv.org/hg/~hgoede/libv4l/rev/1e08d865690a
> 

I have the same issue as Adam when trying to test this with my
gspca_stv06xx based Quickcam Web camera i. e no whitebalancing
controls show up. I'm attaching a dump which logs all available
pixformats and v4l2ctrls showing that libv4l is properly loaded.
(And yes, LIBV4LCONTROL_CONTROLS is exported and set to 15).

Best regards,
Erik

> Thanks & Regards,
> 
> Hans
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--------------090507030909000702000906
Content-Type: text/plain;
 name="v4l2ctrl.dump"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l2ctrl.dump"

ioctl VIDIOCGTUNER: Invalid argument
ioctl VIDIOCGFBUF: Invalid argument
try direct access to /dev/video0
device /dev/video0 open for read
### video4linux device info [/dev/video0] ###
general info
    VIDIOCGCAP
	name                    : "Camera"
	type                    : 0x1 [CAPTURE]
	channels                : 1
	audios                  : 0
	maxwidth                : 356
	maxheight               : 292
	minwidth                : 48
	minheight               : 32

channels
    VIDIOCGCHAN(0)
	channel                 : 0
	name                    : "STV06xx"
	tuners                  : 0
	flags                   : 0x0 []
	type                    : CAMERA
	norm                    : 0

tuner

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
	contrast                : 0
	whiteness               : 0
	depth                   : 8
	palette                 : unknown

buffer

window
    VIDIOCGWIN
	x                       : 0
	y                       : 0
	width                   : 356
	height                  : 292
	chromakey               : 0
	flags                   : 0


### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
	driver                  : "STV06xx"
	card                    : "Camera"
	bus_info                : "usb-0000:00:1d.0-1"
	version                 : 2.5.0
	capabilities            : 0x5000001 [VIDEO_CAPTURE,READWRITE,STREAMING]

standards

inputs
    VIDIOC_ENUMINPUT(0)
	index                   : 0
	name                    : "STV06xx"
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
	description             : "GRBG"
	pixelformat             : 0x47425247 [GRBG]
    VIDIOC_ENUM_FMT(1,VIDEO_CAPTURE)
	index                   : 1
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "RGB3"
	pixelformat             : 0x33424752 [RGB3]
    VIDIOC_ENUM_FMT(2,VIDEO_CAPTURE)
	index                   : 2
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "BGR3"
	pixelformat             : 0x33524742 [BGR3]
    VIDIOC_ENUM_FMT(3,VIDEO_CAPTURE)
	index                   : 3
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "YU12"
	pixelformat             : 0x32315559 [YU12]
    VIDIOC_ENUM_FMT(4,VIDEO_CAPTURE)
	index                   : 4
	type                    : VIDEO_CAPTURE
	flags                   : 0
	description             : "YV12"
	pixelformat             : 0x32315659 [YV12]
    VIDIOC_G_FMT(VIDEO_CAPTURE)
	type                    : VIDEO_CAPTURE
	fmt.pix.width           : 356
	fmt.pix.height          : 292
	fmt.pix.pixelformat     : 0x47425247 [GRBG]
	fmt.pix.field           : NONE
	fmt.pix.bytesperline    : 356
	fmt.pix.sizeimage       : 103952
	fmt.pix.colorspace      : SRGB
	fmt.pix.priv            : 0

controls

    VIDIOC_QUERYCTRL (9963793)
	id                      : 9963793
	type                    : INTEGER
	name                    : "exposure"
	minimum                 : 0
	maximum                 : 32768
	step                    : 1
	default_value           : 20000
	flags                   : 0

    VIDIOC_QUERYCTRL (9963793 | V4L2_CTRL_FLAG_NEXT_CTRL)
	id                      : 9963795
	type                    : INTEGER
	name                    : "analog gain"
	minimum                 : 0
	maximum                 : 15
	step                    : 1
	default_value           : 10
	flags                   : 0

    VIDIOC_QUERYCTRL (9963795 | V4L2_CTRL_FLAG_NEXT_CTRL)
	id                      : 9963796
	type                    : BOOLEAN
	name                    : "horizontal flip"
	minimum                 : 0
	maximum                 : 1
	step                    : 1
	default_value           : 0
	flags                   : 0

    VIDIOC_QUERYCTRL (9963796 | V4L2_CTRL_FLAG_NEXT_CTRL)
	id                      : 9963797
	type                    : BOOLEAN
	name                    : "vertical flip"
	minimum                 : 0
	maximum                 : 1
	step                    : 1
	default_value           : 0
	flags                   : 0

    VIDIOC_QUERYCTRL (9963797 | V4L2_CTRL_FLAG_NEXT_CTRL)
        break

--------------090507030909000702000906--

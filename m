Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41625 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1KICyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Nov 2011 21:54:01 -0500
Received: by faan17 with SMTP id n17so1199145faa.19
        for <linux-media@vger.kernel.org>; Tue, 08 Nov 2011 18:53:59 -0800 (PST)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <201111081342.19494.laurent.pinchart@ideasonboard.com>
References: <CABcw_OkE=ANKDCVRRxgj33Mt=b3KAtGpe3RMnL3h0UMgOQ0ZdQ@mail.gmail.com>
	<201111071214.36935.laurent.pinchart@ideasonboard.com>
	<CABcw_Omoj2VkiksKEs1tV_9vB6ZVtTvUJ2GK0beY5JjFSBgd_g@mail.gmail.com>
	<201111081342.19494.laurent.pinchart@ideasonboard.com>
Date: Tue, 8 Nov 2011 20:53:58 -0600
Message-ID: <CABcw_O=Vg=r1oWJriBT4bOVcdFWjaPEbjs0nAMq74L7-vgrT3Q@mail.gmail.com>
Subject: Re: media0 not showing up on beagleboard-xm
From: Chris Whittenburg <whittenburg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Gary Thomas <gary@mlbassoc.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 8, 2011 at 6:42 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Chris,
>
> On Tuesday 08 November 2011 03:03:43 Chris Whittenburg wrote:
>> On Mon, Nov 7, 2011 at 5:14 AM, Laurent Pinchart wrote:
>> > On Monday 07 November 2011 12:08:15 Gary Thomas wrote:
>> >> On 2011-11-06 15:26, Chris Whittenburg wrote:
>> >> > On Fri, Nov 4, 2011 at 6:49 AM, Laurent Pinchart wrote:
>> >> >> On Tuesday 25 October 2011 04:48:13 Chris Whittenburg wrote:
>> >> >>> I'm using oe-core to build the 3.0.7+ kernel, which runs fine on my
>> >> >>> beagleboard-xm.
>> >> >>
>> >> >> You will need board code to register the OMAP3 ISP platform device
>> >> >> that will then be picked by the OMAP3 ISP driver. Example of such
>> >> >> board code can be found at
>> >> >>
>> >> >> http://git.linuxtv.org/pinchartl/media.git/commit/37f505296ccd3fb055e
>> >> >> 03b 2ab15ccf6ad4befb8d
>> >> >
>> >> > I followed your example to add the MT9P031 support, and now I get
>> >> > /dev/media0 and /dev/video0 to 7.
>> >> >
>> >> > I don't have the actual sensor hooked up yet.
>> >> >
>> >> > If I try "media-ctl -p", I see lots of "Failed to open subdev device
>> >> > node" msgs.
>> >> > http://pastebin.com/F1TC9A1n
>> >> >
>> >> > This is with the media-ctl utility from:
>> >> > http://feeds.angstrom-distribution.org/feeds/core/ipk/eglibc/armv7a/ba
>> >> > se/ media-ctl_0.0.1-r0_armv7a.ipk
>> >> >
>> >> > I also tried with the latest from your media-ctl repository, but got
>> >> > the same msgs.
>> >> >
>> >> > Is this an issue with my 3.0.8 kernel not being compatible with
>> >> > current media-ctl utility?  Is there some older commit that I should
>> >> > build from?  Or maybe it is just a side effect of the sensor not being
>> >> > connected yet.
>> >>
>> >> Does your kernel config enable CONFIG_VIDEO_V4L2_SUBDEV_API?
>>
>> Yes, it is enabled...  Here is a snippet of my config:
>>
>> #
>> # Multimedia core support
>> #
>> CONFIG_MEDIA_CONTROLLER=y
>> CONFIG_VIDEO_DEV=y
>> CONFIG_VIDEO_V4L2_COMMON=y
>> CONFIG_VIDEO_V4L2_SUBDEV_API=y
>> CONFIG_DVB_CORE=m
>> CONFIG_VIDEO_MEDIA=m
>>
>> > And does your system run udev, or have you created the device nodes
>> > manually ?
>>
>> It runs udev-173... I didn't create the nodes manually.
>>
>> I also have the /dev/v4l-subdev0 to 7 entries, as expected.
>>
>> Anything else I should check?
>
> Could you please send me the output of the following commands ?
>
> ls -l /dev/v4l-subdev*
> ls -l /sys/dev/char/
>
> And, optionally,
>
> strace ./media-ctl -p

Hi Laurent,

Your last questions helped me find that sysfs wasn't mounted.  I think
this is because meta-Angstrom was using systemd, and I changed it to
sysvinit, but must have missed something.

With sysfs mounted, I get the following media-ctl -p output... Does
this look as expected?  (The sensor still isn't connected-- it should
come in today, so ignore the "Failed to reset the camera" errors.

root@beagleboard:~# media-ctl -p
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev0
	pad0: Input [SGRBG10 4096x4096]
		<- 'OMAP3 ISP CCP2 input':pad0 []
	pad1: Output [SGRBG10 4096x4096]
		-> 'OMAP3 ISP CCDC':pad0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video0
	pad0: Output
		-> 'OMAP3 ISP CCP2':pad0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev1
	pad0: Input [SGRBG10 4096x4096]
	pad1: Output [SGRBG10 4096x4096]
		-> 'OMAP3 ISP CSI2a output':pad0 []
		-> 'OMAP3 ISP CCDC':pad0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video1
	pad0: Input
		<- 'OMAP3 ISP CSI2a':pad1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev2
	pad0: Input [SGRBG10 4096x4096]
		<- 'OMAP3 ISP CCP2':pad1 []
		<- 'OMAP3 ISP CSI2a':pad1 []
		<- 'mt9p031 2-0048':pad0 []
	pad1: Output [SGRBG10 4096x4096]
		-> 'OMAP3 ISP CCDC output':pad0 []
		-> 'OMAP3 ISP resizer':pad0 []
	pad2: Output [SGRBG10 4096x4095]
		-> 'OMAP3 ISP preview':pad0 []
		-> 'OMAP3 ISP AEWB':pad0 [IMMUTABLE,ACTIVE]
		-> 'OMAP3 ISP AF':pad0 [IMMUTABLE,ACTIVE]
		-> 'OMAP3 ISP histogram':pad0 [IMMUTABLE,ACTIVE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video2
	pad0: Input
		<- 'OMAP3 ISP CCDC':pad1 []

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev3
	pad0: Input [SGRBG10 4096x4096]
		<- 'OMAP3 ISP CCDC':pad2 []
		<- 'OMAP3 ISP preview input':pad0 []
	pad1: Output [YUYV 4082x4088]
		-> 'OMAP3 ISP preview output':pad0 []
		-> 'OMAP3 ISP resizer':pad0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video3
	pad0: Output
		-> 'OMAP3 ISP preview':pad0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video4
	pad0: Input
		<- 'OMAP3 ISP preview':pad1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev4
	pad0: Input [YUYV 4095x4095 (4,6)/4086x4082]
		<- 'OMAP3 ISP CCDC':pad1 []
		<- 'OMAP3 ISP preview':pad1 []
		<- 'OMAP3 ISP resizer input':pad0 []
	pad1: Output [YUYV 4096x4095]
		-> 'OMAP3 ISP resizer output':pad0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video5
	pad0: Output
		-> 'OMAP3 ISP resizer':pad0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video6
	pad0: Input
		<- 'OMAP3 ISP resizer':pad1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev5
	pad0: Input
		<- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev6
	pad0: Input
		<- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev7
	pad0: Input
		<- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 16: mt9p031 2-0048 (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev8
	pad0: Output v4l2_subdev_open: Failed to open subdev device node
/dev/v4l-subdev8

		-> 'OMAP3 ISP CCDC':pad0 []

Thanks.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40328 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422744Ab3BGWj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 17:39:59 -0500
Received: by mail-wi0-f169.google.com with SMTP id l13so236663wie.2
        for <linux-media@vger.kernel.org>; Thu, 07 Feb 2013 14:39:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302060832.46736.hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
	<CA+6av4nj+Gvt2ivVm6YdaMtqF44n7JA3ZSK55CeefonFuaMjTQ@mail.gmail.com>
	<201302051941.31207.hverkuil@xs4all.nl>
	<201302060832.46736.hverkuil@xs4all.nl>
Date: Thu, 7 Feb 2013 23:39:58 +0100
Message-ID: <CA+6av4nWfjBh4jzWRoz9Hvj=QhL5V1CzDb=kKRiANtGCp0Ff1Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
From: Arvydas Sidorenko <asido4@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 6, 2013 at 8:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> I've improved v4l2-compliance a bit, but I've also pushed a fix (I hope) to
> my git branch.
>
> It's great if you can test this!
>

$ v4l2-compliance -d /dev/video0
Driver Info:
	Driver name   : stk
	Card type     : stk
	Bus info      : usb-0000:00:1d.7-8
	Driver version: 3.1.0
	Capabilities  : 0x85000001
		Video Capture
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05000001
		Video Capture
		Read/Write
		Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 4 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
		warn: v4l2-test-formats.cpp(565): TRY_FMT cannot handle an invalid
pixelformat. This may or may not be a problem.
See http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
for more information.
	test VIDIOC_TRY_FMT: OK
		warn: v4l2-test-formats.cpp(723): S_FMT cannot handle an invalid
pixelformat. This may or may not be a problem.
See http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
for more information.
		warn: v4l2-test-formats.cpp(658): Could not set fmt1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		fail: v4l2-test-buffers.cpp(166): doioctl(node->node2, VIDIOC_REQBUFS, &bufs)
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL

Total: 38, Succeeded: 37, Failed: 1, Warnings: 3


On top of that it generates some dmesg output:
[   70.514849] stkwebcam 5-8:1.0: =================  START STATUS
=================
[   70.514856] stkwebcam 5-8:1.0: Brightness: 96
[   70.514860] stkwebcam 5-8:1.0: Horizontal Flip: true
[   70.514863] stkwebcam 5-8:1.0: Vertical Flip: true
[   70.514866] stkwebcam 5-8:1.0: ==================  END STATUS
==================
[   70.596727] stkwebcam: OmniVision sensor detected, id 9652 at address 60
[   70.859490] stkwebcam: isobufs already allocated. Bad
[   70.859977] stkwebcam: isobuf data already allocated
[   70.860502] stkwebcam: Killing URB
[   70.860990] stkwebcam: isobuf data already allocated
[   70.861478] stkwebcam: Killing URB
[   70.862088] stkwebcam: isobuf data already allocated
[   70.862834] stkwebcam: Killing URB
[   70.863594] stkwebcam: sio_bufs already allocated
[   70.864319] stkwebcam: isobufs already allocated. Bad
[   70.865057] stkwebcam: isobuf data already allocated
[   70.865752] stkwebcam: Killing URB
[   70.866490] stkwebcam: isobuf data already allocated
[   70.867275] stkwebcam: Killing URB
[   70.867980] stkwebcam: isobuf data already allocated
[   70.868721] stkwebcam: Killing URB
[   70.869464] stkwebcam: sio_bufs already allocated
[   70.870244] stkwebcam: isobufs already allocated. Bad
[   70.870968] stkwebcam: isobuf data already allocated
[   70.871704] stkwebcam: Killing URB
[   70.872440] stkwebcam: isobuf data already allocated
[   70.873181] stkwebcam: Killing URB
[   70.873936] stkwebcam: isobuf data already allocated
[   70.874671] stkwebcam: Killing URB
[   70.875414] stkwebcam: sio_bufs already allocated


The view is still upside down, but it is also the same using version
before you patches.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:39925 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab3BILWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 06:22:14 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so3488120wgb.33
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2013 03:22:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302081020.49754.hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
	<201302060832.46736.hverkuil@xs4all.nl>
	<CA+6av4nWfjBh4jzWRoz9Hvj=QhL5V1CzDb=kKRiANtGCp0Ff1Q@mail.gmail.com>
	<201302081020.49754.hverkuil@xs4all.nl>
Date: Sat, 9 Feb 2013 12:22:12 +0100
Message-ID: <CA+6av4m5OoVB6aXxfi5GFX6uAY7MJnSgiRG22Navag1t3h8z9A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
From: Arvydas Sidorenko <asido4@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 8, 2013 at 10:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Thanks for the testing! I've pushed some more improvements to my git branch.
> Hopefully the compliance tests are now running OK. Please check the dmesg
> output as well.
>
> In addition I've added an 'upside down' message to the kernel log that tells
> me whether the driver is aware that your sensor is upside down or not.
>
> Which laptop do you have? Asus G1?
>
> Regards,
>
>         Hans

Now it looks better, but clearly there is an issue with the upside down thing.
I have ASUS F3Jc laptop.

Although a commit '6f89814d3d' introduced a problem.
> if (rb->count == 0)
>     dev->owner = NULL;
Now 'v4l_stk_release' doesn't release the resources because 'dev->owner != fp'.

$ dmesg | grep upside
[    4.933507] upside down: 0

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
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		warn: v4l2-test-buffers.cpp(175): VIDIOC_CREATE_BUFS not supported
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK

Total: 38, Succeeded: 38, Failed: 0, Warnings: 3


Arvydas

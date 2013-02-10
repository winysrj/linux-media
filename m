Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2127 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3BJI2s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 03:28:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Sun, 10 Feb 2013 09:28:35 +0100
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl> <201302081020.49754.hverkuil@xs4all.nl> <CA+6av4m5OoVB6aXxfi5GFX6uAY7MJnSgiRG22Navag1t3h8z9A@mail.gmail.com>
In-Reply-To: <CA+6av4m5OoVB6aXxfi5GFX6uAY7MJnSgiRG22Navag1t3h8z9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302100928.35795.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat February 9 2013 12:22:12 Arvydas Sidorenko wrote:
> On Fri, Feb 8, 2013 at 10:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > Thanks for the testing! I've pushed some more improvements to my git branch.
> > Hopefully the compliance tests are now running OK. Please check the dmesg
> > output as well.
> >
> > In addition I've added an 'upside down' message to the kernel log that tells
> > me whether the driver is aware that your sensor is upside down or not.
> >
> > Which laptop do you have? Asus G1?
> >
> > Regards,
> >
> >         Hans
> 
> Now it looks better, but clearly there is an issue with the upside down thing.
> I have ASUS F3Jc laptop.
> 
> Although a commit '6f89814d3d' introduced a problem.
> > if (rb->count == 0)
> >     dev->owner = NULL;
> Now 'v4l_stk_release' doesn't release the resources because 'dev->owner != fp'.

Fixed.

> 
> $ dmesg | grep upside
> [    4.933507] upside down: 0

I've improved this message, so please run again with the latest code and let me
know what it says. I don't understand all the upside-down problems...

Regards,

	Hans

> 
> $ v4l2-compliance -d /dev/video0
> Driver Info:
> 	Driver name   : stk
> 	Card type     : stk
> 	Bus info      : usb-0000:00:1d.7-8
> 	Driver version: 3.1.0
> 	Capabilities  : 0x85000001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 		Device Capabilities
> 	Device Caps   : 0x05000001
> 		Video Capture
> 		Read/Write
> 		Streaming
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> 	test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
> 	test VIDIOC_QUERYCTRL/MENU: OK
> 	test VIDIOC_G/S_CTRL: OK
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> 	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 	Standard Controls: 4 Private Controls: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 
> Format ioctls:
> 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 	test VIDIOC_G/S_PARM: OK
> 	test VIDIOC_G_FBUF: OK (Not Supported)
> 	test VIDIOC_G_FMT: OK
> 		warn: v4l2-test-formats.cpp(565): TRY_FMT cannot handle an invalid
> pixelformat. This may or may not be a problem.
> See http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
> for more information.
> 	test VIDIOC_TRY_FMT: OK
> 		warn: v4l2-test-formats.cpp(723): S_FMT cannot handle an invalid
> pixelformat. This may or may not be a problem.
> See http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
> for more information.
> 	test VIDIOC_S_FMT: OK
> 	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
> Codec ioctls:
> 	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
> 		warn: v4l2-test-buffers.cpp(175): VIDIOC_CREATE_BUFS not supported
> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 
> Total: 38, Succeeded: 38, Failed: 0, Warnings: 3
> 
> 
> Arvydas
> 

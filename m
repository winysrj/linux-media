Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1838 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaBLQNu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 11:13:50 -0500
Message-ID: <52FB9CE3.9010409@xs4all.nl>
Date: Wed, 12 Feb 2014 17:10:11 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Dean Anderson <linux-dev@sensoray.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] s2255drv: upgrade to videobuf2
References: <1392159384-30088-1-git-send-email-linux-dev@sensoray.com> <cd5a631056e9d46cea6f70e6231c0c33@sensoray.com> <52FAAD23.2010606@xs4all.nl> <3b3175b374d23eafaf8ea226e9312d68@sensoray.com>
In-Reply-To: <3b3175b374d23eafaf8ea226e9312d68@sensoray.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/12/14 17:01, Dean Anderson wrote:
> "./utils/v4l2-compliance/v4l2-compliance -s"
> 
> Driver Info:
>     Driver name   : s2255
>     Card type     : s2255
>     Bus info      : usb-0000:00:1a.7-3.6
>     Driver version: 3.13.0
>     Capabilities  : 0x84000001
>         Video Capture
>         Streaming
>         Device Capabilities
>     Device Caps   : 0x04000001
>         Video Capture
>         Streaming
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
>     test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>     test second video open: OK
>     test VIDIOC_QUERYCAP: OK
>     test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>     test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>     test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>     test VIDIOC_G/S_TUNER: OK (Not Supported)
>     test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>     test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>     test VIDIOC_ENUMAUDIO: OK (Not Supported)
>     test VIDIOC_G/S/ENUMINPUT: OK
>     test VIDIOC_G/S_AUDIO: OK (Not Supported)
>     Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>     test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>     test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>     test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>     test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>     test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>     Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
>     test VIDIOC_QUERYCTRL/MENU: OK
>     test VIDIOC_G/S_CTRL: OK
>     test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>     test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>         warn: v4l2-test-controls.cpp(753): The VIDIOC_G_JPEGCOMP ioctl is deprecated!
>         warn: v4l2-test-controls.cpp(770): The VIDIOC_S_JPEGCOMP ioctl is deprecated!
>     test VIDIOC_G/S_JPEGCOMP: OK
>     Standard Controls: 7 Private Controls: 1
> 
> Input/Output configuration ioctls:
>     test VIDIOC_ENUM/G/S/QUERY_STD: OK
>     test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>     test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 
> Format ioctls:
>     test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>     test VIDIOC_G/S_PARM: OK
>     test VIDIOC_G_FBUF: OK (Not Supported)
>     test VIDIOC_G_FMT: OK
>         warn: v4l2-test-formats.cpp(599): TRY_FMT cannot handle an invalid pixelformat.
>         warn: v4l2-test-formats.cpp(600): This may or may not be a problem. For more information see:
>         warn: v4l2-test-formats.cpp(601): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>     test VIDIOC_TRY_FMT: OK
>         warn: v4l2-test-formats.cpp(786): S_FMT cannot handle an invalid pixelformat.
>         warn: v4l2-test-formats.cpp(787): This may or may not be a problem. For more information see:
>         warn: v4l2-test-formats.cpp(788): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>     test VIDIOC_S_FMT: OK
>     test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 
> Codec ioctls:
>     test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>     test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>     test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         warn: v4l2-test-buffers.cpp(343): VIDIOC_CREATE_BUFS not supported
>     test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>         fail: v4l2-test-buffers.cpp(379): ret < 0 && errno != EINVAL

You added read() support, but did not add V4L2_CAP_READWRITE to querycap.

The following errors are a knock-on effect of that since the driver
is still in read() mode so attempts to call REQBUFS will fail.

I should see if I can improve that in v4l2-compliance.

Regards,

	Hans

>     test read/write: FAIL
>         fail: v4l2-test-buffers.cpp(537): can_stream
>     test MMAP: FAIL
>         fail: v4l2-test-buffers.cpp(641): can_stream
>     test USERPTR: FAIL
> 
> Total: 39, Succeeded: 36, Failed: 3, Warnings: 9


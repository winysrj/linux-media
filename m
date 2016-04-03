Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33458 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbcDCRr6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2016 13:47:58 -0400
Subject: Re: [PATCH RFC v2 0/2] pxa_camera transition to v4l2 standalone
 device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57015743.3080003@xs4all.nl>
Date: Sun, 3 Apr 2016 10:47:47 -0700
MIME-Version: 1.0
In-Reply-To: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

Thanks for the patches!

On 04/02/2016 07:26 AM, Robert Jarzmik wrote:
> Hi Hans and Guennadi,
>
> This is the second opus of this RFC. The goal is still to see how close our
> ports are to see if there are things we could either reuse of change.
>
>  From RFCv1, the main change is cleaning up in function names and functions
> grouping, and fixes to make v4l2-compliance happy while live tests still show no
> regression.
>
> For the next steps, I'll have to :
>   - split the second patch, which will be a headache task, into :
>     - first functions grouping and renaming
>       => this to ensure the "internal functions" are almost untouched
>     - the the port itself
>
> I'm leaving soc_mediabus for now, that's another task.
>
> I'm not seeing a big review traction, especially on the vb2 conversion, so I'll
> leave this patchset in RFC form until vb2 patch is reviewed and merged, and then
> will come back to this work.

It's been a very busy time for me, and both Guennadi and myself are attending the
ELC the coming week. Speaking for myself that means that it is unlikely I'll have
time to review anything for the next two weeks.

My own renesas driver conversion work is just as slow for the same reasons. I hope
and expect that that situation will improve during April.

Being able to ditch soc-camera is a fairly high-prio thing for me, but I just don't
have much time right now.

Regarding the compliance test: it looks good to me, except for this one:

> Streaming ioctls:
> test read/write: OK (Not Supported)

With vb2 this is easy to support by just using vb2_fop_read as the read function and
setting the VB2_READ flag in the io_modes. It's free, so I see no reason not to use it.

Can you also test with 'v4l2-compliance -f'? This tests all format variations.

Regards,

	Hans

>
> For information, here is the result of v4l2-compliance -s.
>
> Driver Info:
> 	Driver name   : pxa27x-camera
> 	Card type     : PXA_Camera
> 	Bus info      : platform:pxa-camera
> 	Driver version: 4.6.0
> 	Capabilities  : 0x84200001
> 		Video Capture
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps   : 0x04200001
> 		Video Capture
> 		Streaming
> 		Extended Pix Format
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
> 	test VIDIOC_DBG_G/S_REGISTER: OK
> 	test VIDIOC_LOG_STATUS: OK (Not Supported)
>
> Input ioctls:
> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
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
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 	test VIDIOC_G/S_EDID: OK (Not Supported)
>
> Test input 0:
>
> 	Control ioctls:
> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
> 		test VIDIOC_QUERYCTRL: OK (Not Supported)
> 		test VIDIOC_G/S_CTRL: OK (Not Supported)
> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 		Standard Controls: 0 Private Controls: 0
>
> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		test VIDIOC_G/S_PARM: OK (Not Supported)
> 		test VIDIOC_G_FBUF: OK (Not Supported)
> 		test VIDIOC_G_FMT: OK
> 		warn: v4l2-test-formats.cpp(713): TRY_FMT cannot handle an invalid pixelformat.
> 		warn: v4l2-test-formats.cpp(714): This may or may not be a problem. For more information see:
> 		warn: v4l2-test-formats.cpp(715): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
> 		test VIDIOC_TRY_FMT: OK
> 		warn: v4l2-test-formats.cpp(933): S_FMT cannot handle an invalid pixelformat.
> 		warn: v4l2-test-formats.cpp(934): This may or may not be a problem. For more information see:
> 		warn: v4l2-test-formats.cpp(935): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
> 		test VIDIOC_S_FMT: OK
> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 		test Cropping: OK (Not Supported)
> 		test Composing: OK (Not Supported)
> 		test Scaling: OK
>
> 	Codec ioctls:
> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>
> 	Buffer ioctls:
> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 		test VIDIOC_EXPBUF: OK
>
> Test input 0:
>
> Streaming ioctls:
> 	test read/write: OK (Not Supported)
> 	test MMAP: OK
> 	test USERPTR: OK
> 	test DMABUF: Cannot test, specify --expbuf-device
>
> Total: 45, Succeeded: 45, Failed: 0, Warnings: 6
>
> Robert Jarzmik (2):
>    media: platform: transfer format translations to soc_mediabus
>    media: platform: pxa_camera: make a standalone v4l2 device
>
>   drivers/media/platform/soc_camera/pxa_camera.c   | 1086 ++++++++++++----------
>   drivers/media/platform/soc_camera/soc_camera.c   |    7 +-
>   drivers/media/platform/soc_camera/soc_mediabus.c |   65 ++
>   include/linux/platform_data/media/camera-pxa.h   |    2 +
>   include/media/drv-intf/soc_mediabus.h            |   22 +
>   include/media/soc_camera.h                       |   15 -
>   6 files changed, 708 insertions(+), 489 deletions(-)
>

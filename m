Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41126 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243AbcCUWhb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 18:37:31 -0400
Subject: Re: [PATCH RFC 0/2] pxa_camera transition to v4l2 standalone device
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
 <56EFAD47.8010403@xs4all.nl> <87lh5bmpro.fsf@belgarion.home>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F077A4.1090808@xs4all.nl>
Date: Mon, 21 Mar 2016 23:37:24 +0100
MIME-Version: 1.0
In-Reply-To: <87lh5bmpro.fsf@belgarion.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2016 11:26 PM, Robert Jarzmik wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> On 03/19/2016 10:01 PM, Robert Jarzmik wrote:
>>> Hi Hans and Guennadi,
>>>
>>> As Hans is converting sh_mobile_ceu_camera.c,
>>
>> That's not going as fast as I hoped. This driver is quite complex and extracting
>> it from soc-camera isn't easy. I also can't spend as much time as I'd like on this.
>>
>>> let's see how close our ports are
>>> to see if there are things we could either reuse of change.
>>>
>>> The port is assuming :
>>>  - the formation translation is transferred into soc_mediabus, so that it can be
>>>    reused across all v4l2 devices
>>
>> At best this will be a temporary helper source. I never liked soc_mediabus, I don't
>> believe it is the right approach.
> As long as you provide a better approach, especially for the dynamic formats
> translation, it should be fine.
> 
>> But I have no problem if it is used for now to simplify the soc-camera
>> dependency removal.
> Ok.
> 
>>>  - pxa_camera is ported
>>>
>>> This sets a ground of discussion for soc_camera adherence removal from
>>> pxa_camera. I'd like to have a comment from Hans if this is what he has in mind,
>>> and Guennadi if he agrees to transfer the soc xlate stuff to soc_mediabus.
>>
>> Can you provide the output of 'v4l2-compliance -s' with your new pxa driver?
>> I would be curious to see the result of that.
> Of course, with [1] added (initial format init and querycap strings), I have
> the following results. I have no idea where VIDIOC_EXPBUF failure comes from,
> while the colorspace issues are a consequence from the MT9M111 sensor which
> provides the couple ("VYUY", V4L2_COLORSPACE_JPEG) format (which I also don't
> understand why it is a failure) :
> 
> Driver Info:
> 	Driver name   : pxa27x-camera
> 	Card type     : PXA_Camera
> 	Bus info      : platform:pxa-camera
> 	Driver version: 4.5.0
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
> 		fail: v4l2-test-input-output.cpp(418): G_INPUT not supported for a capture device

ENUM/G/S_INPUT is missing and is required for capture devices.

> 	test VIDIOC_G/S/ENUMINPUT: FAIL
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 0 Audio Inputs: 0 Tuners: 0
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
> 		fail: v4l2-test-formats.cpp(329): pixelformat != V4L2_PIX_FMT_JPEG && colorspace == V4L2_COLORSPACE_JPEG
> 		fail: v4l2-test-formats.cpp(432): testColorspace(pix.pixelformat, pix.colorspace, pix.ycbcr_enc, pix.quantization)

The sensor should almost certainly use COLORSPACE_SRGB. Certainly not COLORSPACE_JPEG.

> 		test VIDIOC_G_FMT: FAIL
> 		test VIDIOC_TRY_FMT: OK (Not Supported)
> 		test VIDIOC_S_FMT: OK (Not Supported)
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
> 		fail: v4l2-test-buffers.cpp(571): q.has_expbuf(node)

You are missing .vidioc_expbuf = vbs_ioctl_expbuf and the vb2 io_mode VB2_DMABUF.

> 		test VIDIOC_EXPBUF: FAIL
> 
> Test input 0:
> 
> Streaming ioctls:
> 	test read/write: OK (Not Supported)
> 	test MMAP: OK (Not Supported)
> 	test USERPTR: OK (Not Supported)
> 	test DMABUF: OK (Not Supported)
> 
> 
> Total: 46, Succeeded: 43, Failed: 3, Warnings: 0
> 

Regards,

	Hans

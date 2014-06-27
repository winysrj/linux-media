Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4687 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaF0JOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 05:14:49 -0400
Message-ID: <53AD35EE.2090604@xs4all.nl>
Date: Fri, 27 Jun 2014 11:14:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 00/30] Initial CODA960 (i.MX6 VPU) support
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>	 <539EAC3E.3040102@xs4all.nl> <1403622429.2910.29.camel@paszta.hi.pengutronix.de>
In-Reply-To: <1403622429.2910.29.camel@paszta.hi.pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/24/2014 05:07 PM, Philipp Zabel wrote:
> Hi Hans,
>
> Am Montag, den 16.06.2014, 10:35 +0200 schrieb Hans Verkuil:
>> Hi Philipp,
>>
>> I went through this patch series and replied with some comments.
>
> thank you for the comments. I have dropped the force IDR patch in
> v2 and will send a separate RFC for the VFU / forced keyframe
> support.
> I have also dropped the enum_framesizes patch for now.
>
>> I have two more general questions:
>>
>> 1) can you post the output of 'v4l2-compliance'?
>
> This is for the v2 series, the previously posted patches still had
> one TRY_FMT(G_FMT) != G_FMT error introduced by the "[media] coda:
> add bytesperline to queue data" patch:
>
> $ v4l2-compliance -d /dev/video8
> Driver Info:
> 	Driver name   : coda
> 	Card type     : CODA960
> 	Bus info      : platform:coda
> 	Driver version: 3.16.0
> 	Capabilities  : 0x84008003
> 		Video Capture
> 		Video Output
> 		Video Memory-to-Memory

This is wrong, m2m devices should only set the VIDEO_M2M capability, it shouldn't be combined with
CAPTURE and OUTPUT.

> 		Streaming
> 		Device Capabilities
> 	Device Caps   : 0x04008003
> 		Video Capture
> 		Video Output
> 		Video Memory-to-Memory
> 		Streaming
>
> Compliance test for device /dev/video8 (not using libv4l2):
>
> Required ioctls:
> 		warn: v4l2-compliance.cpp(366): VIDIOC_QUERYCAP: m2m with video input and output caps

This should be an error, not a warning. I'll update that in v4l2-compliance.

In the very beginning when m2m devices were introduced they were marked as capture+output
devices, but some applications scan video devices for those that have the CAPTURE cap set
(quite reasonable), and they would also match such m2m devices. Quite soon we realized
that this was a problem and we introduced the m2m cap.

> 	test VIDIOC_QUERYCAP: OK
>
> Allow for multiple opens:
> 	test second video open: OK
> 		warn: v4l2-compliance.cpp(366): VIDIOC_QUERYCAP: m2m with video input and output caps
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
>
> Debug ioctls:
> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> 	test VIDIOC_LOG_STATUS: OK (Not Supported)
>
> Input ioctls:
> 	test VIDIOC_G/S_TUNER: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
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
> 		test VIDIOC_QUERYCTRL/MENU: OK
> 		test VIDIOC_G/S_CTRL: OK
> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 		Standard Controls: 19 Private Controls: 0
>
> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		test VIDIOC_G/S_PARM: OK (Not Supported)
> 		test VIDIOC_G_FBUF: OK (Not Supported)
> 		test VIDIOC_G_FMT: OK
> 		test VIDIOC_TRY_FMT: OK
> 		test VIDIOC_S_FMT: OK
> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>
> 	Codec ioctls:
> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 		test VIDIOC_(TRY_)DECODER_CMD: OK
>
> Buffer ioctls:
> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 	test VIDIOC_EXPBUF: OK
>
> Total: 38, Succeeded: 38, Failed: 0, Warnings: 2
>
>> 2) what would be needed for 'v4l2-compliance -s' to work?
>
> I haven't looked at this in detail yet. v4l2-compliance -s curently fails:
>
> Buffer ioctls:
> 		info: test buftype Video Capture
> 		info: test buftype Video Output
> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 	test VIDIOC_EXPBUF: OK
> 	test read/write: OK (Not Supported)
> 		fail: v4l2-test-buffers.cpp(859): ret != EINVAL

This test tries to create a buffer with a sizeimage that is only half of
what the current format is. It expects an error based on the assumption
that this driver cannot change format mid-stream. If this is the case
for your driver, then you need to put a sanity check in queue_setup, if
this is allowed for your driver, then try commenting out this check.

> 	test MMAP: FAIL
> 		fail: v4l2-test-buffers.cpp(936): buf.qbuf(q)
> 		fail: v4l2-test-buffers.cpp(976): setupUserPtr(node, q)
> 	test USERPTR: FAIL

This is a real bug: you added VB2_USERPTR to the io_modes field of the
vb2 queues, but you are using videobuf2-dma-contig.h, which make userptr
support impossible since that requires scatter-gather DMA. Just drop the
VB2_USERPTR from io_modes.

> 	test DMABUF: Cannot test, specify --expbuf-device
>
> In principle the h.264 encoder should work, as you can just feed it
> one frame at a time and then pick up the encoded result on the capture
> side.
>
>> For the encoder 'v4l2-compliance -s' will probably work OK, but for
>> the decoder you need to feed v4l2-compliance -s some compressed
>> stream. I assume each buffer should contain a single P/B/I frame?
>
> Yes, for h.264 we currently expect all NAL units for a complete frame
> in the source buffers.
>
>> The v4l2-ctl utility has already support for writing captured data
>> to a file, but it has no support to store the image sizes as well.
>> So if the captured buffers do not all have the same size you cannot
>> 'index' the captured file. If I would add support for that, then I
>> can add support for it to v4l2-compliance as well, allowing you to
>> playback an earlier captured compressed video stream and use that
>> as the compliance test input.
>>
>> Does this makes sense?
>
> Wouldn't that mean that you had to add a stream parser for every
> supported compressed format? Or are you planning to store an index
> separately?

Most likely I would store a separate index file.

Regards,

	Hans

Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49927 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaFXPHV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 11:07:21 -0400
Message-ID: <1403622429.2910.29.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 00/30] Initial CODA960 (i.MX6 VPU) support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Date: Tue, 24 Jun 2014 17:07:09 +0200
In-Reply-To: <539EAC3E.3040102@xs4all.nl>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
	 <539EAC3E.3040102@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Am Montag, den 16.06.2014, 10:35 +0200 schrieb Hans Verkuil:
> Hi Philipp,
> 
> I went through this patch series and replied with some comments.

thank you for the comments. I have dropped the force IDR patch in
v2 and will send a separate RFC for the VFU / forced keyframe
support.
I have also dropped the enum_framesizes patch for now.

> I have two more general questions:
> 
> 1) can you post the output of 'v4l2-compliance'?

This is for the v2 series, the previously posted patches still had
one TRY_FMT(G_FMT) != G_FMT error introduced by the "[media] coda:
add bytesperline to queue data" patch:

$ v4l2-compliance -d /dev/video8
Driver Info:
	Driver name   : coda
	Card type     : CODA960
	Bus info      : platform:coda
	Driver version: 3.16.0
	Capabilities  : 0x84008003
		Video Capture
		Video Output
		Video Memory-to-Memory
		Streaming
		Device Capabilities
	Device Caps   : 0x04008003
		Video Capture
		Video Output
		Video Memory-to-Memory
		Streaming

Compliance test for device /dev/video8 (not using libv4l2):

Required ioctls:
		warn: v4l2-compliance.cpp(366): VIDIOC_QUERYCAP: m2m with video input and output caps
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
		warn: v4l2-compliance.cpp(366): VIDIOC_QUERYCAP: m2m with video input and output caps
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

	Control ioctls:
		test VIDIOC_QUERYCTRL/MENU: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 19 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Total: 38, Succeeded: 38, Failed: 0, Warnings: 2

> 2) what would be needed for 'v4l2-compliance -s' to work?

I haven't looked at this in detail yet. v4l2-compliance -s curently fails:

Buffer ioctls:
		info: test buftype Video Capture
		info: test buftype Video Output
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK
	test read/write: OK (Not Supported)
		fail: v4l2-test-buffers.cpp(859): ret != EINVAL
	test MMAP: FAIL
		fail: v4l2-test-buffers.cpp(936): buf.qbuf(q)
		fail: v4l2-test-buffers.cpp(976): setupUserPtr(node, q)
	test USERPTR: FAIL
	test DMABUF: Cannot test, specify --expbuf-device

In principle the h.264 encoder should work, as you can just feed it
one frame at a time and then pick up the encoded result on the capture
side.

> For the encoder 'v4l2-compliance -s' will probably work OK, but for
> the decoder you need to feed v4l2-compliance -s some compressed
> stream. I assume each buffer should contain a single P/B/I frame?

Yes, for h.264 we currently expect all NAL units for a complete frame
in the source buffers.

> The v4l2-ctl utility has already support for writing captured data
> to a file, but it has no support to store the image sizes as well.
> So if the captured buffers do not all have the same size you cannot
> 'index' the captured file. If I would add support for that, then I
> can add support for it to v4l2-compliance as well, allowing you to
> playback an earlier captured compressed video stream and use that
> as the compliance test input.
> 
> Does this makes sense?

Wouldn't that mean that you had to add a stream parser for every
supported compressed format? Or are you planning to store an index
separately?

regards
Philipp


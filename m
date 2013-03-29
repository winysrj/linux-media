Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35587 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab3C2UJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 16:09:55 -0400
Date: Fri, 29 Mar 2013 21:10:01 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] fsl-viu: v4l2 compliance fixes
Message-ID: <20130329211001.3fde9c29@crub>
In-Reply-To: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
References: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, 16 Feb 2013 11:18:22 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> This patch series converts fsl-viu to the control framework and provides
> some additional v4l2 compliance fixes.
> 
> Anatolij, are you able to test this?

Sorry for long delay, finally managed to set up the board with recent kernel
to test the fsl-viu driver patches.

> Ideally I'd like to see the output of the v4l2-compliance tool (found in
> the http://git.linuxtv.org/v4l-utils.git repository). I know that there are
> remaining issues, especially with the fact that there can be one user at a
> time only (very bad!) and some overlay issues. I can try to fix those, but
> I need someone to test otherwise I won't bother.

Below is the output of the v4l2-compliance:

# v4l2-compliance -v -d 0
Driver Info:
	Driver name   : viu
	Card type     : viu
	Bus info      : platform:viu
	Driver version: 3.9.0
	Capabilities  : 0x85000005
		Video Capture
		Video Overlay
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05000005
		Video Capture
		Video Overlay
		Read/Write
		Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: FAIL

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(415): could set input to invalid input 1
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
		info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
		info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
		info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
		info: checking v4l2_queryctrl of control 'Chroma AGC' (0x0098091d)
		info: checking v4l2_queryctrl of control 'Chroma Gain' (0x00980924)
		info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
		info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
		info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
		info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
		info: checking v4l2_queryctrl of control 'Chroma AGC' (0x0098091d)
		info: checking v4l2_queryctrl of control 'Chroma Gain' (0x00980924)
	test VIDIOC_QUERYCTRL/MENU: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Brightness' (0x00980900)
		info: checking control 'Contrast' (0x00980901)
		info: checking control 'Saturation' (0x00980902)
		info: checking control 'Hue' (0x00980903)
		info: checking control 'Chroma AGC' (0x0098091d)
		info: checking control 'Chroma Gain' (0x00980924)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Brightness' (0x00980900)
		info: checking extended control 'Contrast' (0x00980901)
		info: checking extended control 'Saturation' (0x00980902)
		info: checking extended control 'Hue' (0x00980903)
		info: checking extended control 'Chroma AGC' (0x0098091d)
		info: checking extended control 'Chroma Gain' (0x00980924)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		info: checking control event 'Brightness' (0x00980900)
		info: checking control event 'Contrast' (0x00980901)
		info: checking control event 'Saturation' (0x00980902)
		info: checking control event 'Hue' (0x00980903)
		info: checking control event 'Chroma AGC' (0x0098091d)
		info: checking control event 'Chroma Gain' (0x00980924)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 7 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
		fail: v4l2-test-formats.cpp(240): fmtdesc.pixelformat not set
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
	test VIDIOC_G/S_PARM: OK
		fail: v4l2-test-formats.cpp(339): !fmt.width || !fmt.height
	test VIDIOC_G_FBUF: FAIL
		fail: v4l2-test-formats.cpp(385): !pix.sizeimage
	test VIDIOC_G_FMT: FAIL
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		fail: v4l2-test-buffers.cpp(84): node->node2 == NULL
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL

Total: 35, Succeeded: 29, Failed: 6, Warnings: 0


Thanks,

Anatolij

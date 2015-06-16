Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35307 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbbFPR3e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 13:29:34 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	<linux-kernel@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch 0/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
Date: Tue, 16 Jun 2015 12:29:21 -0500
Message-ID: <1434475763-20294-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Camera Adaptation Layer (CAL) is a block which consists of a dual
port CSI2/MIPI camera capture engine.
This camera engine is currently found on DRA72xx family of devices.

Port #0 can handle CSI2 camera connected to up to 4 data lanes.
Port #1 can handle CSI2 camera connected to up to 2 data lanes.

The driver implements the required API/ioctls to be V4L2 compliant.
Driver supports the following:
    - V4L2 API using DMABUF/MMAP buffer access based on videobuf2 api
    - Asynchronous sensor sub device registration
    - DT support

Currently each port is designed to connect to a single sub-device.
In other words port aggregation is not currently supported.

Here is a sample output of the v4l2-compliance tool:

# ./v4l2-compliance -s -v -d /dev/video0
Driver Info:
	Driver name   : cal
	Card type     : cal
	Bus info      : platform:cal-000
	Driver version: 4.1.0
	Capabilities  : 0x85200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x05200001
		Video Capture
		Read/Write
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
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

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Test input 0:

	Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
		info: checking v4l2_queryctrl of control 'Pixel Rate' (0x009f0902)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Horizontal Flip' (0x00980914)
		info: checking control 'Vertical Flip' (0x00980915)
		info: checking control 'Image Processing Controls' (0x009f0001)
		info: checking control 'Pixel Rate' (0x009f0902)
		test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Horizontal Flip' (0x00980914)
		info: checking extended control 'Vertical Flip' (0x00980915)
		info: checking extended control 'Image Processing Controls' (0x009f0001)
		info: checking extended control 'Pixel Rate' (0x009f0902)
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		info: checking control event 'Horizontal Flip' (0x00980914)
		info: checking control event 'Vertical Flip' (0x00980915)
		info: checking control event 'Image Processing Controls' (0x009f0001)
		info: checking control event 'Pixel Rate' (0x009f0902)
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 5 Private Controls: 0

	Format ioctls:
		info: found 1 frameintervals for pixel format 47425247 and size 1920x1080
		info: found 1 framesizes for pixel format 47425247
		info: found 1 formats for buftype 1
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		test VIDIOC_G_FMT: OK
		test VIDIOC_TRY_FMT: OK
		test VIDIOC_S_FMT: OK
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		fail: v4l2-test-formats.cpp(1475): node->can_scale && node->frmsizes_count[v4l_format_g_pixelformat(&cur)]
		test Scaling: OK

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		info: test buftype Video Capture
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:

Streaming ioctls:
	test read/write: OK
	    Video Capture:
		Buffer: 0 Sequence: 0 Field: None Timestamp: 66.759683s
		Buffer: 1 Sequence: 1 Field: None Timestamp: 66.781665s
		Buffer: 2 Sequence: 2 Field: None Timestamp: 66.803642s
		Buffer: 0 Sequence: 3 Field: None Timestamp: 66.825619s
		Buffer: 1 Sequence: 4 Field: None Timestamp: 66.847595s
		Buffer: 2 Sequence: 5 Field: None Timestamp: 66.869572s
		Buffer: 0 Sequence: 6 Field: None Timestamp: 66.891549s
		Buffer: 1 Sequence: 7 Field: None Timestamp: 66.913524s
		Buffer: 2 Sequence: 8 Field: None Timestamp: 66.935501s
		Buffer: 0 Sequence: 9 Field: None Timestamp: 66.957477s
		Buffer: 1 Sequence: 10 Field: None Timestamp: 66.979454s
		Buffer: 2 Sequence: 11 Field: None Timestamp: 67.001424s
		Buffer: 0 Sequence: 12 Field: None Timestamp: 67.023407s
		Buffer: 1 Sequence: 13 Field: None Timestamp: 67.045377s
		Buffer: 2 Sequence: 14 Field: None Timestamp: 67.067359s
		Buffer: 0 Sequence: 15 Field: None Timestamp: 67.089337s
		Buffer: 1 Sequence: 16 Field: None Timestamp: 67.111313s
		Buffer: 2 Sequence: 17 Field: None Timestamp: 67.133290s
		Buffer: 0 Sequence: 18 Field: None Timestamp: 67.155260s
		Buffer: 1 Sequence: 19 Field: None Timestamp: 67.177243s
		Buffer: 2 Sequence: 20 Field: None Timestamp: 67.199219s
		Buffer: 0 Sequence: 21 Field: None Timestamp: 67.221195s
		Buffer: 1 Sequence: 22 Field: None Timestamp: 67.243172s
		Buffer: 2 Sequence: 23 Field: None Timestamp: 67.265148s
		Buffer: 0 Sequence: 24 Field: None Timestamp: 67.287125s
		Buffer: 1 Sequence: 25 Field: None Timestamp: 67.309102s
		Buffer: 2 Sequence: 26 Field: None Timestamp: 67.331078s
		Buffer: 0 Sequence: 27 Field: None Timestamp: 67.353055s
		Buffer: 1 Sequence: 28 Field: None Timestamp: 67.375031s
		Buffer: 2 Sequence: 29 Field: None Timestamp: 67.397008s
		Buffer: 0 Sequence: 30 Field: None Timestamp: 67.418984s
		Buffer: 1 Sequence: 31 Field: None Timestamp: 67.440960s
		Buffer: 2 Sequence: 32 Field: None Timestamp: 67.462937s
		Buffer: 0 Sequence: 33 Field: None Timestamp: 67.484913s
		Buffer: 1 Sequence: 34 Field: None Timestamp: 67.506890s
		Buffer: 2 Sequence: 35 Field: None Timestamp: 67.528867s
		Buffer: 0 Sequence: 36 Field: None Timestamp: 67.550843s
		Buffer: 1 Sequence: 37 Field: None Timestamp: 67.572819s
		Buffer: 2 Sequence: 38 Field: None Timestamp: 67.594796s
		Buffer: 0 Sequence: 39 Field: None Timestamp: 67.616773s
		Buffer: 1 Sequence: 40 Field: None Timestamp: 67.638749s
		Buffer: 2 Sequence: 41 Field: None Timestamp: 67.660725s
		Buffer: 0 Sequence: 42 Field: None Timestamp: 67.682702s
		Buffer: 1 Sequence: 43 Field: None Timestamp: 67.704672s
		Buffer: 2 Sequence: 44 Field: None Timestamp: 67.726655s
		Buffer: 0 Sequence: 45 Field: None Timestamp: 67.748632s
		Buffer: 1 Sequence: 46 Field: None Timestamp: 67.770608s
		Buffer: 2 Sequence: 47 Field: None Timestamp: 67.792585s
		Buffer: 0 Sequence: 48 Field: None Timestamp: 67.814561s
		Buffer: 1 Sequence: 49 Field: None Timestamp: 67.836538s
		Buffer: 2 Sequence: 50 Field: None Timestamp: 67.858514s
		Buffer: 0 Sequence: 51 Field: None Timestamp: 67.880491s
		Buffer: 1 Sequence: 52 Field: None Timestamp: 67.902461s
		Buffer: 2 Sequence: 53 Field: None Timestamp: 67.924444s
		Buffer: 0 Sequence: 54 Field: None Timestamp: 67.946420s
		Buffer: 1 Sequence: 55 Field: None Timestamp: 67.968396s
		Buffer: 2 Sequence: 56 Field: None Timestamp: 67.990373s
		Buffer: 0 Sequence: 57 Field: None Timestamp: 68.012350s
		Buffer: 1 Sequence: 58 Field: None Timestamp: 68.034319s
		Buffer: 2 Sequence: 59 Field: None Timestamp: 68.056303s
	    Video Capture (polling):
		Buffer: 0 Sequence: 60 Field: None Timestamp: 68.078279s
		Buffer: 1 Sequence: 61 Field: None Timestamp: 68.100256s
		Buffer: 2 Sequence: 62 Field: None Timestamp: 68.122232s
		Buffer: 0 Sequence: 63 Field: None Timestamp: 68.144208s
		Buffer: 1 Sequence: 64 Field: None Timestamp: 68.166185s
		Buffer: 2 Sequence: 65 Field: None Timestamp: 68.188162s
		Buffer: 0 Sequence: 66 Field: None Timestamp: 68.210138s
		Buffer: 1 Sequence: 67 Field: None Timestamp: 68.232108s
		Buffer: 2 Sequence: 68 Field: None Timestamp: 68.254085s
		Buffer: 0 Sequence: 69 Field: None Timestamp: 68.276068s
		Buffer: 1 Sequence: 70 Field: None Timestamp: 68.298044s
		Buffer: 2 Sequence: 71 Field: None Timestamp: 68.320021s
		Buffer: 0 Sequence: 72 Field: None Timestamp: 68.341997s
		Buffer: 1 Sequence: 73 Field: None Timestamp: 68.363974s
		Buffer: 2 Sequence: 74 Field: None Timestamp: 68.385950s
		Buffer: 0 Sequence: 75 Field: None Timestamp: 68.407920s
		Buffer: 1 Sequence: 76 Field: None Timestamp: 68.429903s
		Buffer: 2 Sequence: 77 Field: None Timestamp: 68.451880s
		Buffer: 0 Sequence: 78 Field: None Timestamp: 68.473856s
		Buffer: 1 Sequence: 79 Field: None Timestamp: 68.495833s
		Buffer: 2 Sequence: 80 Field: None Timestamp: 68.517809s
		Buffer: 0 Sequence: 81 Field: None Timestamp: 68.539779s
		Buffer: 1 Sequence: 82 Field: None Timestamp: 68.561756s
		Buffer: 2 Sequence: 83 Field: None Timestamp: 68.583738s
		Buffer: 0 Sequence: 84 Field: None Timestamp: 68.605715s
		Buffer: 1 Sequence: 85 Field: None Timestamp: 68.627692s
		Buffer: 2 Sequence: 86 Field: None Timestamp: 68.649668s
		Buffer: 0 Sequence: 87 Field: None Timestamp: 68.671645s
		Buffer: 1 Sequence: 88 Field: None Timestamp: 68.693621s
		Buffer: 2 Sequence: 89 Field: None Timestamp: 68.715597s
		Buffer: 0 Sequence: 90 Field: None Timestamp: 68.737574s
		Buffer: 1 Sequence: 91 Field: None Timestamp: 68.759550s
		Buffer: 2 Sequence: 92 Field: None Timestamp: 68.781527s
		Buffer: 0 Sequence: 93 Field: None Timestamp: 68.803503s
		Buffer: 1 Sequence: 94 Field: None Timestamp: 68.825480s
		Buffer: 2 Sequence: 95 Field: None Timestamp: 68.847450s
		Buffer: 0 Sequence: 96 Field: None Timestamp: 68.869427s
		Buffer: 1 Sequence: 97 Field: None Timestamp: 68.891409s
		Buffer: 2 Sequence: 98 Field: None Timestamp: 68.913386s
		Buffer: 0 Sequence: 99 Field: None Timestamp: 68.935363s
		Buffer: 1 Sequence: 100 Field: None Timestamp: 68.957339s
		Buffer: 2 Sequence: 101 Field: None Timestamp: 68.979315s
		Buffer: 0 Sequence: 102 Field: None Timestamp: 69.001292s
		Buffer: 1 Sequence: 103 Field: None Timestamp: 69.023269s
		Buffer: 2 Sequence: 104 Field: None Timestamp: 69.045239s
		Buffer: 0 Sequence: 105 Field: None Timestamp: 69.067222s
		Buffer: 1 Sequence: 106 Field: None Timestamp: 69.089198s
		Buffer: 2 Sequence: 107 Field: None Timestamp: 69.111175s
		Buffer: 0 Sequence: 108 Field: None Timestamp: 69.133151s
		Buffer: 1 Sequence: 109 Field: None Timestamp: 69.155121s
		Buffer: 2 Sequence: 110 Field: None Timestamp: 69.177098s
		Buffer: 0 Sequence: 111 Field: None Timestamp: 69.199074s
		Buffer: 1 Sequence: 112 Field: None Timestamp: 69.221057s
		Buffer: 2 Sequence: 113 Field: None Timestamp: 69.243033s
		Buffer: 0 Sequence: 114 Field: None Timestamp: 69.265010s
		Buffer: 1 Sequence: 115 Field: None Timestamp: 69.286986s
		Buffer: 2 Sequence: 116 Field: None Timestamp: 69.308963s
		Buffer: 0 Sequence: 117 Field: None Timestamp: 69.330940s
		Buffer: 1 Sequence: 118 Field: None Timestamp: 69.352916s
		Buffer: 2 Sequence: 119 Field: None Timestamp: 69.374892s
	test MMAP: OK
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Total: 45, Succeeded: 45, Failed: 0, Warnings: 0

Benoit Parrot (2):
  media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
  media: v4l: ti-vpe: Document CAL driver

 Documentation/devicetree/bindings/media/ti-cal.txt |   70 +
 drivers/media/platform/Kconfig                     |   12 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/ti-vpe/Makefile             |    4 +
 drivers/media/platform/ti-vpe/cal.c                | 2225 ++++++++++++++++++++
 drivers/media/platform/ti-vpe/cal_regs.h           |  779 +++++++
 6 files changed, 3092 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
 create mode 100644 drivers/media/platform/ti-vpe/cal.c
 create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h

-- 
1.8.5.1


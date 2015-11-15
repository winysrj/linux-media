Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33425 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbbKOXxy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 18:53:54 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Benoit Parrot <bparrot@ti.com>
Subject: [Patch v4 0/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
Date: Sun, 15 Nov 2015 17:53:46 -0600
Message-ID: <1447631628-9459-1-git-send-email-bparrot@ti.com>
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

Changes since v3:
- Nothing really I messed up the previous format-patch with the
  wrong commit-id. Sorry about the repeat.

Changes since v2:
- Rework Kconfig options and added COMPILE_TEST
- Merged in provided vb2 buffer rework
- Rebase on tip of lmm master and fixe vb2 split related changes

Changes since v1:
- Remove unnecessary format description
- Reworked how transient frame format is maintained
  in order to make it easier to use the fill helper functions
- Added a per port list of active frame format
- Reworked an added missing vb2 cleanup code
- Fix a module load/unload kernel oops
- Switch to use proper int64 get function for pixel rate control

=====

Here is a sample output of the v4l2-compliance tool:

# ./v4l2-compliance -f -s -v -d /dev/video0 
Driver Info:
	Driver name   : cal
	Card type     : cal
	Bus info : platform:cal-000

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
		test Scaling: OK (Not Supported)

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
		Buffer: 0 Sequence: 0 Field: None Timestamp: 353.276293s
		Buffer: 1 Sequence: 1 Field: None Timestamp: 353.298270s
		Buffer: 2 Sequence: 2 Field: None Timestamp: 353.320238s
		Buffer: 0 Sequence: 3 Field: None Timestamp: 353.342223s
		Buffer: 1 Sequence: 4 Field: None Timestamp: 353.364199s
		Buffer: 2 Sequence: 5 Field: None Timestamp: 353.386175s
		Buffer: 0 Sequence: 6 Field: None Timestamp: 353.408152s
		Buffer: 1 Sequence: 7 Field: None Timestamp: 353.430128s
		Buffer: 2 Sequence: 8 Field: None Timestamp: 353.452105s
		Buffer: 0 Sequence: 9 Field: None Timestamp: 353.474074s
		Buffer: 1 Sequence: 10 Field: None Timestamp: 353.496058s
		Buffer: 2 Sequence: 11 Field: None Timestamp: 353.518034s
		Buffer: 0 Sequence: 12 Field: None Timestamp: 353.540010s
		Buffer: 1 Sequence: 13 Field: None Timestamp: 353.561978s
		Buffer: 2 Sequence: 14 Field: None Timestamp: 353.583963s
		Buffer: 0 Sequence: 15 Field: None Timestamp: 353.605940s
		Buffer: 1 Sequence: 16 Field: None Timestamp: 353.627916s
		Buffer: 2 Sequence: 17 Field: None Timestamp: 353.649893s
		Buffer: 0 Sequence: 18 Field: None Timestamp: 353.671869s
		Buffer: 1 Sequence: 19 Field: None Timestamp: 353.693846s
		Buffer: 2 Sequence: 20 Field: None Timestamp: 353.715815s
		Buffer: 0 Sequence: 21 Field: None Timestamp: 353.737799s
		Buffer: 1 Sequence: 22 Field: None Timestamp: 353.759775s
		Buffer: 2 Sequence: 23 Field: None Timestamp: 353.781751s
		Buffer: 0 Sequence: 24 Field: None Timestamp: 353.803728s
		Buffer: 1 Sequence: 25 Field: None Timestamp: 353.825698s
		Buffer: 2 Sequence: 26 Field: None Timestamp: 353.847681s
		Buffer: 0 Sequence: 27 Field: None Timestamp: 353.869658s
		Buffer: 1 Sequence: 28 Field: None Timestamp: 353.891634s
		Buffer: 2 Sequence: 29 Field: None Timestamp: 353.913610s
		Buffer: 0 Sequence: 30 Field: None Timestamp: 353.935587s
		Buffer: 1 Sequence: 31 Field: None Timestamp: 353.957564s
		Buffer: 2 Sequence: 32 Field: None Timestamp: 353.979533s
		Buffer: 0 Sequence: 33 Field: None Timestamp: 354.001510s
		Buffer: 1 Sequence: 34 Field: None Timestamp: 354.023493s
		Buffer: 2 Sequence: 35 Field: None Timestamp: 354.045469s
		Buffer: 0 Sequence: 36 Field: None Timestamp: 354.067446s
		Buffer: 1 Sequence: 37 Field: None Timestamp: 354.089422s
		Buffer: 2 Sequence: 38 Field: None Timestamp: 354.111399s
		Buffer: 0 Sequence: 39 Field: None Timestamp: 354.133375s
		Buffer: 1 Sequence: 40 Field: None Timestamp: 354.155351s
		Buffer: 2 Sequence: 41 Field: None Timestamp: 354.177328s
		Buffer: 0 Sequence: 42 Field: None Timestamp: 354.199304s
		Buffer: 1 Sequence: 43 Field: None Timestamp: 354.221274s
		Buffer: 2 Sequence: 44 Field: None Timestamp: 354.243257s
		Buffer: 0 Sequence: 45 Field: None Timestamp: 354.265234s
		Buffer: 1 Sequence: 46 Field: None Timestamp: 354.287210s
		Buffer: 2 Sequence: 47 Field: None Timestamp: 354.309187s
		Buffer: 0 Sequence: 48 Field: None Timestamp: 354.331163s
		Buffer: 1 Sequence: 49 Field: None Timestamp: 354.353140s
		Buffer: 2 Sequence: 50 Field: None Timestamp: 354.375116s
		Buffer: 0 Sequence: 51 Field: None Timestamp: 354.397093s
		Buffer: 1 Sequence: 52 Field: None Timestamp: 354.419069s
		Buffer: 2 Sequence: 53 Field: None Timestamp: 354.441038s
		Buffer: 0 Sequence: 54 Field: None Timestamp: 354.463022s
		Buffer: 1 Sequence: 55 Field: None Timestamp: 354.484998s
		Buffer: 2 Sequence: 56 Field: None Timestamp: 354.506975s
		Buffer: 0 Sequence: 57 Field: None Timestamp: 354.528952s
		Buffer: 1 Sequence: 58 Field: None Timestamp: 354.550928s
		Buffer: 2 Sequence: 59 Field: None Timestamp: 354.572904s
	    Video Capture (polling):
		Buffer: 0 Sequence: 60 Field: None Timestamp: 354.594881s
		Buffer: 1 Sequence: 61 Field: None Timestamp: 354.616857s
		Buffer: 2 Sequence: 62 Field: None Timestamp: 354.638834s
		Buffer: 0 Sequence: 63 Field: None Timestamp: 354.660810s
		Buffer: 1 Sequence: 64 Field: None Timestamp: 354.682787s
		Buffer: 2 Sequence: 65 Field: None Timestamp: 354.704764s
		Buffer: 0 Sequence: 66 Field: None Timestamp: 354.726733s
		Buffer: 1 Sequence: 67 Field: None Timestamp: 354.748716s
		Buffer: 2 Sequence: 68 Field: None Timestamp: 354.770693s
		Buffer: 0 Sequence: 69 Field: None Timestamp: 354.792669s
		Buffer: 1 Sequence: 70 Field: None Timestamp: 354.814645s
		Buffer: 2 Sequence: 71 Field: None Timestamp: 354.836615s
		Buffer: 0 Sequence: 72 Field: None Timestamp: 354.858591s
		Buffer: 1 Sequence: 73 Field: None Timestamp: 354.880575s
		Buffer: 2 Sequence: 74 Field: None Timestamp: 354.902552s
		Buffer: 0 Sequence: 75 Field: None Timestamp: 354.924528s
		Buffer: 1 Sequence: 76 Field: None Timestamp: 354.946505s
		Buffer: 2 Sequence: 77 Field: None Timestamp: 354.968481s
		Buffer: 0 Sequence: 78 Field: None Timestamp: 354.990457s
		Buffer: 1 Sequence: 79 Field: None Timestamp: 355.012434s
		Buffer: 2 Sequence: 80 Field: None Timestamp: 355.034411s
		Buffer: 0 Sequence: 81 Field: None Timestamp: 355.056387s
		Buffer: 1 Sequence: 82 Field: None Timestamp: 355.078364s
		Buffer: 2 Sequence: 83 Field: None Timestamp: 355.100340s
		Buffer: 0 Sequence: 84 Field: None Timestamp: 355.122316s
		Buffer: 1 Sequence: 85 Field: None Timestamp: 355.144293s
		Buffer: 2 Sequence: 86 Field: None Timestamp: 355.166269s
		Buffer: 0 Sequence: 87 Field: None Timestamp: 355.188246s
		Buffer: 1 Sequence: 88 Field: None Timestamp: 355.210223s
		Buffer: 2 Sequence: 89 Field: None Timestamp: 355.232199s
		Buffer: 0 Sequence: 90 Field: None Timestamp: 355.254176s
		Buffer: 1 Sequence: 91 Field: None Timestamp: 355.276152s
		Buffer: 2 Sequence: 92 Field: None Timestamp: 355.298128s
		Buffer: 0 Sequence: 93 Field: None Timestamp: 355.320096s
		Buffer: 1 Sequence: 94 Field: None Timestamp: 355.342081s
		Buffer: 2 Sequence: 95 Field: None Timestamp: 355.364058s
		Buffer: 0 Sequence: 96 Field: None Timestamp: 355.386035s
		Buffer: 1 Sequence: 97 Field: None Timestamp: 355.408011s
		Buffer: 2 Sequence: 98 Field: None Timestamp: 355.429987s
		Buffer: 0 Sequence: 99 Field: None Timestamp: 355.451964s
		Buffer: 1 Sequence: 100 Field: None Timestamp: 355.473933s
		Buffer: 2 Sequence: 101 Field: None Timestamp: 355.495917s
		Buffer: 0 Sequence: 102 Field: None Timestamp: 355.517893s
		Buffer: 1 Sequence: 103 Field: None Timestamp: 355.539870s
		Buffer: 2 Sequence: 104 Field: None Timestamp: 355.561837s
		Buffer: 0 Sequence: 105 Field: None Timestamp: 355.583823s
		Buffer: 1 Sequence: 106 Field: None Timestamp: 355.605799s
		Buffer: 2 Sequence: 107 Field: None Timestamp: 355.627775s
		Buffer: 0 Sequence: 108 Field: None Timestamp: 355.649752s
		Buffer: 1 Sequence: 109 Field: None Timestamp: 355.671729s
		Buffer: 2 Sequence: 110 Field: None Timestamp: 355.693705s
		Buffer: 0 Sequence: 111 Field: None Timestamp: 355.715681s
		Buffer: 1 Sequence: 112 Field: None Timestamp: 355.737657s
		Buffer: 2 Sequence: 113 Field: None Timestamp: 355.759634s
		Buffer: 0 Sequence: 114 Field: None Timestamp: 355.781610s
		Buffer: 1 Sequence: 115 Field: None Timestamp: 355.803580s
		Buffer: 2 Sequence: 116 Field: None Timestamp: 355.825556s
		Buffer: 0 Sequence: 117 Field: None Timestamp: 355.847541s
		Buffer: 1 Sequence: 118 Field: None Timestamp: 355.869517s
		Buffer: 2 Sequence: 119 Field: None Timestamp: 355.891493s
	test MMAP: OK
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Stream using all formats:
	test MMAP for Format GRBG, Frame Size 1920x1080@30.00 Hz:
		Stride 1920, Field None: OK                                 

Total: 46, Succeeded: 46, Failed: 0, Warnings: 0

Benoit Parrot (2):
  media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
  media: v4l: ti-vpe: Document CAL driver

 Documentation/devicetree/bindings/media/ti-cal.txt |   70 +
 drivers/media/platform/Kconfig                     |   12 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/ti-vpe/Makefile             |    4 +
 drivers/media/platform/ti-vpe/cal.c                | 2164 ++++++++++++++++++++
 drivers/media/platform/ti-vpe/cal_regs.h           |  779 +++++++
 6 files changed, 3031 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/ti-cal.txt
 create mode 100644 drivers/media/platform/ti-vpe/cal.c
 create mode 100644 drivers/media/platform/ti-vpe/cal_regs.h

-- 
1.8.5.1


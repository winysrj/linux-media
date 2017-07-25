Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33962 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751647AbdGYRkc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 13:40:32 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] go2001 hardware codec support
Date: Tue, 25 Jul 2017 19:40:21 +0200
Message-Id: <1501004422-8294-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch introduces the go2001 hardware codec driver.

Changes in v3:
- Replace crop iotcl with selection ones
- Use video dev device_caps field
- Return v4l2_ctrl_subscribe_event() for default case
- Fix start_streaming error handling
- Remove empty ctrl ops callbacks
- Avoid use of private ctrl structures
- Remove VB2_USERPTR support
- Remove format description strings

Changes in v2:
- Remove unneeded call to dma_cache_sync() on coherent dma buffer.

Following are the results of v4l2-compliance utility execution for both
/dev/video0 and /dev/video1 devices.

Note that the failing tests are due to un-initialized internal
structures of the driver not done through these unit tests.

$ ./utils/v4l2-compliance/v4l2-compliance -d /dev/video0
v4l2-compliance SHA   : 1ae9a7adea3766879935dfede90d5aefd954c786

Driver Info:
	Driver name   : go2001
	Card type     : GO2001 PCIe codec
	Bus info      : PCI:0000:03:00.0
	Driver version: 4.12.0
	Capabilities  : 0x84204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
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
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 2 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		test VIDIOC_G/S_PARM: OK (Not Supported)
		test VIDIOC_G_FBUF: OK (Not Supported)
		fail: v4l2-test-formats.cpp(590): Video Capture Multiplanar cap set, but no Video Capture Multiplanar formats defined
		test VIDIOC_G_FMT: FAIL
		test VIDIOC_TRY_FMT: OK (Not Supported)
		test VIDIOC_S_FMT: OK (Not Supported)
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		fail: v4l2-test-formats.cpp(1670): doioctl(node, VIDIOC_G_FMT, &fmt)
		test Scaling: FAIL

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		fail: v4l2-test-buffers.cpp(574): VIDIOC_EXPBUF is supported, but the V4L2_MEMORY_MMAP support is missing, probably due to earlier failing format tests.
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:

Total: 43, Succeeded: 41, Failed: 2, Warnings: 0

$ ./utils/v4l2-compliance/v4l2-compliance -d /dev/video1
v4l2-compliance SHA   : 1ae9a7adea3766879935dfede90d5aefd954c786

Driver Info:
	Driver name   : go2001
	Card type     : GO2001 PCIe codec
	Bus info      : PCI:0000:03:00.0
	Driver version: 4.12.0
	Capabilities  : 0x84204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps   : 0x04204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format

Compliance test for device /dev/video1 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
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
		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
		test VIDIOC_QUERYCTRL: OK
		test VIDIOC_G/S_CTRL: OK
		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
		Standard Controls: 4 Private Controls: 0

	Format ioctls:
		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		fail: v4l2-test-formats.cpp(1213): got error 22 when setting parms for buftype 10
		test VIDIOC_G/S_PARM: FAIL
		test VIDIOC_G_FBUF: OK (Not Supported)
		fail: v4l2-test-formats.cpp(446): !pix_mp.width || !pix_mp.height
		test VIDIOC_G_FMT: FAIL
		test VIDIOC_TRY_FMT: OK (Not Supported)
		test VIDIOC_S_FMT: OK (Not Supported)
		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
		test Cropping: OK (Not Supported)
		test Composing: OK (Not Supported)
		fail: v4l2-test-formats.cpp(1678): doioctl(node, VIDIOC_G_FMT, &fmt)
		test Scaling: FAIL

	Codec ioctls:
		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

	Buffer ioctls:
		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
		fail: v4l2-test-buffers.cpp(574): VIDIOC_EXPBUF is supported, but the V4L2_MEMORY_MMAP support is missing, probably due to earlier failing format tests.
		test VIDIOC_EXPBUF: OK (Not Supported)

Test input 0:


Total: 43, Succeeded: 40, Failed: 3, Warnings: 0


Thierry Escande (1):
  [media] v4l2: Add support for go2001 PCI codec driver

 drivers/media/pci/Kconfig                |    2 +
 drivers/media/pci/Makefile               |    1 +
 drivers/media/pci/go2001/Kconfig         |   11 +
 drivers/media/pci/go2001/Makefile        |    2 +
 drivers/media/pci/go2001/go2001.h        |  331 ++++
 drivers/media/pci/go2001/go2001_driver.c | 2525 ++++++++++++++++++++++++++++++
 drivers/media/pci/go2001/go2001_hw.c     | 1362 ++++++++++++++++
 drivers/media/pci/go2001/go2001_hw.h     |   55 +
 drivers/media/pci/go2001/go2001_proto.h  |  359 +++++
 9 files changed, 4648 insertions(+)
 create mode 100644 drivers/media/pci/go2001/Kconfig
 create mode 100644 drivers/media/pci/go2001/Makefile
 create mode 100644 drivers/media/pci/go2001/go2001.h
 create mode 100644 drivers/media/pci/go2001/go2001_driver.c
 create mode 100644 drivers/media/pci/go2001/go2001_hw.c
 create mode 100644 drivers/media/pci/go2001/go2001_hw.h
 create mode 100644 drivers/media/pci/go2001/go2001_proto.h

-- 
2.7.4

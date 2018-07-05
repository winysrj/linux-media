Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43704 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753213AbeGER23 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 13:28:29 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 0/3] Add Rockchip VPU JPEG encoder
Date: Thu,  5 Jul 2018 14:28:16 -0300
Message-Id: <20180705172819.5588-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for JPEG encoding via the VPU block
present in Rockchip platforms. Currently, support for RK3288
and RK3399 is included.

The hardware produces a Raw JPEG format (i.e. works as a
JPEG accelerator), and requires quantization tables provided
by the application.

Therefore, the series introduces a new format, and a new pair
of controls, V4L2_CID_JPEG_{LUMA,CHROMA}_QUANTIZATION
allowing userspace to specify the quantization tables.

Userspace is then responsible to add the required headers
and tables to the produced raw payload, to produce a JPEG image.

It is currently not clear if we should try to provide
a userspace helper for this kind of raw JPEG hardware,
such as a libv4l plugin, wrapping up the luma/chroma
quantization tables.

Or perhaps we can let each application (e.g. ffmpeg, gstreamer,
chrome) handle in its own way.

Roadmap
=======

This driver does not rely on the Request API, and so I believe
it could be merged as is. The next steps are support H264
and VP8 codecs.

Compliance
==========

# v4l2-compliance -d 0 
v4l2-compliance SHA: c11ed3a4d961ed67e2b5845569cbbe214abdaa8d, 64 bits

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : rockchip-vpu
	Card type        : rockchip-vpu-enc
	Bus info         : platform: rockchip-vpu
	Driver version   : 4.18.0
	Capabilities     : 0x84204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04204000
		Video Memory-to-Memory Multiplanar
		Streaming
		Extended Pix Format

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video0 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK
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
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

Ezequiel Garcia (1):
  media: add Rockchip VPU driver

Shunqian Zheng (2):
  media: Add JPEG_RAW format
  media: Add controls for jpeg quantization tables

 .../media/uapi/v4l/pixfmt-compressed.rst      |   5 +
 drivers/media/platform/Kconfig                |  12 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/rockchip/vpu/Makefile  |   8 +
 .../platform/rockchip/vpu/rk3288_vpu_hw.c     | 127 +++
 .../rockchip/vpu/rk3288_vpu_hw_jpege.c        | 156 ++++
 .../platform/rockchip/vpu/rk3288_vpu_regs.h   | 442 ++++++++++
 .../platform/rockchip/vpu/rk3399_vpu_hw.c     | 127 +++
 .../rockchip/vpu/rk3399_vpu_hw_jpege.c        | 165 ++++
 .../platform/rockchip/vpu/rk3399_vpu_regs.h   | 601 ++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu.h      | 270 +++++++
 .../platform/rockchip/vpu/rockchip_vpu_drv.c  | 416 ++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.c  | 763 ++++++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.h  |  25 +
 .../platform/rockchip/vpu/rockchip_vpu_hw.h   |  67 ++
 drivers/media/v4l2-core/v4l2-ctrls.c          |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
 include/uapi/linux/v4l2-controls.h            |   3 +
 include/uapi/linux/videodev2.h                |   1 +
 19 files changed, 3194 insertions(+)
 create mode 100644 drivers/media/platform/rockchip/vpu/Makefile
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_hw_jpege.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_hw_jpege.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_enc.h
 create mode 100644 drivers/media/platform/rockchip/vpu/rockchip_vpu_hw.h

-- 
2.18.0.rc2

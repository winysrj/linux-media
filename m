Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49944 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbeHBVxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 17:53:03 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 0/6] Add Rockchip VPU JPEG encoder
Date: Thu,  2 Aug 2018 17:00:04 -0300
Message-Id: <20180802200010.24365-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for JPEG encoding via the VPU block
present in Rockchip platforms. Currently, support for RK3288
and RK3399 is included.

The hardware produces a Raw JPEG format (i.e. works as a
JPEG accelerator). It requires quantization tables provided
by the application, and uses standard huffman tables,
as recommended by the JPEG specification.

In order to support this, the series introduces a new pixel format,
and a new pair of controls, V4L2_CID_JPEG_{LUMA,CHROMA}_QUANTIZATION
allowing userspace to specify the quantization tables.

Userspace is then responsible to add the required headers
and tables to the produced raw payload, to produce a JPEG image.

Compliance
==========

There is an outstanding compliance issue, related to a blocking
dqbuf, but I cannot see where is the issue, nor if the issue is
in the core or in the driver.

# v4l2-compliance -d 0 -s 
v4l2-compliance SHA: 81ea4a243b63d7bb1fec580910c553af4ae072c1, 64 bits

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : rockchip-vpu
	Card type        : rockchip-vpu
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

Test input 0:

Streaming ioctls:
	test read/write: OK (Not Supported)
		fail: v4l2-test-buffers.cpp(1225): pid != pid_streamoff
		fail: v4l2-test-buffers.cpp(1258): testBlockingDQBuf(node, q)
	test blocking wait: FAIL
	test MMAP: OK                                     
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Total: 47, Succeeded: 46, Failed: 1, Warnings: 0

v2:
  - Add devicetree binding documentation and devicetree changes
  - Add documentation to added pixel format and controls
  - Address Hans' review comments
  - Get rid of unused running_ctx field
  - Fix wrong planar pixel format depths
  - Other minor changes for v4l2-compliance
  - Drop .crop support, we will add support for the
    selector API later, if needed.

Ezequiel Garcia (4):
  dt-bindings: Document the Rockchip VPU bindings
  ARM: dts: rockchip: add VPU device node for RK3288
  arm64: dts: rockchip: add VPU device node for RK3399
  media: add Rockchip VPU driver

Shunqian Zheng (2):
  media: Add JPEG_RAW format
  media: Add controls for jpeg quantization tables

 .../bindings/media/rockchip-vpu.txt           |  30 +
 .../media/uapi/v4l/extended-controls.rst      |   9 +
 .../media/uapi/v4l/pixfmt-compressed.rst      |   9 +
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/rk3288.dtsi                 |  13 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |  12 +
 drivers/media/platform/Kconfig                |  13 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/rockchip/vpu/Makefile  |   8 +
 .../platform/rockchip/vpu/rk3288_vpu_hw.c     | 122 +++
 .../rockchip/vpu/rk3288_vpu_hw_jpege.c        | 154 ++++
 .../platform/rockchip/vpu/rk3288_vpu_regs.h   | 442 +++++++++++
 .../platform/rockchip/vpu/rk3399_vpu_hw.c     | 122 +++
 .../rockchip/vpu/rk3399_vpu_hw_jpege.c        | 181 +++++
 .../platform/rockchip/vpu/rk3399_vpu_regs.h   | 601 +++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu.h      | 272 +++++++
 .../platform/rockchip/vpu/rockchip_vpu_drv.c  | 404 ++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.c  | 715 ++++++++++++++++++
 .../platform/rockchip/vpu/rockchip_vpu_enc.h  |  25 +
 .../platform/rockchip/vpu/rockchip_vpu_hw.h   |  67 ++
 drivers/media/v4l2-core/v4l2-ctrls.c          |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
 include/uapi/linux/v4l2-controls.h            |   3 +
 include/uapi/linux/videodev2.h                |   1 +
 24 files changed, 3215 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
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
2.18.0

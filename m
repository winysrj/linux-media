Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34838 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbeJEHIk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 03:08:40 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v7 0/6] Add Rockchip VPU JPEG encoder
Date: Thu,  4 Oct 2018 21:12:20 -0300
Message-Id: <20181005001226.12789-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds support for JPEG encoding via the VPU block
present in Rockchip platforms. Currently, support for RK3288
and RK3399 is included.

Please, see the previous versions of this cover letter for
more information.

This series should apply cleanly on top of

  git://linuxtv.org/hverkuil/media_tree.git br-cedrus tag.

If everyone is happy with this series, I'd like to route the devicetree
changes through the rockchip tree, and the rest via the media subsystem.

Compliance
==========

(Same results as v3)

v4l2-compliance SHA: d0f4ea7ddab6d0244c4fe1e960bb2aaeefb911b9, 64 bits

Compliance test for device /dev/video0:

Driver Info:
	Driver name      : rockchip-vpu
	Card type        : rockchip,rk3399-vpu-enc
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
Media Driver Info:
	Driver name      : rockchip-vpu
	Model            : rockchip-vpu
	Serial           : 
	Bus info         : 
	Media version    : 4.18.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.18.0
Interface Info:
	ID               : 0x0300000c
	Type             : V4L Video
Entity Info:
	ID               : 0x00000001 (1)
	Name             : rockchip,rk3399-vpu-enc-source
	Function         : V4L2 I/O
	Pad 0x01000002   : Source
	  Link 0x02000008: to remote pad 0x1000005 of entity 'rockchip,rk3399-vpu-enc-proc': Data, Enabled, Immutable

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
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
	test blocking wait: OK
	test MMAP: OK                                     
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Total: 48, Succeeded: 48, Failed: 0, Warnings: 0

v7:
  - Fix checkpatch --strict issues.
  - Fix extra blank line in binding doc.

v6:
  - As agreed with Hans change the quantization control
    to support only strict baseline JPEGs, with 8-bit
    coefficients.
v5:
  - Make coefficients 2-byte wide, to support 8-bit and 16-bit
    precision coefficient. Also, add a 'precision' field, to
    allow the user to specifiy the coefficient precision.
  - Minor style changes as requested by Hans.
  - Get rid of all the unused leftover code.
  - Move driver to staging. The driver will support video encoding,
    via the request API. So let's use staging until the
    controls are stabilized.
v4:
  - Change luma and chroma array controls, with a compound
    control, as suggested by Paul.
v3:
  - Refactor driver to allow a more elegant integration with
    other codec modes (h264 decoding, jpeg decoding, etc).
    Each variant can now be encoders, decoders or both.
  - Register driver in the media controller framework,
    in preparation for the Request API.
  - Set values for JPEG quantization controls in the core, as suggested
    by Tomasz and Hans.
  - Move pm_runtime_get/put to run/done, reducing power consumption.
    This was possible thanks to Miouyouyou, who pointed out the power
    domains missing [1].
  - Use bulk clock API for simpler code.
v2:
  - Add devicetree binding documentation and devicetree changes
  - Add documentation to added pixel format and controls
  - Address Hans' review comments
  - Get rid of unused running_ctx field
  - Fix wrong planar pixel format depths
  - Other minor changes for v4l2-compliance
  - Drop .crop support, we will add support for the
    selector API later, if needed.

[1] https://github.com/Miouyouyou/RockMyy/blob/master/patches/kernel/v4.18/DTS/0026-ARM-DTSI-rk3288-Set-the-VPU-MMU-power-domains.patch

Ezequiel Garcia (4):
  dt-bindings: Document the Rockchip VPU bindings
  ARM: dts: rockchip: add VPU device node for RK3288
  arm64: dts: rockchip: add VPU device node for RK3399
  media: add Rockchip VPU JPEG encoder driver

Shunqian Zheng (2):
  media: Add JPEG_RAW format
  media: Add controls for JPEG quantization tables

 .../bindings/media/rockchip-vpu.txt           |  29 +
 .../media/uapi/v4l/extended-controls.rst      |  25 +
 .../media/uapi/v4l/pixfmt-compressed.rst      |   9 +
 .../media/videodev2.h.rst.exceptions          |   1 +
 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/rk3288.dtsi                 |  14 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |  14 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          |   8 +
 drivers/media/v4l2-core/v4l2-ioctl.c          |   1 +
 drivers/staging/media/Kconfig                 |   2 +
 drivers/staging/media/Makefile                |   1 +
 drivers/staging/media/rockchip/vpu/Kconfig    |  13 +
 drivers/staging/media/rockchip/vpu/Makefile   |   9 +
 drivers/staging/media/rockchip/vpu/TODO       |   9 +
 .../media/rockchip/vpu/rk3288_vpu_hw.c        | 125 ++++
 .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     | 127 ++++
 .../media/rockchip/vpu/rk3288_vpu_regs.h      | 442 +++++++++++++
 .../media/rockchip/vpu/rk3399_vpu_hw.c        | 125 ++++
 .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     | 155 +++++
 .../media/rockchip/vpu/rk3399_vpu_regs.h      | 600 +++++++++++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu.h | 278 ++++++++
 .../media/rockchip/vpu/rockchip_vpu_common.h  |  31 +
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 527 +++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 606 ++++++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_hw.h      |  65 ++
 include/uapi/linux/v4l2-controls.h            |  10 +
 include/uapi/linux/videodev2.h                |   2 +
 27 files changed, 3233 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-vpu.txt
 create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
 create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
 create mode 100644 drivers/staging/media/rockchip/vpu/TODO
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h

-- 
2.19.0.rc2

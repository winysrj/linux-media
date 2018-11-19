Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36766 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbeKTBxP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 20:53:15 -0500
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
Subject: [PATCH v8 0/3] Add Rockchip VPU JPEG encoder
Date: Mon, 19 Nov 2018 12:28:59 -0300
Message-Id: <20181119152902.31429-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's a new version of the Rockchip VPU JPEG encoder driver,
for the RK3288 and RK3399 SoCs.

This new version supports V4L2_PIX_FMT_JPEG capture format,
which means standard userspace can be used, such as gstreamer:

  gst-launch-1.0 videotestsrc ! v4l2jpegenc extra-controls="c,compression_quality=95" ! ...

The hardware produces a JPEG scan (i.e. without the start JPEG headers),
so the driver has to add the needed headers. Note that the hardware
produces a EOI marker at the end of the JPEG scan.

Since the driver no longer needs a specific format, I've dropped the
patch adding the V4L2_PIX_FMT_JPEG_RAW format.

Also, since the driver adds the needed quantization tables,
it's possible to drop the new controls and use V4L2_CID_JPEG_COMPRESSION_QUALITY.
This is required for standard userspace to work, as the above
example shows.

Future work
-----------

There's an opportunity for some factorization as default JPEG
tables are specified by the JPEG standard and they are
also currently defined by the CODA driver.

Another factorization is the fill_fmt_mp function,
which should be converted to a proper helper to be used
by other drivers.

I'd like to pospone such factorization until after this driver
is merged, to avoid delaying this work any further.

In addition to this, it would be interesting to add user controls
to specify the quantization tables. It's not yet clear how this
control would interact with the JPEG compression quality control,
and so it needs some discussion.

Compliance output
-----------------

root@ficus:~# v4l2-compliance -d /dev/video3  -s
v4l2-compliance SHA: d0f4ea7ddab6d0244c4fe1e960bb2aaeefb911b9, 64 bits

Compliance test for device /dev/video3:

Driver Info:
	Driver name      : rockchip-vpu
	Card type        : rockchip,rk3399-vpu-enc
	Bus info         : platform: rockchip-vpu
	Driver version   : 4.20.0
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
	Media version    : 4.20.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.20.0
Interface Info:
	ID               : 0x0300000c
	Type             : V4L Video
Entity Info:
	ID               : 0x00000001 (1)
	Name             : rockchip,rk3399-vpu-enc-source
	Function         : V4L2 I/O
	Pad 0x01000002   : 0: Source
	  Link 0x02000008: to remote pad 0x1000005 of entity 'rockchip,rk3399-vpu-enc-proc': Data, Enabled, Immutable

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video3 open: OK
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
	Video Capture Multiplanar: Captured 57 buffers    
	test MMAP: OK
	test USERPTR: OK (Not Supported)
	test DMABUF: Cannot test, specify --expbuf-device

Total: 48, Succeeded: 48, Failed: 0, Warnings: 0

Ezequiel Garcia (3):
  ARM: dts: rockchip: add VPU device node for RK3288
  arm64: dts: rockchip: add VPU device node for RK3399
  media: add Rockchip VPU JPEG encoder driver

 MAINTAINERS                                   |   7 +
 arch/arm/boot/dts/rk3288.dtsi                 |  14 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |  14 +-
 drivers/staging/media/Kconfig                 |   2 +
 drivers/staging/media/Makefile                |   1 +
 drivers/staging/media/rockchip/vpu/Kconfig    |  14 +
 drivers/staging/media/rockchip/vpu/Makefile   |  10 +
 drivers/staging/media/rockchip/vpu/TODO       |   9 +
 .../media/rockchip/vpu/rk3288_vpu_hw.c        | 118 +++
 .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     | 133 ++++
 .../media/rockchip/vpu/rk3288_vpu_regs.h      | 442 +++++++++++
 .../media/rockchip/vpu/rk3399_vpu_hw.c        | 118 +++
 .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     | 160 ++++
 .../media/rockchip/vpu/rk3399_vpu_regs.h      | 600 +++++++++++++++
 .../staging/media/rockchip/vpu/rockchip_vpu.h | 237 ++++++
 .../media/rockchip/vpu/rockchip_vpu_common.h  |  29 +
 .../media/rockchip/vpu/rockchip_vpu_drv.c     | 535 +++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_enc.c     | 701 ++++++++++++++++++
 .../media/rockchip/vpu/rockchip_vpu_hw.h      |  58 ++
 .../media/rockchip/vpu/rockchip_vpu_jpeg.c    | 289 ++++++++
 .../media/rockchip/vpu/rockchip_vpu_jpeg.h    |  12 +
 21 files changed, 3501 insertions(+), 2 deletions(-)
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
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
 create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h

-- 
2.19.1

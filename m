Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f53.google.com ([209.85.160.53]:42903 "EHLO
        mail-pl0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935069AbeCHJsk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 04:48:40 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        devicetree@vger.kernel.org, heiko@sntech.de,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: [PATCH v6 00/17] Rockchip ISP1 Driver
Date: Thu,  8 Mar 2018 17:47:50 +0800
Message-Id: <20180308094807.9443-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Chen <jacob2.chen@rock-chips.com>

changes in V6:
  - add mipi txrx phy support
  - remove bool and enum from uapi header
  - add buf_prepare op
  - correct some spelling problems
  - return all queued buffers when starting stream failed

changes in V5: Sync with local changes,
  - fix the SP height limit
  - speed up the second stream capture
  - the second stream can't force sync for rsz when start/stop streaming
  - add frame id to param vb2 buf
  - enable luminance maximum threshold

changes in V4:
  - fix some bugs during development
  - move quantization settings to rkisp1 subdev
  - correct some spelling problems
  - describe ports in dt-binding documents

changes in V3:
  - add some comments
  - fix wrong use of v4l2_async_subdev_notifier_register
  - optimize two paths capture at a time
  - remove compose
  - re-struct headers
  - add a tmp wiki page: http://opensource.rock-chips.com/wiki_Rockchip-isp1

changes in V2:
  mipi-phy:
    - use async probing
    - make it be a child device of the GRF
  isp:
    - add dummy buffer
    - change the way to get bus configuration, which make it possible to
            add parallel sensor support in the future(without mipi-phy driver).

This patch series add a ISP(Camera) v4l2 driver for rockchip rk3288/rk3399 SoC.

Wiki Pages:
http://opensource.rock-chips.com/wiki_Rockchip-isp1

The deprecated g_mbus_config op is not dropped in  V6 because i am waiting tomasz's patches.

v4l2-compliance for V6(isp params/stats nodes are passed):

    v4l2-compliance SHA   : 93dc5f20727fede5097d67f8b9adabe4b8046d5b

    Compliance test for device /dev/video0:

    Driver Info:
            Driver name      : rkisp1
            Card type        : rkisp1
            Bus info         : platform:ff910000.isp
            Driver version   : 4.16.0
            Capabilities     : 0x84201000
                    Video Capture Multiplanar
                    Streaming
                    Extended Pix Format
                    Device Capabilities
            Device Caps      : 0x04201000
                    Video Capture Multiplanar
                    Streaming
                    Extended Pix Format
    Media Driver Info:
            Driver name      : rkisp1
            Model            : rkisp1
            Serial           : 
            Bus info         : 
            Media version    : 4.16.0
            Hardware revision: 0x00000000 (0)
            Driver version   : 4.16.0
    Interface Info:
            ID               : 0x03000007
            Type             : V4L Video
    Entity Info:
            ID               : 0x00000006 (6)
            Name             : rkisp1_selfpath
            Function         : V4L2 I/O
            Pad 0x01000009   : Sink
              Link 0x02000021: from remote pad 0x1000004 of entity 'rkisp1-isp-subdev': Data, Enabled

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

    Control ioctls (Input 0):
            test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
            test VIDIOC_QUERYCTRL: OK
            test VIDIOC_G/S_CTRL: OK
            test VIDIOC_G/S/TRY_EXT_CTRLS: OK
            test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
            test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
            Standard Controls: 9 Private Controls: 0

    Format ioctls (Input 0):
            test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
            test VIDIOC_G/S_PARM: OK (Not Supported)
            test VIDIOC_G_FBUF: OK (Not Supported)
                    fail: v4l2-test-formats.cpp(330): !colorspace
                    fail: v4l2-test-formats.cpp(454): testColorspace(pix_mp.pixelformat, pix_mp.colorspace, pix_mp.ycbcr_enc, pix_m
    p.quantization)
            test VIDIOC_G_FMT: FAIL
            test VIDIOC_TRY_FMT: OK (Not Supported)
            test VIDIOC_S_FMT: OK (Not Supported)
            test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                    fail: v4l2-test-formats.cpp(1288): doioctl(node, VIDIOC_G_SELECTION, &sel) != EINVAL
            test Cropping: FAIL
            test Composing: OK (Not Supported)
            test Scaling: OK

    Codec ioctls (Input 0):
            test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
            test VIDIOC_G_ENC_INDEX: OK (Not Supported)
            test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

    Buffer ioctls (Input 0):
            test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                    fail: v4l2-test-buffers.cpp(525): VIDIOC_EXPBUF is supported, but the V4L2_MEMORY_MMAP support is missing, prob
    ably due to earlier failing format tests.
            test VIDIOC_EXPBUF: OK (Not Supported)

    Total: 44, Succeeded: 42, Failed: 2, Warnings: 0

Jacob Chen (12):
  media: doc: add document for rkisp1 meta buffer format
  media: rkisp1: add Rockchip MIPI Synopsys DPHY driver
  media: rkisp1: add Rockchip ISP1 subdev driver
  media: rkisp1: add ISP1 statistics driver
  media: rkisp1: add ISP1 params driver
  media: rkisp1: add capture device driver
  media: rkisp1: add rockchip isp1 core driver
  dt-bindings: Document the Rockchip ISP1 bindings
  dt-bindings: Document the Rockchip MIPI RX D-PHY bindings
  ARM: dts: rockchip: add isp node for rk3288
  ARM: dts: rockchip: add rx0 mipi-phy for rk3288
  MAINTAINERS: add entry for Rockchip ISP1 driver

Jeffy Chen (1):
  media: rkisp1: Add user space ABI definitions

Shunqian Zheng (3):
  media: videodev2.h, v4l2-ioctl: add rkisp1 meta buffer format
  arm64: dts: rockchip: add isp0 node for rk3399
  arm64: dts: rockchip: add rx0 mipi-phy for rk3399

Wen Nuan (1):
  ARM: dts: rockchip: Add dts mipi-dphy TXRX1 node for rk3288

 .../devicetree/bindings/media/rockchip-isp1.txt    |   69 +
 .../bindings/media/rockchip-mipi-dphy.txt          |   90 +
 Documentation/media/uapi/v4l/meta-formats.rst      |    2 +
 .../media/uapi/v4l/pixfmt-meta-rkisp1-params.rst   |   20 +
 .../media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst     |   18 +
 MAINTAINERS                                        |   10 +
 arch/arm/boot/dts/rk3288.dtsi                      |   33 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   25 +
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rockchip/isp1/Makefile      |    8 +
 drivers/media/platform/rockchip/isp1/capture.c     | 1751 ++++++++++++++++++++
 drivers/media/platform/rockchip/isp1/capture.h     |  167 ++
 drivers/media/platform/rockchip/isp1/common.h      |  110 ++
 drivers/media/platform/rockchip/isp1/dev.c         |  626 +++++++
 drivers/media/platform/rockchip/isp1/dev.h         |   93 ++
 drivers/media/platform/rockchip/isp1/isp_params.c  | 1539 +++++++++++++++++
 drivers/media/platform/rockchip/isp1/isp_params.h  |   49 +
 drivers/media/platform/rockchip/isp1/isp_stats.c   |  508 ++++++
 drivers/media/platform/rockchip/isp1/isp_stats.h   |   58 +
 .../media/platform/rockchip/isp1/mipi_dphy_sy.c    |  868 ++++++++++
 .../media/platform/rockchip/isp1/mipi_dphy_sy.h    |   15 +
 drivers/media/platform/rockchip/isp1/regs.c        |  239 +++
 drivers/media/platform/rockchip/isp1/regs.h        | 1550 +++++++++++++++++
 drivers/media/platform/rockchip/isp1/rkisp1.c      | 1177 +++++++++++++
 drivers/media/platform/rockchip/isp1/rkisp1.h      |  105 ++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 include/uapi/linux/rkisp1-config.h                 |  798 +++++++++
 include/uapi/linux/videodev2.h                     |    4 +
 29 files changed, 9945 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-isp1.txt
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-params.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-rkisp1-stat.rst
 create mode 100644 drivers/media/platform/rockchip/isp1/Makefile
 create mode 100644 drivers/media/platform/rockchip/isp1/capture.c
 create mode 100644 drivers/media/platform/rockchip/isp1/capture.h
 create mode 100644 drivers/media/platform/rockchip/isp1/common.h
 create mode 100644 drivers/media/platform/rockchip/isp1/dev.c
 create mode 100644 drivers/media/platform/rockchip/isp1/dev.h
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.c
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.h
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.c
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.h
 create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.c
 create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.h
 create mode 100644 drivers/media/platform/rockchip/isp1/regs.c
 create mode 100644 drivers/media/platform/rockchip/isp1/regs.h
 create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.c
 create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.h
 create mode 100644 include/uapi/linux/rkisp1-config.h

-- 
2.16.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38078 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751836AbdKXCh2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 21:37:28 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org,
        Jacob Chen <jacob-chen@iotwrt.com>
Subject: [PATCH v2 00/11] Rockchip ISP1 Driver
Date: Fri, 24 Nov 2017 10:36:55 +0800
Message-Id: <20171124023706.5702-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add a ISP(Camera) v4l2 driver for rockchip rk3288/rk3399 SoC.

Kernel Branch:
https://github.com/wzyy2/linux/tree/rkisp1/drivers/media/platform/rockchip/isp1

Below are some infomations about driver/hardware:

Rockchip ISP1 have many Hardware Blocks(simplied):

  MIPI      --> ISP --> DCrop(Mainpath) --> RSZ(Mainpath) --> DMA(Mainpath)
  DMA-Input -->     --> DCrop(Selfpath) --> RSZ(Selfpath) --> DMA(Selfpath);)

(Acutally the TRM(rk3288, isp) could be found online...... which contains a more detailed block diagrams ;-P)

The funcitons of each hardware block:

  Mainpath : up to 4k resolution, support raw/yuv format
  Selfpath : up tp 1080p, support rotate, support rgb/yuv format
  RSZ: scaling 
  DCrop: crop
  ISP: 3A, Color processing, Crop
  MIPI: MIPI Camera interface

Media pipelines:

  Mainpath, Selfpath <-- ISP subdev <-- MIPI  <-- Sensor
  3A stats           <--            <-- 3A parms

Code struct:

  capture.c : Mainpath, Selfpath, RSZ, DCROP : capture device.
  rkisp1.c : ISP : v4l2 sub-device.
  isp_params.c : 3A parms : output device.
  isp_stats.c : 3A stats : capture device.
  mipi_dphy_sy.c : MIPI : sperated v4l2 sub-device.

Usage:
  ChromiumOS:
    use below v4l2-ctl command to capture frames.

      v4l2-ctl --verbose -d /dev/video4 --stream-mmap=2
      --stream-to=/tmp/stream.out --stream-count=60 --stream-poll

    use below command to playback the video on your PC.

      mplayer /tmp/stream.out -loop 0 --demuxer=rawvideo
      --rawvideo=w=800:h=600:size=$((800*600*2)):format=yuy2
    or
      mplayer ./stream.out -loop 0 -demuxer rawvideo -rawvideo
      w=800:h=600:size=$((800*600*2)):format=yuy2

  Linux:
    use rkcamsrc gstreamer plugin(just a modified v4l2src) to preview.

      gst-launch-1.0 rkcamsrc device=/dev/video0 io-mode=4 disable-3A=true
      videoconvert ! video/x-raw,format=NV12,width=640,height=480 ! kmssink

Jacob Chen (7):
  media: rkisp1: add rockchip isp1 driver
  media: rkisp1: add Rockchip MIPI Synopsys DPHY driver
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

 .../devicetree/bindings/media/rockchip-isp1.txt    |   61 +
 .../bindings/media/rockchip-mipi-dphy.txt          |   77 +
 MAINTAINERS                                        |   10 +
 arch/arm/boot/dts/rk3288.dtsi                      |   24 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   26 +
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rockchip/isp1/Makefile      |    8 +
 drivers/media/platform/rockchip/isp1/capture.c     | 1691 ++++++++++++++++++++
 drivers/media/platform/rockchip/isp1/capture.h     |   46 +
 drivers/media/platform/rockchip/isp1/common.h      |  330 ++++
 drivers/media/platform/rockchip/isp1/dev.c         |  632 ++++++++
 drivers/media/platform/rockchip/isp1/isp_params.c  | 1556 ++++++++++++++++++
 drivers/media/platform/rockchip/isp1/isp_params.h  |   81 +
 drivers/media/platform/rockchip/isp1/isp_stats.c   |  537 +++++++
 drivers/media/platform/rockchip/isp1/isp_stats.h   |   81 +
 .../media/platform/rockchip/isp1/mipi_dphy_sy.c    |  805 ++++++++++
 drivers/media/platform/rockchip/isp1/regs.c        |  251 +++
 drivers/media/platform/rockchip/isp1/regs.h        | 1578 ++++++++++++++++++
 drivers/media/platform/rockchip/isp1/rkisp1.c      | 1230 ++++++++++++++
 drivers/media/platform/rockchip/isp1/rkisp1.h      |  130 ++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 include/uapi/linux/rkisp1-config.h                 |  554 +++++++
 include/uapi/linux/videodev2.h                     |    4 +
 24 files changed, 9725 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-isp1.txt
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
 create mode 100644 drivers/media/platform/rockchip/isp1/Makefile
 create mode 100644 drivers/media/platform/rockchip/isp1/capture.c
 create mode 100644 drivers/media/platform/rockchip/isp1/capture.h
 create mode 100644 drivers/media/platform/rockchip/isp1/common.h
 create mode 100644 drivers/media/platform/rockchip/isp1/dev.c
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.c
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_params.h
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.c
 create mode 100644 drivers/media/platform/rockchip/isp1/isp_stats.h
 create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.c
 create mode 100644 drivers/media/platform/rockchip/isp1/regs.c
 create mode 100644 drivers/media/platform/rockchip/isp1/regs.h
 create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.c
 create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.h
 create mode 100644 include/uapi/linux/rkisp1-config.h

-- 
2.15.0

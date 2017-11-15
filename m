Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43476 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdKOHaP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 02:30:15 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, heiko@sntech.de,
        mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com, zhengsq@rock-chips.com,
        zyc@rock-chips.com, eddie.cai.linux@gmail.com,
        jeffy.chen@rock-chips.com, allon.huang@rock-chips.com,
        p.zabel@pengutronix.de, slongerbeam@gmail.com,
        linux@armlinux.org.uk, Jacob Chen <jacob-chen@iotwrt.com>
Subject: [RFC PATCH 0/5] Rockchip ISP1 Driver
Date: Wed, 15 Nov 2017 15:29:22 +0800
Message-Id: <20171115072927.29367-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add a ISP(Camera) v4l2 driver for rockchip rk3288/rk3399 SoC.

TODO:
  - Thomas is rewriting the binding code between isp, phy, sensors, i hope we could get suggestions.
        https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/768633/2
    rules:
      - There are many mipi interfaces("rx0", "dxrx0")(actually it also could be parallel interface) in SoC and isp can decide which one will be used.
      - Sometimes there will be more than one senor in a mipi phy, the sofrware should decide which one is used(media link).
      - rk3399 have two isp.
  - Add a dummy buffer(dma_alloc_coherent) so drvier won't hold buffer.
  - Finish all TODO comments(mostly about hardware) in driver.

To help do a quick review, i have push source code to my Github.
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

Jacob Chen (2):
  media: rkisp1: add rockchip isp1 driver
  ARM: dts: rockchip: add isp node for rk3288

Jeffy Chen (1):
  media: rkisp1: Add user space ABI definitions

Shunqian Zheng (2):
  media: videodev2.h, v4l2-ioctl: add rkisp1 meta buffer format
  arm64: dts: rockchip: add isp0 node for rk3399

 arch/arm/boot/dts/rk3288.dtsi                      |   24 +
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   26 +
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/rockchip/isp1/Makefile      |    9 +
 drivers/media/platform/rockchip/isp1/capture.c     | 1678 ++++++++++++++++++++
 drivers/media/platform/rockchip/isp1/capture.h     |   46 +
 drivers/media/platform/rockchip/isp1/common.h      |  327 ++++
 drivers/media/platform/rockchip/isp1/dev.c         |  728 +++++++++
 drivers/media/platform/rockchip/isp1/isp_params.c  | 1556 ++++++++++++++++++
 drivers/media/platform/rockchip/isp1/isp_params.h  |   81 +
 drivers/media/platform/rockchip/isp1/isp_stats.c   |  537 +++++++
 drivers/media/platform/rockchip/isp1/isp_stats.h   |   81 +
 .../media/platform/rockchip/isp1/mipi_dphy_sy.c    |  619 ++++++++
 .../media/platform/rockchip/isp1/mipi_dphy_sy.h    |   42 +
 drivers/media/platform/rockchip/isp1/regs.c        |  251 +++
 drivers/media/platform/rockchip/isp1/regs.h        | 1578 ++++++++++++++++++
 drivers/media/platform/rockchip/isp1/rkisp1.c      | 1132 +++++++++++++
 drivers/media/platform/rockchip/isp1/rkisp1.h      |  130 ++
 drivers/media/v4l2-core/v4l2-ioctl.c               |    2 +
 include/uapi/linux/rkisp1-config.h                 |  554 +++++++
 include/uapi/linux/videodev2.h                     |    4 +
 22 files changed, 9416 insertions(+)
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
 create mode 100644 drivers/media/platform/rockchip/isp1/mipi_dphy_sy.h
 create mode 100644 drivers/media/platform/rockchip/isp1/regs.c
 create mode 100644 drivers/media/platform/rockchip/isp1/regs.h
 create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.c
 create mode 100644 drivers/media/platform/rockchip/isp1/rkisp1.h
 create mode 100644 include/uapi/linux/rkisp1-config.h

-- 
2.14.2

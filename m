Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47729 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaFGV5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:00 -0400
Received: by mail-pb0-f43.google.com with SMTP id up15so3901203pbc.2
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:56:59 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 00/43] i.MX6 Video capture
Date: Sat,  7 Jun 2014 14:56:02 -0700
Message-Id: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch set adds video capture support for the Freescale i.MX6 SOC.

It is a from-scratch standardized driver that works with community
v4l2 utilities, such as v4l2-ctl, v4l2-cap, and the v4l2src gstreamer
plugin. It uses the latest v4l2 interfaces (subdev, videobuf2).
Please see Documentation/video4linux/mx6_camera.txt for it's full list
of features!

The first 38 patches:

- prepare the ipu-v3 driver for video capture support. The current driver
  contains only video display functionality to support the imx DRM drivers.
  At some point ipu-v3 should be moved out from under staging/imx-drm since
  it will no longer only support DRM.

- Adds the device tree nodes and OF graph bindings for video capture support
  on sabrelite, sabresd, and sabreauto reference platforms.

The new i.MX6 capture host interface driver is at patch 39.

To support the sensors found on the sabrelite, sabresd, and sabreauto,
three patches add sensor subdev's for parallel OV5642, MIPI CSI-2 OV5640,
and the ADV7180 decoder chip, beginning at patch 40.

There is an existing adv7180 subdev driver under drivers/media/i2c, but
it needs some extra functionality to work on the sabreauto. It will need
OF graph bindings support and gpio for a power-on pin on the sabreauto.
It would also need to send a new subdev notification to take advantage
of decoder status change handling provided by the host driver. This
feature makes it possible to correctly handle "hot" (while streaming)
signal lock/unlock and autodetected video standard changes.

Usage notes are found in Documentation/video4linux/mx6_camera.txt for the
above three reference platforms.

The driver source is under drivers/staging/media/imx6/capture/.


Steve Longerbeam (43):
  imx-drm: ipu-v3: Move imx-ipu-v3.h to include/linux/platform_data/
  ARM: dts: imx6qdl: Add ipu aliases
  imx-drm: ipu-v3: Add ipu_get_num()
  imx-drm: ipu-v3: Add solo/dual-lite IPU device type
  imx-drm: ipu-v3: Map IOMUXC registers
  imx-drm: ipu-v3: Add functions to set CSI/IC source muxes
  imx-drm: ipu-v3: Rename and add IDMAC channels
  imx-drm: ipu-v3: Add units required for video capture
  imx-drm: ipu-v3: Add ipu_mbus_code_to_colorspace()
  imx-drm: ipu-v3: Add rotation mode conversion utilities
  imx-drm: ipu-v3: Add helper function checking if pixfmt is planar
  imx-drm: ipu-v3: Move IDMAC channel names to imx-ipu-v3.h
  imx-drm: ipu-v3: Add ipu_idmac_buffer_is_ready()
  imx-drm: ipu-v3: Add ipu_idmac_clear_buffer()
  imx-drm: ipu-v3: Add ipu_idmac_current_buffer()
  imx-drm: ipu-v3: Add __ipu_idmac_reset_current_buffer()
  imx-drm: ipu-v3: Add ipu_stride_to_bytes()
  imx-drm: ipu-v3: Add ipu_idmac_enable_watermark()
  imx-drm: ipu-v3: Add ipu_idmac_lock_enable()
  imx-drm: ipu-v3: Add idmac channel linking support
  imx-drm: ipu-v3: Add ipu_bits_per_pixel()
  imx-drm: ipu-v3: Add ipu-cpmem unit
  imx-drm: ipu-cpmem: Add ipu_cpmem_set_block_mode()
  imx-drm: ipu-cpmem: Add ipu_cpmem_set_axi_id()
  imx-drm: ipu-cpmem: Add ipu_cpmem_set_rotation()
  imx-drm: ipu-cpmem: Add second buffer support to ipu_cpmem_set_image()
  imx-drm: ipu-v3: Add more planar formats support
  imx-drm: ipu-cpmem: Add ipu_cpmem_dump()
  imx-drm: ipu-v3: Add ipu_dump()
  ARM: dts: imx6: add pin groups for imx6q/dl for IPU1 CSI0
  ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
  ARM: dts: imx: sabrelite: add video capture ports and endpoints
  ARM: dts: imx6-sabresd: add video capture ports and endpoints
  ARM: dts: imx6-sabreauto: add video capture ports and endpoints
  ARM: dts: imx6qdl: Add simple-bus to ipu compatibility
  gpio: pca953x: Add reset-gpios property
  ARM: imx6q: clk: Add video 27m clock
  media: imx6: Add device tree binding documentation
  media: Add new camera interface driver for i.MX6
  media: imx6: Add support for MIPI CSI-2 OV5640
  media: imx6: Add support for Parallel OV5642
  media: imx6: Add support for ADV7180 Video Decoder
  ARM: imx_v6_v7_defconfig: Enable video4linux drivers

 .../devicetree/bindings/clock/imx6q-clock.txt      |    1 +
 Documentation/devicetree/bindings/media/imx6.txt   |  433 ++
 .../bindings/staging/imx-drm/fsl-imx-drm.txt       |    6 +-
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/video4linux/mx6_camera.txt           |  188 +
 arch/arm/boot/dts/imx6q.dtsi                       |    3 +-
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  149 +
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |   91 +
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  116 +
 arch/arm/boot/dts/imx6qdl.dtsi                     |   62 +-
 arch/arm/configs/imx_v6_v7_defconfig               |    4 +
 arch/arm/mach-imx/clk-imx6q.c                      |    3 +-
 drivers/gpio/gpio-pca953x.c                        |   26 +
 drivers/staging/imx-drm/imx-hdmi.c                 |    2 +-
 drivers/staging/imx-drm/imx-tve.c                  |    2 +-
 drivers/staging/imx-drm/ipu-v3/Makefile            |    3 +-
 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h        |  326 --
 drivers/staging/imx-drm/ipu-v3/ipu-common.c        | 1151 ++++--
 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c         |  814 ++++
 drivers/staging/imx-drm/ipu-v3/ipu-csi.c           |  821 ++++
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-di.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c          |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c            |    2 +-
 drivers/staging/imx-drm/ipu-v3/ipu-ic.c            |  835 ++++
 drivers/staging/imx-drm/ipu-v3/ipu-irt.c           |  103 +
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h           |  126 +-
 drivers/staging/imx-drm/ipu-v3/ipu-smfc.c          |  348 ++
 drivers/staging/imx-drm/ipuv3-crtc.c               |    2 +-
 drivers/staging/imx-drm/ipuv3-plane.c              |   18 +-
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/imx6/Kconfig                 |   25 +
 drivers/staging/media/imx6/Makefile                |    1 +
 drivers/staging/media/imx6/capture/Kconfig         |   33 +
 drivers/staging/media/imx6/capture/Makefile        |    7 +
 drivers/staging/media/imx6/capture/adv7180.c       | 1298 ++++++
 drivers/staging/media/imx6/capture/mipi-csi2.c     |  322 ++
 drivers/staging/media/imx6/capture/mx6-camif.c     | 2235 ++++++++++
 drivers/staging/media/imx6/capture/mx6-camif.h     |  197 +
 drivers/staging/media/imx6/capture/mx6-encode.c    |  775 ++++
 drivers/staging/media/imx6/capture/mx6-preview.c   |  748 ++++
 drivers/staging/media/imx6/capture/ov5640-mipi.c   | 2158 ++++++++++
 drivers/staging/media/imx6/capture/ov5642.c        | 4258 ++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h           |  425 ++
 include/media/imx6.h                               |   18 +
 46 files changed, 17340 insertions(+), 805 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/imx6.txt
 create mode 100644 Documentation/video4linux/mx6_camera.txt
 delete mode 100644 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-csi.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-ic.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-irt.c
 create mode 100644 drivers/staging/imx-drm/ipu-v3/ipu-smfc.c
 create mode 100644 drivers/staging/media/imx6/Kconfig
 create mode 100644 drivers/staging/media/imx6/Makefile
 create mode 100644 drivers/staging/media/imx6/capture/Kconfig
 create mode 100644 drivers/staging/media/imx6/capture/Makefile
 create mode 100644 drivers/staging/media/imx6/capture/adv7180.c
 create mode 100644 drivers/staging/media/imx6/capture/mipi-csi2.c
 create mode 100644 drivers/staging/media/imx6/capture/mx6-camif.c
 create mode 100644 drivers/staging/media/imx6/capture/mx6-camif.h
 create mode 100644 drivers/staging/media/imx6/capture/mx6-encode.c
 create mode 100644 drivers/staging/media/imx6/capture/mx6-preview.c
 create mode 100644 drivers/staging/media/imx6/capture/ov5640-mipi.c
 create mode 100644 drivers/staging/media/imx6/capture/ov5642.c
 create mode 100644 include/linux/platform_data/imx-ipu-v3.h
 create mode 100644 include/media/imx6.h

-- 
1.7.9.5


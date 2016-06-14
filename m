Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34655 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbcFNWvF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:05 -0400
Received: by mail-pf0-f193.google.com with SMTP id 66so305533pfy.1
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:04 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 00/38] i.MX5/6 Video Capture
Date: Tue, 14 Jun 2016 15:48:56 -0700
Message-Id: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested on imx6q SabreAuto with ADV7180, and imx6q SabreSD with
mipi-csi2 OV5640. There is device-tree support also for imx6qdl
SabreLite, but that is not tested. Also, this driver should
theoretically work on i.MX5 targets, but that is also untested.

Not run through v4l2-compliance yet, but that is in my queue.


Philipp Zabel (2):
  ARM: dts: imx6qdl: Add mipi_ipu1/2 video muxes, mipi_csi, and their
    connections
  media: imx: Add video switch

Steve Longerbeam (35):
  gpu: ipu-v3: Add Video Deinterlacer unit
  gpu: ipu-cpmem: Add ipu_cpmem_set_uv_offset()
  gpu: ipu-cpmem: Add ipu_cpmem_get_burstsize()
  gpu: ipu-v3: Add ipu_get_num()
  gpu: ipu-v3: Add IDMA channel linking support
  gpu: ipu-v3: Add ipu_set_vdi_src_mux()
  gpu: ipu-v3: Add VDI input IDMAC channels
  gpu: ipu-v3: Add ipu_csi_set_src()
  gpu: ipu-v3: Add ipu_ic_set_src()
  gpu: ipu-v3: set correct full sensor frame for PAL/NTSC
  gpu: ipu-v3: Fix CSI data format for 16-bit media bus formats
  gpu: ipu-v3: Fix IRT usage
  gpu: ipu-ic: Add complete image conversion support with tiling
  gpu: ipu-ic: allow multiple handles to ic
  gpu: ipu-v3: rename CSI client device
  ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
  ARM: dts: imx6-sabrelite: add video capture ports and connections
  ARM: dts: imx6-sabresd: add video capture ports and connections
  ARM: dts: imx6-sabreauto: create i2cmux for i2c3
  ARM: dts: imx6-sabreauto: add reset-gpios property for max7310
  ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
  ARM: dts: imx6-sabreauto: add video capture ports and connections
  ARM: dts: imx6qdl: add mem2mem device for sabre* boards
  gpio: pca953x: Add reset-gpios property
  clocksource/drivers/imx: add input capture support
  v4l: Add signal lock status to source change events
  media: Add camera interface driver for i.MX5/6
  media: imx: Add MIPI CSI-2 Receiver driver
  media: imx: Add support for MIPI CSI-2 OV5640
  media: imx: Add support for Parallel OV5642
  media: imx: Add support for ADV7180 Video Decoder
  media: adv7180: add power pin control
  media: adv7180: implement g_parm
  media: Add i.MX5/6 mem2mem driver
  ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers

Suresh Dhandapani (1):
  gpu: ipu-v3: Fix CSI0 blur in NTSC format

 Documentation/DocBook/media/v4l/vidioc-dqevent.xml |   12 +-
 Documentation/devicetree/bindings/media/imx.txt    |  449 ++
 Documentation/video4linux/imx_camera.txt           |  243 ++
 arch/arm/boot/dts/imx6dl-sabresd.dts               |   44 +
 arch/arm/boot/dts/imx6dl.dtsi                      |  183 +
 arch/arm/boot/dts/imx6q-sabreauto.dts              |    7 +
 arch/arm/boot/dts/imx6q-sabrelite.dts              |    6 +
 arch/arm/boot/dts/imx6q-sabresd.dts                |   22 +
 arch/arm/boot/dts/imx6q.dtsi                       |  120 +
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  166 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |   95 +
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  145 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   13 +
 arch/arm/configs/imx_v6_v7_defconfig               |    2 +
 drivers/clocksource/timer-imx-gpt.c                |  463 ++-
 drivers/gpio/gpio-pca953x.c                        |   28 +
 drivers/gpu/ipu-v3/Makefile                        |    2 +-
 drivers/gpu/ipu-v3/ipu-common.c                    |  155 +-
 drivers/gpu/ipu-v3/ipu-cpmem.c                     |   13 +
 drivers/gpu/ipu-v3/ipu-csi.c                       |   36 +-
 drivers/gpu/ipu-v3/ipu-ic.c                        | 1769 +++++++-
 drivers/gpu/ipu-v3/ipu-prv.h                       |    7 +
 drivers/gpu/ipu-v3/ipu-vdi.c                       |  266 ++
 drivers/media/i2c/adv7180.c                        |   73 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/imx/Kconfig                  |   35 +
 drivers/staging/media/imx/Makefile                 |    2 +
 drivers/staging/media/imx/capture/Kconfig          |   42 +
 drivers/staging/media/imx/capture/Makefile         |   10 +
 drivers/staging/media/imx/capture/adv7180.c        | 1533 +++++++
 drivers/staging/media/imx/capture/imx-camif.c      | 2496 +++++++++++
 drivers/staging/media/imx/capture/imx-camif.h      |  281 ++
 drivers/staging/media/imx/capture/imx-csi.c        |  195 +
 drivers/staging/media/imx/capture/imx-ic-prpenc.c  |  660 +++
 drivers/staging/media/imx/capture/imx-of.c         |  354 ++
 drivers/staging/media/imx/capture/imx-of.h         |   18 +
 drivers/staging/media/imx/capture/imx-smfc.c       |  505 +++
 drivers/staging/media/imx/capture/imx-vdic.c       |  994 +++++
 .../staging/media/imx/capture/imx-video-switch.c   |  348 ++
 drivers/staging/media/imx/capture/mipi-csi2.c      |  373 ++
 drivers/staging/media/imx/capture/ov5640-mipi.c    | 2318 +++++++++++
 drivers/staging/media/imx/capture/ov5642.c         | 4333 ++++++++++++++++++++
 drivers/staging/media/imx/m2m/Makefile             |    1 +
 drivers/staging/media/imx/m2m/imx-m2m.c            | 1049 +++++
 include/linux/mxc_icap.h                           |   20 +
 include/media/imx.h                                |   15 +
 include/uapi/Kbuild                                |    1 +
 include/uapi/linux/v4l2-controls.h                 |    8 +
 include/uapi/linux/videodev2.h                     |    1 +
 include/uapi/media/Kbuild                          |    3 +
 include/uapi/media/adv718x.h                       |   42 +
 include/uapi/media/imx.h                           |   22 +
 include/video/imx-ipu-v3.h                         |   96 +-
 54 files changed, 19946 insertions(+), 131 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt
 create mode 100644 Documentation/video4linux/imx_camera.txt
 create mode 100644 drivers/gpu/ipu-v3/ipu-vdi.c
 create mode 100644 drivers/staging/media/imx/Kconfig
 create mode 100644 drivers/staging/media/imx/Makefile
 create mode 100644 drivers/staging/media/imx/capture/Kconfig
 create mode 100644 drivers/staging/media/imx/capture/Makefile
 create mode 100644 drivers/staging/media/imx/capture/adv7180.c
 create mode 100644 drivers/staging/media/imx/capture/imx-camif.c
 create mode 100644 drivers/staging/media/imx/capture/imx-camif.h
 create mode 100644 drivers/staging/media/imx/capture/imx-csi.c
 create mode 100644 drivers/staging/media/imx/capture/imx-ic-prpenc.c
 create mode 100644 drivers/staging/media/imx/capture/imx-of.c
 create mode 100644 drivers/staging/media/imx/capture/imx-of.h
 create mode 100644 drivers/staging/media/imx/capture/imx-smfc.c
 create mode 100644 drivers/staging/media/imx/capture/imx-vdic.c
 create mode 100644 drivers/staging/media/imx/capture/imx-video-switch.c
 create mode 100644 drivers/staging/media/imx/capture/mipi-csi2.c
 create mode 100644 drivers/staging/media/imx/capture/ov5640-mipi.c
 create mode 100644 drivers/staging/media/imx/capture/ov5642.c
 create mode 100644 drivers/staging/media/imx/m2m/Makefile
 create mode 100644 drivers/staging/media/imx/m2m/imx-m2m.c
 create mode 100644 include/linux/mxc_icap.h
 create mode 100644 include/media/imx.h
 create mode 100644 include/uapi/media/Kbuild
 create mode 100644 include/uapi/media/adv718x.h
 create mode 100644 include/uapi/media/imx.h

-- 
1.9.1


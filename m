Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34855 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933065AbdAGCL5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 21:11:57 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 00/24] i.MX Media Driver
Date: Fri,  6 Jan 2017 18:11:18 -0800
Message-Id: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In version 3:

Changes suggested by Rob Herring <robh@kernel.org>:

  - prepended FIM node properties with vendor prefix "fsl,".

  - make mipi csi-2 receiver compatible string SoC specific:
    "fsl,imx6-mipi-csi2" instead of "fsl,imx-mipi-csi2".

  - redundant "_clk" removed from mipi csi-2 receiver clock-names property.

  - removed board-specific info from the media driver binding doc. These
    were all related to sensor bindings, which already are (adv7180)
    or will be (ov564x) covered in separate binding docs. All reference
    board info not related to DT bindings has been moved to
    Documentation/media/v4l-drivers/imx.rst.

  - removed "_mipi" from the OV5640 compatible string.

Changes suggested by Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>:

  Mostly cosmetic/non-functional changes which I won't list here, except
  for the following:

  - spin_lock_irqsave() changed to spin_lock() in a couple interrupt handlers.

  - fixed some unnecessary of_node_put()'s in for_each_child_of_node() loops.

  - check/handle return code from required reg property of CSI port nodes.

  - check/handle return code from clk_prepare_enable().

Changes suggested by Fabio Estevam <festevam@gmail.com>:

  - switch to VGEN3 Analog Vdd supply assuming rev. C SabreSD boards.

  - finally got around to passing valid IOMUX pin config values to the
    pin groups.

Other changes:

  - removed the FIM properties that overrided the v4l2 FIM control defaults
    values. This was left-over from a requirement of a customer and is not
    necessary here.

  - The FIM must be explicitly enabled in the fim child node under the CSI
    port nodes, using the status property. If not enabled, FIM v4l2 controls
    will not appear in the video capture driver.

  - brought in additional media types patch from Philipp Zabel. Use new
    MEDIA_ENT_F_VID_IF_BRIDGE in mipi csi-2 receiver subdev.

  - brought in latest platform generic video multiplexer subdevice driver
    from Philipp Zabel (squashed with patch that uses new MEDIA_ENT_F_MUX).

  - removed imx-media-of.h, moved those prototypes into imx-media.h.


Philipp Zabel (3):
  ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
    connections
  add mux and video interface bridge entity functions
  platform: add video-multiplexer subdevice driver

Steve Longerbeam (21):
  [media] dt-bindings: Add bindings for i.MX media driver
  ARM: dts: imx6qdl: Add compatible, clocks, irqs to MIPI CSI-2 node
  ARM: dts: imx6qdl: add media device
  ARM: dts: imx6qdl-sabrelite: remove erratum ERR006687 workaround
  ARM: dts: imx6-sabrelite: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabreauto: create i2cmux for i2c3
  ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
  ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
  ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
  UAPI: Add media UAPI Kbuild file
  media: Add userspace header file for i.MX
  media: Add i.MX media core driver
  media: imx: Add CSI subdev driver
  media: imx: Add SMFC subdev driver
  media: imx: Add IC subdev drivers
  media: imx: Add Camera Interface subdev driver
  media: imx: Add MIPI CSI-2 Receiver subdev driver
  media: imx: Add MIPI CSI-2 OV5640 sensor subdev driver
  media: imx: Add Parallel OV5642 sensor subdev driver
  ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers

 Documentation/devicetree/bindings/media/imx.txt    |   57 +
 .../bindings/media/video-multiplexer.txt           |   59 +
 Documentation/media/uapi/mediactl/media-types.rst  |   22 +
 Documentation/media/v4l-drivers/imx.rst            |  443 ++
 arch/arm/boot/dts/imx6dl-sabrelite.dts             |    5 +
 arch/arm/boot/dts/imx6dl-sabresd.dts               |    5 +
 arch/arm/boot/dts/imx6dl.dtsi                      |  187 +
 arch/arm/boot/dts/imx6q-sabrelite.dts              |    6 +
 arch/arm/boot/dts/imx6q-sabresd.dts                |    5 +
 arch/arm/boot/dts/imx6q.dtsi                       |  127 +
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  147 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |  122 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  114 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   25 +-
 arch/arm/configs/imx_v6_v7_defconfig               |   12 +-
 drivers/media/platform/Kconfig                     |    8 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/video-multiplexer.c         |  472 +++
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/imx/Kconfig                  |   36 +
 drivers/staging/media/imx/Makefile                 |   15 +
 drivers/staging/media/imx/TODO                     |   22 +
 drivers/staging/media/imx/imx-camif.c              | 1000 +++++
 drivers/staging/media/imx/imx-csi.c                |  644 +++
 drivers/staging/media/imx/imx-ic-common.c          |  109 +
 drivers/staging/media/imx/imx-ic-pp.c              |  636 +++
 drivers/staging/media/imx/imx-ic-prpenc.c          | 1033 +++++
 drivers/staging/media/imx/imx-ic-prpvf.c           | 1179 ++++++
 drivers/staging/media/imx/imx-ic.h                 |   38 +
 drivers/staging/media/imx/imx-media-common.c       |  981 +++++
 drivers/staging/media/imx/imx-media-dev.c          |  486 +++
 drivers/staging/media/imx/imx-media-fim.c          |  471 +++
 drivers/staging/media/imx/imx-media-internal-sd.c  |  457 ++
 drivers/staging/media/imx/imx-media-of.c           |  289 ++
 drivers/staging/media/imx/imx-media.h              |  310 ++
 drivers/staging/media/imx/imx-mipi-csi2.c          |  501 +++
 drivers/staging/media/imx/imx-smfc.c               |  737 ++++
 drivers/staging/media/imx/ov5640-mipi.c            | 2348 +++++++++++
 drivers/staging/media/imx/ov5642.c                 | 4363 ++++++++++++++++++++
 include/media/imx.h                                |   15 +
 include/uapi/Kbuild                                |    1 +
 include/uapi/linux/media.h                         |    6 +
 include/uapi/linux/v4l2-controls.h                 |    4 +
 include/uapi/media/Kbuild                          |    2 +
 include/uapi/media/imx.h                           |   30 +
 46 files changed, 17505 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-multiplexer.txt
 create mode 100644 Documentation/media/v4l-drivers/imx.rst
 create mode 100644 drivers/media/platform/video-multiplexer.c
 create mode 100644 drivers/staging/media/imx/Kconfig
 create mode 100644 drivers/staging/media/imx/Makefile
 create mode 100644 drivers/staging/media/imx/TODO
 create mode 100644 drivers/staging/media/imx/imx-camif.c
 create mode 100644 drivers/staging/media/imx/imx-csi.c
 create mode 100644 drivers/staging/media/imx/imx-ic-common.c
 create mode 100644 drivers/staging/media/imx/imx-ic-pp.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prpenc.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prpvf.c
 create mode 100644 drivers/staging/media/imx/imx-ic.h
 create mode 100644 drivers/staging/media/imx/imx-media-common.c
 create mode 100644 drivers/staging/media/imx/imx-media-dev.c
 create mode 100644 drivers/staging/media/imx/imx-media-fim.c
 create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
 create mode 100644 drivers/staging/media/imx/imx-media-of.c
 create mode 100644 drivers/staging/media/imx/imx-media.h
 create mode 100644 drivers/staging/media/imx/imx-mipi-csi2.c
 create mode 100644 drivers/staging/media/imx/imx-smfc.c
 create mode 100644 drivers/staging/media/imx/ov5640-mipi.c
 create mode 100644 drivers/staging/media/imx/ov5642.c
 create mode 100644 include/media/imx.h
 create mode 100644 include/uapi/media/Kbuild
 create mode 100644 include/uapi/media/imx.h

-- 
2.7.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34203 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933379AbdACU5i (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:57:38 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 00/19] i.MX Media Driver
Date: Tue,  3 Jan 2017 12:57:10 -0800
Message-Id: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In version 2 (no functional changes):

- removed patch "gpio: pca953x: Add optional reset gpio control", it
  has been submitted separately.
- fixed some whitespace errors.
- added a few missing Signed-off-by's.


Philipp Zabel (2):
  ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
    connections
  media: imx: Add video switch subdev driver

Steve Longerbeam (17):
  ARM: dts: imx6qdl: Add compatible, clocks, irqs to MIPI CSI-2 node
  ARM: dts: imx6qdl: add media device
  ARM: dts: imx6-sabrelite: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabreauto: create i2cmux for i2c3
  ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
  ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
  ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
  media: Add i.MX media core driver
  media: imx: Add CSI subdev driver
  media: imx: Add SMFC subdev driver
  media: imx: Add IC subdev drivers
  media: imx: Add Camera Interface subdev driver
  media: imx: Add MIPI CSI-2 Receiver subdev driver
  media: imx: Add MIPI CSI-2 OV5640 sensor subdev driver
  media: imx: Add Parallel OV5642 sensor subdev driver
  ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers

 Documentation/devicetree/bindings/media/imx.txt   |  205 +
 Documentation/media/v4l-drivers/imx.rst           |  430 ++
 arch/arm/boot/dts/imx6dl-sabrelite.dts            |    5 +
 arch/arm/boot/dts/imx6dl-sabresd.dts              |    5 +
 arch/arm/boot/dts/imx6dl.dtsi                     |  183 +
 arch/arm/boot/dts/imx6q-sabrelite.dts             |    6 +
 arch/arm/boot/dts/imx6q-sabresd.dts               |    5 +
 arch/arm/boot/dts/imx6q.dtsi                      |  123 +
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi          |  142 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi          |  122 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi            |  114 +-
 arch/arm/boot/dts/imx6qdl.dtsi                    |   25 +-
 arch/arm/configs/imx_v6_v7_defconfig              |   10 +-
 drivers/staging/media/Kconfig                     |    2 +
 drivers/staging/media/Makefile                    |    1 +
 drivers/staging/media/imx/Kconfig                 |   36 +
 drivers/staging/media/imx/Makefile                |   16 +
 drivers/staging/media/imx/TODO                    |   18 +
 drivers/staging/media/imx/imx-camif.c             | 1010 +++++
 drivers/staging/media/imx/imx-csi.c               |  638 +++
 drivers/staging/media/imx/imx-ic-common.c         |  113 +
 drivers/staging/media/imx/imx-ic-pp.c             |  636 +++
 drivers/staging/media/imx/imx-ic-prpenc.c         | 1037 +++++
 drivers/staging/media/imx/imx-ic-prpvf.c          | 1180 ++++++
 drivers/staging/media/imx/imx-ic.h                |   36 +
 drivers/staging/media/imx/imx-media-common.c      |  985 +++++
 drivers/staging/media/imx/imx-media-dev.c         |  479 +++
 drivers/staging/media/imx/imx-media-fim.c         |  509 +++
 drivers/staging/media/imx/imx-media-internal-sd.c |  457 +++
 drivers/staging/media/imx/imx-media-of.c          |  291 ++
 drivers/staging/media/imx/imx-media-of.h          |   25 +
 drivers/staging/media/imx/imx-media.h             |  299 ++
 drivers/staging/media/imx/imx-mipi-csi2.c         |  509 +++
 drivers/staging/media/imx/imx-smfc.c              |  739 ++++
 drivers/staging/media/imx/imx-video-switch.c      |  351 ++
 drivers/staging/media/imx/ov5640-mipi.c           | 2349 +++++++++++
 drivers/staging/media/imx/ov5642.c                | 4364 +++++++++++++++++++++
 include/media/imx.h                               |   15 +
 include/uapi/Kbuild                               |    1 +
 include/uapi/linux/v4l2-controls.h                |    4 +
 include/uapi/media/Kbuild                         |    2 +
 include/uapi/media/imx.h                          |   30 +
 42 files changed, 17479 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt
 create mode 100644 Documentation/media/v4l-drivers/imx.rst
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
 create mode 100644 drivers/staging/media/imx/imx-media-of.h
 create mode 100644 drivers/staging/media/imx/imx-media.h
 create mode 100644 drivers/staging/media/imx/imx-mipi-csi2.c
 create mode 100644 drivers/staging/media/imx/imx-smfc.c
 create mode 100644 drivers/staging/media/imx/imx-video-switch.c
 create mode 100644 drivers/staging/media/imx/ov5640-mipi.c
 create mode 100644 drivers/staging/media/imx/ov5642.c
 create mode 100644 include/media/imx.h
 create mode 100644 include/uapi/media/Kbuild
 create mode 100644 include/uapi/media/imx.h

-- 
2.7.4


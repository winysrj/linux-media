Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36721 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751690AbdFGSeX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 14:34:23 -0400
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
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v8 00/34] i.MX Media Driver
Date: Wed,  7 Jun 2017 11:33:39 -0700
Message-Id: <1496860453-6282-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In version 8:

- Switched to v4l2_fwnode APIs.

- Always pass a valid CSI id to ipu_set_ic_src_mux() in imx-ic-prp, even
  if the IC is receiving from the VDIC. The reason is due to a bug in the
  i.MX6 reference manual: from experiment it is determined that the CSI id
  select bit in IPU_CONF register selects which CSI is routed to either
  the VDIC or the IC, and is independent of whether the IC is set to
  receive from a CSI or the VDIC. Sugested by Marek Vasut <marex@denx.de>.

- ov5640: propagate error codes from all i2c register accesses.
  Sugested by Sakari Ailus <sakari.ailus@iki.fi>.

- ov5640: drop the entity stream count check in ov5640_s_stream().
  Sugested by Sakari Ailus <sakari.ailus@iki.fi>.

- ov5640: Fix manual exposure control. The manual exposure setting
  (in line periods) cannot exceed the max exposure value in registers
  {0x380E, 0x380F} + {0x350C,0x350D}, however the max eposure value was
  not being calcualted correctly.

- ov5640: the video mode register tables require auto gain/exposure be
  disabled before programming the register set. However auto gain/exp was
  being disabled by direct register write. This caused the auto gain/exp
  control values to be inconsistent with the actual hardware setting. Fixed
  by going through v4l2-ctrl when disabling auto gain/exp.

- ov5640: converted virtual channel macro to a module parameter, default
  to channel 0.

- ov5640: override the v4l2-ctl lock to use the ov5640 subdev driver's
  lock. Sugested by Sakari Ailus <sakari.ailus@iki.fi>.

- ov5640: switch to unit-less V4L2_CID_EXPOSURE. Using
  V4L2_CID_EXPOSURE_ABSOLUTE will require converting from 100-usec units
  to line periods and vice-versa. Sugested by Sakari Ailus and
  Pavel Machek <pavel@ucw.cz>.

- ov5640: drop dangling regulator_bulk_disable() from probe/remove.
  Sugested by Sakari Ailus <sakari.ailus@iki.fi>.

- FIM: move input capture channel selection out of the device-tree and
  make this a V4L2 control. In order to support attaching a FIM to prpencvf,
  the FIM cannot have any device-tree configuration, because prpencvf has
  no device node. The FIM now is completely configurable via its V4L2
  controls.

- FIM: drop imx_media_fim_set_power(), and move the input capture channel
  request to imx_media_fim_set_stream(). This allows to drop csi_s_power()
  as well, since the latter only called imx_media_fim_set_power().

- FIM: add a spinlock to protect the frame_interval_monitor() from the
  setting of new control values. The frame_interval_monitor() is called
  from interrupt context so a spinlock must be used.

- Updated to version 8 video-mux patchset from Philipp Zabel
  <p.zabel@pengutronix.de>.


Marek Vasut (1):
  media: imx: Drop warning upon multiple S_STREAM disable calls

Philipp Zabel (8):
  dt-bindings: Add bindings for video-multiplexer device
  ARM: dts: imx6qdl: add multiplexer controls
  ARM: dts: imx6qdl: Add video multiplexers, mipi_csi, and their
    connections
  add mux and video interface bridge entity functions
  platform: add video-multiplexer subdevice driver
  media: imx: csi: increase burst size for YUV formats
  media: imx: csi: add frame skipping support
  media: imx: csi: add sink selection rectangles

Russell King (3):
  media: imx: csi: add support for bayer formats
  media: imx: csi: add frame size/interval enumeration
  media: imx: capture: add frame sizes/interval enumeration

Steve Longerbeam (22):
  [media] dt-bindings: Add bindings for i.MX media driver
  [media] dt/bindings: Add bindings for OV5640
  ARM: dts: imx6qdl: Add compatible, clocks, irqs to MIPI CSI-2 node
  ARM: dts: imx6qdl: add capture-subsystem device
  ARM: dts: imx6qdl-sabrelite: remove erratum ERR006687 workaround
  ARM: dts: imx6-sabrelite: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabreauto: create i2cmux for i2c3
  ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
  ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
  ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
  [media] add Omnivision OV5640 sensor driver
  media: Add userspace header file for i.MX
  media: Add i.MX media core driver
  media: imx: Add a TODO file
  media: imx: Add Capture Device Interface
  media: imx: Add CSI subdev driver
  media: imx: Add VDIC subdev driver
  media: imx: Add IC subdev drivers
  media: imx: Add MIPI CSI-2 Receiver subdev driver
  media: imx: set and propagate default field, colorimetry
  ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers

 .../devicetree/bindings/media/i2c/ov5640.txt       |   45 +
 Documentation/devicetree/bindings/media/imx.txt    |   47 +
 .../devicetree/bindings/media/video-mux.txt        |   60 +
 Documentation/media/uapi/mediactl/media-types.rst  |   21 +
 Documentation/media/v4l-drivers/imx.rst            |  614 +++++
 arch/arm/boot/dts/imx6dl-sabrelite.dts             |    5 +
 arch/arm/boot/dts/imx6dl-sabresd.dts               |    5 +
 arch/arm/boot/dts/imx6dl.dtsi                      |  189 ++
 arch/arm/boot/dts/imx6q-sabrelite.dts              |    5 +
 arch/arm/boot/dts/imx6q-sabresd.dts                |    5 +
 arch/arm/boot/dts/imx6q.dtsi                       |  125 ++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  136 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |  152 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  114 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   20 +-
 arch/arm/configs/imx_v6_v7_defconfig               |   11 +
 drivers/media/i2c/Kconfig                          |   10 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5640.c                         | 2344 ++++++++++++++++++++
 drivers/media/platform/Kconfig                     |    6 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/video-mux.c                 |  334 +++
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/imx/Kconfig                  |   21 +
 drivers/staging/media/imx/Makefile                 |   12 +
 drivers/staging/media/imx/TODO                     |   23 +
 drivers/staging/media/imx/imx-ic-common.c          |  113 +
 drivers/staging/media/imx/imx-ic-prp.c             |  518 +++++
 drivers/staging/media/imx/imx-ic-prpencvf.c        | 1309 +++++++++++
 drivers/staging/media/imx/imx-ic.h                 |   38 +
 drivers/staging/media/imx/imx-media-capture.c      |  775 +++++++
 drivers/staging/media/imx/imx-media-csi.c          | 1816 +++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c          |  666 ++++++
 drivers/staging/media/imx/imx-media-fim.c          |  494 +++++
 drivers/staging/media/imx/imx-media-internal-sd.c  |  349 +++
 drivers/staging/media/imx/imx-media-of.c           |  270 +++
 drivers/staging/media/imx/imx-media-utils.c        |  896 ++++++++
 drivers/staging/media/imx/imx-media-vdic.c         | 1009 +++++++++
 drivers/staging/media/imx/imx-media.h              |  325 +++
 drivers/staging/media/imx/imx6-mipi-csi2.c         |  698 ++++++
 include/linux/imx-media.h                          |   29 +
 include/media/imx.h                                |   15 +
 include/uapi/linux/media.h                         |    6 +
 include/uapi/linux/v4l2-controls.h                 |    4 +
 45 files changed, 13613 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-mux.txt
 create mode 100644 Documentation/media/v4l-drivers/imx.rst
 create mode 100644 drivers/media/i2c/ov5640.c
 create mode 100644 drivers/media/platform/video-mux.c
 create mode 100644 drivers/staging/media/imx/Kconfig
 create mode 100644 drivers/staging/media/imx/Makefile
 create mode 100644 drivers/staging/media/imx/TODO
 create mode 100644 drivers/staging/media/imx/imx-ic-common.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prp.c
 create mode 100644 drivers/staging/media/imx/imx-ic-prpencvf.c
 create mode 100644 drivers/staging/media/imx/imx-ic.h
 create mode 100644 drivers/staging/media/imx/imx-media-capture.c
 create mode 100644 drivers/staging/media/imx/imx-media-csi.c
 create mode 100644 drivers/staging/media/imx/imx-media-dev.c
 create mode 100644 drivers/staging/media/imx/imx-media-fim.c
 create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
 create mode 100644 drivers/staging/media/imx/imx-media-of.c
 create mode 100644 drivers/staging/media/imx/imx-media-utils.c
 create mode 100644 drivers/staging/media/imx/imx-media-vdic.c
 create mode 100644 drivers/staging/media/imx/imx-media.h
 create mode 100644 drivers/staging/media/imx/imx6-mipi-csi2.c
 create mode 100644 include/linux/imx-media.h
 create mode 100644 include/media/imx.h

-- 
2.7.4

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33103 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753190AbdC1AlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 20:41:10 -0400
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
Subject: [PATCH v6 00/39] i.MX Media Driver
Date: Mon, 27 Mar 2017 17:40:17 -0700
Message-Id: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In version 6:

- moved FIM error event back to a i.MX private event. I would like to
  leave this as a (private) event rather than reporting a vb2 queue
  error, for now. If and when the i.MX6 timer input capture patch is
  accepted later, then this event can become a queue error.

- removed new-frame-before-end-of-frame (NFB4EOF) event. Instead when
  this IPU DMA channel error occurs, the next captured frame is marked
  with the vb2 error flag.

- updates to Documentation/media/v4l-drivers/imx.rst.

- ov5640: propagate return codes from the register read/write primitives
  in various places.

- ov5640: removed the [gs]_parm ops.

- ov5640: avoid possible divide-by-0's.

- only the CSI subdevice implements [gs]_frame_interval now (or needs
  to). Those ops have been removed from the subdevices that have no
  control over frame rate.

- removed the patch that adds v4l2_subdev_link_validate_frame_interval().

- properly propagate the TRY formats from sink to source pads within the
  subdevices (spotted by Philipp Zabel <p.zabel@pengutronix.de>).

- added enum_frame_size op to imx-ic-prpencvf and CSI subdevices.

- added enum_frame_intervals op to CSI subdevice (patch from Russell
  King <rmk+kernel@armlinux.org.uk>).

- added V4L2 interface ops enum_framesizes and enum_frameintervals, which
  calls the corresponding subdev op at the connected source subdev (patch
  from Russell King <rmk+kernel@armlinux.org.uk>).

- added missing Bayer support to CSI subdevice (patch from Russell King
  <rmk+kernel@armlinux.org.uk>).

- switched to v4l2_pipeline_pm_use() and v4l2_pipeline_link_notify()
  for the pipeline power management.

- the power-on order has changed due to above: the sensor now
  is powered on _before_ the MIPI CSI-2 receiver, which means
  MIPI CSI-2 receiver startup sequence steps 3, 4, and 5 can
  be moved up to csi2_s_power() from csi2_s_stream(). And that
  means step 7 (wait for clock lane) now has a place to be called
  in csi2_s_stream().

- changed the bus_info string for the capture device interfaces to
  "platform:[src_sd->name]" instead of using the capture device name,
  so that the bus_info strings are unique between the capture devices.
  I was hoping this would provide unique device node symlink names under
  /dev/v4l/by-path/, but they are still named
  "platform-capture-subsystem-video-indexNN".

- fixed cropping and /2 downsizing in the CSI subdevice. These should be
  specified using the crop and compose APIs at the sink pad, not the
  source pad (patch from Philipp Zabel <p.zabel@pengutronix.de>).

- added a check at CSI subdevice stream on. If the connected sensor
  reports faulty frames at power on via g_skip_frames op, the CSI
  should avoid capturing those frames before enabling the CSI.

- moved imx.h UAPI header to include/linux/imx-media.h while imx-media
  driver is still under staging.


Philipp Zabel (8):
  [media] dt-bindings: Add bindings for video-multiplexer device
  ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
    connections
  add mux and video interface bridge entity functions
  platform: add video-multiplexer subdevice driver
  media: imx: csi: fix crop rectangle changes in set_fmt
  media: imx: csi: add frame skipping support
  media: imx: csi: fix crop rectangle reset in sink set_fmt
  media: imx: csi: add sink selection rectangles

Russell King (5):
  media: imx: add support for bayer formats
  media: imx: csi: add support for bayer formats
  media: imx: csi/fim: add support for frame intervals
  media: imx-csi: add frame size/interval enumeration
  media: imx-media-capture: add frame sizes/interval enumeration

Steve Longerbeam (26):
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
  [media] v4l2-mc: add a function to inherit controls from a pipeline
  [media] add Omnivision OV5640 sensor driver
  media: Add userspace header file for i.MX
  media: Add i.MX media core driver
  media: imx: Add Capture Device Interface
  media: imx: Add CSI subdev driver
  media: imx: Add VDIC subdev driver
  media: imx: Add IC subdev drivers
  media: imx: Add MIPI CSI-2 Receiver subdev driver
  ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
  media: imx: csi: add __csi_get_fmt
  media: imx: redo pixel format enumeration and negotiation
  media: imx: csi: Avoid faulty sensor frames at stream start
  media: imx: propagate sink pad formats to source pads
  media: imx-ic-prpencvf: add frame size enumeration

 .../devicetree/bindings/media/i2c/ov5640.txt       |   45 +
 Documentation/devicetree/bindings/media/imx.txt    |   74 +
 .../bindings/media/video-multiplexer.txt           |   59 +
 Documentation/media/uapi/mediactl/media-types.rst  |   22 +
 Documentation/media/v4l-drivers/imx.rst            |  590 ++++++
 arch/arm/boot/dts/imx6dl-sabrelite.dts             |    5 +
 arch/arm/boot/dts/imx6dl-sabresd.dts               |    5 +
 arch/arm/boot/dts/imx6dl.dtsi                      |  185 ++
 arch/arm/boot/dts/imx6q-sabrelite.dts              |    5 +
 arch/arm/boot/dts/imx6q-sabresd.dts                |    5 +
 arch/arm/boot/dts/imx6q.dtsi                       |  121 ++
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  144 +-
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |  152 +-
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  114 +-
 arch/arm/boot/dts/imx6qdl.dtsi                     |   17 +-
 arch/arm/configs/imx_v6_v7_defconfig               |   11 +
 drivers/media/i2c/Kconfig                          |    7 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5640.c                         | 2219 ++++++++++++++++++++
 drivers/media/platform/Kconfig                     |    8 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/video-multiplexer.c         |  451 ++++
 drivers/media/v4l2-core/v4l2-mc.c                  |   50 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/imx/Kconfig                  |   20 +
 drivers/staging/media/imx/Makefile                 |   12 +
 drivers/staging/media/imx/TODO                     |   17 +
 drivers/staging/media/imx/imx-ic-common.c          |  113 +
 drivers/staging/media/imx/imx-ic-prp.c             |  452 ++++
 drivers/staging/media/imx/imx-ic-prpencvf.c        | 1232 +++++++++++
 drivers/staging/media/imx/imx-ic.h                 |   38 +
 drivers/staging/media/imx/imx-media-capture.c      |  776 +++++++
 drivers/staging/media/imx/imx-media-csi.c          | 1779 ++++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c          |  503 +++++
 drivers/staging/media/imx/imx-media-fim.c          |  463 ++++
 drivers/staging/media/imx/imx-media-internal-sd.c  |  349 +++
 drivers/staging/media/imx/imx-media-of.c           |  267 +++
 drivers/staging/media/imx/imx-media-utils.c        |  947 +++++++++
 drivers/staging/media/imx/imx-media-vdic.c         |  910 ++++++++
 drivers/staging/media/imx/imx-media.h              |  305 +++
 drivers/staging/media/imx/imx6-mipi-csi2.c         |  673 ++++++
 include/linux/imx-media.h                          |   27 +
 include/media/imx.h                                |   15 +
 include/media/v4l2-mc.h                            |   31 +
 include/uapi/linux/media.h                         |    6 +
 include/uapi/linux/v4l2-controls.h                 |    4 +
 47 files changed, 13207 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-multiplexer.txt
 create mode 100644 Documentation/media/v4l-drivers/imx.rst
 create mode 100644 drivers/media/i2c/ov5640.c
 create mode 100644 drivers/media/platform/video-multiplexer.c
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

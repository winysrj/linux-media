Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33781 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdBPCT4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 21:19:56 -0500
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
Subject: [PATCH v4 00/36] i.MX Media Driver
Date: Wed, 15 Feb 2017 18:19:02 -0800
Message-Id: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In version 4:

Changes suggested by Philipp Zabel <p.zabel@pengutronix.de> and
Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>:

- split out VDIC from imx-ic-prpvf into a distinct VDIC subdev.

Changes suggested by Philipp Zabel <p.zabel@pengutronix.de>:

- Re-org of pre-process entities. Created an ipuX_ic_prp entity
  that receives on a single sink pad from the CSIs and the VDIC.
  Two source pads route to ipuX_ic_prpenc and ipuX_ic_prpvf. The
  code for ipuX_ic_prpenc and ipuX_ic_prpvf is now identical, which
  adds rotation to ipuX_ic_prpvf.

- renamed media node in DT to capture-subsystem, compatible string to
  "fsl,imx-capture-subsystem".

- the ov564x subdevs get the xclk rate from clk_get_rate() instead of
  attempting to change the rate. "xclk" property in ov564x DT nodes is
  removed.

- changed "pix" clock to IMX6QDL_CLK_EIM_PODF in mipi_csi node.

- added comptible string "snps,dw-mipi-csi2" to mipi_csi node in DT.

- silenced many of the v4l2_info()'s.

- move conversion of ALTERNATE field type to SEQ_BT/TB to output pad
  of ipuX_csiY entity.

- added bounds checks to set_fmt in ipuX_csiY and ipuX_vdic entities.

- Get rid of SMFC entity. CSI frame output via SMFC and IDMAC channel
  is now built into the CSI entities via a new source pad. So CSI
  entities now have two source pads : direct and IDMAC.

- the IPU internal pads (direct between subunuits, not via IDMAC channels),
  should only accept the pixel formats used internally by the IPU:
  MEDIA_BUS_FMT_AYUV8_1X32 and MEDIA_BUS_FMT_ARGB8888_1X32.

- export V4L2_EVENT_IMX_EOF_TIMEOUT as V4L2_EVENT_FRAME_TIMEOUT for
  general use.

- export imx_media_inherit_controls() as v4l2_pipeline_inherit_controls()
  for general use.

- completely removed dma_buf ring support. There is no capture interface
  or ic-pp subdevs any longer. The CSI and ic-prp enc/vf subdevs now attach
  directly to a capture device node from their IDMAC (non-direct) source pads.


Changes suggested by Javier Martinez Canillas <javier@dowhile0.org>:

- add missing MODULE_DEVICE_TABLE() to video mux subdev.


Changes suggested by Hans Verkuil <hverkuil@xs4all.nl>:

- entity function type MEDIA_ENT_F_MUX renamed to MEDIA_ENT_F_VID_MUX.

- removed use of g_mbus_config subdev op. Sensor bus config is instead
  gotten from the sensor DT node via v4l2_of_parse_endpoint().

- use v4l2_ctrl_handler_setup() for restoring current control values
  in the ov564x subdevs, rather than a custom control cache.


Changes suggested by Russell King <linux@armlinux.org.uk>:

- re-ordered clock lane and data lane # assignments in device tree.

- fixed module unload.

- propagate the return code from ipu_ic_task_idma_init(), don't start
  streaming if it returned error!


Changes suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>:

- ov5640 subdev is improved and moved to drivers/media/i2c, along with
  binding docs. The ov5642 subdev has been dropped for now.

- regulator DT properties are now required in ov5640 subdev, and resewt/power
  GPIOs are optional. Created dummy regulator nodes in imx6qdl-sabrelite.dtsi
  for the ov5640 node (the ov5640 regulators are fixed regulators on the
  OV5640 module for sabrelite).

- removed use of endpoint ID in device tree as a way to specify a MIPI CSI-2
  virtual channel for the OV5640. The ov5640 subdev now hard-codes the
  virtual channel to 1 until a new subdev API becomes available to allow
  run-time virtual channel selection.


Other changes:

- v4l2-compliance fixes.

- since dma_buf ring support is gone, the VDIC subdev is modified to
  potentially receive frames from a future output device node on its
  IDMAC sink pad.

- fixed mbus pixel format enumeration and selection. The source pads
  and capture device select the correct formats based on the sink
  formats. For example the capture device can only report and allow
  selecting an RGB format if the attached source pad's format is RGB.
  Likewise for YUV space, with the added benefit that the capture
  device can select a YUV planar format in this case, and the attached
  subdev will comply and output planar.

- stripped out sensor input OF properties and parsing for now. It is
  problematic since there is currently no subdev op so that the bridge
  can retrieve this information and use for VIDIOC_{ENUM|S|G}_INPUT.

- modified imx6-mipi-csi2 subdev to comply strictly with the MIPI CSI-2
  startup sequence described in the i.MX6 reference manual.



Philipp Zabel (6):
  ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
    connections
  add mux and video interface bridge entity functions
  platform: add video-multiplexer subdevice driver
  media: imx: csi: fix crop rectangle changes in set_fmt
  media: imx: csi: add frame skipping support
  media: imx: csi: fix crop rectangle reset in sink set_fmt

Russell King (3):
  media: imx: add support for bayer formats
  media: imx: csi: add support for bayer formats
  media: imx: mipi-csi2: enable setting and getting of frame rates

Steve Longerbeam (27):
  [media] dt-bindings: Add bindings for i.MX media driver
  ARM: dts: imx6qdl: Add compatible, clocks, irqs to MIPI CSI-2 node
  ARM: dts: imx6qdl: add capture-subsystem device
  ARM: dts: imx6qdl-sabrelite: remove erratum ERR006687 workaround
  ARM: dts: imx6-sabrelite: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
  ARM: dts: imx6-sabreauto: create i2cmux for i2c3
  ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
  ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
  ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
  [media] v4l2: add a frame timeout event
  [media] v4l2-mc: add a function to inherit controls from a pipeline
  UAPI: Add media UAPI Kbuild file
  media: Add userspace header file for i.MX
  media: Add i.MX media core driver
  media: imx: Add Capture Device Interface
  media: imx: Add CSI subdev driver
  media: imx: Add VDIC subdev driver
  media: imx: Add IC subdev drivers
  media: imx: Add MIPI CSI-2 Receiver subdev driver
  [media] add Omnivision OV5640 sensor driver
  ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
  media: imx: update capture dev format on IDMAC output pad set_fmt
  media: imx: csi: add __csi_get_fmt
  media: imx: csi/fim: add support for frame intervals
  media: imx: redo pixel format enumeration and negotiation
  media: imx: propagate sink pad formats to source pads

 .../devicetree/bindings/media/i2c/ov5640.txt       |   43 +
 Documentation/devicetree/bindings/media/imx.txt    |   66 +
 .../bindings/media/video-multiplexer.txt           |   59 +
 Documentation/media/uapi/mediactl/media-types.rst  |   22 +
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |    5 +
 Documentation/media/v4l-drivers/imx.rst            |  542 +++++
 Documentation/media/videodev2.h.rst.exceptions     |    1 +
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
 arch/arm/configs/imx_v6_v7_defconfig               |   14 +-
 drivers/media/i2c/Kconfig                          |    7 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/ov5640.c                         | 2109 ++++++++++++++++++++
 drivers/media/platform/Kconfig                     |    8 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/video-multiplexer.c         |  474 +++++
 drivers/media/v4l2-core/v4l2-mc.c                  |   48 +
 drivers/staging/media/Kconfig                      |    2 +
 drivers/staging/media/Makefile                     |    1 +
 drivers/staging/media/imx/Kconfig                  |   20 +
 drivers/staging/media/imx/Makefile                 |   12 +
 drivers/staging/media/imx/TODO                     |   36 +
 drivers/staging/media/imx/imx-ic-common.c          |  113 ++
 drivers/staging/media/imx/imx-ic-prp.c             |  458 +++++
 drivers/staging/media/imx/imx-ic-prpencvf.c        | 1138 +++++++++++
 drivers/staging/media/imx/imx-ic.h                 |   38 +
 drivers/staging/media/imx/imx-media-capture.c      |  671 +++++++
 drivers/staging/media/imx/imx-media-csi.c          | 1483 ++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c          |  487 +++++
 drivers/staging/media/imx/imx-media-fim.c          |  463 +++++
 drivers/staging/media/imx/imx-media-internal-sd.c  |  349 ++++
 drivers/staging/media/imx/imx-media-of.c           |  267 +++
 drivers/staging/media/imx/imx-media-utils.c        |  930 +++++++++
 drivers/staging/media/imx/imx-media-vdic.c         |  915 +++++++++
 drivers/staging/media/imx/imx-media.h              |  305 +++
 drivers/staging/media/imx/imx6-mipi-csi2.c         |  600 ++++++
 include/media/imx.h                                |   15 +
 include/media/v4l2-mc.h                            |   25 +
 include/uapi/Kbuild                                |    1 +
 include/uapi/linux/media.h                         |    6 +
 include/uapi/linux/v4l2-controls.h                 |    4 +
 include/uapi/linux/videodev2.h                     |    1 +
 include/uapi/media/Kbuild                          |    2 +
 include/uapi/media/imx.h                           |   29 +
 52 files changed, 12496 insertions(+), 29 deletions(-)
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
 create mode 100644 include/media/imx.h
 create mode 100644 include/uapi/media/Kbuild
 create mode 100644 include/uapi/media/imx.h

-- 
2.7.4

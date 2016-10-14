Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:48890 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753679AbcJNRew (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:34:52 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
Date: Fri, 14 Oct 2016 19:34:20 +0200
Message-Id: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the second round removes the prepare_stream callback and instead lets the
intermediate subdevices propagate s_stream calls to their sources rather
than individually calling s_stream on each subdevice from the bridge driver.
This is similar to how drm bridges recursively call into their next neighbor.
It makes it easier to do bringup ordering on a per-link level, as long as the
source preparation can be done at s_power, and the sink can just prepare, call
s_stream on its source, and then enable itself inside s_stream. Obviously this
would only work in a generic fashion if all asynchronous subdevices with both
inputs and outputs would propagate s_stream to their source subdevices.

Changes since v1:
 - Propagate field and colorspace in ipucsi_subdev_set_format.
 - Remove v4l2_media_subdev_prepare_stream and v4l2_media_subdev_s_stream,
   let subdevices propagate s_stream calls to their upstream subdevices
   themselves.
 - Various fixes (see individual patches for details)

regards
Philipp

Philipp Zabel (20):
  [media] v4l2-async: move code out of v4l2_async_notifier_register into
    v4l2_async_test_nofity_all
  [media] v4l2-async: allow subdevices to add further subdevices to the
    notifier waiting list
  [media] v4l: of: add v4l2_of_subdev_registered
  [media] v4l2-async: add new subdevices to the tail of subdev_list
  [media] imx: Add i.MX SoC wide media device driver
  [media] imx-ipu: Add i.MX IPUv3 CSI subdevice driver
  [media] imx: Add i.MX IPUv3 capture driver
  [media] platform: add video-multiplexer subdevice driver
  [media] imx: Add i.MX MIPI CSI-2 subdevice driver
  [media] tc358743: put lanes in STOP state before starting streaming
  ARM: dts: imx6qdl: Add capture-subsystem node
  ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
    connections
  ARM: dts: imx6qdl: Add MIPI CSI-2 D-PHY compatible and clocks
  ARM: dts: nitrogen6x: Add dtsi for BD_HDMI_MIPI HDMI to MIPI CSI-2
    receiver board
  gpu: ipuv3: add ipu_csi_set_downsize
  [media] imx-ipuv3-csi: support downsizing
  [media] add mux and video interface bridge entity functions
  [media] video-multiplexer: set entity function to mux
  [media] imx: Set i.MX MIPI CSI-2 entity function to bridge
  [media] tc358743: set entity function to video interface bridge

Sascha Hauer (1):
  [media] imx: Add IPUv3 media common code

 .../devicetree/bindings/media/fsl-imx-capture.txt  |   92 ++
 .../bindings/media/video-multiplexer.txt           |   59 ++
 Documentation/media/uapi/mediactl/media-types.rst  |   22 +
 arch/arm/boot/dts/imx6dl.dtsi                      |  187 ++++
 arch/arm/boot/dts/imx6q.dtsi                       |  123 +++
 .../boot/dts/imx6qdl-nitrogen6x-bd-hdmi-mipi.dtsi  |   73 ++
 arch/arm/boot/dts/imx6qdl.dtsi                     |   17 +-
 drivers/gpu/ipu-v3/ipu-csi.c                       |   16 +
 drivers/media/i2c/tc358743.c                       |    5 +
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    3 +
 drivers/media/platform/imx/Kconfig                 |   33 +
 drivers/media/platform/imx/Makefile                |    5 +
 drivers/media/platform/imx/imx-ipu-capture.c       | 1015 ++++++++++++++++++++
 drivers/media/platform/imx/imx-ipu.c               |  321 +++++++
 drivers/media/platform/imx/imx-ipu.h               |   43 +
 drivers/media/platform/imx/imx-ipuv3-csi.c         |  578 +++++++++++
 drivers/media/platform/imx/imx-media.c             |  249 +++++
 drivers/media/platform/imx/imx-mipi-csi2.c         |  698 ++++++++++++++
 drivers/media/platform/video-multiplexer.c         |  473 +++++++++
 drivers/media/v4l2-core/v4l2-async.c               |  102 +-
 drivers/media/v4l2-core/v4l2-of.c                  |   69 ++
 include/media/v4l2-async.h                         |   12 +
 include/media/v4l2-of.h                            |   15 +
 include/uapi/linux/media.h                         |    6 +
 include/video/imx-ipu-v3.h                         |    1 +
 26 files changed, 4214 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-imx-capture.txt
 create mode 100644 Documentation/devicetree/bindings/media/video-multiplexer.txt
 create mode 100644 arch/arm/boot/dts/imx6qdl-nitrogen6x-bd-hdmi-mipi.dtsi
 create mode 100644 drivers/media/platform/imx/Kconfig
 create mode 100644 drivers/media/platform/imx/Makefile
 create mode 100644 drivers/media/platform/imx/imx-ipu-capture.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.c
 create mode 100644 drivers/media/platform/imx/imx-ipu.h
 create mode 100644 drivers/media/platform/imx/imx-ipuv3-csi.c
 create mode 100644 drivers/media/platform/imx/imx-media.c
 create mode 100644 drivers/media/platform/imx/imx-mipi-csi2.c
 create mode 100644 drivers/media/platform/video-multiplexer.c

-- 
2.9.3


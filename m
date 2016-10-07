Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58762 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932268AbcJGQBL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:11 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 00/22] Basic i.MX IPUv3 capture support
Date: Fri,  7 Oct 2016 18:00:45 +0200
Message-Id: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this series adds very basic IPUv3 capture support for i.MX5/6 SoCs via a SoC
global media controller device that collects all IPUv3 CSIs and their direct
sources from the device tree via of_graph bindings. The device is probed from
device tree using a capture-subsystem node similarly to the already existing
display-subsystem node for imx-drm.
Each subdevice is then allowed to add further still missing subdevices to the
asynchronous subdevice notifier waitlist until the graph is complete.

Each CSI subdevice gets assigned an ipu-capture video_device that corresponds
to one direct CSI -> SMFC -> IDMAC channel path.
This series does not contain IC support yet. I'd like to add the IC as another
subdevice with one sink pad (PRP) that can be connected to either CSI, and two
source pads (PRP VF and PRP ENC) that each would get their own video_device.

Also included are drivers for the video bus multiplexers in front of the CSIs
and for the DesignWare MIPI CSI-2 Host Controller and an example device tree
configuration for TC358743 on Nitrogen6X.
This is the output of media-ctl --print-dot:

digraph board {
	rankdir=TB
	n00000001 [label="{{<port0> 0} | IPU0 CSI0\n/dev/v4l-subdev0 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000001:port1 -> n00000004
	n00000004 [label="imx-ipuv3-capture.0\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
	n0000000a [label="{{<port0> 0} | IPU0 CSI1\n/dev/v4l-subdev1 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000000a:port1 -> n0000000d
	n0000000d [label="imx-ipuv3-capture.1\n/dev/video1", shape=box, style=filled, fillcolor=yellow]
	n00000013 [label="{{<port0> 0} | IPU1 CSI0\n/dev/v4l-subdev2 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000013:port1 -> n00000016
	n00000016 [label="imx-ipuv3-capture.0\n/dev/video2", shape=box, style=filled, fillcolor=yellow]
	n0000001c [label="{{<port0> 0} | IPU1 CSI1\n/dev/v4l-subdev3 | {<port1> 1}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000001c:port1 -> n0000001f
	n0000001f [label="imx-ipuv3-capture.1\n/dev/video3", shape=box, style=filled, fillcolor=yellow]
	n00000025 [label="{{<port0> 0 | <port1> 1} | mipi_ipu1_mux\n/dev/v4l-subdev4 | {<port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000025:port2 -> n00000001:port0
	n00000029 [label="{{<port0> 0 | <port1> 1} | mipi_ipu2_mux\n/dev/v4l-subdev5 | {<port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000029:port2 -> n0000001c:port0 [style=dashed]
	n0000002d [label="{{<port0> 0} | mipi-csi2\n/dev/v4l-subdev6 | {<port1> 1 | <port2> 2 | <port3> 3 | <port4> 4}}", shape=Mrecord, style=filled, fillcolor=green]
	n0000002d:port1 -> n00000025:port0
	n0000002d:port4 -> n00000029:port0 [style=dashed]
	n0000002d:port3 -> n00000013:port0 [style=dashed]
	n0000002d:port2 -> n0000000a:port0 [style=dashed]
	n00000033 [label="{{} | tc358743 1-000f\n/dev/v4l-subdev7 | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000033:port0 -> n0000002d:port0
}

regards
Philipp

Philipp Zabel (21):
  [media] v4l2-async: move code out of v4l2_async_notifier_register into
    v4l2_async_test_nofity_all
  [media] v4l2-async: allow subdevices to add further subdevices to the
    notifier waiting list
  [media] v4l: of: add v4l2_of_subdev_registered
  [media] v4l2-subdev.h: add prepare_stream op
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
 drivers/media/i2c/tc358743.c                       |   10 +
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    3 +
 drivers/media/platform/imx/Kconfig                 |   33 +
 drivers/media/platform/imx/Makefile                |    5 +
 drivers/media/platform/imx/imx-ipu-capture.c       | 1085 ++++++++++++++++++++
 drivers/media/platform/imx/imx-ipu.c               |  321 ++++++
 drivers/media/platform/imx/imx-ipu.h               |   43 +
 drivers/media/platform/imx/imx-ipuv3-csi.c         |  555 ++++++++++
 drivers/media/platform/imx/imx-media.c             |  249 +++++
 drivers/media/platform/imx/imx-mipi-csi2.c         |  677 ++++++++++++
 drivers/media/platform/video-multiplexer.c         |  445 ++++++++
 drivers/media/v4l2-core/v4l2-async.c               |   96 +-
 drivers/media/v4l2-core/v4l2-of.c                  |   68 ++
 include/media/v4l2-async.h                         |   12 +
 include/media/v4l2-of.h                            |   12 +
 include/media/v4l2-subdev.h                        |    1 +
 include/uapi/linux/media.h                         |    6 +
 include/video/imx-ipu-v3.h                         |    1 +
 27 files changed, 4210 insertions(+), 11 deletions(-)
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


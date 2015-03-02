Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56467 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbbCBBtB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 20:49:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>, devicetree@vger.kernel.org
Subject: [PATCH v5 0/8] Xilinx Video IP Core support
Date: Mon,  2 Mar 2015 03:48:37 +0200
Message-Id: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the fifth, latest and greatest version of the Xilinx FPGA Video IP
Cores kernel drivers.

I won't detail in great lengths the Xilinx Video IP architecture here, as that
would result in dozens of pages of documentation. The interested reader can
refer to the Zynq ZC702 Base TRD (Targeted Reference Design) User Guide
(http://www.xilinx.com/support/documentation/boards_and_kits/zc702_zvik/2014_2/ug925-zynq-zc702-base-trd.pdf).

In a nutshell, the Xilinx Video IP Cores architecture specifies how
video-related IP cores need to be designed to interoperate and how to assemble
them in pipelines of various complexities. The concepts map neatly to the
media controller architecture, which this patch set uses extensively.

The series starts with various new V4L2 core features, bug fixes or cleanups,
with a small documentation enhancement (1/8), the addition of new media bus
formats needed by the new drivers (2/8 to 4/8) and a new V4L2 OF link
parsing function (5/8).

The last three patches are the core of this series.

Patch 6/8 adds support for the Xilinx Video IP architecture core in the form
of a base object to model video IP cores (xilinx-vip.c - Video IP), a
framework that parses a DT representation of a video pipeline and connects the
corresponding V4L2 subdevices together (xilinx-vipp.c - Video IP Pipeline) and
a glue between the Video DMA engine driver and the V4L2 API (xilinx-dma.c).

Patch 7/8 adds a driver for the Video Timing Controller (VTC) IP core. While
not strictly a video processing IP core, the VTC is required by other video IP
core drivers.

Finally, patch 8/8 adds a first video IP core driver for the Test Pattern
Generator (TPG). Drivers for other IP cores will be added in the future.

Changes since v4:

- Clarify the v4l2_of_parse_link() documentation
- Use a DT format description closer to the hardware
- Document the xvip_device clk field
- Fix a crash in the TPG probe error path

Cc: devicetree@vger.kernel.org

Hyun Kwon (2):
  v4l: Sort YUV formats of v4l2_mbus_pixelcode
  v4l: Add VUY8 24 bits bus format

Laurent Pinchart (6):
  media: entity: Document the media_entity_ops structure
  v4l: Add RBG and RGB 8:8:8 media bus formats on 24 and 32 bit busses
  v4l: of: Add v4l2_of_parse_link() function
  v4l: xilinx: Add Xilinx Video IP core
  v4l: xilinx: Add Video Timing Controller driver
  v4l: xilinx: Add Test Pattern Generator driver

 Documentation/DocBook/media/v4l/subdev-formats.xml | 719 +++++++++-------
 .../devicetree/bindings/media/xilinx/video.txt     |  35 +
 .../devicetree/bindings/media/xilinx/xlnx,v-tc.txt |  33 +
 .../bindings/media/xilinx/xlnx,v-tpg.txt           |  71 ++
 .../bindings/media/xilinx/xlnx,video.txt           |  55 ++
 MAINTAINERS                                        |  10 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/xilinx/Kconfig              |  23 +
 drivers/media/platform/xilinx/Makefile             |   5 +
 drivers/media/platform/xilinx/xilinx-dma.c         | 753 +++++++++++++++++
 drivers/media/platform/xilinx/xilinx-dma.h         | 109 +++
 drivers/media/platform/xilinx/xilinx-tpg.c         | 926 +++++++++++++++++++++
 drivers/media/platform/xilinx/xilinx-vip.c         | 309 +++++++
 drivers/media/platform/xilinx/xilinx-vip.h         | 236 ++++++
 drivers/media/platform/xilinx/xilinx-vipp.c        | 669 +++++++++++++++
 drivers/media/platform/xilinx/xilinx-vipp.h        |  49 ++
 drivers/media/platform/xilinx/xilinx-vtc.c         | 380 +++++++++
 drivers/media/platform/xilinx/xilinx-vtc.h         |  42 +
 drivers/media/v4l2-core/v4l2-of.c                  |  61 ++
 include/dt-bindings/media/xilinx-vip.h             |  39 +
 include/media/media-entity.h                       |   9 +
 include/media/v4l2-of.h                            |  27 +
 include/uapi/linux/Kbuild                          |   1 +
 include/uapi/linux/media-bus-format.h              |  19 +-
 include/uapi/linux/xilinx-v4l2-controls.h          |  73 ++
 26 files changed, 4337 insertions(+), 319 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/video.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,v-tc.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,v-tpg.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
 create mode 100644 drivers/media/platform/xilinx/Kconfig
 create mode 100644 drivers/media/platform/xilinx/Makefile
 create mode 100644 drivers/media/platform/xilinx/xilinx-dma.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-dma.h
 create mode 100644 drivers/media/platform/xilinx/xilinx-tpg.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vip.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vip.h
 create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.h
 create mode 100644 drivers/media/platform/xilinx/xilinx-vtc.c
 create mode 100644 drivers/media/platform/xilinx/xilinx-vtc.h
 create mode 100644 include/dt-bindings/media/xilinx-vip.h
 create mode 100644 include/uapi/linux/xilinx-v4l2-controls.h

-- 
Regards,

Laurent Pinchart


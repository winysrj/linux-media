Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39448 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbCKUrh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 16:47:37 -0400
Received: from avalon.localnet (unknown [70.98.210.103])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id DC3762000F
	for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 21:46:30 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.1] Xilinx video pipeline drivers
Date: Wed, 11 Mar 2015 22:47:37 +0200
Message-ID: <5245308.M2sog0XFbh@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit ae3da40179c66001afad608f972bdb57d50d1e66:

  v4l2-subdev: remove enum_framesizes/intervals (2015-03-06 10:01:44 +0100)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git xilinx

for you to fetch changes up to 5fc7561dba773afd95169aba32f53a01facaf22a:

  v4l: xilinx: Add Test Pattern Generator driver (2015-03-11 22:43:48 +0200)

Please note that the series depends and is based on Hans' for-v4.1g branch for 
which he has sent a pull request.

----------------------------------------------------------------
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

 Documentation/DocBook/media/v4l/subdev-formats.xml      | 719 ++++++++-------
 .../devicetree/bindings/media/xilinx/video.txt          |  35 +
 .../devicetree/bindings/media/xilinx/xlnx,v-tc.txt      |  33 +
 .../devicetree/bindings/media/xilinx/xlnx,v-tpg.txt     |  71 ++
 .../devicetree/bindings/media/xilinx/xlnx,video.txt     |  55 ++
 MAINTAINERS                                             |  10 +
 drivers/media/platform/Kconfig                          |   1 +
 drivers/media/platform/Makefile                         |   2 +
 drivers/media/platform/xilinx/Kconfig                   |  23 +
 drivers/media/platform/xilinx/Makefile                  |   5 +
 drivers/media/platform/xilinx/xilinx-dma.c              | 766 +++++++++++++++
 drivers/media/platform/xilinx/xilinx-dma.h              | 109 +++
 drivers/media/platform/xilinx/xilinx-tpg.c              | 931 +++++++++++++++
 drivers/media/platform/xilinx/xilinx-vip.c              | 323 ++++++++
 drivers/media/platform/xilinx/xilinx-vip.h              | 238 ++++++
 drivers/media/platform/xilinx/xilinx-vipp.c             | 669 +++++++++++++++
 drivers/media/platform/xilinx/xilinx-vipp.h             |  49 ++
 drivers/media/platform/xilinx/xilinx-vtc.c              | 380 ++++++++++
 drivers/media/platform/xilinx/xilinx-vtc.h              |  42 ++
 drivers/media/v4l2-core/v4l2-of.c                       |  61 ++
 include/dt-bindings/media/xilinx-vip.h                  |  39 +
 include/media/media-entity.h                            |   9 +
 include/media/v4l2-of.h                                 |  27 +
 include/uapi/linux/Kbuild                               |   1 +
 include/uapi/linux/media-bus-format.h                   |  19 +-
 include/uapi/linux/xilinx-v4l2-controls.h               |  73 ++
 26 files changed, 4371 insertions(+), 319 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/video.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,v-
tc.txt
 create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,v-
tpg.txt
 create mode 100644 
Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
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


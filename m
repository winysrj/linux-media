Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36767 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3HGKyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Aug 2013 06:54:01 -0400
Received: from avalon.localnet (unknown [91.178.204.6])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 960FB35A6C
	for <linux-media@vger.kernel.org>; Wed,  7 Aug 2013 12:53:42 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.12] Renesas VSP1 driver
Date: Wed, 07 Aug 2013 12:55:05 +0200
Message-ID: <1733060.guP3eZqyCA@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit dfb9f94e8e5e7f73c8e2bcb7d4fb1de57e7c333d:

  [media] stk1160: Build as a module if SND is m and audio support is selected 
(2013-08-01 14:55:25 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git vsp1

for you to fetch changes up to aa41f0e9ee56108671e4af4ef075bc869c5c5746:

  vsp1: Use the maximum number of entities defined in platform data 
(2013-08-07 12:45:40 +0200)

----------------------------------------------------------------
Katsuya Matsubara (2):
      vsp1: Fix lack of the sink entity registration for enabled links
      vsp1: Use the maximum number of entities defined in platform data

Laurent Pinchart (8):
      media: Add support for circular graph traversal
      Documentation: media: Clarify the VIDIOC_CREATE_BUFS format requirements
      media: vb2: Clarify queue_setup() and buf_prepare() usage documentation
      media: vb2: Take queue or device lock in mmap-related vb2 ioctl handlers
      v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code value
      v4l: Add media format codes for ARGB8888 and AYUV8888 on 32-bit busses
      v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M formats
      v4l: Renesas R-Car VSP1 driver

 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml       |  171 ++++
 Documentation/DocBook/media/v4l/pixfmt.xml             |    1 +
 Documentation/DocBook/media/v4l/subdev-formats.xml     |  611 ++++++--------
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |   41 +-
 Documentation/DocBook/media_api.tmpl                   |    6 +
 drivers/media/media-entity.c                           |   14 +-
 drivers/media/platform/Kconfig                         |   10 +
 drivers/media/platform/Makefile                        |    2 +
 drivers/media/platform/vsp1/Makefile                   |    5 +
 drivers/media/platform/vsp1/vsp1.h                     |   73 ++
 drivers/media/platform/vsp1/vsp1_drv.c                 |  495 +++++++++++
 drivers/media/platform/vsp1/vsp1_entity.c              |  181 ++++
 drivers/media/platform/vsp1/vsp1_entity.h              |   68 ++
 drivers/media/platform/vsp1/vsp1_lif.c                 |  238 ++++++
 drivers/media/platform/vsp1/vsp1_lif.h                 |   37 +
 drivers/media/platform/vsp1/vsp1_regs.h                |  581 +++++++++++++
 drivers/media/platform/vsp1/vsp1_rpf.c                 |  209 +++++
 drivers/media/platform/vsp1/vsp1_rwpf.c                |  124 +++
 drivers/media/platform/vsp1/vsp1_rwpf.h                |   53 ++
 drivers/media/platform/vsp1/vsp1_uds.c                 |  346 ++++++++
 drivers/media/platform/vsp1/vsp1_uds.h                 |   40 +
 drivers/media/platform/vsp1/vsp1_video.c               | 1071 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_video.h               |  144 ++++
 drivers/media/platform/vsp1/vsp1_wpf.c                 |  233 ++++++
 drivers/media/v4l2-core/videobuf2-core.c               |   18 +-
 include/linux/platform_data/vsp1.h                     |   25 +
 include/media/media-entity.h                           |    4 +
 include/media/videobuf2-core.h                         |   11 +-
 include/uapi/linux/v4l2-mediabus.h                     |    6 +-
 include/uapi/linux/videodev2.h                         |    2 +
 30 files changed, 4428 insertions(+), 392 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
 create mode 100644 drivers/media/platform/vsp1/Makefile
 create mode 100644 drivers/media/platform/vsp1/vsp1.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_drv.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_entity.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lif.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_regs.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_rpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_rwpf.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uds.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_video.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_wpf.c
 create mode 100644 include/linux/platform_data/vsp1.h

-- 
Regards,

Laurent Pinchart


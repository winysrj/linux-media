Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53132 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3HERwg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 13:52:36 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v6 00/10] Renesas VSP1 driver
Date: Mon,  5 Aug 2013 19:53:19 +0200
Message-Id: <1375725209-2674-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the sixth version of the VSP1 engine (a Video Signal Processor found
in several Renesas R-Car SoCs) driver. This version adds a videobuf2 mmap
locking fix and improves the documentation patch (thanks to Hans for the
discussion we had on IRC, hopefully we won't need another round now).

The VSP1 is a video processing engine that includes a blender, scalers,
filters and statistics computation. Configurable data path routing logic
allows ordering the internal blocks in a flexible way, making this driver a
prime candidate for the media controller API.

Due to the configurable nature of the pipeline the driver doesn't use the V4L2
mem-to-mem framework, even though the device usually operates in memory to
memory mode.

Only the read pixel formatters, up/down scalers, write pixel formatters and
LCDC interface are supported at this stage.

The patch series starts with a fix for the media controller graph traversal
code, three documentation fixes, a videobuf2 mmap locking fix  and new pixel
format and media bus code definitions. The last three patches finally add the
VSP1 driver and fix two issues (I haven't squashed the patches together to
keep proper attribution).

Changes since v1:

- Updated to the v3.11 media controller API changes
- Only add the LIF entity to the entities list when the LIF is present
- Added a MODULE_ALIAS()
- Fixed file descriptions in comment blocks
- Removed function prototypes for the unimplemented destroy functions
- Fixed a typo in the HST register name
- Fixed format propagation for the UDS entities
- Added v4l2_capability::device_caps support
- Prefix the device name with "platform:" in bus_info
- Zero the v4l2_pix_format priv field in the internal try format handler
- Use vb2_is_busy() instead of vb2_is_streaming() when setting the
  format
- Use the vb2_ioctl_* handlers where possible

Changes since v2:

- Use a bitmap to track visited entities during graph traversal
- Fixed a typo in the V4L2_MBUS_FMT_ARGB888_1X32 documentation
- Fix register macros that were missing a n argument
- Mask unused bits when clearing the interrupt status register
- Explain why stride alignment to 128 bytes is needed
- Use the aligned stride value when computing the image size
- Assorted cosmetic changes

Changes since v3:

- Handle timeout errors when resetting WPFs
- Use DECLARE_BITMAP
- Update the NV16M/NV61M documentation to mention the multi-planar API for
  NV61M

Changes since v4:

- Clarify the VIDIOC_CREATE_BUFS format requirements in the V4L2
  documentation
- Clarify vb2 queue_setup() and buf_prepare() usage documentation
- Remove duplicate printk's in devm_* error paths
- Implement VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF support
- Reject invalid buffers in the .buffer_queue() handler

Changes since v5:

- Use the vb2 fop helpers
- Reword the VIDIOC_CREATE_BUFS clarification
- Take the queue or device lock in vb2_fop_mmap()
- Accept custom sizeimage values in .queue_setup()

Katsuya Matsubara (2):
  vsp1: Fix lack of the sink entity registration for enabled links
  vsp1: Use the maximum number of entities defined in platform data

Laurent Pinchart (8):
  media: Add support for circular graph traversal
  Documentation: media: Clarify the VIDIOC_CREATE_BUFS format
    requirements
  media: vb2: Clarify queue_setup() and buf_prepare() usage
    documentation
  media: vb2: Take queue or device lock in vb2_fop_mmap()
  v4l: Fix V4L2_MBUS_FMT_YUV10_1X30 media bus pixel code value
  v4l: Add media format codes for ARGB8888 and AYUV8888 on 32-bit busses
  v4l: Add V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV61M formats
  v4l: Renesas R-Car VSP1 driver

 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml   |  171 ++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
 Documentation/DocBook/media/v4l/subdev-formats.xml |  611 +++++------
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |   41 +-
 Documentation/DocBook/media_api.tmpl               |    6 +
 drivers/media/media-entity.c                       |   14 +-
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/vsp1/Makefile               |    5 +
 drivers/media/platform/vsp1/vsp1.h                 |   73 ++
 drivers/media/platform/vsp1/vsp1_drv.c             |  495 +++++++++
 drivers/media/platform/vsp1/vsp1_entity.c          |  181 ++++
 drivers/media/platform/vsp1/vsp1_entity.h          |   68 ++
 drivers/media/platform/vsp1/vsp1_lif.c             |  238 +++++
 drivers/media/platform/vsp1/vsp1_lif.h             |   37 +
 drivers/media/platform/vsp1/vsp1_regs.h            |  581 +++++++++++
 drivers/media/platform/vsp1/vsp1_rpf.c             |  209 ++++
 drivers/media/platform/vsp1/vsp1_rwpf.c            |  124 +++
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   53 +
 drivers/media/platform/vsp1/vsp1_uds.c             |  346 +++++++
 drivers/media/platform/vsp1/vsp1_uds.h             |   40 +
 drivers/media/platform/vsp1/vsp1_video.c           | 1071 ++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_video.h           |  144 +++
 drivers/media/platform/vsp1/vsp1_wpf.c             |  233 +++++
 drivers/media/v4l2-core/videobuf2-core.c           |    9 +-
 include/linux/platform_data/vsp1.h                 |   25 +
 include/media/media-entity.h                       |    4 +
 include/media/videobuf2-core.h                     |   11 +-
 include/uapi/linux/v4l2-mediabus.h                 |    6 +-
 include/uapi/linux/videodev2.h                     |    2 +
 30 files changed, 4420 insertions(+), 391 deletions(-)
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


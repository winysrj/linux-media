Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:56753 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0JEOZD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 10:25:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH/RFC v3 00/11] Sub-device pad-level operations
Date: Tue,  5 Oct 2010 16:25:03 +0200
Message-Id: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's the third version of the patch set (I'll try not to send more than a
few dozens versions a day ;-)).

Changes compared to the previous version are the media bus pixel codes sort
order, documentation images being split to a separate patch for ease of review,
and variable renames moved from one patch to another.

There's no change to the API or ABI, so I won't repost a new version of the
OMAP3 ISP driver.

Antti Koskipaa (1):
  v4l: v4l2_subdev userspace crop API

Laurent Pinchart (9):
  v4l: Move the media/v4l2-mediabus.h header to include/linux
  v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
  v4l: Group media bus pixel codes by types and sort them
    alphabetically
  v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
  v4l: Add remaining RAW10 patterns w DPCM pixel code variants
  v4l: v4l2_subdev pad-level operations
  v4l: v4l2_subdev userspace format API - documentation binary files
  v4l: v4l2_subdev userspace format API
  v4l: v4l2_subdev userspace frame interval API

Stanimir Varbanov (1):
  v4l: Create v4l2 subdev file handle structure

 Documentation/DocBook/Makefile                     |    5 +-
 Documentation/DocBook/media-entities.tmpl          |   26 +
 Documentation/DocBook/v4l/bayer.pdf                |  Bin 0 -> 12116 bytes
 Documentation/DocBook/v4l/bayer.png                |  Bin 0 -> 9725 bytes
 Documentation/DocBook/v4l/dev-subdev.xml           |  307 +++++
 Documentation/DocBook/v4l/pipeline.pdf             |  Bin 0 -> 20276 bytes
 Documentation/DocBook/v4l/pipeline.png             |  Bin 0 -> 12130 bytes
 Documentation/DocBook/v4l/subdev-formats.xml       | 1294 ++++++++++++++++++++
 Documentation/DocBook/v4l/v4l2.xml                 |    7 +
 Documentation/DocBook/v4l/vidioc-streamon.xml      |    9 +
 .../v4l/vidioc-subdev-enum-frame-interval.xml      |  146 +++
 .../DocBook/v4l/vidioc-subdev-enum-frame-size.xml  |  148 +++
 .../DocBook/v4l/vidioc-subdev-enum-mbus-code.xml   |  113 ++
 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml |  143 +++
 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml  |  168 +++
 .../DocBook/v4l/vidioc-subdev-g-frame-interval.xml |  135 ++
 drivers/media/video/mt9m001.c                      |    2 +-
 drivers/media/video/mt9v022.c                      |    4 +-
 drivers/media/video/sh_mobile_csi2.c               |    6 +-
 drivers/media/video/soc_mediabus.c                 |    2 +-
 drivers/media/video/v4l2-subdev.c                  |  170 +++-
 include/linux/Kbuild                               |    2 +
 include/linux/v4l2-mediabus.h                      |   96 ++
 include/linux/v4l2-subdev.h                        |  141 +++
 include/media/soc_mediabus.h                       |    3 +-
 include/media/v4l2-mediabus.h                      |   53 +-
 include/media/v4l2-subdev.h                        |   51 +
 27 files changed, 2942 insertions(+), 89 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/bayer.pdf
 create mode 100644 Documentation/DocBook/v4l/bayer.png
 create mode 100644 Documentation/DocBook/v4l/dev-subdev.xml
 create mode 100644 Documentation/DocBook/v4l/pipeline.pdf
 create mode 100644 Documentation/DocBook/v4l/pipeline.png
 create mode 100644 Documentation/DocBook/v4l/subdev-formats.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-crop.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml
 create mode 100644 include/linux/v4l2-mediabus.h
 create mode 100644 include/linux/v4l2-subdev.h

-- 
Regards,

Laurent Pinchart


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:56472 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752623AbdDJT1K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCHv4 00/15] R-Car VSP1 Histogram Support
Date: Mon, 10 Apr 2017 21:26:36 +0200
Message-Id: <20170410192651.18486-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series is the rebased version of this pull request:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg111025.html

It slightly modifies 'Add metadata buffer type and format' (remove
experimental note and add newline after label) and it adds support
for V4L2_CTRL_FLAG_MODIFY_LAYOUT, as requested by Mauro.

No other changes were made.

Regards,

	Hans

Hans Verkuil (5):
  vidioc-queryctrl.rst: document V4L2_CTRL_FLAG_MODIFY_LAYOUT
  videodev.h: add V4L2_CTRL_FLAG_MODIFY_LAYOUT
  v4l2-ctrls.c: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for ROTATE
  buffer.rst: clarify how V4L2_CTRL_FLAG_MODIFY_LAYOUT/GRABBER are used
  vsp1: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for histogram controls

Laurent Pinchart (8):
  v4l: Clearly document interactions between formats, controls and
    buffers
  v4l: vsp1: wpf: Implement rotation support
  v4l: Add metadata buffer type and format
  v4l: vsp1: Add histogram support
  v4l: vsp1: Support histogram generators in pipeline configuration
  v4l: vsp1: Fix HGO and HGT routing register addresses
  v4l: Define a pixel format for the R-Car VSP1 1-D histogram engine
  v4l: vsp1: Add HGO support

Niklas Söderlund (2):
  v4l: Define a pixel format for the R-Car VSP1 2-D histogram engine
  v4l: vsp1: Add HGT support

 Documentation/media/uapi/v4l/buffer.rst            | 122 ++++
 Documentation/media/uapi/v4l/dev-meta.rst          |  58 ++
 Documentation/media/uapi/v4l/devices.rst           |   1 +
 Documentation/media/uapi/v4l/meta-formats.rst      |  16 +
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst        | 168 ++++++
 .../media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst        | 120 ++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   3 +
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |  13 +
 Documentation/media/videodev2.h.rst.exceptions     |   3 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/vsp1/Makefile               |   1 +
 drivers/media/platform/vsp1/vsp1.h                 |   6 +
 drivers/media/platform/vsp1/vsp1_drm.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |  70 ++-
 drivers/media/platform/vsp1/vsp1_entity.c          | 154 ++++-
 drivers/media/platform/vsp1/vsp1_entity.h          |   8 +-
 drivers/media/platform/vsp1/vsp1_hgo.c             | 230 ++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h             |  45 ++
 drivers/media/platform/vsp1/vsp1_hgt.c             | 222 +++++++
 drivers/media/platform/vsp1/vsp1_hgt.h             |  42 ++
 drivers/media/platform/vsp1/vsp1_histo.c           | 646 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_histo.h           |  84 +++
 drivers/media/platform/vsp1/vsp1_pipe.c            |  38 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   4 +
 drivers/media/platform/vsp1/vsp1_regs.h            |  33 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   5 +
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   7 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  42 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             | 205 +++++--
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  19 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |   4 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  16 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  36 ++
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   3 +
 include/media/v4l2-ioctl.h                         |  17 +
 include/trace/events/v4l2.h                        |   1 +
 include/uapi/linux/videodev2.h                     |  18 +
 39 files changed, 2364 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/dev-meta.rst
 create mode 100644 Documentation/media/uapi/v4l/meta-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h

-- 
2.11.0

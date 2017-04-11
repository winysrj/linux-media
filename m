Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34479 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752513AbdDKNlG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 09:41:06 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Remaining vsp patches,
 V4L2_CTRL_FLAG_MODIFY_LAYOUT support
Message-ID: <7e928b72-4411-3ecd-e72c-0ea514239e82@xs4all.nl>
Date: Tue, 11 Apr 2017 15:40:59 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These are the remaining vsp1 patches, plus the V4L2_CTRL_FLAG_MODIFY_LAYOUT
control & documentation and the buffer.rst documentation improvements.

Regards,

	Hans

The following changes since commit 4aed35ca73f6d9cfd5f7089ba5d04f5fb8623080:

  [media] v4l2-tpg: don't clamp XV601/709 to lim range (2017-04-10 14:58:06 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vsp1

for you to fetch changes up to e387b8ba72a471b471b977ccee21f63dd0f7c9f4:

  vsp1: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for histogram controls (2017-04-11 15:22:27 +0200)

----------------------------------------------------------------
Hans Verkuil (5):
      vidioc-queryctrl.rst: document V4L2_CTRL_FLAG_MODIFY_LAYOUT
      videodev.h: add V4L2_CTRL_FLAG_MODIFY_LAYOUT
      v4l2-ctrls.c: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for ROTATE
      buffer.rst: clarify how V4L2_CTRL_FLAG_MODIFY_LAYOUT/GRABBER are used
      vsp1: set V4L2_CTRL_FLAG_MODIFY_LAYOUT for histogram controls

Laurent Pinchart (8):
      v4l: Clearly document interactions between formats, controls and buffers
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

 Documentation/media/uapi/v4l/buffer.rst               | 122 ++++++++++++++++++++
 Documentation/media/uapi/v4l/dev-meta.rst             |  58 ++++++++++
 Documentation/media/uapi/v4l/devices.rst              |   1 +
 Documentation/media/uapi/v4l/meta-formats.rst         |  16 +++
 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgo.rst | 168 +++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-meta-vsp1-hgt.rst | 120 +++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt.rst               |   1 +
 Documentation/media/uapi/v4l/vidioc-querycap.rst      |   3 +
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst     |  13 +++
 Documentation/media/videodev2.h.rst.exceptions        |   3 +
 drivers/media/platform/Kconfig                        |   1 +
 drivers/media/platform/vsp1/Makefile                  |   1 +
 drivers/media/platform/vsp1/vsp1.h                    |   6 +
 drivers/media/platform/vsp1/vsp1_drm.c                |   2 +-
 drivers/media/platform/vsp1/vsp1_drv.c                |  70 +++++++++--
 drivers/media/platform/vsp1/vsp1_entity.c             | 154 ++++++++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_entity.h             |   8 +-
 drivers/media/platform/vsp1/vsp1_hgo.c                | 230 ++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h                |  45 ++++++++
 drivers/media/platform/vsp1/vsp1_hgt.c                | 222 +++++++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgt.h                |  42 +++++++
 drivers/media/platform/vsp1/vsp1_histo.c              | 646 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_histo.h              |  84 ++++++++++++++
 drivers/media/platform/vsp1/vsp1_pipe.c               |  38 +++++-
 drivers/media/platform/vsp1/vsp1_pipe.h               |   4 +
 drivers/media/platform/vsp1/vsp1_regs.h               |  33 +++++-
 drivers/media/platform/vsp1/vsp1_rpf.c                |   2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c               |   5 +
 drivers/media/platform/vsp1/vsp1_rwpf.h               |   7 +-
 drivers/media/platform/vsp1/vsp1_video.c              |  42 +++++--
 drivers/media/platform/vsp1/vsp1_wpf.c                | 205 +++++++++++++++++++++++++--------
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c         |  19 +++
 drivers/media/v4l2-core/v4l2-ctrls.c                  |   4 +
 drivers/media/v4l2-core/v4l2-dev.c                    |  16 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c                  |  36 ++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c              |   3 +
 include/media/v4l2-ioctl.h                            |  17 +++
 include/trace/events/v4l2.h                           |   1 +
 include/uapi/linux/videodev2.h                        |  18 +++
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

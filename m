Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36685 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbcIGIob (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 04:44:31 -0400
Received: by mail-wm0-f48.google.com with SMTP id b187so103549513wme.1
        for <linux-media@vger.kernel.org>; Wed, 07 Sep 2016 01:44:30 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 7 Sep 2016 10:44:09 +0200
Message-ID: <CAPybu_0jjiX6OXuesz0EyNq_XH7+XY33NWY6qERAZk5w1AE51g@mail.gmail.com>
Subject: [GIT PULL] HSV formats
To: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,


These patches add support for HSV.

HSV formats are extremely useful for image segmentation. This set of
patches makes v4l2 aware of this kind of formats.

Vivid changes have been divided to ease the reviewing process.

We are working on patches for Gstreamer and OpenCV that will make use
of these formats.

This pull request contains [PATCH v5 00/12] Add HSV format, plus the
following chanes:

-It has been rebased to media/master
-Laurent patch to add support for vsp1
-Hans Ack-by
-Documentation now make use of tabularcolumn (latex)

This is my first pull request :)

Please pull


The following changes since commit 036bbb8213ecca49799217f30497dc0484178e53:

  [media] cobalt: update EDID (2016-09-06 16:46:39 -0300)

are available in the git repository at:

  https://github.com/ribalda/linux.git vivid-hsv-v6

for you to fetch changes up to 1242d7e43b9053cd649ac5ec81aad8597e88ab46:

  [media] vsp1: Add support for capture and output in HSV formats
(2016-09-07 10:41:52 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      [media] vsp1: Add support for capture and output in HSV formats

Ricardo Ribalda Delgado (12):
      [media] videodev2.h Add HSV formats
      [media] Documentation: Add HSV format
      [media] Documentation: Add Ricardo Ribalda
      [media] vivid: Code refactor for color encoding
      [media] vivid: Add support for HSV formats
      [media] vivid: Rename variable
      [media] vivid: Introduce TPG_COLOR_ENC_LUMA
      [media] vivid: Fix YUV555 and YUV565 handling
      [media] vivid: Local optimization
      [media] videodev2.h Add HSV encoding
      [media] Documentation: Add HSV encodings
      [media] vivid: Add support for HSV encoding

 Documentation/media/uapi/v4l/hsv-formats.rst       |  19 ++++
 Documentation/media/uapi/v4l/pixfmt-002.rst        |  12 +-
 Documentation/media/uapi/v4l/pixfmt-003.rst        |  14 ++-
 Documentation/media/uapi/v4l/pixfmt-006.rst        |  43 ++++++-
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 164
+++++++++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/v4l2.rst              |   9 ++
 Documentation/media/videodev2.h.rst.exceptions     |   4 +
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      | 411
++++++++++++++++++++++++++++++++++++++++++++-----------------------
 drivers/media/platform/vivid/vivid-core.h          |   3 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |  25 +++++
 drivers/media/platform/vivid/vivid-vid-cap.c       |  17 ++-
 drivers/media/platform/vivid/vivid-vid-common.c    |  68 ++++++-----
 drivers/media/platform/vivid/vivid-vid-out.c       |   1 +
 drivers/media/platform/vsp1/vsp1_pipe.c            |   8 ++
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   2 +
 drivers/media/platform/vsp1/vsp1_video.c           |   5 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 include/media/v4l2-tpg.h                           |  24 +++-
 include/uapi/linux/videodev2.h                     |  36 +++++-
 20 files changed, 685 insertions(+), 183 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst


-- 
Ricardo Ribalda

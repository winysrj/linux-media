Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35130 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932340AbcJQVcZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 17:32:25 -0400
Received: by mail-qt0-f193.google.com with SMTP id g49so6696994qtc.2
        for <linux-media@vger.kernel.org>; Mon, 17 Oct 2016 14:32:25 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 17 Oct 2016 23:32:03 +0200
Message-ID: <CAPybu_1cpNz0HCKXjiYkJaf87SxL+rmTtrtCdw-CdczijSF-5Q@mail.gmail.com>
Subject: [GIT PULL] HSV formats v2
To: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These is the last PULL request rebased to your last master thanks to Laurent :)


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

Please pull:

The following changes since commit 11a1e0ed7908f04c896e69d0eb65e478c12f8519:

  [media] dvb-usb: warn if return value for USB read/write routines is
not checked (2016-10-14 12:52:31 -0300)

are available in the git repository at:

  https://github.com/ribalda/linux.git vivid-hsv-v7

for you to fetch changes up to 7cb9d88402c4f674887af165e1425f1fd347583f:

  v4l: vsp1: Add support for capture and output in HSV formats
(2016-10-17 23:20:10 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: vsp1: Add support for capture and output in HSV formats

Ricardo Ribalda Delgado (12):
      videodev2.h Add HSV formats
      Documentation: Add HSV format
      Documentation: Add Ricardo Ribalda
      vivid: Code refactor for color encoding
      vivid: Add support for HSV formats
      vivid: Rename variable
      vivid: Introduce TPG_COLOR_ENC_LUMA
      vivid: Fix YUV555 and YUV565 handling
      vivid: Local optimization
      videodev2.h Add HSV encoding
      Documentation: Add HSV encodings
      vivid: Add support for HSV encoding

 Documentation/media/uapi/v4l/hsv-formats.rst       |  19 +
 Documentation/media/uapi/v4l/pixfmt-002.rst        |   5 +
 Documentation/media/uapi/v4l/pixfmt-003.rst        |   5 +
 Documentation/media/uapi/v4l/pixfmt-006.rst        |  31 +-
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 157 ++++++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/v4l2.rst              |   9 +
 Documentation/media/videodev2.h.rst.exceptions     |   4 +
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      | 411 ++++++++++++++-------
 drivers/media/platform/vivid/vivid-core.h          |   3 +-
 drivers/media/platform/vivid/vivid-ctrls.c         |  25 ++
 drivers/media/platform/vivid/vivid-vid-cap.c       |  17 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |  68 ++--
 drivers/media/platform/vivid/vivid-vid-out.c       |   1 +
 drivers/media/platform/vsp1/vsp1_pipe.c            |   8 +
 drivers/media/platform/vsp1/vsp1_rwpf.c            |   2 +
 drivers/media/platform/vsp1/vsp1_video.c           |   5 +
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 include/media/v4l2-tpg.h                           |  24 +-
 include/uapi/linux/videodev2.h                     |  36 +-
 20 files changed, 653 insertions(+), 180 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst

-- 
Ricardo Ribalda

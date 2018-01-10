Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:40925 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755130AbeAJQJp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 11:09:45 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v7 0/6] V4L2 Explicit Synchronization
Date: Wed, 10 Jan 2018 14:07:26 -0200
Message-Id: <20180110160732.7722-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

v7 bring a fix for a crash when not using fences and a uAPI fix.
I've done a bit more of testing on it and also measured some
performance. On a intel laptop a DRM<->V4L2 pipeline with fences is
runnning twice as faster than the same pipeline with no fences.

For more details on how fences work refer to patch 6 in this series.

The test tools I've been using are:
https://gitlab.collabora.com/padovan/drm-v4l2-test
https://gitlab.collabora.com/padovan/v4l2-fences-test

Please review,

Gustavo

Gustavo Padovan (6):
  [media] vb2: add is_unordered callback for drivers
  [media] v4l: add 'unordered' flag to format description ioctl
  [media] vb2: add explicit fence user API
  [media] vb2: add in-fence support to QBUF
  [media] vb2: add out-fence support to QBUF
  [media] v4l: Document explicit synchronization behavior

 Documentation/media/uapi/v4l/buffer.rst          |  15 ++
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst |   3 +
 Documentation/media/uapi/v4l/vidioc-qbuf.rst     |  47 ++++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst |   9 +-
 drivers/media/common/videobuf/videobuf2-core.c   | 253 +++++++++++++++++++++--
 drivers/media/common/videobuf/videobuf2-v4l2.c   |  51 ++++-
 drivers/media/v4l2-core/Kconfig                  |  33 +++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |   4 +-
 include/media/videobuf2-core.h                   |  41 +++-
 include/uapi/linux/videodev2.h                   |   8 +-
 10 files changed, 437 insertions(+), 27 deletions(-)

-- 
2.14.3

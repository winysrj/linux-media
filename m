Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:42839 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdLKS14 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 13:27:56 -0500
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
Subject: [PATCH v6 0/6] V4L2 Explicit Synchronization
Date: Mon, 11 Dec 2017 16:27:35 -0200
Message-Id: <20171211182741.29712-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

One more iteration of the explicit fences patches, please refer
to the previous version[1] for more details about the general
mechanism

This version makes the patchset and the implementation much more
simple, to start we are not using a ordered capability anymore,
but instead we have a VIDIOC_ENUM_FMT flag to tell when the
queue in not ordered. Drivers with ordered queues/formats don't
need implement anything. See patches 1 and 2 for more details.

The implementation of in-fences and out-fences were condensed in
just patches 4 and 5, making it more self-contained and easy to
understand. See the patches for detailed changelog.

Please review! Thanks.

Gustavo.

[1] https://lkml.org/lkml/2017/11/15/550

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
 drivers/media/usb/cpia2/cpia2_v4l.c              |   2 +-
 drivers/media/v4l2-core/Kconfig                  |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |   4 +-
 drivers/media/v4l2-core/videobuf2-core.c         | 239 +++++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-v4l2.c         |  52 ++++-
 include/media/videobuf2-core.h                   |  41 +++-
 include/uapi/linux/videodev2.h                   |   8 +-
 11 files changed, 393 insertions(+), 28 deletions(-)

-- 
2.13.6

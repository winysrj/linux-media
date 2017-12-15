Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33200 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbdLOH4t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 02:56:49 -0500
Received: by mail-pf0-f196.google.com with SMTP id y89so5633092pfk.0
        for <linux-media@vger.kernel.org>; Thu, 14 Dec 2017 23:56:49 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 0/9] media: base request API support
Date: Fri, 15 Dec 2017 16:56:16 +0900
Message-Id: <20171215075625.27028-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is a new attempt at the request API, following the UAPI we agreed on in
Prague. Hopefully this can be used as the basis to move forward.

This series only introduces the very basics of how requests work: allocate a
request, queue buffers to it, queue the request itself, wait for it to complete,
reuse it. It does *not* yet use Hans' work with controls setting. I have
preferred to submit it this way for now as it allows us to concentrate on the
basic request/buffer flow, which was harder to get properly than I initially
thought. I still have a gut feeling that it can be improved, with less back-and-
forth into drivers.

Plugging in controls support should not be too hard a task (basically just apply
the saved controls when the request starts), and I am looking at it now.

The resulting vim2m driver can be successfully used with requests, and my tests
so far have been successful.

There are still some rougher edges:

* locking is currently quite coarse-grained
* too many #ifdef CONFIG_MEDIA_CONTROLLER in the code, as the request API
  depends on it - I plan to craft the headers so that it becomes unnecessary.
  As it is, some of the code will probably not even compile if
  CONFIG_MEDIA_CONTROLLER is not set

But all in all I think the request flow should be clear and easy to review, and
the possibility of custom queue and entity support implementations should give
us the flexibility we need to support more specific use-cases (I expect the
generic implementations to be sufficient most of the time though).

A very simple test program exercising this API is available here (don't forget
to adapt the /dev/media0 hardcoding):
https://gist.github.com/Gnurou/dbc3776ed97ea7d4ce6041ea15eb0438

Looking forward to your feedback and comments!

Alexandre Courbot (8):
  media: add request API core and UAPI
  media: request: add generic queue
  media: request: add generic entity ops
  media: vb2: add support for requests
  media: vb2: add support for requests in QBUF ioctl
  media: v4l2-mem2mem: add request support
  media: vim2m: add media device
  media: vim2m: add request support

Hans Verkuil (1):
  videodev2.h: Add request field to v4l2_buffer

 drivers/media/Makefile                        |   4 +-
 drivers/media/media-device.c                  |   6 +
 drivers/media/media-request-entity-generic.c  |  56 ++++
 drivers/media/media-request-queue-generic.c   | 150 ++++++++++
 drivers/media/media-request.c                 | 390 ++++++++++++++++++++++++++
 drivers/media/platform/vim2m.c                |  46 +++
 drivers/media/usb/cpia2/cpia2_v4l.c           |   2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   7 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  99 ++++++-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  34 +++
 drivers/media/v4l2-core/videobuf2-core.c      |  59 +++-
 drivers/media/v4l2-core/videobuf2-v4l2.c      |  32 ++-
 include/media/media-device.h                  |   3 +
 include/media/media-entity.h                  |   6 +
 include/media/media-request.h                 | 282 +++++++++++++++++++
 include/media/v4l2-mem2mem.h                  |  19 ++
 include/media/videobuf2-core.h                |  25 +-
 include/media/videobuf2-v4l2.h                |   2 +
 include/uapi/linux/media.h                    |  11 +
 include/uapi/linux/videodev2.h                |   3 +-
 20 files changed, 1216 insertions(+), 20 deletions(-)
 create mode 100644 drivers/media/media-request-entity-generic.c
 create mode 100644 drivers/media/media-request-queue-generic.c
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.15.1.504.g5279b80103-goog

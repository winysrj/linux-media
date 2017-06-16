Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34974 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdFPHja (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 03:39:30 -0400
Received: by mail-pg0-f68.google.com with SMTP id f127so4548590pgc.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 00:39:30 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH 00/12] V4L2 explicit synchronization support
Date: Fri, 16 Jun 2017 16:39:03 +0900
Message-Id: <20170616073915.5027-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

This adds support for Explicit Synchronization of shared buffers in V4L2.
It uses the Sync File Framework[1] as vector to communicate the fences
between kernel and userspace.

Explicit Synchronization allows us to control the synchronization of
shared buffers from userspace by passing fences to the kernel and/or 
receiving them from the the kernel.

Fences passed to the kernel are named in-fences and the kernel should wait
them to signal before using the buffer. On the other side, the kernel creates
out-fences for every buffer it receives from userspace. This fence is sent back
to userspace and it will signal when the capture, for example, has finished.

Signalling an out-fence in V4L2 would mean that the job on the buffer is done
and the buffer can be used by other drivers.

The first patch proposes an userspace API for fences, then on patch 2
we prepare to the addition of in-fences in patch 3, by introducing the
infrastructure on vb2 to wait on an in-fence signal before queueing the buffer
in the driver.

Patch 4 fix uvc v4l2 event handling and patch 5 configure q->dev for vivid
drivers to enable to subscribe and dequeue events on it.

Patches 6-7 enables support to notify BUF_QUEUED events, i.e., let userspace
know that particular buffer was enqueued in the driver. This is needed,
because we return the out-fence fd as an out argument in QBUF, but at the time
it returns we don't know to which buffer the fence will be attached thus
the BUF_QUEUED event tells which buffer is associated to the fence received in
QBUF by userspace.

Patches 8-9 add support to mark queues as ordered. Finally patches 10 and 11
add more fence infrastructure to support out-fences and finally patch 12 adds
support to out-fences.

Changelog are detailed in each patch.

Please review! Thanks.

Gustavo

[1] drivers/dma-buf/sync_file.c
---
Gustavo Padovan (11):
  [media] vb2: add explicit fence user API
  [media] vb2: split out queueing from vb_core_qbuf()
  [media] vb2: add in-fence support to QBUF
  [media] uvc: enable subscriptions to other events
  [media] vivid: assign the specific device to the vb2_queue->dev
  [media] v4l: add V4L2_EVENT_BUF_QUEUED event
  [media] v4l: add support to BUF_QUEUED event
  [media] vb2: add 'ordered' property to queues
  [media] vivid: mark vivid queues as ordered
  [media] vb2: add infrastructure to support out-fences
  [media] vb2: add out-fence support to QBUF

Javier Martinez Canillas (1):
  [media] vb2: add videobuf2 dma-buf fence helpers

 drivers/media/Kconfig                         |   1 +
 drivers/media/platform/vivid/vivid-core.c     |  15 ++-
 drivers/media/usb/uvc/uvc_v4l2.c              |   2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          |   6 +-
 drivers/media/v4l2-core/videobuf2-core.c      | 172 ++++++++++++++++++++++----
 drivers/media/v4l2-core/videobuf2-v4l2.c      |  37 +++++-
 include/media/videobuf2-core.h                |  16 ++-
 include/media/videobuf2-fence.h               |  49 ++++++++
 include/uapi/linux/videodev2.h                |  10 +-
 10 files changed, 272 insertions(+), 40 deletions(-)
 create mode 100644 include/media/videobuf2-fence.h

-- 
2.9.4

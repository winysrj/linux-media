Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36376 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755218AbdIGSmd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:42:33 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v3 00/15] V4L2 Explicit Synchronization support
Date: Thu,  7 Sep 2017 15:42:11 -0300
Message-Id: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

Refer to the documentation on the first patch for the details. The previous
iteration is here: https://www.mail-archive.com/linux-media@vger.kernel.org/msg118077.html

The 2nd patch proposes an userspace API for fences, then on patch 3 we
prepare to the addition of in-fences in patch 4, by introducing the
infrastructure on vb2 to wait on an in-fence signal before queueing the
buffer in the driver.

Patch 5 fix uvc v4l2 event handling and patch 6 configure q->dev for
vivid drivers to enable to subscribe and dequeue events on it.

Patches 7-9 enables support to notify BUF_QUEUED events, the event send
to userspace the out-fence fd and the index of the buffer that was queued.

Patches 10-11 add support to mark queues as ordered. Finally patches 12
and 13 add more fence infrastructure to support out-fences, patch 13 exposes
close_fd() and patch 14 adds support to out-fences. 

It only works for ordered queues for now, see open question at the end
of the letter.

Test tool can be found at:
https://git.collabora.com/cgit/user/padovan/v4l2-test.git/

Main Changes
------------

* out-fences: change in behavior: the out-fence fd now comes out of the
BUF_QUEUED event along with the buffer id.

All other changes are recorded on the patches' commit messages.

Open Questions
--------------

* non-ordered devices, like m2m: I've been thinking a lot about those
  and one possibility is to have a way to tell userspace that the queue
  is not ordered and then associate the fence with the current buffer in
  QBUF instead of the next one to be queued. Of course, there won't be
  any ordering between the fences. But it may be enough for userspace to
  take advantage of Explicit Synchronization in such cases. Any
  thoughts?

* OUTPUT devices and in-fence. If I understood OUTPUT devices correctly
  it is desirable to queue the buffers to the driver in the same order
  we received them from userspace. If that is correct, shouldn't we add
  some mechanism to prevent buffer whose fence signaled to jump ahead of
  others?

Gustavo Padovan (14):
  [media] v4l: Document explicit synchronization behaviour
  [media] vb2: add explicit fence user API
  [media] vb2: check earlier if stream can be started
  [media] vb2: add in-fence support to QBUF
  [media] uvc: enable subscriptions to other events
  [media] vivid: assign the specific device to the vb2_queue->dev
  [media] v4l: add V4L2_EVENT_BUF_QUEUED event
  [media] vb2: add .buffer_queued() to notify queueing in the driver
  [media] v4l: add support to BUF_QUEUED event
  [media] vb2: add 'ordered' property to queues
  [media] vivid: mark vivid queues as ordered
  [media] vb2: add infrastructure to support out-fences
  fs/files: export close_fd() symbol
  [media] vb2: add out-fence support to QBUF

Javier Martinez Canillas (1):
  [media] vb2: add videobuf2 dma-buf fence helpers

 Documentation/media/uapi/v4l/buffer.rst         |  19 ++
 Documentation/media/uapi/v4l/vidioc-dqevent.rst |  23 +++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst    |  31 ++++
 Documentation/media/videodev2.h.rst.exceptions  |   1 +
 drivers/android/binder.c                        |   2 +-
 drivers/media/platform/vivid/vivid-core.c       |  15 +-
 drivers/media/usb/cpia2/cpia2_v4l.c             |   2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                |   2 +-
 drivers/media/v4l2-core/Kconfig                 |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c            |   6 +-
 drivers/media/v4l2-core/videobuf2-core.c        | 221 ++++++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-v4l2.c        |  63 ++++++-
 fs/file.c                                       |   5 +-
 fs/open.c                                       |   2 +-
 include/linux/fdtable.h                         |   2 +-
 include/media/videobuf2-core.h                  |  63 ++++++-
 include/media/videobuf2-fence.h                 |  49 ++++++
 include/uapi/linux/videodev2.h                  |  15 +-
 19 files changed, 489 insertions(+), 37 deletions(-)
 create mode 100644 include/media/videobuf2-fence.h

-- 
2.13.5

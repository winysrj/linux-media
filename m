Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:34813 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdIABus (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:50:48 -0400
Received: by mail-qt0-f171.google.com with SMTP id u11so5822756qtu.1
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:50:48 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 00/14] V4L2 Explicit Synchronization support
Date: Thu, 31 Aug 2017 22:50:27 -0300
Message-Id: <20170901015041.7757-1-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

Explicit Synchronization allows us to control the synchronization of
shared buffers from userspace by passing fences to the kernel and/or
receiving them from it. Fences passed to the kernel are named in-fences
and the kernel should wait them to signal before using the buffer, i.e.,
queueing it to the driver. On the other side, the kernel can create
out-fences for the buffers it queues to the drivers, out-fences signal
when the driver is finished with buffer, that is, the buffer is ready.

The in-fences and out-fences are communicated at the VIDIOC_QBUF ioctl
using the V4L2_BUF_FLAG_IN_FENCE and V4L2_BUF_FLAG_OUT_FENCE buffer
flags and the fence_fd field. If an in-fence needs to be passed to the
kernel, fence_fd should be set to the fence file descriptor number and
the V4L2_BUF_FLAG_IN_FENCE should be set as well.

To get an out-fence back from V4L2 the V4L2_BUF_FLAG_OUT_FENCE flag
should be set and the fence_fd field will be returned with out-fence
file descriptor related to the next fence to be queued internally to the
V4L2 driver. That means the out-fence may not be associated with the
buffer in the current VIDIOC_QBUF ioctl call because the ordering in
which videobuf2 core queues the buffer to the drivers can’t be
guaranteed. To become aware of the buffer with which the out-fence will
be attached the V4L2_EVENT_BUF_QUEUED should be used. It will trigger an
event for every buffer queued to the V4L2 driver.

Note that the fence_fd field is both an input and output argument here
with different meaning on each direction. As input argument it carries
an in-fence and as output argument it carries an out-fence.

It only works for ordered queues for now, see open question at the end
of the letter.

Test tool can be found at:
https://git.collabora.com/cgit/user/padovan/v4l2-test.git/

The Patches
-----------

The first patch proposes an userspace API for fences, then on patch 2 we
prepare to the addition of in-fences in patch 3, by introducing the
infrastructure on vb2 to wait on an in-fence signal before queueing the
buffer in the driver.

Patch 4 fix uvc v4l2 event handling and patch 5 configure q->dev for
vivid drivers to enable to subscribe and dequeue events on it.

Patches 6-8 enables support to notify BUF_QUEUED events, i.e., let
userspace know that particular buffer was enqueued in the driver. This
is needed, because we return the out-fence fd as an out argument in
QBUF, but at the time it returns we don't know to which buffer the fence
will be attached thus the BUF_QUEUED event tells which buffer is
associated to the fence received in QBUF by userspace.

Patches 9-10 add support to mark queues as ordered. Finally patches 11
and 12 add more fence infrastructure to support out-fences and patch 13
adds support to out-fences. Patch 14 adds overall Documentation about
Explicit Synchronization.

Main Changes
------------

* There is now a .buffer_queued hook on vb2_ops to support notification to
  V4L2 users of buffer queued events
* When handling in-fences we never call vb2_start_streaming() in the fence
  callback, so on the QBUF that is going to trigger the start of the streaming
  we wait synchronously  for the fence to signal before calling
  vb2_start_streaming()
* out-fences: change in behavior: now the out-fence returned via  QBUF
  represents the out-fence of the next buffer to be queued
  to the driver. The buffer id comes out of the BUF_QUEUED event.

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

TODO
----

* Gstreamer patch to support fences for some real testing


Gustavo Padovan (13):
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
  [media] vb2: add out-fence support to QBUF
  [media] v4l: Document explicit synchronization behaviour

Javier Martinez Canillas (1):
  [media] vb2: add videobuf2 dma-buf fence helpers

 Documentation/media/uapi/v4l/buffer.rst         |  19 +++
 Documentation/media/uapi/v4l/vidioc-dqevent.rst |  18 ++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst    |  30 ++++
 Documentation/media/videodev2.h.rst.exceptions  |   1 +
 drivers/media/platform/vivid/vivid-core.c       |  15 +-
 drivers/media/usb/cpia2/cpia2_v4l.c             |   2 +-
 drivers/media/usb/uvc/uvc_v4l2.c                |   2 +-
 drivers/media/v4l2-core/Kconfig                 |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |   4 +-
 drivers/media/v4l2-core/v4l2-ctrls.c            |   6 +-
 drivers/media/v4l2-core/videobuf2-core.c        | 213 ++++++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-v4l2.c        |  51 +++++-
 include/media/videobuf2-core.h                  |  35 +++-
 include/media/videobuf2-fence.h                 |  49 ++++++
 include/uapi/linux/videodev2.h                  |  14 +-
 15 files changed, 428 insertions(+), 32 deletions(-)
 create mode 100644 include/media/videobuf2-fence.h

-- 
2.13.5

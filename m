Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:46131 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755597AbdKORLF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 12:11:05 -0500
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
Subject: [RFC v5 00/11] V4L2 Explicit Synchronization
Date: Wed, 15 Nov 2017 15:10:46 -0200
Message-Id: <20171115171057.17340-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

After the comments received in the last patchset[1] and 
during the media summit [2] here is the new and improved version
of the patchset. The implementation is simpler, smaller and cover
a lot more cases.

If you look to the last patchset I got rid of a few things, the main
one is the OUT_FENCE event, one thing that we decided in Prague was
that, when using fences, we would keep ordering of all buffers queued
to vb2. That means they would be queued to the drivers in the same order
that the QBUF calls happen, just like it already happens when not using
fences. Fences can signal in whatever order, so we need this guarantee
here. Drivers can, however, not keep ordering when processing the
buffers.

But there is one conclusion of that that we didn't reached at the
summit, maybe because of the order we discussed things, and that is: we do
not need the OUT_FENCE event anymore, because now at the QBUF call time
we *always* know the order in which the buffers will be queued to the
v4l2 driver. So the out-fence fd is now returned using the fence_fd
field as a return argument, thus the event is not necessary anymore.

The fence_fd field is now used to comunicate both in-fences and
out-fences, just like we do for GPU drivers. We pass in-fences as input
arguments and get out-fences as return arguments on the QBUF call.
The approach is documented.

I also added a capability flag, V4L2_CAP_ORDERED, to tell userspace if
the v4l2 drivers keep the buffers ordered or not. 

We still have the 'ordered_in_driver' property for queues, but its
meaning has changed. When set videobuf2 will know that the driver can
keep the order of the buffers, thus videobuf2 can use the same fence
context for all out-fences. Fences inside the same context should signal
in order, so 'ordered_in_driver' is a optimization for that case.
When not set, a context for each out-fence is created.

So now explicit synchronization also works for drivers that do not keep
the ordering of buffers.

Another thing is that we do not allow videobuf2 to requeue buffers
internally when using fences, they have a fence associated to it and
we need to finish the job on them, i.e., signal the fence, even if an
error happened.

The rest of the changes are documented in each patch separated.

There a test app at:

https://gitlab.collabora.com/padovan/v4l2-fences-test

Among my next steps is to create a v4l2->drm test app using fences as a
PoC, and also look into how to support it in ChromeOS.

Open Questions
--------------

* Do drivers reorder buffers internally? How to handle that with fences?

* How to handle audio/video syncronization? Fences aren't enough, we  need 
  to know things like the start of capture timestamp.

Regards,

Gustavo
--

[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1518928.html
[2] http://muistio.tieke.fi/p/media-summit-2017

Gustavo Padovan (10):
  [media] v4l: add V4L2_CAP_ORDERED to the uapi
  [media] vivid: add the V4L2_CAP_ORDERED capability
  [media] vb2: add 'ordered_in_driver' property to queues
  [media] vivid: mark vivid queues as ordered_in_driver
  [media] vb2: check earlier if stream can be started
  [media] vb2: add explicit fence user API
  [media] vb2: add in-fence support to QBUF
  [media] vb2: add infrastructure to support out-fences
  [media] vb2: add out-fence support to QBUF
  [media] v4l: Document explicit synchronization behavior

Javier Martinez Canillas (1):
  [media] vb2: add videobuf2 dma-buf fence helpers

 Documentation/media/uapi/v4l/buffer.rst          |  15 ++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst     |  42 +++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst |   9 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst |   3 +
 drivers/media/platform/vivid/vivid-core.c        |  24 +-
 drivers/media/usb/cpia2/cpia2_v4l.c              |   2 +-
 drivers/media/v4l2-core/Kconfig                  |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c    |   4 +-
 drivers/media/v4l2-core/videobuf2-core.c         | 274 +++++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-v4l2.c         |  48 +++-
 include/media/videobuf2-core.h                   |  44 +++-
 include/media/videobuf2-fence.h                  |  48 ++++
 include/uapi/linux/videodev2.h                   |   8 +-
 13 files changed, 485 insertions(+), 37 deletions(-)
 create mode 100644 include/media/videobuf2-fence.h

-- 
2.13.6

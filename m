Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38603 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728608AbeKSVcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 16:32:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCHv2 0/4] vb2: fix syzkaller race conditions
Date: Mon, 19 Nov 2018 12:08:59 +0100
Message-Id: <20181119110903.24383-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These four patches fix syzkaller race conditions. The first patch
fixes the case where VIDIOC_DQBUF (and indirectly via read()/write())
can release the core serialization mutex, thus allowing another thread
to access the same vb2 queue through a dup()ped filehandle.

If no new buffer is available the DQBUF ioctl will block and wait for
a new buffer to arrive. Before it waits it releases the serialization
lock, and afterwards it reacquires it. This is intentional, since you
do not want to block other ioctls while waiting for a buffer.

But this means that you need to flag that you are waiting for a buffer
and check the flag in the appropriate places.

Specifically, that has to happen for VIDIOC_REQBUFS and VIDIOC_CREATE_BUFS
since those can free/reallocate all buffers. Obviously you should not do
that while waiting for a new frame to arrive. The other place where the
flag should be checked is in VIDIOC_DQBUF and read/write since it makes
not sense to call those while another fd is already waiting for a new
frame.

The remaining three patches fix a problem with vivid: due to the way
vivid was designed it had to release the dev->mutex lock when stop_streaming
was called. However, that was the same lock that was assigned to
queue->lock, so that caused a race condition as well. It really is a
vivid bug, which I fixed by giving each queue its own lock instead of
relying on dev->mutex.

It is a good idea to have vivid do this, since, while vb2 has allowed this
for a long time, no drivers were actually using that feature.

But while analyzing the behavior of vivid and vb2 in this scenario I
realized that doing this (i.e. separate mutexes per queue) caused another
race between calling queue_setup and VIDIOC_S_FMT: if queue->lock and
the ioctl serialization lock are the same, then those operations are
nicely serialized. But if the locks are different, then it is possible
that S_FMT changes the buffer size right after queue_setup returns.

So queue_setup might report that each buffer is 1 MB, while the S_FMT
changes it to 2 MB. So there is now a mismatch between what vb2 thinks
the size should be and what the driver thinks.

So to do this correctly the ioctl serialization lock (or whatever the
driver uses for that) should be taken before calling queue_setup and
released once q->num_buffers has been updated (so vb2_is_busy()
will return true).

The final two patches add support for that.

Regards,

	Hans

Hans Verkuil (4):
  vb2: add waiting_in_dqbuf flag
  vivid: use per-queue mutexes instead of one global mutex.
  vb2 core: add new queue_setup_lock/unlock ops
  vivid: add queue_setup_(un)lock ops

 .../media/common/videobuf2/videobuf2-core.c   | 71 +++++++++++++++----
 drivers/media/platform/vivid/vivid-core.c     | 29 ++++++--
 drivers/media/platform/vivid/vivid-core.h     |  8 +++
 .../media/platform/vivid/vivid-kthread-cap.c  |  2 -
 .../media/platform/vivid/vivid-kthread-out.c  |  2 -
 drivers/media/platform/vivid/vivid-sdr-cap.c  |  4 +-
 drivers/media/platform/vivid/vivid-vbi-cap.c  |  2 +
 drivers/media/platform/vivid/vivid-vbi-out.c  |  2 +
 drivers/media/platform/vivid/vivid-vid-cap.c  |  2 +
 drivers/media/platform/vivid/vivid-vid-out.c  |  2 +
 include/media/videobuf2-core.h                | 20 ++++++
 11 files changed, 119 insertions(+), 25 deletions(-)

-- 
2.19.1

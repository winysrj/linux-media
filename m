Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:48888 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728818AbeKNBHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 20:07:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Myungho Jung <mhjungk@gmail.com>
Subject: [PATCH 0/2] vb2: fix syzkaller race conditions
Date: Tue, 13 Nov 2018 16:08:32 +0100
Message-Id: <20181113150834.22125-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

These two patches fix syzkaller race conditions. The basic problem is
the same for both: in some specific cases an ioctl can release the
core serialization mutex, thus allowing another thread to access the
same vb2 queue through a dup()ped filehandle.

This can happen in VIDIOC_DQBUF and read()/write() (this calls dqbuf
internally, so it is really the same problem): if no new buffer is
available the DQBUF ioctl will block and wait for a new
buffer to arrive. Before it waits it releases the serialization lock,
and afterwards it reacquires it. This is intentional, since you do not
want to block other ioctls while waiting for a buffer.

But this means that you need to flag that you are waiting for a buffer
and check the flag in the appropriate places.

The same can happen in the stop_streaming operation: the driver may
have to release the serialization lock while waiting for streaming to
stop (vivid does this). The same approach is used to prevent new
read()s/write()s or QBUF ioctls while it is in stop_streaming.

These flags are always checked/set with the serialization mutex locked.

Regards,

	Hans

Hans Verkuil (2):
  vb2: add waiting_in_dqbuf flag
  vb2: don't allow queueing buffers when canceling queue

 .../media/common/videobuf2/videobuf2-core.c   | 32 ++++++++++++++++++-
 include/media/videobuf2-core.h                |  2 ++
 2 files changed, 33 insertions(+), 1 deletion(-)

-- 
2.19.1

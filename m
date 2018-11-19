Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34995 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728613AbeKSVcY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 16:32:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 1/4] vb2: add waiting_in_dqbuf flag
Date: Mon, 19 Nov 2018 12:09:00 +0100
Message-Id: <20181119110903.24383-2-hverkuil@xs4all.nl>
In-Reply-To: <20181119110903.24383-1-hverkuil@xs4all.nl>
References: <20181119110903.24383-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling VIDIOC_DQBUF can release the core serialization lock pointed to
by vb2_queue->lock if it has to wait for a new buffer to arrive.

However, if userspace dup()ped the video device filehandle, then it is
possible to read or call DQBUF from two filehandles at the same time.

It is also possible to call REQBUFS from one filehandle while the other
is waiting for a buffer. This will remove all the buffers and reallocate
new ones. Removing all the buffers isn't the problem here (that's already
handled correctly by DQBUF), but the reallocating part is: DQBUF isn't
aware that the buffers have changed.

This is fixed by setting a flag whenever the lock is released while waiting
for a buffer to arrive. And checking the flag where needed so we can return
-EBUSY.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com
---
 .../media/common/videobuf2/videobuf2-core.c   | 22 +++++++++++++++++++
 include/media/videobuf2-core.h                |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 975ff5669f72..f7e7e633bcd7 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -672,6 +672,11 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -EBUSY;
 	}
 
+	if (q->waiting_in_dqbuf && *count) {
+		dprintk(1, "another dup()ped fd is waiting for a buffer\n");
+		return -EBUSY;
+	}
+
 	if (*count == 0 || q->num_buffers != 0 ||
 	    (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
 		/*
@@ -809,6 +814,10 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 	}
 
 	if (!q->num_buffers) {
+		if (q->waiting_in_dqbuf && *count) {
+			dprintk(1, "another dup()ped fd is waiting for a buffer\n");
+			return -EBUSY;
+		}
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 		q->memory = memory;
 		q->waiting_for_buffers = !q->is_output;
@@ -1621,6 +1630,11 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 	for (;;) {
 		int ret;
 
+		if (q->waiting_in_dqbuf) {
+			dprintk(1, "another dup()ped fd is waiting for a buffer\n");
+			return -EBUSY;
+		}
+
 		if (!q->streaming) {
 			dprintk(1, "streaming off, will not wait for buffers\n");
 			return -EINVAL;
@@ -1648,6 +1662,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 			return -EAGAIN;
 		}
 
+		q->waiting_in_dqbuf = 1;
 		/*
 		 * We are streaming and blocking, wait for another buffer to
 		 * become ready or for streamoff. Driver's lock is released to
@@ -1668,6 +1683,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		 * the locks or return an error if one occurred.
 		 */
 		call_void_qop(q, wait_finish, q);
+		q->waiting_in_dqbuf = 0;
 		if (ret) {
 			dprintk(1, "sleep was interrupted\n");
 			return ret;
@@ -2539,6 +2555,12 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 	if (!data)
 		return -EINVAL;
 
+	if (q->waiting_in_dqbuf) {
+		dprintk(3, "another dup()ped fd is %s\n",
+			read ? "reading" : "writing");
+		return -EBUSY;
+	}
+
 	/*
 	 * Initialize emulator on first call.
 	 */
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index e86981d615ae..613f22910174 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -584,6 +584,7 @@ struct vb2_queue {
 	unsigned int			start_streaming_called:1;
 	unsigned int			error:1;
 	unsigned int			waiting_for_buffers:1;
+	unsigned int			waiting_in_dqbuf:1;
 	unsigned int			is_multiplanar:1;
 	unsigned int			is_output:1;
 	unsigned int			copy_timestamp:1;
-- 
2.19.1

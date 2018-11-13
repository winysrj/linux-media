Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:40290 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732298AbeKNBHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 20:07:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Myungho Jung <mhjungk@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/2] vb2: don't allow queueing buffers when canceling queue
Date: Tue, 13 Nov 2018 16:08:34 +0100
Message-Id: <20181113150834.22125-3-hverkuil@xs4all.nl>
In-Reply-To: <20181113150834.22125-1-hverkuil@xs4all.nl>
References: <20181113150834.22125-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling the stop_streaming op can release the core serialization lock
pointed to by vb2_queue->lock if it has to wait for buffers to finish.
An example of that behavior is the vivid driver.

However, if userspace dup()ped the video device filehandle, then it is
possible to stop streaming on one filehandle and call read/write or
VIDIOC_QBUF from the other.

This is fixed by setting a flag whenever stop_streaming is called and
checking the flag where needed so we can return -EBUSY.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: syzbot+736c3aae4af7b50d9683@syzkaller.appspotmail.com
---
 drivers/media/common/videobuf2/videobuf2-core.c | 14 +++++++++++++-
 include/media/videobuf2-core.h                  |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 138223af701f..560577321fe7 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1503,6 +1503,10 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		dprintk(1, "fatal error occurred on queue\n");
 		return -EIO;
 	}
+	if (q->in_stop_streaming) {
+		dprintk(1, "stop_streaming is called\n");
+		return -EBUSY;
+	}
 
 	vb = q->bufs[index];
 
@@ -1834,8 +1838,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 * Tell driver to stop all transactions and release all queued
 	 * buffers.
 	 */
-	if (q->start_streaming_called)
+	if (q->start_streaming_called) {
+		q->in_stop_streaming = 1;
 		call_void_qop(q, stop_streaming, q);
+		q->in_stop_streaming = 0;
+	}
 
 	/*
 	 * If you see this warning, then the driver isn't cleaning up properly
@@ -2565,6 +2572,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		return -EBUSY;
 	}
 
+	if (q->in_stop_streaming) {
+		dprintk(3, "stop_streaming is called\n");
+		return -EBUSY;
+	}
+
 	/*
 	 * Initialize emulator on first call.
 	 */
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 613f22910174..5a3d3ada5940 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -585,6 +585,7 @@ struct vb2_queue {
 	unsigned int			error:1;
 	unsigned int			waiting_for_buffers:1;
 	unsigned int			waiting_in_dqbuf:1;
+	unsigned int			in_stop_streaming:1;
 	unsigned int			is_multiplanar:1;
 	unsigned int			is_output:1;
 	unsigned int			copy_timestamp:1;
-- 
2.19.1

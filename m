Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53334 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaKBOxh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:53:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v2 06/13] v4l: vb2: Fix race condition in vb2_fop_poll
Date: Sun,  2 Nov 2014 16:53:31 +0200
Message-Id: <1414940018-3016-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_fop_poll() implementation tries to be clever on whether it needs
to lock the queue mutex by checking whether polling might start fileio.
The test requires reading the q->num_buffer field, which is racy if we
don't hold the queue mutex in the first place.

Remove the extra cleverness and just lock the mutex.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f2e43de..de59465f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3455,27 +3455,16 @@ unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
 	struct video_device *vdev = video_devdata(file);
 	struct vb2_queue *q = vdev->queue;
 	struct mutex *lock = q->lock ? q->lock : vdev->lock;
-	unsigned long req_events = poll_requested_events(wait);
 	unsigned res;
 	void *fileio;
-	bool must_lock = false;
-
-	/* Try to be smart: only lock if polling might start fileio,
-	   otherwise locking will only introduce unwanted delays. */
-	if (q->num_buffers == 0 && !vb2_fileio_is_active(q)) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
-				(req_events & (POLLIN | POLLRDNORM)))
-			must_lock = true;
-		else if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
-				(req_events & (POLLOUT | POLLWRNORM)))
-			must_lock = true;
-	}
 
-	/* If locking is needed, but this helper doesn't know how, then you
-	   shouldn't be using this helper but you should write your own. */
-	WARN_ON(must_lock && !lock);
+	/*
+	 * If this helper doesn't know how to lock, then you shouldn't be using
+	 * it but you should write your own.
+	 */
+	WARN_ON(!lock);
 
-	if (must_lock && lock && mutex_lock_interruptible(lock))
+	if (lock && mutex_lock_interruptible(lock))
 		return POLLERR;
 
 	fileio = q->fileio;
@@ -3483,9 +3472,9 @@ unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
 	res = vb2_poll(vdev->queue, file, wait);
 
 	/* If fileio was started, then we have a new queue owner. */
-	if (must_lock && !fileio && q->fileio)
+	if (!fileio && q->fileio)
 		q->owner = file->private_data;
-	if (must_lock && lock)
+	if (lock)
 		mutex_unlock(lock);
 	return res;
 }
-- 
2.0.4


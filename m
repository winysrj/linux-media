Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:44423 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbbCCLYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 06:24:16 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6977E2A008D
	for <linux-media@vger.kernel.org>; Tue,  3 Mar 2015 12:23:59 +0100 (CET)
Message-ID: <54F599CF.90508@xs4all.nl>
Date: Tue, 03 Mar 2015 12:23:59 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vb2: check if vb2_fop_write/read is allowed
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return -EINVAL if read() or write() is not supported by the queue. This
makes it possible to provide both vb2_fop_read and vb2_fop_write in a
struct v4l2_file_operations since the vb2_fop_* function will check if
the file operation is allowed.

A similar check exists in __vb2_init_fileio() which is called from
__vb2_perform_fileio(), but that check is only done if no file I/O is
active. So the sequence of read() followed by write() would be allowed,
which is obviously a bug.

In addition, vb2_fop_write/read should always return -EINVAL if the
operation is not allowed, and by putting the check in the lower levels
of the code it is possible that other error codes are returned (EBUSY
or ERESTARTSYS).

All these issues are avoided by just doing a quick explicit check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index bc08a82..167c1d9 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3416,6 +3416,8 @@ ssize_t vb2_fop_write(struct file *file, const char __user *buf,
 	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 	int err = -EBUSY;
 
+	if (!(vdev->queue->io_modes & VB2_WRITE))
+		return -EINVAL;
 	if (lock && mutex_lock_interruptible(lock))
 		return -ERESTARTSYS;
 	if (vb2_queue_is_busy(vdev, file))
@@ -3438,6 +3440,8 @@ ssize_t vb2_fop_read(struct file *file, char __user *buf,
 	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
 	int err = -EBUSY;
 
+	if (!(vdev->queue->io_modes & VB2_READ))
+		return -EINVAL;
 	if (lock && mutex_lock_interruptible(lock))
 		return -ERESTARTSYS;
 	if (vb2_queue_is_busy(vdev, file))

Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:27311 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2INLPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 07:15:43 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id q8EBFghN000742
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 11:15:42 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 API PATCH 1/4] vb2: fix wrong owner check
Date: Fri, 14 Sep 2012 13:15:33 +0200
Message-Id: <da47f14735bb06321de298db1cb50172f8e1f480.1347620872.git.hans.verkuil@cisco.com>
In-Reply-To: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
References: <1347621336-14108-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check against q->fileio to see if the queue owner should be set or not.
The former check against the return value of read or write is wrong, since
read/write can return an error, even if the queue is in streaming mode.
For example, EAGAIN when in non-blocking mode.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4da3df6..59ed522 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2278,7 +2278,7 @@ ssize_t vb2_fop_write(struct file *file, char __user *buf,
 		goto exit;
 	err = vb2_write(vdev->queue, buf, count, ppos,
 		       file->f_flags & O_NONBLOCK);
-	if (err >= 0)
+	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
 exit:
 	if (lock)
@@ -2300,7 +2300,7 @@ ssize_t vb2_fop_read(struct file *file, char __user *buf,
 		goto exit;
 	err = vb2_read(vdev->queue, buf, count, ppos,
 		       file->f_flags & O_NONBLOCK);
-	if (err >= 0)
+	if (vdev->queue->fileio)
 		vdev->queue->owner = file->private_data;
 exit:
 	if (lock)
-- 
1.7.10.4


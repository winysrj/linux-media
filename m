Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57016 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754082AbcDFLqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2016 07:46:22 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com
Subject: [PATCH 1/2] videobuf2-core: Check user space planes array in dqbuf
Date: Wed,  6 Apr 2016 14:46:07 +0300
Message-Id: <1459943168-18406-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1459943168-18406-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1459943168-18406-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The number of planes in videobuf2 is specific to a buffer. In order to
verify that the planes array provided by the user is long enough, a new
vb2_buf_op is required.

Call __verify_planes_array() when the dequeued buffer is known. Return an
error to the caller if there was one, otherwise remove the buffer from the
done list.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 10 +++++-----
 include/media/videobuf2-core.h           |  4 ++++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5d016f4..2169544 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1645,7 +1645,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
  * Will sleep if required for nonblocking == false.
  */
 static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
-				int nonblocking)
+			     void *pb, int nonblocking)
 {
 	unsigned long flags;
 	int ret;
@@ -1666,10 +1666,10 @@ static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
 	/*
 	 * Only remove the buffer from done_list if v4l2_buffer can handle all
 	 * the planes.
-	 * Verifying planes is NOT necessary since it already has been checked
-	 * before the buffer is queued/prepared. So it can never fail.
 	 */
-	list_del(&(*vb)->done_entry);
+	ret = call_bufop(q, verify_planes_array, *vb, pb);
+	if (!ret)
+		list_del(&(*vb)->done_entry);
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	return ret;
@@ -1748,7 +1748,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	struct vb2_buffer *vb = NULL;
 	int ret;
 
-	ret = __vb2_get_done_vb(q, &vb, nonblocking);
+	ret = __vb2_get_done_vb(q, &vb, pb, nonblocking);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8a0f55b..e2b1773 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -375,6 +375,9 @@ struct vb2_ops {
 /**
  * struct vb2_ops - driver-specific callbacks
  *
+ * @verify_planes_array:Verify that a given user space structure contains
+ *			enough planes for the buffer. This is called
+ *			for each dequeued buffer.
  * @fill_user_buffer:	given a vb2_buffer fill in the userspace structure.
  *			For V4L2 this is a struct v4l2_buffer.
  * @fill_vb2_buffer:	given a userspace structure, fill in the vb2_buffer.
@@ -384,6 +387,7 @@ struct vb2_ops {
  *			the vb2_buffer struct.
  */
 struct vb2_buf_ops {
+	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
 	void (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
 	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
 				struct vb2_plane *planes);
-- 
2.1.4


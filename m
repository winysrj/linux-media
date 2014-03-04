Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3684 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbaCDKnQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Mar 2014 05:43:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 13/18] vb2: properly clean up PREPARED and QUEUED buffers
Date: Tue,  4 Mar 2014 11:42:21 +0100
Message-Id: <1393929746-39437-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
References: <1393929746-39437-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If __reqbufs was called then existing buffers are freed. However, if that
happens without ever having started STREAMON, but if buffers have been queued,
then the buf_finish op is never called.

Add a call to __vb2_queue_cancel in __reqbufs so that these buffers are
cleaned up there as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 1f6eccf..8dc8d50 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -96,6 +96,8 @@ module_param(debug, int, 0644);
 				 V4L2_BUF_FLAG_PREPARED | \
 				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
 
+static void __vb2_queue_cancel(struct vb2_queue *q);
+
 /**
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
@@ -789,6 +791,12 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 			return -EBUSY;
 		}
 
+		/*
+		 * Call queue_cancel to clean up any buffers in the PREPARED or
+		 * QUEUED state which is possible if buffers were prepared or
+		 * queued without ever calling STREAMON.
+		 */
+		__vb2_queue_cancel(q);
 		ret = __vb2_queue_free(q, q->num_buffers);
 		if (ret)
 			return ret;
-- 
1.9.0


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42660 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbKBEnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2015 23:43:55 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NX6017KF7T0YT00@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Nov 2015 13:43:48 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v8 4/6] media: videobuf2: last_buffer_queued is set at
 fill_v4l2_buffer()
Date: Mon, 02 Nov 2015 13:43:43 +0900
Message-id: <1446439425-13242-5-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1446439425-13242-1-git-send-email-jh1009.sung@samsung.com>
References: <1446439425-13242-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The location in which last_buffer_queued is set is moved to fill_v4l2_buffer().
So, __vb2_perform_fileio() can use vb2_core_dqbuf() instead of
vb2_internal_dqbuf().

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 5be9ed8e..1468b30 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -274,6 +274,11 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	if (vb2_buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
 
+	if (!q->is_output &&
+		b->flags & V4L2_BUF_FLAG_DONE &&
+		b->flags & V4L2_BUF_FLAG_LAST)
+		q->last_buffer_dequeued = true;
+
 	return 0;
 }
 
@@ -584,10 +589,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 
 	ret = vb2_core_dqbuf(q, b, nonblocking);
 
-	if (!ret && !q->is_output &&
-			b->flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
-
 	return ret;
 }
 
-- 
1.7.9.5


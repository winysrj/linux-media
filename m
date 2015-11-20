Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47954 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1163059AbbKTQuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:50:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv11 07/15] media: videobuf2: last_buffer_queued is set at fill_v4l2_buffer()
Date: Fri, 20 Nov 2015 17:45:40 +0100
Message-Id: <1448037948-36820-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Junghak Sung <jh1009.sung@samsung.com>

The location in which last_buffer_queued is set is moved to fill_v4l2_buffer().
So, __vb2_perform_fileio() can use vb2_core_dqbuf() instead of
vb2_internal_dqbuf().

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index a6945ee..91728c1 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -270,6 +270,11 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	if (vb2_buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
 
+	if (!q->is_output &&
+		b->flags & V4L2_BUF_FLAG_DONE &&
+		b->flags & V4L2_BUF_FLAG_LAST)
+		q->last_buffer_dequeued = true;
+
 	return 0;
 }
 
@@ -617,10 +622,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 
 	ret = vb2_core_dqbuf(q, b, nonblocking);
 
-	if (!ret && !q->is_output &&
-			b->flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
-
 	return ret;
 }
 
-- 
2.6.2


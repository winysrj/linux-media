Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53311 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbKCKQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 05:16:48 -0500
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NX802I24HVW5M60@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Nov 2015 19:16:44 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v9 4/6] media: videobuf2: last_buffer_queued is set at
 fill_v4l2_buffer()
Date: Tue, 03 Nov 2015 19:16:40 +0900
Message-id: <1446545802-28496-5-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
References: <1446545802-28496-1-git-send-email-jh1009.sung@samsung.com>
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
index 0ca9f23..b0293df 100644
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
 
@@ -579,10 +584,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 
 	ret = vb2_core_dqbuf(q, b, nonblocking);
 
-	if (!ret && !q->is_output &&
-			b->flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
-
 	return ret;
 }
 
-- 
1.7.9.5


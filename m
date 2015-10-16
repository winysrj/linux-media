Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:37279 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbJPG1s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2015 02:27:48 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NWA00VC5VAAC370@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Oct 2015 15:27:46 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH v7 5/7] media: videobuf2: last_buffer_queued is checked at
 fill_v4l2_buffer()
Date: Fri, 16 Oct 2015 15:27:41 +0900
Message-id: <1444976863-3657-6-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
References: <1444976863-3657-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The location to set last_buffer_queued is moved to fill_v4l2_buffer().
So, vb2_core_dqbuf() can be used instead of vb2_internal_dqbuf()
in __vb2_perform_fileio().

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 8ea4d9e..dabcb6d 100644
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
 
@@ -580,10 +585,6 @@ static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 
 	ret = vb2_core_dqbuf(q, b, nonblocking);
 
-	if (!ret && !q->is_output &&
-			b->flags & V4L2_BUF_FLAG_LAST)
-		q->last_buffer_dequeued = true;
-
 	return ret;
 }
 
-- 
1.7.9.5


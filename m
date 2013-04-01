Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42478 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab3DAGkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 02:40:42 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MKK0011OD7O3JO0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Apr 2013 15:40:41 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	hans.verkuil@cisco.com, pawel@osciak.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: [RFC][PATCH 1/2] media: vb2: return for polling if a buffer is
 available
Date: Mon, 01 Apr 2013 15:40:46 +0900
Message-id: <1364798447-32224-2-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
References: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_poll() does not need to wait next vb_buffer_done() if there is already
a buffer in done_list of queue, but current vb2_poll() always waits.
So done_list is checked before calling poll_wait().

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index db1235d..e941d2b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1996,7 +1996,8 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	if (list_empty(&q->queued_list))
 		return res | POLLERR;
 
-	poll_wait(file, &q->done_wq, wait);
+	if (list_empty(&q->done_list))
+		poll_wait(file, &q->done_wq, wait);
 
 	/*
 	 * Take first buffer available for dequeuing.
-- 
1.7.4.1


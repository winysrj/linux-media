Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34906 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3EUDrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 23:47:32 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MN400F77QJ69OM0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 May 2013 12:47:30 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: m.szyprowski@samsung.com, hans.verkuil@cisco.com, pawel@osciak.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: [RESEND][PATCH 1/2] media: vb2: return for polling if a buffer is
 available
Date: Tue, 21 May 2013 12:47:29 +0900
Message-id: <1369108050-13522-2-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1369108050-13522-1-git-send-email-sw0312.kim@samsung.com>
References: <1369108050-13522-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_poll() does not need to wait next vb_buffer_done() if there is already
a buffer in done_list of queue, but current vb2_poll() always waits.
So done_list is checked before calling poll_wait().

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> 
---
 drivers/media/v4l2-core/videobuf2-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7d833ee..e3bdc3b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2014,7 +2014,8 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	if (list_empty(&q->queued_list))
 		return res | POLLERR;
 
-	poll_wait(file, &q->done_wq, wait);
+	if (list_empty(&q->done_list))
+		poll_wait(file, &q->done_wq, wait);
 
 	/*
 	 * Take first buffer available for dequeuing.
-- 
1.7.4.1


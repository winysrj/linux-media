Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:11566 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3DAGkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 02:40:42 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MKK00DKSD7TVEM0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Apr 2013 15:40:41 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	hans.verkuil@cisco.com, pawel@osciak.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: [RFC][PATCH 2/2] media: v4l2-mem2mem: return for polling if a buffer
 is available
Date: Mon, 01 Apr 2013 15:40:47 +0900
Message-id: <1364798447-32224-3-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
References: <1364798447-32224-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_poll() does not need to wait if there is already a buffer in
done_list of source and destination queues, but current v4l2_m2m_poll() always
waits. So done_list of each queue is checked before calling poll_wait().

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index da99cf7..b6f0316 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -458,8 +458,10 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 	if (m2m_ctx->m2m_dev->m2m_ops->unlock)
 		m2m_ctx->m2m_dev->m2m_ops->unlock(m2m_ctx->priv);
 
-	poll_wait(file, &src_q->done_wq, wait);
-	poll_wait(file, &dst_q->done_wq, wait);
+	if (list_empty(&src_q->done_list))
+		poll_wait(file, &src_q->done_wq, wait);
+	if (list_empty(&dst_q->done_list))
+		poll_wait(file, &dst_q->done_wq, wait);
 
 	if (m2m_ctx->m2m_dev->m2m_ops->lock)
 		m2m_ctx->m2m_dev->m2m_ops->lock(m2m_ctx->priv);
-- 
1.7.4.1


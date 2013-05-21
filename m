Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34906 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3EUDrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 23:47:33 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MN400558QINUN60@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 May 2013 12:47:30 +0900 (KST)
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: m.szyprowski@samsung.com, hans.verkuil@cisco.com, pawel@osciak.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com
Subject: [RESEND][PATCH 2/2] media: v4l2-mem2mem: return for polling if a
 buffer is available
Date: Tue, 21 May 2013 12:47:30 +0900
Message-id: <1369108050-13522-3-git-send-email-sw0312.kim@samsung.com>
In-reply-to: <1369108050-13522-1-git-send-email-sw0312.kim@samsung.com>
References: <1369108050-13522-1-git-send-email-sw0312.kim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_poll() does not need to wait if there is already a buffer in
done_list of source and destination queues, but current v4l2_m2m_poll() always
waits. So done_list of each queue is checked before calling poll_wait().

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com> 
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 66f599f..9ac39b5 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -486,8 +486,10 @@ unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
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


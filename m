Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56008 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3JaA6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 20:58:30 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MVI00CG1DD80460@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Oct 2013 09:58:29 +0900 (KST)
From: =?ks_c_5601-1987?B?sK28usO1?= <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org, m.chehab@samsung.com,
	kgene.kim@samsung.com, sylvester.nawrocki@gmail.com
Subject: [PATCH] media: v4l2-mem2mem: Fixed bug v4l2_m2m_streamoff function
Date: Thu, 31 Oct 2013 09:58:28 +0900
Message-id: <000001ced5d4$4fd78330$ef868990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 
In multi-instance scenario with multi-core, m2m_ctx->queue is removed again
sometimes.
So, it is need to check whether the queue is removed or not.
 
Change-Id: Ie938e9026039304388a369d5d10d1654213ba3b1
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
---
drivers/media/v4l2-core/v4l2-mem2mem.c |   11 ++++++++---
1 files changed, 8 insertions(+), 3 deletions(-)
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-
core/v4l2-mem2mem.c
index 8512314..47b8fdd 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -438,9 +438,14 @@ int v4l2_m2m_streamoff(struct file *file, struct
v4l2_m2m_ctx *m2m_ctx,
m2m_dev = m2m_ctx->m2m_dev;
spin_lock_irqsave(&m2m_dev->job_spinlock, flags_job);
/* We should not be scheduled anymore, since we're dropping a queue. */
-       if (!list_empty(&m2m_dev->job_queue))
-               list_del(&m2m_ctx->queue);
-
+       if (!list_empty(&m2m_dev->job_queue)) {
+               struct v4l2_m2m_ctx *list_ctx, *temp_ctx;
+               list_for_each_entry_safe(list_ctx, temp_ctx,
+                       &m2m_dev->job_queue, queue) {
+               if (list_ctx == m2m_ctx)
+                       list_del(&m2m_ctx->queue);
+               }
+       }
INIT_LIST_HEAD(&m2m_ctx->queue);
m2m_ctx->job_flags = 0;

-- 
1.7.4.1


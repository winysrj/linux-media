Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61596 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751655AbdLUQSQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Satendra Singh Thakur <satendra.t@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 01/11] media: vb2-core: Fix a bug about unnecessary calls to queue cancel and free
Date: Thu, 21 Dec 2017 14:18:00 -0200
Message-Id: <4a42c988b7b63fa2804b3ffcb3a1f122e3b9836e.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Satendra Singh Thakur <satendra.t@samsung.com>

When the func vb2_core_reqbufs is called first time after
vb2_core_queue_init(), the condition q->memory != memory always gets
satisfied, since q->memory was set to 0 at vb2_core_queue_init().

After the condition is true, unnecessary calls to __vb2_queue_cancel()
and  __vb2_queue_free() are done. in such case, *count is non-zero,
q->num_buffers is zero and q->memory is 0, which is not equal to
memory field *count=N, q->num_buffers=0, q->memory != memory.

[mchehab@s-opensource.com: fix checkpatch issues]
Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index cb115ba6a1d2..21017b478a34 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -662,7 +662,8 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -EBUSY;
 	}
 
-	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
+	if (*count == 0 || q->num_buffers != 0 ||
+	    (q->memory && q->memory != memory)) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
-- 
2.14.3

Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:63758 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751655AbdLUQS0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 11:18:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 04/11] media: vb2-core: add a new warning about pending buffers
Date: Thu, 21 Dec 2017 14:18:03 -0200
Message-Id: <d3124b349c89607520e44f94dddbeec061842819.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513872637.git.mchehab@s-opensource.com>
References: <cover.1513872637.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a logic at the VB2 core that produces a WARN_ON if
there are still buffers waiting to be filled. However, it doesn't
indicate what buffers are still opened, with makes harder to
identify issues inside caller drivers.

So, add a new pr_warn() pointing to such buffers. That, together
with debug instrumentation inside the drivers can make easier to
identify where the problem is.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 319ab8bf220f..064d3c6f1e74 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1653,8 +1653,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 	 */
 	if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
 		for (i = 0; i < q->num_buffers; ++i)
-			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
+			if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
+				pr_warn("driver bug: stop_streaming operation is leaving buf %p in active state\n",
+					q->bufs[i]);
 				vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+			}
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
-- 
2.14.3

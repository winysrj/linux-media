Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59183 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdL1Q3o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 11:29:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Hirokazu Honda <hiroh@chromium.org>
Subject: [PATCH 5/5] media: vb2: add a new warning about pending buffers
Date: Thu, 28 Dec 2017 14:29:38 -0200
Message-Id: <2bc65a8418686185530e14711bd7727079614d07.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
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
 drivers/media/common/videobuf/videobuf2-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
index 195942bf8fde..c82c1e3157a4 100644
--- a/drivers/media/common/videobuf/videobuf2-core.c
+++ b/drivers/media/common/videobuf/videobuf2-core.c
@@ -1657,8 +1657,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
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

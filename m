Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35978 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750904AbdE3JtJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 05:49:09 -0400
Received: by mail-pf0-f176.google.com with SMTP id m17so67649206pfg.3
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 02:49:09 -0700 (PDT)
From: Hirokazu Honda <hiroh@chromium.org>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hirokazu Honda <hiroh@chromium.org>
Subject: [PATCH v2] [media] vb2: core: Lower the log level of debug outputs
Date: Tue, 30 May 2017 18:49:01 +0900
Message-Id: <20170530094901.1807-1-hiroh@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some debug output whose log level is set 1 flooded the log.
Their log level is lowered to find the important log easily.

Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
---
 drivers/media/v4l2-core/videobuf2-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 94afbbf92807..25257f92bbcf 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1139,7 +1139,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 			continue;
 		}
 
-		dprintk(1, "buffer for plane %d changed\n", plane);
+		dprintk(3, "buffer for plane %d changed\n", plane);
 
 		if (!reacquired) {
 			reacquired = true;
@@ -1294,7 +1294,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
 	/* Fill buffer information for the userspace */
 	call_void_bufop(q, fill_user_buffer, vb, pb);
 
-	dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
+	dprintk(2, "prepare of buffer %d succeeded\n", vb->index);
 
 	return ret;
 }
@@ -1424,7 +1424,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 			return ret;
 	}
 
-	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
+	dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_core_qbuf);
@@ -1472,7 +1472,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
 		}
 
 		if (nonblocking) {
-			dprintk(1, "nonblocking and no buffers to dequeue, will not wait\n");
+			dprintk(3, "nonblocking and no buffers to dequeue, will not wait\n");
 			return -EAGAIN;
 		}
 
@@ -1619,7 +1619,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
 	/* go back to dequeued state */
 	__vb2_dqbuf(vb);
 
-	dprintk(1, "dqbuf of buffer %d, with state %d\n",
+	dprintk(2, "dqbuf of buffer %d, with state %d\n",
 			vb->index, vb->state);
 
 	return 0;
-- 
2.13.0.219.gdb65acc882-goog

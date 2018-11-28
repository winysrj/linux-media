Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:44896 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727814AbeK1Tim (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 14:38:42 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Subject: [PATCH for v4.20 1/5] vb2: don't call __vb2_queue_cancel if vb2_start_streaming failed
Date: Wed, 28 Nov 2018 09:37:43 +0100
Message-Id: <20181128083747.18530-2-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
References: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

vb2_start_streaming() already rolls back the buffers, so there is no
need to call __vb2_queue_cancel(). Especially since __vb2_queue_cancel()
does too much, such as zeroing the q->queued_count value, causing vb2
to think that no buffers have been queued.

It appears that this call to __vb2_queue_cancel() is a left-over from
before commit b3379c6201bb3.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: b3379c6201bb3 ('vb2: only call start_streaming if sufficient buffers are queued')
Cc: <stable@vger.kernel.org>      # for v4.16 and up
---
 drivers/media/common/videobuf2/videobuf2-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 0ca81d495bda..77e2bfe5e722 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -1941,10 +1941,8 @@ int vb2_core_streamon(struct vb2_queue *q, unsigned int type)
 		if (ret)
 			return ret;
 		ret = vb2_start_streaming(q);
-		if (ret) {
-			__vb2_queue_cancel(q);
+		if (ret)
 			return ret;
-		}
 	}
 
 	q->streaming = 1;
-- 
2.19.1

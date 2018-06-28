Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33470 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753642AbeF1T0T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 15:26:19 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/2] v4l-helpers: Fix EXPBUF queue type
Date: Thu, 28 Jun 2018 16:25:57 -0300
Message-Id: <20180628192557.22966-2-ezequiel@collabora.com>
In-Reply-To: <20180628192557.22966-1-ezequiel@collabora.com>
References: <20180628192557.22966-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l_queue_export_bufs uses the v4l_fd type when calling
EXPBUF ioctl. However, this doesn't work on mem2mem
where there are one capture queue and one output queue
associated to the device.

The current code calls v4l_queue_export_bufs with the
wrong type, failing as:

fail: v4l2-test-buffers.cpp(544): q_.export_bufs(node)
test VIDIOC_EXPBUF: FAIL

Fix this by using the queue type instead.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 utils/common/v4l-helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/common/v4l-helpers.h b/utils/common/v4l-helpers.h
index 83d8d7d9c073..d6866f04e23a 100644
--- a/utils/common/v4l-helpers.h
+++ b/utils/common/v4l-helpers.h
@@ -1633,7 +1633,7 @@ static inline int v4l_queue_export_bufs(struct v4l_fd *f, struct v4l_queue *q,
 	unsigned b, p;
 	int ret = 0;
 
-	expbuf.type = exp_type ? : f->type;
+	expbuf.type = exp_type ? : q->type;
 	expbuf.flags = O_RDWR;
 	memset(expbuf.reserved, 0, sizeof(expbuf.reserved));
 	for (b = 0; b < v4l_queue_g_buffers(q); b++) {
-- 
2.18.0.rc2

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35796 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3001335AbdDZOqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 10:46:36 -0400
Received: by mail-io0-f196.google.com with SMTP id d203so711411iof.2
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 07:46:31 -0700 (PDT)
From: Andres Rodriguez <andresx7@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: andresx7@gmail.com, deathsimple@vodafone.de,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-buf: avoid scheduling on fence status query v2
Date: Wed, 26 Apr 2017 10:46:20 -0400
Message-Id: <20170426144620.3560-1-andresx7@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a timeout of zero is specified, the caller is only interested in
the fence status.

In the current implementation, dma_fence_default_wait will always call
schedule_timeout() at least once for an unsignaled fence. This adds a
significant overhead to a fence status query.

Avoid this overhead by returning early if a zero timeout is specified.

v2: move early return after enable_signaling

Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
---

 If I'm understanding correctly, I don't think we need to register the
 default wait callback. But if that isn't the case please let me know.

 This patch has the same perf improvements as v1.

 drivers/dma-buf/dma-fence.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 0918d3f..57da14c 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -402,6 +402,11 @@ dma_fence_default_wait(struct dma_fence *fence, bool intr, signed long timeout)
 		}
 	}
 
+	if (!timeout) {
+		ret = 0;
+		goto out;
+	}
+
 	cb.base.func = dma_fence_default_wait_cb;
 	cb.task = current;
 	list_add(&cb.base.node, &fence->cb_list);
-- 
2.9.3

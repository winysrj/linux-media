Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35584 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbcH2SQU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Aug 2016 14:16:20 -0400
Received: by mail-wm0-f68.google.com with SMTP id i5so10588212wmg.2
        for <linux-media@vger.kernel.org>; Mon, 29 Aug 2016 11:16:19 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: dri-devel@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-buf/sync-file: Avoid enable fence signaling if poll(.timeout=0)
Date: Mon, 29 Aug 2016 19:16:13 +0100
Message-Id: <20160829181613.30722-1-chris@chris-wilson.co.uk>
In-Reply-To: <20160829070834.22296-11-chris@chris-wilson.co.uk>
References: <20160829070834.22296-11-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If we being polled with a timeout of zero, a nonblocking busy query,
we don't need to install any fence callbacks as we will not be waiting.
As we only install the callback once, the overhead comes from the atomic
bit test that also causes serialisation between threads.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/sync_file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/sync_file.c b/drivers/dma-buf/sync_file.c
index 486d29c1a830..abb5fdab75fd 100644
--- a/drivers/dma-buf/sync_file.c
+++ b/drivers/dma-buf/sync_file.c
@@ -306,7 +306,8 @@ static unsigned int sync_file_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &sync_file->wq, wait);
 
-	if (!test_and_set_bit(POLL_ENABLED, &sync_file->fence->flags)) {
+	if (!poll_does_not_wait(wait) &&
+	    !test_and_set_bit(POLL_ENABLED, &sync_file->fence->flags)) {
 		if (fence_add_callback(sync_file->fence, &sync_file->cb,
 				       fence_check_cb_func) < 0)
 			wake_up_all(&sync_file->wq);
-- 
2.9.3


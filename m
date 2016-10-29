Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33633 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbcJ2QaF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Oct 2016 12:30:05 -0400
Received: by mail-pf0-f194.google.com with SMTP id a136so885148pfa.0
        for <linux-media@vger.kernel.org>; Sat, 29 Oct 2016 09:30:04 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH -next] dma-buf/sw_sync: fix non static symbol warning
Date: Sat, 29 Oct 2016 16:29:58 +0000
Message-Id: <1477758598-6054-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/dma-buf/sw_sync.c:87:22: warning:
 symbol 'sync_timeline_create' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/dma-buf/sw_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 82e0ca4..7aa4d7b 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -84,7 +84,7 @@ static inline struct sync_pt *dma_fence_to_sync_pt(struct dma_fence *fence)
  * Creates a new sync_timeline. Returns the sync_timeline object or NULL in
  * case of error.
  */
-struct sync_timeline *sync_timeline_create(const char *name)
+static struct sync_timeline *sync_timeline_create(const char *name)
 {
 	struct sync_timeline *obj;


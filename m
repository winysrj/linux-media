Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:36856 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751739AbdF1PvR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Jun 2017 11:51:17 -0400
Received: by mail-qt0-f174.google.com with SMTP id i2so52886901qta.3
        for <linux-media@vger.kernel.org>; Wed, 28 Jun 2017 08:51:17 -0700 (PDT)
From: Sean Paul <seanpaul@chromium.org>
To: dri-devel@lists.freedesktop.org
Cc: dbehr@chromium.org, marcheu@chromium.org,
        Sean Paul <seanpaul@chromium.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] dma-buf/sw_sync: Fix timeline/pt overflow cases
Date: Wed, 28 Jun 2017 11:51:11 -0400
Message-Id: <20170628155117.3558-1-seanpaul@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Protect against long-running processes from overflowing the timeline
and creating fences that go back in time. While we're at it, avoid
overflowing while we're incrementing the timeline.

Signed-off-by: Sean Paul <seanpaul@chromium.org>
---
 drivers/dma-buf/sw_sync.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 69c5ff36e2f9..40934619ed88 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -142,7 +142,7 @@ static void sync_timeline_signal(struct sync_timeline *obj, unsigned int inc)
 
 	spin_lock_irqsave(&obj->child_list_lock, flags);
 
-	obj->value += inc;
+	obj->value += min(inc, ~0x0U - obj->value);
 
 	list_for_each_entry_safe(pt, next, &obj->active_list_head,
 				 active_list) {
@@ -178,6 +178,11 @@ static struct sync_pt *sync_pt_create(struct sync_timeline *obj, int size,
 		return NULL;
 
 	spin_lock_irqsave(&obj->child_list_lock, flags);
+	if (value < obj->value) {
+		spin_unlock_irqrestore(&obj->child_list_lock, flags);
+		return NULL;
+	}
+
 	sync_timeline_get(obj);
 	dma_fence_init(&pt->base, &timeline_fence_ops, &obj->child_list_lock,
 		       obj->context, value);
-- 
2.13.2.725.g09c95d1e9-goog

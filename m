Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:43004 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728167AbeKJHCZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 02:02:25 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab+samsung@kernel.org, jasmin@anw.at
Subject: [PATCH] media: Use wait_queue_head_t for media_request
Date: Fri,  9 Nov 2018 22:06:05 +0100
Message-Id: <20181109210605.12848-1-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

The portable type for a wait queue is wait_queue_head_t.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 include/media/media-request.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/media-request.h b/include/media/media-request.h
index 0ce75c35131f..bd36d7431698 100644
--- a/include/media/media-request.h
+++ b/include/media/media-request.h
@@ -68,7 +68,7 @@ struct media_request {
 	unsigned int access_count;
 	struct list_head objects;
 	unsigned int num_incomplete_objects;
-	struct wait_queue_head poll_wait;
+	wait_queue_head_t poll_wait;
 	spinlock_t lock;
 };
 
-- 
2.17.1

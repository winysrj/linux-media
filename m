Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:36897 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750967AbeEFKob (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 6 May 2018 06:44:31 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, jasmin@anw.at
Subject: [PATCH] media: Use ktime_set() in pt1.c
Date: Sun,  6 May 2018 12:44:22 +0200
Message-Id: <1525603462-26734-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

In commit 20a63349b142 a new variable ktime_t delay has been added.
We decided to use the API functions to initialize ktime_t variables
within media-tree. Thus variable delay needs to be initialized with
ktime_set() instead of setting it directly.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/pci/pt1/pt1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 55a89ea..5708f69 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -485,7 +485,7 @@ static int pt1_thread(void *data)
 		if (!pt1_filter(pt1, page)) {
 			ktime_t delay;
 
-			delay = PT1_FETCH_DELAY * NSEC_PER_MSEC;
+			delay = ktime_set(0, PT1_FETCH_DELAY * NSEC_PER_MSEC);
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule_hrtimeout_range(&delay,
 					PT1_FETCH_DELAY_DELTA * NSEC_PER_MSEC,
-- 
2.7.4

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44088 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2K1TJ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:58 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700LI6P8E8G40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:57 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:56 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 08/12] s5p-csis: Correct the event counters logging
Date: Wed, 28 Nov 2012 20:09:25 +0100
Message-id: <1354129766-2821-9-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The counter field is unsigned so >= 0 condition always evaluates
to true. Fix this to log events for which counter is > 0 or for
all when in debug mode.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index e979b6e..8ec7c3b 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -415,12 +415,12 @@ static void s5pcsis_log_counters(struct csis_state *state, bool non_errors)
 
 	spin_lock_irqsave(&state->slock, flags);
 
-	for (i--; i >= 0; i--)
-		if (state->events[i].counter >= 0)
+	for (i--; i >= 0; i--) {
+		if (state->events[i].counter > 0 || debug)
 			v4l2_info(&state->sd, "%s events: %d\n",
 				  state->events[i].name,
 				  state->events[i].counter);
-
+	}
 	spin_unlock_irqrestore(&state->slock, flags);
 }
 
-- 
1.7.9.5


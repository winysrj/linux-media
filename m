Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:48623 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbcAZPqa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 10:46:30 -0500
From: Todor Tomov <ttomov@mm-sol.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Cc: Todor Tomov <ttomov@mm-sol.com>
Subject: [yavta PATCH] Fix requeue of last buffers
Date: Tue, 26 Jan 2016 17:45:06 +0200
Message-Id: <1453823106-24777-1-git-send-email-ttomov@mm-sol.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When capturing n image with p buffers, dequeued buffers don't need to be
requeued in the last p iterations. Currently requeue in iteration
n - p + 1 is skipped only. So skip requeue on all last p iterations.

Also handle correctly the case when n < p.

Signed-off-by: Todor Tomov <ttomov@mm-sol.com>
---
 yavta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/yavta.c b/yavta.c
index 49361ad..12f1608 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1696,7 +1696,7 @@ static int video_do_capture(struct device *dev, unsigned int nframes,
 
 		fflush(stdout);
 
-		if (i == nframes - dev->nbufs && !do_requeue_last)
+		if (i + dev->nbufs >= nframes && !do_requeue_last)
 			continue;
 
 		ret = video_queue_buffer(dev, buf.index, fill);
-- 
1.9.1


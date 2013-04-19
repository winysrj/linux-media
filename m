Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030552Ab3DSOlF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Apr 2013 10:41:05 -0400
Date: Fri, 19 Apr 2013 16:41:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH] V4L2: fix subdevice matching in asynchronous probing
Message-ID: <Pine.LNX.4.64.1304191640010.591@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A wrapped list iterating loop hasn't been correctly recognised in
v4l2_async_belongs(), which led to false positives. Fix the bug by
verifying the loop termination condition.

Reported-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Prabhakar, please, check, whether this fixes your problem.

 drivers/media/v4l2-core/v4l2-async.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5d6b428..5631944 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -76,6 +76,10 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 			break;
 	}
 
+	if (&asd->list == &notifier->waiting)
+		/* Wrapped - no match found */
+		return NULL;
+
 	return asd;
 }
 
-- 
1.7.2.5


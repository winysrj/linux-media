Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42317 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaFFPVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 11:21:20 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.142.25])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9B3CA363DB
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 17:20:53 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] v4l: omap4iss: Don't reinitialize the video qlock at every streamon
Date: Fri,  6 Jun 2014 17:21:42 +0200
Message-Id: <1402068106-32677-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the spin lock once only when initializing the video object.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index ded31ea..7aded26 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -895,7 +895,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	video->queue = &vfh->queue;
 	INIT_LIST_HEAD(&video->dmaqueue);
-	spin_lock_init(&video->qlock);
 	video->error = false;
 	atomic_set(&pipe->frame_number, -1);
 
@@ -1175,6 +1174,7 @@ int omap4iss_video_init(struct iss_video *video, const char *name)
 	if (ret < 0)
 		return ret;
 
+	spin_lock_init(&video->qlock);
 	mutex_init(&video->mutex);
 	atomic_set(&video->active, 0);
 
-- 
1.8.5.5


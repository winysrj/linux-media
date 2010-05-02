Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36860 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068Ab0EBRcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 May 2010 13:32:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: sakari.ailus@maxwell.research.nokia.com,
	linux-media@vger.kernel.org
Subject: [PATCH FOR 2.6.35] v4l: event: Export the v4l2_event_init and v4l2_event_dequeue functions
Date: Sun,  2 May 2010 19:32:43 +0200
Message-Id: <1272821563-7946-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-event.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

 Sakari, this should go to 2.6.35 with the V4L2 events patch set. Could you ack
 the patch so that Mauro can apply it to his linux-next tree ?

 Regards,

 Laurent Pinchart

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 170e40f..2e673fb 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -45,6 +45,7 @@ int v4l2_event_init(struct v4l2_fh *fh)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(v4l2_event_init);
 
 int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
 {
@@ -144,6 +145,7 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
 
 /* Caller must hold fh->event->lock! */
 static struct v4l2_subscribed_event *v4l2_event_subscribed(
-- 
1.6.4.4


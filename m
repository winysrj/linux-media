Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41034 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWWWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:22:18 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so4212401eek.30
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 14:22:16 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com
Subject: [PATCH RFC v3 3/6] V4L: Add v4l2_event_subdev_unsubscribe() helper function
Date: Wed, 23 Jan 2013 23:21:58 +0100
Message-Id: <1358979721-17473-4-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a v4l2 core helper function that can be used as the subdev
.unsubscribe_event handler. This allows to eliminate some
boilerplate from drivers that are only handling the control events.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/v4l2-core/v4l2-event.c |    7 +++++++
 include/media/v4l2-event.h           |    4 +++-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index c720092..86dcb54 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -311,3 +311,10 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe);
+
+int v4l2_event_subdev_unsubscribe(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				  struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_unsubscribe(fh, sub);
+}
+EXPORT_SYMBOL_GPL(v4l2_event_subdev_unsubscribe);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index eff85f9..be05d01 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -64,6 +64,7 @@
  */
 
 struct v4l2_fh;
+struct v4l2_subdev;
 struct v4l2_subscribed_event;
 struct video_device;
 
@@ -129,5 +130,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			   const struct v4l2_event_subscription *sub);
 void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
-
+int v4l2_event_subdev_unsubscribe(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				  struct v4l2_event_subscription *sub);
 #endif /* V4L2_EVENT_H */
-- 
1.7.4.1


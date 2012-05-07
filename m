Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1300 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2EGUx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 16:53:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.5] v4l2-event: fix regression with initial event handling.
Date: Mon,  7 May 2012 22:53:20 +0200
Message-Id: <d89c2be6827e0801d4637a80e8b667c611f0c7a9.1336424000.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the V4L2_EVENT_SUB_FL_SEND_INITIAL was set, then the application expects
to receive an initial event of the initial value of the control.

However, commit c53c2549333b340e2662dc64ec81323476b69a97 that added the new
v4l2_subscribed_event_ops introduced a regression: while the code still queued
that initial event the __v4l2_event_queue_fh() function was modified to ignore
such requests if sev->elems was 0 (meaning that the event subscription wasn't
finished yet).

And sev->elems was only set to a non-zero value after the add operation
returned.

This patch fixes this by passing the elems value to the add function. Then the
add function can set it before queuing the initial event.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/uvc/uvc_ctrl.c |    5 ++++-
 drivers/media/video/v4l2-ctrls.c   |    5 ++++-
 drivers/media/video/v4l2-event.c   |    2 +-
 include/media/v4l2-event.h         |    2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 28363b7..f3bd66c 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1250,7 +1250,7 @@ static void uvc_ctrl_send_events(struct uvc_fh *handle,
 	}
 }
 
-static int uvc_ctrl_add_event(struct v4l2_subscribed_event *sev)
+static int uvc_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 {
 	struct uvc_fh *handle = container_of(sev->fh, struct uvc_fh, vfh);
 	struct uvc_control_mapping *mapping;
@@ -1278,6 +1278,9 @@ static int uvc_ctrl_add_event(struct v4l2_subscribed_event *sev)
 
 		uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, val,
 				    changes);
+		/* Mark the queue as active, allowing this initial
+		   event to be accepted. */
+		sev->elems = elems;
 		v4l2_event_queue_fh(sev->fh, &ev);
 	}
 
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index ae544d8..20873c2 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2424,7 +2424,7 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
 }
 EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
 
-static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev)
+static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 {
 	struct v4l2_ctrl *ctrl = v4l2_ctrl_find(sev->fh->ctrl_handler, sev->id);
 
@@ -2441,6 +2441,9 @@ static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev)
 		if (!(ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY))
 			changes |= V4L2_EVENT_CTRL_CH_VALUE;
 		fill_event(&ev, ctrl, changes);
+		/* Mark the queue as active, allowing this initial
+		   event to be accepted. */
+		sev->elems = elems;
 		v4l2_event_queue_fh(sev->fh, &ev);
 	}
 	v4l2_ctrl_unlock(ctrl);
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 60b4e2e..ef2a33c 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -239,7 +239,7 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	}
 
 	if (sev->ops && sev->ops->add) {
-		int ret = sev->ops->add(sev);
+		int ret = sev->ops->add(sev, elems);
 		if (ret) {
 			sev->ops = NULL;
 			v4l2_event_unsubscribe(fh, sub);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 88fa9a1..2885a81 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -85,7 +85,7 @@ struct v4l2_kevent {
   * @merge:	Optional callback that can merge event 'old' into event 'new'.
   */
 struct v4l2_subscribed_event_ops {
-	int  (*add)(struct v4l2_subscribed_event *sev);
+	int  (*add)(struct v4l2_subscribed_event *sev, unsigned elems);
 	void (*del)(struct v4l2_subscribed_event *sev);
 	void (*replace)(struct v4l2_event *old, const struct v4l2_event *new);
 	void (*merge)(const struct v4l2_event *old, struct v4l2_event *new);
-- 
1.7.10


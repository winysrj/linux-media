Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4019 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab1F1L0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/13] v4l2-ctrls/v4l2-events: small coding style cleanups
Date: Tue, 28 Jun 2011 13:26:04 +0200
Message-Id: <cc47decdce317c84ecfd80b307a59be752142f9b.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Thanks to Laurent Pinchart <laurent.pinchart@ideasonboard.com>.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |    2 +-
 drivers/media/video/v4l2-event.c |    6 ++----
 include/media/v4l2-ctrls.h       |    1 -
 include/media/v4l2-event.h       |   34 +++++++++++++++++++---------------
 4 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 627a1e4..bc08f86 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -586,7 +586,7 @@ static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
 	struct v4l2_subscribed_event *sev;
 
 	if (list_empty(&ctrl->ev_subs))
-			return;
+		return;
 	fill_event(&ev, ctrl, changes);
 
 	list_for_each_entry(sev, &ctrl->ev_subs, node)
diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index b1c19fc..53b190c 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -100,10 +100,9 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 
 	assert_spin_locked(&fh->vdev->fh_lock);
 
-	list_for_each_entry(sev, &fh->subscribed, list) {
+	list_for_each_entry(sev, &fh->subscribed, list)
 		if (sev->type == type && sev->id == id)
 			return sev;
-	}
 
 	return NULL;
 }
@@ -169,9 +168,8 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
-	list_for_each_entry(fh, &vdev->fh_list, list) {
+	list_for_each_entry(fh, &vdev->fh_list, list)
 		__v4l2_event_queue_fh(fh, ev, &timestamp);
-	}
 
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
 }
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5fc3a2d..0a22209 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -31,7 +31,6 @@ struct v4l2_ctrl_helper;
 struct v4l2_ctrl;
 struct video_device;
 struct v4l2_subdev;
-struct v4l2_event_subscription;
 struct v4l2_subscribed_event;
 struct v4l2_fh;
 
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 6da793f..7abeb39 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -33,41 +33,45 @@ struct v4l2_fh;
 struct v4l2_subscribed_event;
 struct video_device;
 
+/** struct v4l2_kevent - Internal kernel event struct.
+  * @list:	List node for the v4l2_fh->available list.
+  * @sev:	Pointer to parent v4l2_subscribed_event.
+  * @event:	The event itself.
+  */
 struct v4l2_kevent {
-	/* list node for the v4l2_fh->available list */
 	struct list_head	list;
-	/* pointer to parent v4l2_subscribed_event */
 	struct v4l2_subscribed_event *sev;
-	/* event itself */
 	struct v4l2_event	event;
 };
 
+/** struct v4l2_subscribed_event - Internal struct representing a subscribed event.
+  * @list:	List node for the v4l2_fh->subscribed list.
+  * @type:	Event type.
+  * @id:	Associated object ID (e.g. control ID). 0 if there isn't any.
+  * @flags:	Copy of v4l2_event_subscription->flags.
+  * @fh:	Filehandle that subscribed to this event.
+  * @node:	List node that hooks into the object's event list (if there is one).
+  * @replace:	Optional callback that can replace event 'old' with event 'new'.
+  * @merge:	Optional callback that can merge event 'old' into event 'new'.
+  * @elems:	The number of elements in the events array.
+  * @first:	The index of the events containing the oldest available event.
+  * @in_use:	The number of queued events.
+  * @events:	An array of @elems events.
+  */
 struct v4l2_subscribed_event {
-	/* list node for the v4l2_fh->subscribed list */
 	struct list_head	list;
-	/* event type */
 	u32			type;
-	/* associated object ID (e.g. control ID) */
 	u32			id;
-	/* copy of v4l2_event_subscription->flags */
 	u32			flags;
-	/* filehandle that subscribed to this event */
 	struct v4l2_fh		*fh;
-	/* list node that hooks into the object's event list (if there is one) */
 	struct list_head	node;
-	/* Optional callback that can replace event 'old' with event 'new'. */
 	void			(*replace)(struct v4l2_event *old,
 					   const struct v4l2_event *new);
-	/* Optional callback that can merge event 'old' into event 'new'. */
 	void			(*merge)(const struct v4l2_event *old,
 					 struct v4l2_event *new);
-	/* the number of elements in the events array */
 	unsigned		elems;
-	/* the index of the events containing the oldest available event */
 	unsigned		first;
-	/* the number of queued events */
 	unsigned		in_use;
-	/* an array of elems events */
 	struct v4l2_kevent	events[];
 };
 
-- 
1.7.1


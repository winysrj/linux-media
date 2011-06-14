Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4149 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab1FNPWz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 11:22:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 4/8] v4l2-event: add optional 'merge' callback to merge two events
Date: Tue, 14 Jun 2011 17:22:29 +0200
Message-Id: <e3b0b697f29a86fa0299b51bfdb808e4df847175.1308063857.git.hans.verkuil@cisco.com>
In-Reply-To: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
References: <1308064953-11156-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1308063857.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the event queue for a subscribed event is full, then the oldest
event is dropped. It would be nice if the contents of that oldest
event could be merged with the next-oldest. That way no information is
lost, only intermediate steps are lost.

This patch adds an optional merge function that will be called to do
this job and implements it for the control event.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-event.c |   27 ++++++++++++++++++++++++++-
 include/media/v4l2-event.h       |    5 +++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 9e325dd..aeec2d5 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -113,6 +113,7 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 {
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_kevent *kev;
+	bool copy_payload = true;
 
 	/* Are we subscribed? */
 	sev = v4l2_event_subscribed(fh, ev->type, ev->id);
@@ -130,12 +131,23 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 		sev->in_use--;
 		sev->first = sev_pos(sev, 1);
 		fh->navailable--;
+		if (sev->merge) {
+			if (sev->elems == 1) {
+				sev->merge(&kev->event, ev, &kev->event);
+				copy_payload = false;
+			} else {
+				struct v4l2_kevent *second_oldest =
+					sev->events + sev_pos(sev, 0);
+				sev->merge(&second_oldest->event, &second_oldest->event, &kev->event);
+			}
+		}
 	}
 
 	/* Take one and fill it. */
 	kev = sev->events + sev_pos(sev, sev->in_use);
 	kev->event.type = ev->type;
-	kev->event.u = ev->u;
+	if (copy_payload)
+		kev->event.u = ev->u;
 	kev->event.id = ev->id;
 	kev->event.timestamp = *ts;
 	kev->event.sequence = fh->sequence;
@@ -184,6 +196,17 @@ int v4l2_event_pending(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
+static void ctrls_merge(struct v4l2_event *dst,
+			const struct v4l2_event *new,
+			const struct v4l2_event *old)
+{
+	u32 changes = new->u.ctrl.changes | old->u.ctrl.changes;
+
+	if (dst == old)
+		dst->u.ctrl = new->u.ctrl;
+	dst->u.ctrl.changes = changes;
+}
+
 int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub, unsigned elems)
 {
@@ -210,6 +233,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	sev->flags = sub->flags;
 	sev->fh = fh;
 	sev->elems = elems;
+	if (ctrl)
+		sev->merge = ctrls_merge;
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 8d681e5..111b2bc 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -55,6 +55,11 @@ struct v4l2_subscribed_event {
 	struct v4l2_fh		*fh;
 	/* list node that hooks into the object's event list (if there is one) */
 	struct list_head	node;
+	/* Optional callback that can merge two events.
+	   Note that 'dst' can be the same as either 'new' or 'old'. */
+	void			(*merge)(struct v4l2_event *dst,
+					 const struct v4l2_event *new,
+					 const struct v4l2_event *old);
 	/* the number of elements in the events array */
 	unsigned		elems;
 	/* the index of the events containing the oldest available event */
-- 
1.7.1


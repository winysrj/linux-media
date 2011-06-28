Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1361 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab1F1L0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 04/13] v4l2-event: add optional merge and replace callbacks
Date: Tue, 28 Jun 2011 13:25:56 +0200
Message-Id: <1cca2ef5cd03f12f6833bba9055572616927569a.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

When the event queue for a subscribed event is full, then the oldest
event is dropped. It would be nice if the contents of that oldest
event could be merged with the next-oldest. That way no information is
lost, only intermediate steps are lost.

This patch adds optional replace() (called when only one kevent was allocated)
and merge() (called when more than one kevent was allocated) callbacks that
will be called to do this job.

These two callbacks are implemented for the V4L2_EVENT_CTRL event.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-event.c |   31 ++++++++++++++++++++++++++++++-
 include/media/v4l2-event.h       |    6 ++++++
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index 9e325dd..b1c19fc 100644
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
+		if (sev->elems == 1) {
+			if (sev->replace) {
+				sev->replace(&kev->event, ev);
+				copy_payload = false;
+			}
+		} else if (sev->merge) {
+			struct v4l2_kevent *second_oldest =
+				sev->events + sev_pos(sev, 0);
+			sev->merge(&kev->event, &second_oldest->event);
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
@@ -184,6 +196,19 @@ int v4l2_event_pending(struct v4l2_fh *fh)
 }
 EXPORT_SYMBOL_GPL(v4l2_event_pending);
 
+static void ctrls_replace(struct v4l2_event *old, const struct v4l2_event *new)
+{
+	u32 old_changes = old->u.ctrl.changes;
+
+	old->u.ctrl = new->u.ctrl;
+	old->u.ctrl.changes |= old_changes;
+}
+
+static void ctrls_merge(const struct v4l2_event *old, struct v4l2_event *new)
+{
+	new->u.ctrl.changes |= old->u.ctrl.changes;
+}
+
 int v4l2_event_subscribe(struct v4l2_fh *fh,
 			 struct v4l2_event_subscription *sub, unsigned elems)
 {
@@ -210,6 +235,10 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 	sev->flags = sub->flags;
 	sev->fh = fh;
 	sev->elems = elems;
+	if (ctrl) {
+		sev->replace = ctrls_replace;
+		sev->merge = ctrls_merge;
+	}
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 8d681e5..6da793f 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -55,6 +55,12 @@ struct v4l2_subscribed_event {
 	struct v4l2_fh		*fh;
 	/* list node that hooks into the object's event list (if there is one) */
 	struct list_head	node;
+	/* Optional callback that can replace event 'old' with event 'new'. */
+	void			(*replace)(struct v4l2_event *old,
+					   const struct v4l2_event *new);
+	/* Optional callback that can merge event 'old' into event 'new'. */
+	void			(*merge)(const struct v4l2_event *old,
+					 struct v4l2_event *new);
 	/* the number of elements in the events array */
 	unsigned		elems;
 	/* the index of the events containing the oldest available event */
-- 
1.7.1


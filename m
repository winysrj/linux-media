Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:41988 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab3IQSHJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 14:07:09 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	teemux.tuominen@intel.com
Subject: [RFC 1/1] v4l: return POLLERR on V4L2 sub-devices if no events are subscribed
Date: Tue, 17 Sep 2013 21:07:19 +0300
Message-Id: <1379441239-7378-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Teemu Tuominen <teemux.tuominen@intel.com>

Add check and return POLLERR from subdev_poll() in case of no events
subscribed and wakeup once the last event subscription is removed.

This change is essentially done to add possibility to wakeup polling
with concurrent unsubscribe.

Signed-off-by: Teemu Tuominen <teemux.tuominen@intel.com>

Move the check after calling poll_wait(). Otherwise it's possible that we go
to sleep without getting notified if the subscription went away between the
two.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Tested-by: Teemu Tuominen <teemux.tuominen@intel.com>
---
Hi all,

Poll for events will sleep forever if there are no events subscribed.
Calling poll from an application that has not subscribed any event indeed
sounds silly, but un multi-threaded applications this is not quite as
straightforward.

Assume the following: an application has two threads where one handles
event subscription and the other handles the events. The first thread
unsubscribes the events and the latter will sleep forever. And do this while
the program intends to quit without an intention to subscribe for any
further events, and there's a deadlock.

Alternative solutions to handle this are signals (rather a nuisance if the
application happens to be a library instead) or a pipe (2) between the
threads. Pipe is workable, but instead of being a proper solution to the
problem still looks like a workaround instead.

This patch fixes the issue on kernel side by waking up the processes
sleeping in poll and returning POLLERR when the last subscribed event is
gone. The behaviour mirrors that of videobuf2 which will return POLLERR if
either streaming is disabled or no buffers are queued.

Just "waking up the sleeping threads once" is not an option: threads are not
visible to the kernel at this level and just "waking them up" isn't either
since poll will go back to sleep before returning the control back to user
space as long as it would return zero.

(Thinking about it --- similar change should probably be made to videobuf2
event poll handling as well.)

Kind regards,
Sakari

 drivers/media/v4l2-core/v4l2-event.c  | 15 +++++++++++++++
 drivers/media/v4l2-core/v4l2-subdev.c |  3 +++
 include/media/v4l2-event.h            |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 86dcb54..b53897e 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -107,6 +107,19 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 	return NULL;
 }
 
+bool v4l2_event_has_subscribed(struct v4l2_fh *fh)
+{
+	unsigned long flags;
+	bool rval;
+
+	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
+	rval = !list_empty(&fh->subscribed);
+	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+
+	return rval;
+}
+EXPORT_SYMBOL(v4l2_event_has_subscribed);
+
 static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
 		const struct timespec *ts)
 {
@@ -299,6 +312,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 			fh->navailable--;
 		}
 		list_del(&sev->list);
+		if (list_empty(&fh->subscribed))
+			wake_up_all(&fh->wait);
 	}
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 996c248..f2aa00f 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -382,6 +382,9 @@ static unsigned int subdev_poll(struct file *file, poll_table *wait)
 	if (v4l2_event_pending(fh))
 		return POLLPRI;
 
+	if (!v4l2_event_has_subscribed(fh))
+		return POLLERR;
+
 	return 0;
 }
 
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index be05d01..a9ca2b5 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -121,6 +121,7 @@ struct v4l2_subscribed_event {
 
 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
 		       int nonblocking);
+bool v4l2_event_has_subscribed(struct v4l2_fh *fh);
 void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
 int v4l2_event_pending(struct v4l2_fh *fh);
-- 
1.8.3.2


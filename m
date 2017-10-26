Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33053 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752130AbdJZJLz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 05:11:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/2] v4l2-core: make VIDIOC_DQEVENT y2038 proof.
Date: Thu, 26 Oct 2017 11:11:49 +0200
Message-Id: <20171026091149.29606-3-hverkuil@xs4all.nl>
In-Reply-To: <20171026091149.29606-1-hverkuil@xs4all.nl>
References: <20171026091149.29606-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 +++-
 drivers/media/v4l2-core/v4l2-event.c          | 22 +++++++++++-----------
 drivers/media/v4l2-core/v4l2-ioctl.c          |  6 ++++--
 include/uapi/linux/videodev2.h                |  3 ++-
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 821f2aa299ae..2d48b0bf45c0 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -790,7 +790,8 @@ struct v4l2_event32 {
 	__u32				sequence;
 	struct compat_timespec		timestamp;
 	__u32				id;
-	__u32				reserved[8];
+	__u64				timestamp64;
+	__u32				reserved[6];
 };
 
 static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *up)
@@ -803,6 +804,7 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 		put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
 		put_user(kp->timestamp.tv_nsec, &up->timestamp.tv_nsec) ||
 		put_user(kp->id, &up->id) ||
+		put_user(kp->timestamp64, &up->timestamp64) ||
 		copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
 			return -EFAULT;
 	return 0;
diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 968c2eb08b5a..6fb85703fedf 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -36,6 +36,7 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 {
 	struct v4l2_kevent *kev;
 	unsigned long flags;
+	u64 nsecs;
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
 
@@ -56,6 +57,9 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 	kev->sev->in_use--;
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
+	event->timestamp.tv_sec = div64_u64_rem(event->timestamp64,
+						NSEC_PER_SEC, &nsecs);
+	event->timestamp.tv_nsec = nsecs;
 
 	return 0;
 }
@@ -103,8 +107,8 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 	return NULL;
 }
 
-static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
-		const struct timespec *ts)
+static void __v4l2_event_queue_fh(struct v4l2_fh *fh,
+				  const struct v4l2_event *ev, u64 ts)
 {
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_kevent *kev;
@@ -152,7 +156,7 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 	if (copy_payload)
 		kev->event.u = ev->u;
 	kev->event.id = ev->id;
-	kev->event.timestamp = *ts;
+	kev->event.timestamp64 = ts;
 	kev->event.sequence = fh->sequence;
 	sev->in_use++;
 	list_add_tail(&kev->list, &fh->available);
@@ -166,17 +170,15 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 {
 	struct v4l2_fh *fh;
 	unsigned long flags;
-	struct timespec timestamp;
+	u64 timestamp = ktime_get_ns();
 
 	if (vdev == NULL)
 		return;
 
-	ktime_get_ts(&timestamp);
-
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
 	list_for_each_entry(fh, &vdev->fh_list, list)
-		__v4l2_event_queue_fh(fh, ev, &timestamp);
+		__v4l2_event_queue_fh(fh, ev, timestamp);
 
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
 }
@@ -185,12 +187,10 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
 {
 	unsigned long flags;
-	struct timespec timestamp;
-
-	ktime_get_ts(&timestamp);
+	u64 timestamp = ktime_get_ns();
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	__v4l2_event_queue_fh(fh, ev, &timestamp);
+	__v4l2_event_queue_fh(fh, ev, timestamp);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index b014904ec3bc..b60b82978fad 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -805,10 +805,12 @@ static void v4l_print_event(const void *arg, bool write_only)
 {
 	const struct v4l2_event *p = arg;
 	const struct v4l2_event_ctrl *c;
+	u64 secs, nsecs;
 
-	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, timestamp=%lu.%9.9lu\n",
+	secs = div64_u64_rem(p->timestamp64, NSEC_PER_SEC, &nsecs);
+	pr_cont("type=0x%x, pending=%u, sequence=%u, id=%u, timestamp64=%llu.%9.9llu\n",
 			p->type, p->pending, p->sequence, p->id,
-			p->timestamp.tv_sec, p->timestamp.tv_nsec);
+			secs, nsecs);
 	switch (p->type) {
 	case V4L2_EVENT_VSYNC:
 		printk(KERN_DEBUG "field=%s\n",
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 908eeaa66c7a..898d5d287222 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -2264,7 +2264,8 @@ struct v4l2_event {
 	__u32				sequence;
 	struct timespec			timestamp;
 	__u32				id;
-	__u32				reserved[8];
+	__u64				timestamp64;
+	__u32				reserved[6];
 };
 
 #define V4L2_EVENT_SUB_FL_SEND_INITIAL		(1 << 0)
-- 
2.14.2

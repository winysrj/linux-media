Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54249 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754978AbeARLWA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 06:22:00 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Michael Walz <m.walz@digitalendoscopy.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC PATCH] v4l2-event/dev: wakeup pending events when unregistering
Message-ID: <83e3318b-3f6e-7f27-6585-b5b69ddd9f65@xs4all.nl>
Date: Thu, 18 Jan 2018 12:21:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the video device is unregistered any filehandles waiting on
an event (i.e. in VIDIOC_DQEVENT) will never wake up.

Wake them up and detect that the video device is unregistered in
__v4l2_event_dequeue() and return -ENODEV in that case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Note: this is a quick hack, just for events. We have the same problem
with vb2 (waiting for a buffer) and cec (waiting for an event). Not sure if rc
or dvb are also suffering from the same problem.

I wonder if there is an easier way to wake up all fhs that are waiting for
some event.

Michael: most applications use non-blocking mode and poll/select to wait
for something to happen. In such applications the poll/select will return
when the device is unregistered and this problem does not occur.
---
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d5e0e536ef04..42574ccbd770 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -1017,6 +1017,9 @@ EXPORT_SYMBOL(__video_register_device);
  */
 void video_unregister_device(struct video_device *vdev)
 {
+	unsigned long flags;
+	struct v4l2_fh *fh;
+
 	/* Check if vdev was ever registered at all */
 	if (!vdev || !video_is_registered(vdev))
 		return;
@@ -1027,6 +1030,12 @@ void video_unregister_device(struct video_device *vdev)
 	 */
 	clear_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_unlock(&videodev_lock);
+
+	spin_lock_irqsave(&vdev->fh_lock, flags);
+	list_for_each_entry(fh, &vdev->fh_list, list)
+		wake_up_all(&fh->wait);
+	spin_unlock_irqrestore(&vdev->fh_lock, flags);
+
 	device_unregister(&vdev->dev);
 }
 EXPORT_SYMBOL(video_unregister_device);
diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 968c2eb08b5a..d04977cd1bfb 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -36,12 +36,17 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 {
 	struct v4l2_kevent *kev;
 	unsigned long flags;
+	int ret = 0;

 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);

+	if (!video_is_registered(fh->vdev)) {
+		ret = -ENODEV;
+		goto err;
+	}
 	if (list_empty(&fh->available)) {
-		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-		return -ENOENT;
+		ret = -ENOENT;
+		goto err;
 	}

 	WARN_ON(fh->navailable == 0);
@@ -54,10 +59,10 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 	*event = kev->event;
 	kev->sev->first = sev_pos(kev->sev, 1);
 	kev->sev->in_use--;
-
+err:
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);

-	return 0;
+	return ret;
 }

 int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,

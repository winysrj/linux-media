Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F40CEC2F3A0
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEC9E2085A
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 13:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbfAUNcf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:32:35 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:57570 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728696AbfAUNcf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 08:32:35 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lZgjgZ95MBDyIlZgngPCJZ; Mon, 21 Jan 2019 14:32:33 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/8] v4l2-event: keep track of the timestamp in ns
Date:   Mon, 21 Jan 2019 14:32:22 +0100
Message-Id: <20190121133229.33893-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
References: <20190121133229.33893-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfM0QK8gYafaF5b9P2oUlVqe7L2gMxiwSFDhXm9+vhpenhzggc7JtWtqYYGCj/cRy01IMSfGRO/Tfa7qDlNtpGu5j69/sCR8lb4RpeORFp4JKFkkiYS0m
 rgmjYCL9Xc/beyL3g703eqI7hgYc7rT8JPtF6861SpDeoPv6OOWiEtw/JYU282TuiOpUbZy8eNxse8P2DFFsA44HTG1iw9Li9y0HrUbEcchjw8qnULKZhVfY
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Internally use ktime_get_ns() to get the timestamp of the event.
Only convert to timespec when interfacing with userspace.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-event.c | 19 +++++++++----------
 include/media/v4l2-event.h           |  2 ++
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 481e3c65cf97..c46d14c996fc 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -52,6 +52,7 @@ static int __v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
 
 	kev->event.pending = fh->navailable;
 	*event = kev->event;
+	event->timestamp = ns_to_timespec(kev->ts);
 	kev->sev->first = sev_pos(kev->sev, 1);
 	kev->sev->in_use--;
 
@@ -103,8 +104,8 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 	return NULL;
 }
 
-static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
-		const struct timespec *ts)
+static void __v4l2_event_queue_fh(struct v4l2_fh *fh,
+				  const struct v4l2_event *ev, u64 ts)
 {
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_kevent *kev;
@@ -144,7 +145,7 @@ static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *e
 	if (copy_payload)
 		kev->event.u = ev->u;
 	kev->event.id = ev->id;
-	kev->event.timestamp = *ts;
+	kev->ts = ts;
 	kev->event.sequence = fh->sequence;
 	sev->in_use++;
 	list_add_tail(&kev->list, &fh->available);
@@ -158,17 +159,17 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 {
 	struct v4l2_fh *fh;
 	unsigned long flags;
-	struct timespec timestamp;
+	u64 ts;
 
 	if (vdev == NULL)
 		return;
 
-	ktime_get_ts(&timestamp);
+	ts = ktime_get_ns();
 
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
 	list_for_each_entry(fh, &vdev->fh_list, list)
-		__v4l2_event_queue_fh(fh, ev, &timestamp);
+		__v4l2_event_queue_fh(fh, ev, ts);
 
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
 }
@@ -177,12 +178,10 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
 {
 	unsigned long flags;
-	struct timespec timestamp;
-
-	ktime_get_ts(&timestamp);
+	u64 ts = ktime_get_ns();
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	__v4l2_event_queue_fh(fh, ev, &timestamp);
+	__v4l2_event_queue_fh(fh, ev, ts);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 17833e886e11..c2b6cdc714d2 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -34,11 +34,13 @@ struct video_device;
  * @list:	List node for the v4l2_fh->available list.
  * @sev:	Pointer to parent v4l2_subscribed_event.
  * @event:	The event itself.
+ * @ts:		The timestamp of the event.
  */
 struct v4l2_kevent {
 	struct list_head	list;
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_event	event;
+	u64			ts;
 };
 
 /**
-- 
2.20.1


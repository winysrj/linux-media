Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:57541 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbbIOPte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 11:49:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-api@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/7] [RFC] [media] introduce v4l2_timespec type for timestamps
Date: Tue, 15 Sep 2015 17:49:08 +0200
Message-Id: <1442332148-488079-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1442332148-488079-1-git-send-email-arnd@arndb.de>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2 event queue uses a 'struct timespec' to pass monotonic
timestamps. This is not a problem by itself, but it breaks when user
space redefines timespec to use 'long long' on 32-bit systems.

To avoid that problem, we define our own replacement for timespec here,
using 'long' tv_sec and tv_nsec members. This means no change to the
existing API, but lets us keep using it with a y2038 compatible libc.

As a side-effect, this changes the API for x32 programs to be the same
as native 32-bit, using a 32-bit tv_sec/tv_nsec value, but both old and
new kernels already support both formats for on the binary level for
compat and x32.

Alternatively, we could leave the header file to define the interface
based on 'struct timespec', and implement both ioctls for native
processes. I picked the approach in this case because it matches what
we do for v4l2_timeval in the respective patch, but both would work
equally well here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/v4l2-core/v4l2-event.c | 20 +++++++++++++-------
 include/uapi/linux/videodev2.h       |  8 +++++++-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-event.c b/drivers/media/v4l2-core/v4l2-event.c
index 8d3171c6bee8..2a26ad591f59 100644
--- a/drivers/media/v4l2-core/v4l2-event.c
+++ b/drivers/media/v4l2-core/v4l2-event.c
@@ -108,7 +108,7 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
 }
 
 static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
-		const struct timespec *ts)
+		const struct v4l2_timespec *ts)
 {
 	struct v4l2_subscribed_event *sev;
 	struct v4l2_kevent *kev;
@@ -170,17 +170,20 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
 {
 	struct v4l2_fh *fh;
 	unsigned long flags;
-	struct timespec timestamp;
+	struct timespec64 timestamp;
+	struct v4l2_timespec vts;
 
 	if (vdev == NULL)
 		return;
 
-	ktime_get_ts(&timestamp);
+	ktime_get_ts64(&timestamp);
+	vts.tv_sec = timestamp.tv_sec;
+	vts.tv_nsec = timestamp.tv_nsec;
 
 	spin_lock_irqsave(&vdev->fh_lock, flags);
 
 	list_for_each_entry(fh, &vdev->fh_list, list)
-		__v4l2_event_queue_fh(fh, ev, &timestamp);
+		__v4l2_event_queue_fh(fh, ev, &vts);
 
 	spin_unlock_irqrestore(&vdev->fh_lock, flags);
 }
@@ -189,12 +192,15 @@ EXPORT_SYMBOL_GPL(v4l2_event_queue);
 void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
 {
 	unsigned long flags;
-	struct timespec timestamp;
+	struct timespec64 timestamp;
+	struct v4l2_timespec vts;
 
-	ktime_get_ts(&timestamp);
+	ktime_get_ts64(&timestamp);
+	vts.tv_sec = timestamp.tv_sec;
+	vts.tv_nsec = timestamp.tv_nsec;
 
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	__v4l2_event_queue_fh(fh, ev, &timestamp);
+	__v4l2_event_queue_fh(fh, ev, &vts);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 }
 EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index b02cf054fbb8..bc659be87260 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -809,6 +809,12 @@ struct v4l2_timeval {
 	long tv_usec;
 };
 
+/* used for monotonic times, therefore y2038 safe */
+struct v4l2_timespec {
+	long tv_sec;
+	long tv_nsec;
+};
+
 /**
  * struct v4l2_buffer - video buffer info
  * @index:	id number of the buffer
@@ -2088,7 +2094,7 @@ struct v4l2_event {
 	} u;
 	__u32				pending;
 	__u32				sequence;
-	struct timespec			timestamp;
+	struct v4l2_timespec		timestamp;
 	__u32				id;
 	__u32				reserved[8];
 };
-- 
2.1.0.rc2


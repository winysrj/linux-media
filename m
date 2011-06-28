Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3056 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab1F1L0V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 13/13] v4l2-event.h: add overview documentation to the header.
Date: Tue, 28 Jun 2011 13:26:05 +0200
Message-Id: <671351808887ca28ad4b844b343fefc5fa360641.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

It's getting confusing who is linking to what, so add an overview at
the start of the header.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-event.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
index 7abeb39..5f14e88 100644
--- a/include/media/v4l2-event.h
+++ b/include/media/v4l2-event.h
@@ -29,6 +29,40 @@
 #include <linux/videodev2.h>
 #include <linux/wait.h>
 
+/*
+ * Overview:
+ *
+ * Events are subscribed per-filehandle. An event specification consists of a
+ * type and is optionally associated with an object identified through the
+ * 'id' field. So an event is uniquely identified by the (type, id) tuple.
+ *
+ * The v4l2-fh struct has a list of subscribed events. The v4l2_subscribed_event
+ * struct is added to that list, one for every subscribed event.
+ *
+ * Each v4l2_subscribed_event struct ends with an array of v4l2_kevent structs.
+ * This array (ringbuffer, really) is used to store any events raised by the
+ * driver. The v4l2_kevent struct links into the 'available' list of the
+ * v4l2_fh struct so VIDIOC_DQEVENT will know which event to dequeue first.
+ *
+ * Finally, if the event subscription is associated with a particular object
+ * such as a V4L2 control, then that object needs to know about that as well
+ * so that an event can be raised by that object. So the 'node' field can
+ * be used to link the v4l2_subscribed_event struct into a list of that
+ * object.
+ *
+ * So to summarize:
+ *
+ * struct v4l2_fh has two lists: one of the subscribed events, and one of the
+ * pending events.
+ *
+ * struct v4l2_subscribed_event has a ringbuffer of raised (pending) events of
+ * that particular type.
+ *
+ * If struct v4l2_subscribed_event is associated with a specific object, then
+ * that object will have an internal list of struct v4l2_subscribed_event so
+ * it knows who subscribed an event to that object.
+ */
+
 struct v4l2_fh;
 struct v4l2_subscribed_event;
 struct video_device;
-- 
1.7.1


Return-path: <mchehab@pedra>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:56397 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab1DDLwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:52:23 -0400
Received: from OSLEXCP11.eu.tandberg.int ([173.38.136.5])
	by rcdn-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id p34BqDrl001853
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 11:52:22 GMT
Received: from cobaltpc1.rd.tandberg.com (cobaltpc1.rd.tandberg.com [10.47.3.155])
	by ultra.eu.tandberg.int (8.13.1/8.13.1) with ESMTP id p34BqDdO009325
	for <linux-media@vger.kernel.org>; Mon, 4 Apr 2011 13:52:14 +0200
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv1 PATCH 8/9] vivi: add support for CTRL_CH_STATE events.
Date: Mon,  4 Apr 2011 13:51:53 +0200
Message-Id: <ee0baff35423ae37b5e7a207477badf8fbf90551.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
References: <2fa42294dbc167cae5daf227d072b2284f77b1ab.1301916466.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-event.c |    6 ++++--
 drivers/media/video/vivi.c       |    8 ++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index c9251a5..9b503aa 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -258,7 +258,8 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
 		return -ENOMEM;
 	}
 
-	if (sub->type == V4L2_EVENT_CTRL_CH_VALUE) {
+	if (sub->type == V4L2_EVENT_CTRL_CH_VALUE ||
+			sub->type == V4L2_EVENT_CTRL_CH_STATE) {
 		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
 		if (ctrl == NULL)
 			return -EINVAL;
@@ -341,7 +342,8 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
 		list_del(&sev->list);
 
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
-	if (sev->type == V4L2_EVENT_CTRL_CH_VALUE) {
+	if (sev->type == V4L2_EVENT_CTRL_CH_VALUE ||
+			sev->type == V4L2_EVENT_CTRL_CH_STATE) {
 		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
 
 		if (ctrl)
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 8790e03..a8d91ce 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -987,9 +987,13 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 static int vidioc_subscribe_event(struct v4l2_fh *fh,
 				struct v4l2_event_subscription *sub)
 {
-	if (sub->type != V4L2_EVENT_CTRL_CH_VALUE)
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL_CH_VALUE:
+	case V4L2_EVENT_CTRL_CH_STATE:
+		return v4l2_event_subscribe(fh, sub);
+	default:
 		return -EINVAL;
-	return v4l2_event_subscribe(fh, sub);
+	}
 }
 
 /* --- controls ---------------------------------------------- */
-- 
1.7.1


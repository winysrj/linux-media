Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4537 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab2BBL5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 06:57:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] vivi: use v4l2_ctrl_subscribe_event.
Date: Thu,  2 Feb 2012 12:56:34 +0100
Message-Id: <b6563ffd396902fd91d5fef05093adaf6f28c36c.1328183271.git.hans.verkuil@cisco.com>
In-Reply-To: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
References: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <71ef01f774221fd98c5d3e5a0dc4613dc928d967.1328183271.git.hans.verkuil@cisco.com>
References: <71ef01f774221fd98c5d3e5a0dc4613dc928d967.1328183271.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index cef8c91..28d7112 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1001,17 +1001,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-static int vidioc_subscribe_event(struct v4l2_fh *fh,
-				struct v4l2_event_subscription *sub)
-{
-	switch (sub->type) {
-	case V4L2_EVENT_CTRL:
-		return v4l2_event_subscribe(fh, sub, 0);
-	default:
-		return -EINVAL;
-	}
-}
-
 /* --- controls ---------------------------------------------- */
 
 static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -1203,7 +1192,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-- 
1.7.8.3


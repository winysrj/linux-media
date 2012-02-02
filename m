Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2155 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab2BBL5F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 06:57:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] v4l2-ctrls: add helper functions for control events.
Date: Thu,  2 Feb 2012 12:56:33 +0100
Message-Id: <dacb62c3908fc1b15b4cf0193ba063cdab2bc170.1328183271.git.hans.verkuil@cisco.com>
In-Reply-To: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
References: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <71ef01f774221fd98c5d3e5a0dc4613dc928d967.1328183271.git.hans.verkuil@cisco.com>
References: <71ef01f774221fd98c5d3e5a0dc4613dc928d967.1328183271.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Many drivers just support control events, and most radio drivers just need
to poll for control events. Add some functions to simplify those jobs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   20 ++++++++++++++++++++
 include/media/v4l2-ctrls.h       |    9 +++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index d070688..39829fa 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2371,3 +2371,23 @@ int v4l2_ctrl_log_status(struct file *file, void *fh)
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_log_status);
+
+int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	if (sub->type == V4L2_EVENT_CTRL)
+		return v4l2_event_subscribe(fh, sub, 0);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
+
+unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	if (v4l2_event_pending(fh))
+		return POLLPRI;
+	poll_wait(file, &fh->wait, wait);
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_ctrl_poll);
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5f246c2..3dbd066 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -33,6 +33,7 @@ struct video_device;
 struct v4l2_subdev;
 struct v4l2_subscribed_event;
 struct v4l2_fh;
+struct poll_table_struct;
 
 /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
   * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
@@ -496,6 +497,14 @@ void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
    associated with the filehandle. */
 int v4l2_ctrl_log_status(struct file *file, void *fh);
 
+/* Can be used as a vidioc_subscribe_event function that just subscribes
+   control events. */
+int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub);
+
+/* Can be used as a poll function that just polls for control events. */
+unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
+
 /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
 int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
 int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
-- 
1.7.8.3


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62057 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3AWWWU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:22:20 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so4211190eei.7
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 14:22:18 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com
Subject: [PATCH RFC v3 4/6] V4L: Add v4l2_ctrl_subdev_subscribe_event() helper function
Date: Wed, 23 Jan 2013 23:21:59 +0100
Message-Id: <1358979721-17473-5-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a v4l2 core helper function that can be used as the subdev
.subscribe_event handler. This allows to eliminate some boilerplate
from drivers that are only handling the control events.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    9 +++++++++
 include/media/v4l2-ctrls.h           |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 3f27571..9051ec5 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2885,6 +2885,15 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
 }
 EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
 
+int v4l2_ctrl_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				     struct v4l2_event_subscription *sub)
+{
+	if (!sd->ctrl_handler)
+		return -EINVAL;
+	return v4l2_ctrl_subscribe_event(fh, sub);
+}
+EXPORT_SYMBOL(v4l2_ctrl_subdev_subscribe_event);
+
 unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct v4l2_fh *fh = file->private_data;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 91125b6..1e84946 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -654,4 +654,9 @@ int v4l2_subdev_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *cs
 int v4l2_subdev_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 
+/* Can be used as a subscribe_event function that just subscribes control
+   events. */
+int v4l2_ctrl_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				     struct v4l2_event_subscription *sub);
+
 #endif
-- 
1.7.4.1


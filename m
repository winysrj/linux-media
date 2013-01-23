Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:60356 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3AWWWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:22:22 -0500
Received: by mail-ea0-f180.google.com with SMTP id c1so3585333eaa.39
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 14:22:20 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com
Subject: [PATCH RFC v3 5/6] V4L: Add v4l2_ctrl_subdev_log_status() helper function
Date: Wed, 23 Jan 2013 23:22:00 +0100
Message-Id: <1358979721-17473-6-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a v4l2 core helper function that can be used as
the log_status handler for subdevs that only need to log state
of the v4l2 controls owned by the subdev's control handler.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |    7 +++++++
 include/media/v4l2-ctrls.h           |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 9051ec5..6b28b58 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2004,6 +2004,13 @@ void v4l2_ctrl_handler_log_status(struct v4l2_ctrl_handler *hdl,
 }
 EXPORT_SYMBOL(v4l2_ctrl_handler_log_status);
 
+int v4l2_ctrl_subdev_log_status(struct v4l2_subdev *sd)
+{
+	v4l2_ctrl_handler_log_status(sd->ctrl_handler, sd->name);
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_ctrl_subdev_log_status);
+
 /* Call s_ctrl for all controls owned by the handler */
 int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 {
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 1e84946..f00d42b 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -659,4 +659,7 @@ int v4l2_subdev_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl);
 int v4l2_ctrl_subdev_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
 				     struct v4l2_event_subscription *sub);
 
+/* Log all controls owned by subdev's control handler. */
+int v4l2_ctrl_subdev_log_status(struct v4l2_subdev *sd);
+
 #endif
-- 
1.7.4.1


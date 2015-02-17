Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:38189 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbbBQPId (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 10:08:33 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v4 1/2] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
Date: Tue, 17 Feb 2015 16:08:26 +0100
Message-Id: <1424185706-16711-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Volatile controls can change their value outside the v4l-ctrl framework.
We should ignore the cached written value of the ctrl when evaluating if
we should run s_ctrl.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
v4: Hans Verkuil:

explicity set has_changed to false. and add comment

 drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 45c5b47..f34a689 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1609,6 +1609,17 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 		if (ctrl == NULL)
 			continue;
+
+		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
+			/*
+			 * Set has_changed to false to avoid generating
+			 * the event V4L2_EVENT_CTRL_CH_VALUE
+			 */
+			ctrl->has_changed = false;
+			changed = true;
+			continue;
+		}
+
 		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
 			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
 				ctrl->p_cur, ctrl->p_new);
-- 
2.1.4


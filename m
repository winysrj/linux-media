Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2212 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1FGPFb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 11:05:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 02/18] v4l2-ctrls: simplify error_idx handling.
Date: Tue,  7 Jun 2011 17:05:07 +0200
Message-Id: <5389151f22127fac05adbf276eb41395d215850e.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
References: <a1daecb26b464ddd980297783d04941f1f34666b.1307458245.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

The lower-level prepare functions just set error_idx for each control that
might have an error. The high-level functions will override this with
cs->count in the get and set cases. Only try will keep the error_idx.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 3f2a0c5..d9e0439 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1450,8 +1450,7 @@ EXPORT_SYMBOL(v4l2_subdev_querymenu);
    Find the controls in the control array and do some basic checks. */
 static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 			     struct v4l2_ext_controls *cs,
-			     struct ctrl_helper *helpers,
-			     bool try)
+			     struct ctrl_helper *helpers)
 {
 	u32 i;
 
@@ -1460,8 +1459,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		struct v4l2_ctrl *ctrl;
 		u32 id = c->id & V4L2_CTRL_ID_MASK;
 
-		if (try)
-			cs->error_idx = i;
+		cs->error_idx = i;
 
 		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
 			return -EINVAL;
@@ -1554,7 +1552,8 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 			return -ENOMEM;
 	}
 
-	ret = prepare_ext_ctrls(hdl, cs, helpers, false);
+	ret = prepare_ext_ctrls(hdl, cs, helpers);
+	cs->error_idx = cs->count;
 
 	for (i = 0; !ret && i < cs->count; i++)
 		if (helpers[i].ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
@@ -1701,12 +1700,10 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 	unsigned i, j;
 	int ret = 0;
 
-	cs->error_idx = cs->count;
 	for (i = 0; i < cs->count; i++) {
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
 
-		if (!set)
-			cs->error_idx = i;
+		cs->error_idx = i;
 
 		if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
 			return -EACCES;
@@ -1724,11 +1721,10 @@ static int try_or_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		struct v4l2_ctrl *ctrl = helpers[i].ctrl;
 		struct v4l2_ctrl *master = ctrl->cluster[0];
 
-		cs->error_idx = i;
-
 		if (helpers[i].handled)
 			continue;
 
+		cs->error_idx = i;
 		v4l2_ctrl_lock(ctrl);
 
 		/* Reset the 'is_new' flags of the cluster */
@@ -1777,12 +1773,11 @@ static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		if (!helpers)
 			return -ENOMEM;
 	}
-	ret = prepare_ext_ctrls(hdl, cs, helpers, !set);
-	if (ret)
-		goto free;
+	ret = prepare_ext_ctrls(hdl, cs, helpers);
 
 	/* First 'try' all controls and abort on error */
-	ret = try_or_set_ext_ctrls(hdl, cs, helpers, false);
+	if (!ret)
+		ret = try_or_set_ext_ctrls(hdl, cs, helpers, false);
 	/* If this is a 'set' operation and the initial 'try' failed,
 	   then set error_idx to count to tell the application that no
 	   controls changed value yet. */
@@ -1795,7 +1790,6 @@ static int try_set_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 		ret = try_or_set_ext_ctrls(hdl, cs, helpers, true);
 	}
 
-free:
 	if (cs->count > ARRAY_SIZE(helper))
 		kfree(helpers);
 	return ret;
-- 
1.7.1


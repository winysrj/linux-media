Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36510 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935177AbeF2KMs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 06:12:48 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-ctrls.c: fix broken auto cluster handling
Message-ID: <c65ccb5a-75ff-bb99-779c-d932f84b4769@xs4all.nl>
Date: Fri, 29 Jun 2018 12:12:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When you switch from auto to manual mode for an auto-cluster (e.g.
autogain+gain controls), then the current HW value has to be copied
to the current control value. However, has_changed was never set to
true, so new_to_cur didn't actually copy this value.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Hugues FRUCHET <hugues.fruchet@st.com>
---
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d29e45516eb7..d1087573da34 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -3137,9 +3137,22 @@ static int try_or_set_cluster(struct v4l2_fh *fh, struct v4l2_ctrl *master,

 	/* If OK, then make the new values permanent. */
 	update_flag = is_cur_manual(master) != is_new_manual(master);
-	for (i = 0; i < master->ncontrols; i++)
+
+	for (i = 0; i < master->ncontrols; i++) {
+		/*
+		 * If we switch from auto to manual mode, and this cluster
+		 * contains volatile controls, then all non-master controls
+		 * have to be marked as changed. The 'new' value contains
+		 * the volatile value (obtained by update_from_auto_cluster),
+		 * which now has to become the current value.
+		 */
+		if (i && update_flag && is_new_manual(master) &&
+		    master->has_volatiles && master->cluster[i])
+			master->cluster[i]->has_changed = true;
+
 		new_to_cur(fh, master->cluster[i], ch_flags |
 			((update_flag && i > 0) ? V4L2_EVENT_CTRL_CH_FLAGS : 0));
+	}
 	return 0;
 }

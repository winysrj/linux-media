Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2898 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab1F1L0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/13] v4l2-ctrls: v4l2_ctrl_handler_setup code simplification
Date: Tue, 28 Jun 2011 13:26:00 +0200
Message-Id: <e08a400635839e8ccca2643e58b572f77debc3e7.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 040d5c9..627a1e4 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1410,26 +1410,21 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
 		int i;
 
 		/* Skip if this control was already handled by a cluster. */
-		if (ctrl->done)
+		/* Skip button controls and read-only controls. */
+		if (ctrl->done || ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
+		    (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
 			continue;
 
 		for (i = 0; i < master->ncontrols; i++) {
 			if (master->cluster[i]) {
 				cur_to_new(master->cluster[i]);
 				master->cluster[i]->is_new = 1;
+				master->cluster[i]->done = true;
 			}
 		}
-
-		/* Skip button controls and read-only controls. */
-		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
-		    (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
-			continue;
 		ret = call_op(master, s_ctrl);
 		if (ret)
 			break;
-		for (i = 0; i < master->ncontrols; i++)
-			if (master->cluster[i])
-				master->cluster[i]->done = true;
 	}
 	mutex_unlock(&hdl->lock);
 	return ret;
-- 
1.7.1


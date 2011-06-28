Return-path: <mchehab@pedra>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1221 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757241Ab1F1L0S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 07:26:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 05/13] v4l2-ctrls: don't initially set CH_VALUE for write-only controls
Date: Tue, 28 Jun 2011 13:25:57 +0200
Message-Id: <cbf40e5e19dd65b2581b53e00103960c6254d9e1.1309260043.git.hans.verkuil@cisco.com>
In-Reply-To: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
References: <1309260365-4831-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
References: <3d92b242dcf5e7766d128d6c1f05c0bd837a2633.1309260043.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Hans Verkuil <hans.verkuil@cisco.com>

When sending the SEND_INITIAL event for write-only controls the
V4L2_EVENT_CTRL_CH_VALUE flag should not be set. It's meaningless.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ctrls.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 63a44fd..1b0422e 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -2032,9 +2032,11 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
 	if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
 	    (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
 		struct v4l2_event ev;
+		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
 
-		fill_event(&ev, ctrl, V4L2_EVENT_CTRL_CH_VALUE |
-			V4L2_EVENT_CTRL_CH_FLAGS);
+		if (!(ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY))
+			changes |= V4L2_EVENT_CTRL_CH_VALUE;
+		fill_event(&ev, ctrl, changes);
 		v4l2_event_queue_fh(sev->fh, &ev);
 	}
 	v4l2_ctrl_unlock(ctrl);
-- 
1.7.1


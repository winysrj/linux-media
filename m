Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:42770 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbbBQLCT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 06:02:19 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Antti Palosaari <crope@iki.fi>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] media/v4l2-ctrls: Always run s_ctrl on volatile ctrls
Date: Tue, 17 Feb 2015 12:02:14 +0100
Message-Id: <1424170934-18619-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Volatile controls can change their value outside the v4l-ctrl framework.

We should ignore the cached written value of the ctrl when evaluating if
we should run s_ctrl.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

I have a control that tells the user when there has been a external trigger
overrun. (Trigger while processing old image). This is a volatile control.

The user writes 0 to the control, to ack the error condition, and clear the
hardware flag.

Unfortunately, it only works one time, because the next time the user writes
a zero to the control cluster_changed returns false.

I think on volatile controls it is safer to run s_ctrl twice than missing a
valid s_ctrl.

I know I am abusing a bit the API for this :P, but I also believe that the
semantic here is a bit confusing.

 drivers/media/v4l2-core/v4l2-ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 45c5b47..3d0c7f4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1605,7 +1605,7 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 	for (i = 0; i < master->ncontrols; i++) {
 		struct v4l2_ctrl *ctrl = master->cluster[i];
-		bool ctrl_changed = false;
+		bool ctrl_changed = ctrl->flags & V4L2_CTRL_FLAG_VOLATILE;
 
 		if (ctrl == NULL)
 			continue;
-- 
2.1.4


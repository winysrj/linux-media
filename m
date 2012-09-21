Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:60391 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070Ab2IUJBg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 05:01:36 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/2] m5mols: Remove unneeded control ops assignments
Date: Fri, 21 Sep 2012 11:01:22 +0200
Message-id: <1348218083-32201-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since all host drivers using this subdev are already using
the control framework these compatibility ops can be removed.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index ac7d28b..cbb6381 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -822,13 +822,6 @@ static int m5mols_log_status(struct v4l2_subdev *sd)
 
 static const struct v4l2_subdev_core_ops m5mols_core_ops = {
 	.s_power	= m5mols_s_power,
-	.g_ctrl		= v4l2_subdev_g_ctrl,
-	.s_ctrl		= v4l2_subdev_s_ctrl,
-	.queryctrl	= v4l2_subdev_queryctrl,
-	.querymenu	= v4l2_subdev_querymenu,
-	.g_ext_ctrls	= v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls	= v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls	= v4l2_subdev_s_ext_ctrls,
 	.log_status	= m5mols_log_status,
 };
 
-- 
1.7.11.3


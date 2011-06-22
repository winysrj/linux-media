Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13014 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab1FVPoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 11:44:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LN7005BR7QCYN30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN700JK17QBOB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:35 +0100 (BST)
Date: Wed, 22 Jun 2011 17:44:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] noon010pc30: Clean up the s_power callback
In-reply-to: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1308757470-24421-4-git-send-email-s.nawrocki@samsung.com>
References: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove unneeded check for the platform data in s_power operation
and reorder the code to use early return path. There is no functional
changes in this patch.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 6920cc4..99b58d0 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -588,25 +588,19 @@ static int noon010_base_config(struct v4l2_subdev *sd)
 static int noon010_s_power(struct v4l2_subdev *sd, int on)
 {
 	struct noon010_info *info = to_noon010(sd);
-	const struct noon010pc30_platform_data *pdata = info->pdata;
-	int ret = 0;
-
-	if (WARN(pdata == NULL, "No platform data!\n"))
-		return -ENOMEM;
+	int ret;
 
 	if (on) {
 		ret = power_enable(info);
 		if (ret)
 			return ret;
-		ret = noon010_base_config(sd);
-	} else {
-		noon010_power_ctrl(sd, false, true);
-		ret = power_disable(info);
-		info->curr_win = NULL;
-		info->curr_fmt = NULL;
+		return noon010_base_config(sd);
 	}
 
-	return ret;
+	noon010_power_ctrl(sd, false, true);
+	info->curr_win = NULL;
+	info->curr_fmt = NULL;
+	return power_disable(info);
 }
 
 static int noon010_s_stream(struct v4l2_subdev *sd, int on)
-- 
1.7.5.4


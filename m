Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13014 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab1FVPoh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 11:44:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LN7005BR7QCYN30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LN700JI17QBWR@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 16:44:35 +0100 (BST)
Date: Wed, 22 Jun 2011 17:44:28 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/3] noon010pc30: Do not ignore errors in initial controls setup
In-reply-to: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1308757470-24421-2-git-send-email-s.nawrocki@samsung.com>
References: <1308757470-24421-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Propagate return value from v4l2_ctrl_handler_setup as any
errors from it are now silently ignored.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 35f722a..50ca097 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -554,7 +554,8 @@ static int noon010_base_config(struct v4l2_subdev *sd)
 		ret = noon010_power_ctrl(sd, false, false);
 
 	/* sync the handler and the registers state */
-	v4l2_ctrl_handler_setup(&to_noon010(sd)->hdl);
+	if (!ret)
+		ret = v4l2_ctrl_handler_setup(&info->hdl);
 	return ret;
 }
 
-- 
1.7.5.4


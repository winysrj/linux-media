Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62510 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1GAPEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 11:04:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNN00ESKTVNRX80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNN0006TTVM2O@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 16:04:34 +0100 (BST)
Date: Fri, 01 Jul 2011 17:04:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 1/4] noon010pc30: Do not ignore errors in initial controls
 setup
In-reply-to: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1309532672-17920-2-git-send-email-s.nawrocki@samsung.com>
References: <1309532672-17920-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Propagate return value from v4l2_ctrl_handler_setup as any
errors from it are now silently ignored.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 35f722a..37eca91 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -553,8 +553,9 @@ static int noon010_base_config(struct v4l2_subdev *sd)
 	if (!ret)
 		ret = noon010_power_ctrl(sd, false, false);
 
-	/* sync the handler and the registers state */
-	v4l2_ctrl_handler_setup(&to_noon010(sd)->hdl);
+	/* Synchronize the control handler and the registers state */
+	if (!ret)
+		ret = v4l2_ctrl_handler_setup(&info->hdl);
 	return ret;
 }
 
-- 
1.7.5.4


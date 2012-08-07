Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:48012 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2HGI7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 04:59:10 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8D005SYNL14I40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Aug 2012 17:58:57 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8D004FYNLXN810@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Aug 2012 17:58:57 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] m5mols: Fix cast warnings from m5mols_[set/get]_ctrl_mode
Date: Tue, 07 Aug 2012 10:58:35 +0200
Message-id: <1344329915-4647-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes following warnings on 64-bit architectures:

m5mols.h: In function 'm5mols_set_ctrl_mode':
m5mols.h:326:15: warning: cast to pointer from integer of different
size [-Wint-to-pointer-cast]

m5mols.h: In function 'm5mols_get_ctrl_mode':
m5mols.h:331:9: warning: cast from pointer to integer of different
size [-Wpointer-to-int-cast]

drivers/media/video/m5mols/m5mols_controls.c:466:2: warning: cast
from pointer to integer of different size

Cc: Heungjun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    4 ++--
 drivers/media/video/m5mols/m5mols_controls.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index bb58991..527e7b2 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -323,12 +323,12 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 static inline void m5mols_set_ctrl_mode(struct v4l2_ctrl *ctrl,
 					unsigned int mode)
 {
-	ctrl->priv = (void *)mode;
+	ctrl->priv = (void *)(uintptr_t)mode;
 }

 static inline unsigned int m5mols_get_ctrl_mode(struct v4l2_ctrl *ctrl)
 {
-	return (unsigned int)ctrl->priv;
+	return (unsigned int)(uintptr_t)ctrl->priv;
 }

 #endif	/* M5MOLS_H */
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index fdbc205..f34429e 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -463,8 +463,8 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 		return 0;
 	}

-	v4l2_dbg(1, m5mols_debug, sd, "%s: %s, val: %d, priv: %#x\n",
-		 __func__, ctrl->name, ctrl->val, (int)ctrl->priv);
+	v4l2_dbg(1, m5mols_debug, sd, "%s: %s, val: %d, priv: %p\n",
+		 __func__, ctrl->name, ctrl->val, ctrl->priv);

 	if (ctrl_mode && ctrl_mode != info->mode) {
 		ret = m5mols_set_mode(info, ctrl_mode);
--
1.7.10


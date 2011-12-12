Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41577 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1LLRpF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LW300DC4QN3CU90@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:03 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LW3001DSQN2FG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 12 Dec 2011 17:45:02 +0000 (GMT)
Date: Mon, 12 Dec 2011 18:44:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 05/14] m5mols: Remove mode_save field from struct m5mols_info
In-reply-to: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1323711898-17162-6-git-send-email-s.nawrocki@samsung.com>
References: <1323711898-17162-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to keep this in the drivers' private data structure,
an on the stack variable is enough. Also simplify a bit the ISP state
switching function.

Acked-by: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h      |    2 --
 drivers/media/video/m5mols/m5mols_core.c |   13 ++++++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 13da3f2..cf9701c 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -188,7 +188,6 @@ struct m5mols_version {
  * @lock_awb: true means the Aut WhiteBalance is locked
  * @resolution:	register value for current resolution
  * @mode: register value for current operation mode
- * @mode_save: register value for current operation mode for saving
  * @set_power: optional power callback to the board code
  */
 struct m5mols_info {
@@ -219,7 +218,6 @@ struct m5mols_info {
 	bool lock_awb;
 	u8 resolution;
 	u8 mode;
-	u8 mode_save;
 	int (*set_power)(struct device *dev, int on);
 };
 
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index a2b44ad..8ee5e81 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -369,13 +369,13 @@ int m5mols_mode(struct m5mols_info *info, u8 mode)
 		return ret;
 
 	ret = m5mols_read_u8(sd, SYSTEM_SYSMODE, &reg);
-	if ((!ret && reg == mode) || ret)
+	if (ret || reg == mode)
 		return ret;
 
 	switch (reg) {
 	case REG_PARAMETER:
 		ret = m5mols_reg_mode(sd, REG_MONITOR);
-		if (!ret && mode == REG_MONITOR)
+		if (mode == REG_MONITOR)
 			break;
 		if (!ret)
 			ret = m5mols_reg_mode(sd, REG_CAPTURE);
@@ -392,7 +392,7 @@ int m5mols_mode(struct m5mols_info *info, u8 mode)
 
 	case REG_CAPTURE:
 		ret = m5mols_reg_mode(sd, REG_MONITOR);
-		if (!ret && mode == REG_MONITOR)
+		if (mode == REG_MONITOR)
 			break;
 		if (!ret)
 			ret = m5mols_reg_mode(sd, REG_PARAMETER);
@@ -691,15 +691,14 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct m5mols_info *info = to_m5mols(sd);
-	int ret;
-
-	info->mode_save = info->mode;
+	int isp_state = info->mode;
+	int ret = 0;
 
 	ret = m5mols_mode(info, REG_PARAMETER);
 	if (!ret)
 		ret = m5mols_set_ctrl(ctrl);
 	if (!ret)
-		ret = m5mols_mode(info, info->mode_save);
+		ret = m5mols_mode(info, isp_state);
 
 	return ret;
 }
-- 
1.7.8


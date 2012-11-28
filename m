Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44087 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2K1TJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 14:09:55 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700LI6P8E8G40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:54 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME7006TUP7TOU90@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Nov 2012 04:09:54 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, kyungmin.park@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 07/12] s5p-csis: Enable only data lanes that are actively
 used
Date: Wed, 28 Nov 2012 20:09:24 +0100
Message-id: <1354129766-2821-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
References: <1354129766-2821-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable only MIPI CSI-2 data lanes at the DPHY that are actively
used, rather than unmasking all unconditionally.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index a6791b5..e979b6e 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -273,7 +273,8 @@ static void s5pcsis_reset(struct csis_state *state)
 
 static void s5pcsis_system_enable(struct csis_state *state, int on)
 {
-	u32 val;
+	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
+	u32 val, mask;
 
 	val = s5pcsis_read(state, S5PCSIS_CTRL);
 	if (on)
@@ -283,10 +284,11 @@ static void s5pcsis_system_enable(struct csis_state *state, int on)
 	s5pcsis_write(state, S5PCSIS_CTRL, val);
 
 	val = s5pcsis_read(state, S5PCSIS_DPHYCTRL);
-	if (on)
-		val |= S5PCSIS_DPHYCTRL_ENABLE;
-	else
-		val &= ~S5PCSIS_DPHYCTRL_ENABLE;
+	val &= ~S5PCSIS_DPHYCTRL_ENABLE;
+	if (on) {
+		mask = (1 << (pdata->lanes + 1)) - 1;
+		val |= (mask & S5PCSIS_DPHYCTRL_ENABLE);
+	}
 	s5pcsis_write(state, S5PCSIS_DPHYCTRL, val);
 }
 
-- 
1.7.9.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:38472 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2FRIiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 04:38:25 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5T007EA1BXQVQ0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jun 2012 17:38:24 +0900 (KST)
Received: from localhost.localdomain ([106.116.37.195])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M5T00MMO1BTIG80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jun 2012 17:38:24 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, s.nawrocki@samsung.com, snjw23@gmail.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-fimc: Fix control creation function
Date: Mon, 18 Jun 2012 10:38:14 +0200
Message-id: <1340008694-28508-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed the size of the V4L2_CID_COLORFX control cluster.
Prior to this fix V4L2_CID_ROTATE was also icluded in
the cluster preventing applications from enabling rotation.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index fedcd56..92fc5a2 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -615,7 +615,7 @@ int fimc_ctrls_create(struct fimc_ctx *ctx)
 	ctx->effect.type = FIMC_REG_CIIMGEFF_FIN_BYPASS;
 
 	if (!handler->error) {
-		v4l2_ctrl_cluster(3, &ctrls->colorfx);
+		v4l2_ctrl_cluster(2, &ctrls->colorfx);
 		ctrls->ready = true;
 	}
 
-- 
1.7.0.4


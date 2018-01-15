Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1678950229.outbound-mail.sendgrid.net ([167.89.50.229]:47808
        "EHLO o1678950229.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966868AbeAOQio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 11:38:44 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v5 9/9] v4l: vsp1: Reduce display list body size
Date: Mon, 15 Jan 2018 16:38:43 +0000 (UTC)
Message-Id: <fa58cc7e478813b2e3e8a7e5f646e4c9db844312.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.7c5bc67e9d7032daf8ea4d7bd18cf237c61676b4.1516028582.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The display list originally allocated a body of 256 entries to store all
of the register lists required for each frame.

This has now been separated into fragments for constant stream setup, and
runtime updates.

Empirical testing shows that the body0 now uses a maximum of 41
registers for each frame, for both DRM and Video API pipelines thus a
rounded 64 entries provides a suitable allocation.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_dl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 1fc52496fc13..ce315821b60c 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -21,7 +21,7 @@
 #include "vsp1.h"
 #include "vsp1_dl.h"
 
-#define VSP1_DL_NUM_ENTRIES		256
+#define VSP1_DL_NUM_ENTRIES		64
 
 #define VSP1_DLH_INT_ENABLE		(1 << 1)
 #define VSP1_DLH_AUTO_START		(1 << 0)
-- 
git-series 0.9.1

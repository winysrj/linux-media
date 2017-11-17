Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965821AbdKQPru (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 10:47:50 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 9/9] v4l: vsp1: Reduce display list body size
Date: Fri, 17 Nov 2017 15:47:32 +0000
Message-Id: <84592170dbe4ffdb4cc8d33aa20c23218e029ee7.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.04beabdebfb3483e7f009337bc09953e6d78701d.1510933306.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index 49d88b03d359..278451e8bc4e 100644
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

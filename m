Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44486 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934802AbeB1UxC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 15:53:02 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v6 9/9] v4l: vsp1: Reduce display list body size
Date: Wed, 28 Feb 2018 20:52:43 +0000
Message-Id: <e0ad4e839ffffb002ced5e960b43f5a54cd0260e.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d841c9354585c652c97473ace29c877b9395e83b.1519850924.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index a762e840d147..6b5743a431a2 100644
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

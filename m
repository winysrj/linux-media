Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752406AbdIMLTF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 07:19:05 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 9/9] v4l: vsp1: Reduce display list body size
Date: Wed, 13 Sep 2017 12:18:48 +0100
Message-Id: <56bf843c98242a55deeed7c6ddcfea8f9a2a9092.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index bca9bd45ac7f..5bb1e9103f84 100644
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

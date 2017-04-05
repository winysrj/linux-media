Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44737 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755218AbdDENLR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Apr 2017 09:11:17 -0400
From: Lucas Stach <l.stach@pengutronix.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: [PATCH] [media] coda: bump maximum number of internal framebuffers to 17
Date: Wed,  5 Apr 2017 15:11:15 +0200
Message-Id: <20170405131115.31769-1-l.stach@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The h.264 standard allows up to 16 reference frame for the high profile
and we need one additional internal framebuffer when the VDOA is in use.

Lift the current maximum of 8 internal framebuffers to allow playback
of those video streams.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 drivers/media/platform/coda/coda.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 799ffca72203..2a5bbe0050bb 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -28,7 +28,7 @@
 
 #include "coda_regs.h"
 
-#define CODA_MAX_FRAMEBUFFERS	8
+#define CODA_MAX_FRAMEBUFFERS	17
 #define FMO_SLICE_SAVE_BUF_SIZE	(32)
 
 enum {
-- 
2.11.0

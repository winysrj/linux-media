Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41395 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932097AbeADP66 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Jan 2018 10:58:58 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] media: coda: bump maximum number of internal framebuffers to 19
Date: Thu,  4 Jan 2018 16:58:55 +0100
Message-Id: <20180104155855.21681-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the h.264 standard only allows up to 16 reference frames, the CODA
firmware needs two more buffers: one to hold the currently decoded frame
and one for the display frame. Adding the framebuffer needed by the
driver for VDOA operation brings the total to a maximum of 19 internal
framebuffers.
Lift the current maximum of 17 internal framebuffers to allow playback
of high profile streams that require more than 14 reference frames.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index c5f504d8cf67f..ea8a4e23540d0 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -28,7 +28,7 @@
 
 #include "coda_regs.h"
 
-#define CODA_MAX_FRAMEBUFFERS	17
+#define CODA_MAX_FRAMEBUFFERS	19
 #define FMO_SLICE_SAVE_BUF_SIZE	(32)
 
 enum {
-- 
2.11.0

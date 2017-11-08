Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:43006 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751839AbdKHOM5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 09:12:57 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 5E67720BC0
        for <linux-media@vger.kernel.org>; Wed,  8 Nov 2017 15:12:55 +0100 (CET)
From: Martin Kepplinger <martink@posteo.de>
To: p.zabel@pengutronix.de, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] media: coda: Fix definition of CODA_STD_MJPG
Date: Wed,  8 Nov 2017 15:12:47 +0100
Message-Id: <20171108141247.24824-1-martink@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to i.MX 6 VPU API Reference Manual Rev. L3.0.35_1.1.0, 01/2013
chapter 3.2.1.5, the MJPG video codec is refernced to by number 7, not 3.
So change this accordingly.

This isn't yet being used right now and therefore probably hasn't been
noticed. Fixing this avoids causing trouble in the future.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/media/platform/coda/coda_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 38df5fd9a2fa..8d726faaf86e 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -254,7 +254,7 @@
 #define		CODA9_STD_H264					0
 #define		CODA_STD_H263					1
 #define		CODA_STD_H264					2
-#define		CODA_STD_MJPG					3
+#define		CODA_STD_MJPG					7
 #define		CODA9_STD_MPEG4					3
 
 #define CODA_CMD_ENC_SEQ_SRC_SIZE				0x190
-- 
2.11.0

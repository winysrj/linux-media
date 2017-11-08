Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:50429 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751944AbdKHS6T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Nov 2017 13:58:19 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 892EC20C05
        for <linux-media@vger.kernel.org>; Wed,  8 Nov 2017 19:58:17 +0100 (CET)
From: Martin Kepplinger <martink@posteo.de>
To: p.zabel@pengutronix.de, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] media: coda: remove definition of CODA_STD_MJPG
Date: Wed,  8 Nov 2017 19:58:03 +0100
Message-Id: <20171108185803.12408-1-martink@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to i.MX VPU API Reference Manuals the MJPG video codec is
refernced to by number 7, not 3.

Also Philipp pointed out that this value is only meant to fill in
CMD_ENC_SEQ_COD_STD for encoding, only on i.MX53. It was never written
to any register, and even if defined correctly, wouldn't be needed
for i.MX6.

So avoid confusion and remove this definition.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/media/platform/coda/coda_regs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 38df5fd9a2fa..35e620c7f1f4 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -254,7 +254,6 @@
 #define		CODA9_STD_H264					0
 #define		CODA_STD_H263					1
 #define		CODA_STD_H264					2
-#define		CODA_STD_MJPG					3
 #define		CODA9_STD_MPEG4					3
 
 #define CODA_CMD_ENC_SEQ_SRC_SIZE				0x190
-- 
2.11.0

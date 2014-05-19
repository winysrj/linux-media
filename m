Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33992 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbaESMd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:33:28 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 05/10] [media] s5p-mfc: Update scratch buffer size for VP8 encoder
Date: Mon, 19 May 2014 18:03:01 +0530
Message-Id: <1400502786-4826-6-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
References: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kiran AVND <avnd.kiran@samsung.com>

Scratch buffer size updated for vp8 encoding as per
the latest v7 firmware. As the new macro increases the
scratch buffer size, it is backward compatible with the older
firmware too.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
index ea5ec2a..5dfa149 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
@@ -56,6 +56,7 @@
 			(SZ_1M + ((w) * 144) + (8192 * (h)) + 49216)
 
 #define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V7(w, h) \
-			(((w) * 48) + (((w) + 1) / 2 * 128) + 144 + 8192)
+			(((w) * 48) + 8192 + ((((w) + 1) / 2) * 128) + 144 + \
+			((((((w) * 16) * ((h) * 16)) * 3) / 2) * 4))
 
 #endif /*_REGS_MFC_V7_H*/
-- 
1.7.9.5


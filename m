Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:65027 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaESMde (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:33:34 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 07/10] [media] s5p-mfc: Update scratch buffer size for MPEG4
Date: Mon, 19 May 2014 18:03:03 +0530
Message-Id: <1400502786-4826-8-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
References: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update the MPEG4 decoder scratch buffer size as per the
new v6 firmware. This updation is increasing the size and so
is backward compatible with older v6 firmwares.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 8d0b686..8e4021c 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -381,8 +381,7 @@
 	 (DIV_ROUND_UP((mbw) * (mbh), 32) * 16))
 #define S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(w, h)	(((w) * 192) + 64)
 #define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(w, h) \
-			((w) * ((h) * 64 + 144) + (2048/16 * (h) * 64) + \
-			 (2048/16 * 256 + 8320))
+			((w) * 144 + 8192 * (h) + 49216 + 1048576)
 #define S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(w, h) \
 						(2096 * ((w) + (h) + 1))
 #define S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(w, h)	((w) * 400)
-- 
1.7.9.5


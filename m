Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51758 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab3GIFBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 01:01:38 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MPN00HAEKLEDNI0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Jul 2013 14:01:31 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v5 1/8] [media] s5p-mfc: Update v6 encoder buffer sizes
Date: Tue, 09 Jul 2013 10:54:35 +0530
Message-id: <1373347482-9264-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1373347482-9264-1-git-send-email-arun.kk@samsung.com>
References: <1373347482-9264-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch updates few encoder buffer sizes for MFC v6.5
as per the udpdated user manual. The same buffer sizes
holds good for v7 firmware also.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 363a97c..2398cdf 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -374,9 +374,9 @@
 #define S5P_FIMV_NUM_PIXELS_IN_MB_COL_V6	16
 
 /* Buffer size requirements defined by hardware */
-#define S5P_FIMV_TMV_BUFFER_SIZE_V6(w, h)	(((w) + 1) * ((h) + 1) * 8)
+#define S5P_FIMV_TMV_BUFFER_SIZE_V6(w, h)	(((w) + 1) * ((h) + 3) * 8)
 #define S5P_FIMV_ME_BUFFER_SIZE_V6(imw, imh, mbw, mbh) \
-	((DIV_ROUND_UP(imw, 64) *  DIV_ROUND_UP(imh, 64) * 256) + \
+	(((((imw + 127) / 64) * 16) *  DIV_ROUND_UP(imh, 64) * 256) + \
 	 (DIV_ROUND_UP((mbw) * (mbh), 32) * 16))
 #define S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(w, h)	(((w) * 192) + 64)
 #define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(w, h) \
-- 
1.7.9.5


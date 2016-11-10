Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35062 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755024AbcKJKbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 05:31:39 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 1/4] s5p-mfc: Correct scratch buffer size of H.263 decoder
Date: Thu, 10 Nov 2016 11:31:20 +0100
Message-id: <1478773883-12083-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478773883-12083-1-git-send-email-m.szyprowski@samsung.com>
References: <1478773883-12083-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161110103134eucas1p12d51176e2f40390b7ae8356471e79084@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrzej Hajda <a.hajda@samsung.com>

Driver complains about too small scratch buffer size. After adjusting
it according to vendor code, decoding works.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
[mszyprow: moved the change to the header file]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 83e01f3..d2cd359 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -386,7 +386,8 @@
 			((w) * 144 + 8192 * (h) + 49216 + 1048576)
 #define S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(w, h) \
 						(2096 * ((w) + (h) + 1))
-#define S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(w, h)	((w) * 400)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(w, h)	\
+			S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(w, h)
 #define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V6(w, h) \
 			((w) * 32 + (h) * 128 + (((w) + 1) / 2) * 64 + 2112)
 #define S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(w, h) \
-- 
1.9.1


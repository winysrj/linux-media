Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35464 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753667AbdCTK5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:57:16 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v3 10/16] media: s5p-mfc: Reduce firmware buffer size for MFC
 v6+ variants
Date: Mon, 20 Mar 2017 11:56:36 +0100
Message-id: <1490007402-30265-11-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105652eucas1p1dfa223654e55908446103109d97aa2c2@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware for MFC v6+ variants is not larger than 400 KiB, so there is no
need to allocate a full 1 MiB buffer for it. Reduce it to 512 KiB to keep
proper alignment of allocated buffer.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
Tested-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h | 2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h | 2 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index d2cd35916dc5..c0166ee9a455 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -403,7 +403,7 @@
 #define MFC_OTHER_ENC_CTX_BUF_SIZE_V6	(12 * SZ_1K)	/*  12KB */
 
 /* MFCv6 variant defines */
-#define MAX_FW_SIZE_V6			(SZ_1M)		/* 1MB */
+#define MAX_FW_SIZE_V6			(SZ_512K)	/* 512KB */
 #define MAX_CPB_SIZE_V6			(3 * SZ_1M)	/* 3MB */
 #define MFC_VERSION_V6			0x61
 #define MFC_NUM_PORTS_V6		1
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
index 1a5c6fdf7846..9f220769d970 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
@@ -34,7 +34,7 @@
 #define S5P_FIMV_E_VP8_NUM_T_LAYER_V7			0xfdc4
 
 /* MFCv7 variant defines */
-#define MAX_FW_SIZE_V7			(SZ_1M)		/* 1MB */
+#define MAX_FW_SIZE_V7			(SZ_512K)	/* 512KB */
 #define MAX_CPB_SIZE_V7			(3 * SZ_1M)	/* 3MB */
 #define MFC_VERSION_V7			0x72
 #define MFC_NUM_PORTS_V7		1
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v8.h b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
index 4d1c3750eb5e..75f5f7511d72 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
@@ -116,7 +116,7 @@
 #define S5P_FIMV_D_ALIGN_PLANE_SIZE_V8	64
 
 /* MFCv8 variant defines */
-#define MAX_FW_SIZE_V8			(SZ_1M)		/* 1MB */
+#define MAX_FW_SIZE_V8			(SZ_512K)	/* 512KB */
 #define MAX_CPB_SIZE_V8			(3 * SZ_1M)	/* 3MB */
 #define MFC_VERSION_V8			0x80
 #define MFC_NUM_PORTS_V8		1
-- 
1.9.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:44592 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3FYKdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 06:33:47 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MOY008OL2O1QT30@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Jun 2013 19:33:46 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v3 3/8] [media] s5p-mfc: Add register definition file for MFC v7
Date: Tue, 25 Jun 2013 16:27:10 +0530
Message-id: <1372157835-27663-4-git-send-email-arun.kk@samsung.com>
In-reply-to: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
References: <1372157835-27663-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch adds the register definition file for new firmware
version v7 for MFC. New firmware supports VP8 encoding along with
many other features.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h |   58 ++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v7.h

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
new file mode 100644
index 0000000..24dba69
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
@@ -0,0 +1,58 @@
+/*
+ * Register definition file for Samsung MFC V7.x Interface (FIMV) driver
+ *
+ * Copyright (c) 2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _REGS_MFC_V7_H
+#define _REGS_MFC_V7_H
+
+#include "regs-mfc-v6.h"
+
+/* Additional features of v7 */
+#define S5P_FIMV_CODEC_VP8_ENC_V7	25
+
+/* Additional registers for v7 */
+#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7		0xf47c
+
+#define S5P_FIMV_E_SOURCE_FIRST_ADDR_V7			0xf9e0
+#define S5P_FIMV_E_SOURCE_SECOND_ADDR_V7		0xf9e4
+#define S5P_FIMV_E_SOURCE_THIRD_ADDR_V7			0xf9e8
+#define S5P_FIMV_E_SOURCE_FIRST_STRIDE_V7		0xf9ec
+#define S5P_FIMV_E_SOURCE_SECOND_STRIDE_V7		0xf9f0
+#define S5P_FIMV_E_SOURCE_THIRD_STRIDE_V7		0xf9f4
+
+#define S5P_FIMV_E_ENCODED_SOURCE_FIRST_ADDR_V7		0xfa70
+#define S5P_FIMV_E_ENCODED_SOURCE_SECOND_ADDR_V7	0xfa74
+
+#define S5P_FIMV_E_VP8_OPTIONS_V7			0xfdb0
+#define S5P_FIMV_E_VP8_FILTER_OPTIONS_V7		0xfdb4
+#define S5P_FIMV_E_VP8_GOLDEN_FRAME_OPTION_V7		0xfdb8
+#define S5P_FIMV_E_VP8_NUM_T_LAYER_V7			0xfdc4
+
+/* MFCv7 variant defines */
+#define MAX_FW_SIZE_V7			(SZ_1M)		/* 1MB */
+#define MAX_CPB_SIZE_V7			(3 * SZ_1M)	/* 3MB */
+#define MFC_VERSION_V7			0x72
+#define MFC_NUM_PORTS_V7		1
+
+/* MFCv7 Context buffer sizes */
+#define MFC_CTX_BUF_SIZE_V7		(30 * SZ_1K)	/*  30KB */
+#define MFC_H264_DEC_CTX_BUF_SIZE_V7	(2 * SZ_1M)	/*  2MB */
+#define MFC_OTHER_DEC_CTX_BUF_SIZE_V7	(20 * SZ_1K)	/*  20KB */
+#define MFC_H264_ENC_CTX_BUF_SIZE_V7	(100 * SZ_1K)	/* 100KB */
+#define MFC_OTHER_ENC_CTX_BUF_SIZE_V7	(10 * SZ_1K)	/*  10KB */
+
+/* Buffer size defines */
+#define S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V7(w, h) \
+			(SZ_1M + ((w) * 144) + (8192 * (h)) + 49216)
+
+#define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_ENC_V7(w, h) \
+			(((w) * 48) + (((w) + 1) / 2 * 128) + 144 + 8192)
+
+#endif /*_REGS_MFC_V7_H*/
-- 
1.7.9.5


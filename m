Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:32440 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3FRMd5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 08:33:57 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MOL0019P9KJ36J0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 18 Jun 2013 21:33:56 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH v2 4/8] [media] s5p-mfc: Core support for MFC v7
Date: Tue, 18 Jun 2013 18:26:19 +0530
Message-id: <1371560183-23244-5-git-send-email-arun.kk@samsung.com>
In-reply-to: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
References: <1371560183-23244-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds variant data and core support for the MFC v7 firmware

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 .../devicetree/bindings/media/s5p-mfc.txt          |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   32 ++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    2 ++
 3 files changed, 35 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index 67ec3d4..cb9c5bc 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -10,6 +10,7 @@ Required properties:
   - compatible : value should be either one among the following
 	(a) "samsung,mfc-v5" for MFC v5 present in Exynos4 SoCs
 	(b) "samsung,mfc-v6" for MFC v6 present in Exynos5 SoCs
+	(b) "samsung,mfc-v7" for MFC v7 present in Exynos5420 SoC
 
   - reg : Physical base address of the IP registers and length of memory
 	  mapped region.
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d12faa6..d6be52f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1391,6 +1391,32 @@ static struct s5p_mfc_variant mfc_drvdata_v6 = {
 	.fw_name        = "s5p-mfc-v6.fw",
 };
 
+struct s5p_mfc_buf_size_v6 mfc_buf_size_v7 = {
+	.dev_ctx	= MFC_CTX_BUF_SIZE_V7,
+	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V7,
+	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V7,
+	.h264_enc_ctx	= MFC_H264_ENC_CTX_BUF_SIZE_V7,
+	.other_enc_ctx	= MFC_OTHER_ENC_CTX_BUF_SIZE_V7,
+};
+
+struct s5p_mfc_buf_size buf_size_v7 = {
+	.fw	= MAX_FW_SIZE_V7,
+	.cpb	= MAX_CPB_SIZE_V7,
+	.priv	= &mfc_buf_size_v7,
+};
+
+struct s5p_mfc_buf_align mfc_buf_align_v7 = {
+	.base = 0,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v7 = {
+	.version	= MFC_VERSION_V7,
+	.port_num	= MFC_NUM_PORTS_V7,
+	.buf_size	= &buf_size_v7,
+	.buf_align	= &mfc_buf_align_v7,
+	.fw_name        = "s5p-mfc-v7.fw",
+};
+
 static struct platform_device_id mfc_driver_ids[] = {
 	{
 		.name = "s5p-mfc",
@@ -1401,6 +1427,9 @@ static struct platform_device_id mfc_driver_ids[] = {
 	}, {
 		.name = "s5p-mfc-v6",
 		.driver_data = (unsigned long)&mfc_drvdata_v6,
+	}, {
+		.name = "s5p-mfc-v7",
+		.driver_data = (unsigned long)&mfc_drvdata_v7,
 	},
 	{},
 };
@@ -1413,6 +1442,9 @@ static const struct of_device_id exynos_mfc_match[] = {
 	}, {
 		.compatible = "samsung,mfc-v6",
 		.data = &mfc_drvdata_v6,
+	}, {
+		.compatible = "samsung,mfc-v7",
+		.data = &mfc_drvdata_v7,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index d47016d..17545d7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -24,6 +24,7 @@
 #include <media/videobuf2-core.h>
 #include "regs-mfc.h"
 #include "regs-mfc-v6.h"
+#include "regs-mfc-v7.h"
 
 /* Definitions related to MFC memory */
 
@@ -684,5 +685,6 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 				(dev->variant->port_num ? 1 : 0) : 0) : 0)
 #define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
 #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
+#define IS_MFCV7(dev)		(dev->variant->version >= 0x70 ? 1 : 0)
 
 #endif /* S5P_MFC_COMMON_H_ */
-- 
1.7.9.5


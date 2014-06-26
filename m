Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:54753 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbaFZBHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:25 -0400
Received: by mail-pb0-f52.google.com with SMTP id rq2so2386197pbb.25
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:24 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 12/28] gpu: ipu-v3: Move IDMAC channel names to imx-ipu-v3.h
Date: Wed, 25 Jun 2014 18:05:39 -0700
Message-Id: <1403744755-24944-13-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the IDMAC channel names to imx-ipu-v3.h, to make the names
available outside IPU. Add a couple new channels in the process
(async display BG/FG, channels 24 and 29).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-prv.h |   25 -------------------------
 include/video/imx-ipu-v3.h   |   30 ++++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
index 8e0bc1d..90fc02a 100644
--- a/drivers/gpu/ipu-v3/ipu-prv.h
+++ b/drivers/gpu/ipu-v3/ipu-prv.h
@@ -24,31 +24,6 @@ struct ipu_soc;
 
 #include <video/imx-ipu-v3.h>
 
-#define IPUV3_CHANNEL_CSI0			 0
-#define IPUV3_CHANNEL_CSI1			 1
-#define IPUV3_CHANNEL_CSI2			 2
-#define IPUV3_CHANNEL_CSI3			 3
-#define IPUV3_CHANNEL_VDI_MEM_IC_VF              5
-#define IPUV3_CHANNEL_MEM_IC_PP                 11
-#define IPUV3_CHANNEL_MEM_IC_PRP_VF             12
-#define IPUV3_CHANNEL_G_MEM_IC_PRP_VF           14
-#define IPUV3_CHANNEL_G_MEM_IC_PP               15
-#define IPUV3_CHANNEL_IC_PRP_ENC_MEM            20
-#define IPUV3_CHANNEL_IC_PRP_VF_MEM             21
-#define IPUV3_CHANNEL_IC_PP_MEM                 22
-#define IPUV3_CHANNEL_MEM_BG_SYNC		23
-#define IPUV3_CHANNEL_MEM_FG_SYNC		27
-#define IPUV3_CHANNEL_MEM_DC_SYNC		28
-#define IPUV3_CHANNEL_MEM_FG_SYNC_ALPHA		31
-#define IPUV3_CHANNEL_MEM_DC_ASYNC		41
-#define IPUV3_CHANNEL_MEM_ROT_ENC		45
-#define IPUV3_CHANNEL_MEM_ROT_VF		46
-#define IPUV3_CHANNEL_MEM_ROT_PP		47
-#define IPUV3_CHANNEL_ROT_ENC_MEM		48
-#define IPUV3_CHANNEL_ROT_VF_MEM		49
-#define IPUV3_CHANNEL_ROT_PP_MEM		50
-#define IPUV3_CHANNEL_MEM_BG_SYNC_ALPHA		51
-
 #define IPU_MCU_T_DEFAULT	8
 #define IPU_CM_IDMAC_REG_OFS	0x00008000
 #define IPU_CM_IC_REG_OFS	0x00020000
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 20776cf..44e337b 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -135,6 +135,36 @@ enum ipu_channel_irq {
 	IPU_IRQ_EOS = 192,
 };
 
+/*
+ * Enumeration of IDMAC channels
+ */
+#define IPUV3_CHANNEL_CSI0			 0
+#define IPUV3_CHANNEL_CSI1			 1
+#define IPUV3_CHANNEL_CSI2			 2
+#define IPUV3_CHANNEL_CSI3			 3
+#define IPUV3_CHANNEL_VDI_MEM_IC_VF		 5
+#define IPUV3_CHANNEL_MEM_IC_PP			11
+#define IPUV3_CHANNEL_MEM_IC_PRP_VF		12
+#define IPUV3_CHANNEL_G_MEM_IC_PRP_VF		14
+#define IPUV3_CHANNEL_G_MEM_IC_PP		15
+#define IPUV3_CHANNEL_IC_PRP_ENC_MEM		20
+#define IPUV3_CHANNEL_IC_PRP_VF_MEM		21
+#define IPUV3_CHANNEL_IC_PP_MEM			22
+#define IPUV3_CHANNEL_MEM_BG_SYNC		23
+#define IPUV3_CHANNEL_MEM_BG_ASYNC		24
+#define IPUV3_CHANNEL_MEM_FG_SYNC		27
+#define IPUV3_CHANNEL_MEM_DC_SYNC		28
+#define IPUV3_CHANNEL_MEM_FG_ASYNC		29
+#define IPUV3_CHANNEL_MEM_FG_SYNC_ALPHA		31
+#define IPUV3_CHANNEL_MEM_DC_ASYNC		41
+#define IPUV3_CHANNEL_MEM_ROT_ENC		45
+#define IPUV3_CHANNEL_MEM_ROT_VF		46
+#define IPUV3_CHANNEL_MEM_ROT_PP		47
+#define IPUV3_CHANNEL_ROT_ENC_MEM		48
+#define IPUV3_CHANNEL_ROT_VF_MEM		49
+#define IPUV3_CHANNEL_ROT_PP_MEM		50
+#define IPUV3_CHANNEL_MEM_BG_SYNC_ALPHA		51
+
 int ipu_map_irq(struct ipu_soc *ipu, int irq);
 int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
 		enum ipu_channel_irq irq);
-- 
1.7.9.5


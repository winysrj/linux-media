Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:62230 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaFGV5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:07 -0400
Received: by mail-pb0-f54.google.com with SMTP id jt11so3906480pbb.13
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:07 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 07/43] imx-drm: ipu-v3: Rename and add IDMAC channels
Date: Sat,  7 Jun 2014 14:56:09 -0700
Message-Id: <1402178205-22697-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the ENC/VF/PP rotation channel names, to be more consistent
with the convention that *_MEM is write-to-memory channels and
MEM_* is read-from-memory channels. Also add the channels who's
source and destination is the IC.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 69d99b0..1398752 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -31,17 +31,25 @@ struct ipu_soc;
 #define IPUV3_CHANNEL_CSI1			 1
 #define IPUV3_CHANNEL_CSI2			 2
 #define IPUV3_CHANNEL_CSI3			 3
+#define IPUV3_CHANNEL_VDI_MEM_IC_VF              5
+#define IPUV3_CHANNEL_MEM_IC_PP                 11
+#define IPUV3_CHANNEL_MEM_IC_PRP_VF             12
+#define IPUV3_CHANNEL_G_MEM_IC_PRP_VF           14
+#define IPUV3_CHANNEL_G_MEM_IC_PP               15
+#define IPUV3_CHANNEL_IC_PRP_ENC_MEM            20
+#define IPUV3_CHANNEL_IC_PRP_VF_MEM             21
+#define IPUV3_CHANNEL_IC_PP_MEM                 22
 #define IPUV3_CHANNEL_MEM_BG_SYNC		23
 #define IPUV3_CHANNEL_MEM_FG_SYNC		27
 #define IPUV3_CHANNEL_MEM_DC_SYNC		28
 #define IPUV3_CHANNEL_MEM_FG_SYNC_ALPHA		31
 #define IPUV3_CHANNEL_MEM_DC_ASYNC		41
-#define IPUV3_CHANNEL_ROT_ENC_MEM		45
-#define IPUV3_CHANNEL_ROT_VF_MEM		46
-#define IPUV3_CHANNEL_ROT_PP_MEM		47
-#define IPUV3_CHANNEL_ROT_ENC_MEM_OUT		48
-#define IPUV3_CHANNEL_ROT_VF_MEM_OUT		49
-#define IPUV3_CHANNEL_ROT_PP_MEM_OUT		50
+#define IPUV3_CHANNEL_MEM_ROT_ENC		45
+#define IPUV3_CHANNEL_MEM_ROT_VF		46
+#define IPUV3_CHANNEL_MEM_ROT_PP		47
+#define IPUV3_CHANNEL_ROT_ENC_MEM		48
+#define IPUV3_CHANNEL_ROT_VF_MEM		49
+#define IPUV3_CHANNEL_ROT_PP_MEM		50
 #define IPUV3_CHANNEL_MEM_BG_SYNC_ALPHA		51
 
 #define IPU_MCU_T_DEFAULT	8
-- 
1.7.9.5


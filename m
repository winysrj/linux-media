Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34230 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbcGFXH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:29 -0400
Received: by mail-pf0-f195.google.com with SMTP id 66so101598pfy.1
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:29 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 07/28] gpu: ipu-v3: Add VDI input IDMAC channels
Date: Wed,  6 Jul 2016 16:06:37 -0700
Message-Id: <1467846418-12913-8-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the VDIC field input IDMAC channels. These channels
transfer fields F(n-1), F(n), and F(N+1) from memory to
the VDIC (channels 8, 9, 10 respectively).

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 include/video/imx-ipu-v3.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 586979e..2302fc5 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -107,6 +107,9 @@ enum ipu_channel_irq {
 #define IPUV3_CHANNEL_CSI2			 2
 #define IPUV3_CHANNEL_CSI3			 3
 #define IPUV3_CHANNEL_VDI_MEM_IC_VF		 5
+#define IPUV3_CHANNEL_MEM_VDI_P			 8
+#define IPUV3_CHANNEL_MEM_VDI			 9
+#define IPUV3_CHANNEL_MEM_VDI_N			10
 #define IPUV3_CHANNEL_MEM_IC_PP			11
 #define IPUV3_CHANNEL_MEM_IC_PRP_VF		12
 #define IPUV3_CHANNEL_G_MEM_IC_PRP_VF		14
-- 
1.9.1


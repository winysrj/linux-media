Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51779 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaFGV5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:15 -0400
Received: by mail-pd0-f169.google.com with SMTP id w10so3814581pde.28
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:15 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 15/43] imx-drm: ipu-v3: Add ipu_idmac_current_buffer()
Date: Sat,  7 Jun 2014 14:56:17 -0700
Message-Id: <1402178205-22697-16-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ipu_idmac_current_buffer(), returns the currently active
buffer number in the given channel.

Checks for third buffer ready in case triple-buffer support is
added later.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   27 +++++++++++++++++++++++++++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |    2 ++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 3 files changed, 30 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index fd15eae..4839893 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -683,6 +683,8 @@ void ipu_idmac_put(struct ipuv3_channel *channel)
 EXPORT_SYMBOL_GPL(ipu_idmac_put);
 
 #define idma_mask(ch)			(1 << ((ch) & 0x1f))
+#define tri_cur_buf_mask(ch)		(idma_mask((ch) * 2) * 3)
+#define tri_cur_buf_shift(ch)		(ffs(idma_mask((ch) * 2)) - 1)
 
 void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 		bool doublebuffer)
@@ -780,6 +782,31 @@ bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_buffer_is_ready);
 
+int ipu_idmac_current_buffer(struct ipuv3_channel *channel)
+{
+	struct ipu_soc *ipu = channel->ipu;
+	unsigned long flags;
+	int bufnum;
+	u32 reg;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	reg = ipu_cm_read(ipu, IPU_CHA_TRB_MODE_SEL(channel->num));
+	if (reg & idma_mask(channel->num)) {
+		reg = ipu_cm_read(ipu, IPU_CHA_TRIPLE_CUR_BUF(channel->num));
+		bufnum = (reg & tri_cur_buf_mask(channel->num)) >>
+			tri_cur_buf_shift(channel->num);
+	} else {
+		reg = ipu_cm_read(ipu, IPU_CHA_CUR_BUF(channel->num));
+		bufnum = (reg & idma_mask(channel->num)) ? 1 : 0;
+	}
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	return bufnum;
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_current_buffer);
+
 void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num)
 {
 	struct ipu_soc *ipu = channel->ipu;
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 43ac6c3..446ed20 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -62,8 +62,10 @@ struct ipu_soc;
 #define IPU_PM				IPU_CM_REG(0x00e0)
 #define IPU_GPR				IPU_CM_REG(0x00e4)
 #define IPU_CHA_DB_MODE_SEL(ch)		IPU_CM_REG(0x0150 + 4 * ((ch) / 32))
+#define IPU_CHA_TRB_MODE_SEL(ch)	IPU_CM_REG(0x0178 + 4 * ((ch) / 32))
 #define IPU_ALT_CHA_DB_MODE_SEL(ch)	IPU_CM_REG(0x0168 + 4 * ((ch) / 32))
 #define IPU_CHA_CUR_BUF(ch)		IPU_CM_REG(0x023C + 4 * ((ch) / 32))
+#define IPU_CHA_TRIPLE_CUR_BUF(ch)	IPU_CM_REG(0x0258 + 4 * ((ch) / 32))
 #define IPU_ALT_CUR_BUF0		IPU_CM_REG(0x0244)
 #define IPU_ALT_CUR_BUF1		IPU_CM_REG(0x0248)
 #define IPU_SRM_STAT			IPU_CM_REG(0x024C)
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 480c30d..6f2c408 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -201,6 +201,7 @@ void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num);
 void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num);
 bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num);
+int ipu_idmac_current_buffer(struct ipuv3_channel *channel);
 
 /*
  * IPU Display Controller (dc) functions
-- 
1.7.9.5


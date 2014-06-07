Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43414 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaFGV5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:15 -0400
Received: by mail-pb0-f50.google.com with SMTP id ma3so3885192pbc.37
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:14 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 14/43] imx-drm: ipu-v3: Add ipu_idmac_clear_buffer()
Date: Sat,  7 Jun 2014 14:56:16 -0700
Message-Id: <1402178205-22697-15-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the reverse of ipu_idmac_select_buffer(), that is, clear a buffer
ready status in a channel.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   28 +++++++++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 3ff55da..fd15eae 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -798,6 +798,34 @@ void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_select_buffer);
 
+void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num)
+{
+	struct ipu_soc *ipu = channel->ipu;
+	unsigned int chno = channel->num;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	ipu_cm_write(ipu, 0xF0300000, IPU_GPR); /* write one to clear */
+	switch (buf_num) {
+	case 0:
+		ipu_cm_write(ipu, idma_mask(chno), IPU_CHA_BUF0_RDY(chno));
+		break;
+	case 1:
+		ipu_cm_write(ipu, idma_mask(chno), IPU_CHA_BUF1_RDY(chno));
+		break;
+	case 2:
+		ipu_cm_write(ipu, idma_mask(chno), IPU_CHA_BUF2_RDY(chno));
+		break;
+	default:
+		break;
+	}
+	ipu_cm_write(ipu, 0x0, IPU_GPR); /* write one to set */
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_clear_buffer);
+
 int ipu_idmac_enable_channel(struct ipuv3_channel *channel)
 {
 	struct ipu_soc *ipu = channel->ipu;
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 0128667..480c30d 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -199,6 +199,7 @@ int ipu_idmac_wait_busy(struct ipuv3_channel *channel, int ms);
 void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 		bool doublebuffer);
 void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num);
+void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num);
 bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num);
 
 /*
-- 
1.7.9.5


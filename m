Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43100 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbaFZBH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:26 -0400
Received: by mail-pb0-f46.google.com with SMTP id md12so2412051pbc.33
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:25 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 13/28] gpu: ipu-v3: Add ipu_idmac_buffer_is_ready()
Date: Wed, 25 Jun 2014 18:05:40 -0700
Message-Id: <1403744755-24944-14-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add ipu_idmac_buffer_is_ready(), returns true if the given buffer in
the given channel is set ready (owned by IPU), or false if not ready
(owned by CPU core).

Support has been added for third buffer, there is no support yet for
triple-buffering in idmac channels, but this function checks
buffer-ready for third buffer in case this support is added later.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   26 +++++++++++++++++++++++++-
 drivers/gpu/ipu-v3/ipu-prv.h    |    1 +
 include/video/imx-ipu-v3.h      |    1 +
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 909ef71..35442f20 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -682,7 +682,7 @@ void ipu_idmac_put(struct ipuv3_channel *channel)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_put);
 
-#define idma_mask(ch)			(1 << (ch & 0x1f))
+#define idma_mask(ch)			(1 << ((ch) & 0x1f))
 
 void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 		bool doublebuffer)
@@ -765,6 +765,30 @@ int ipu_idmac_get_current_buffer(struct ipuv3_channel *channel)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_get_current_buffer);
 
+bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num)
+{
+	struct ipu_soc *ipu = channel->ipu;
+	unsigned long flags;
+	u32 reg = 0;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+	switch (buf_num) {
+	case 0:
+		reg = ipu_cm_read(ipu, IPU_CHA_BUF0_RDY(channel->num));
+		break;
+	case 1:
+		reg = ipu_cm_read(ipu, IPU_CHA_BUF1_RDY(channel->num));
+		break;
+	case 2:
+		reg = ipu_cm_read(ipu, IPU_CHA_BUF2_RDY(channel->num));
+		break;
+	}
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	return ((reg & idma_mask(channel->num)) != 0);
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_buffer_is_ready);
+
 void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num)
 {
 	struct ipu_soc *ipu = channel->ipu;
diff --git a/drivers/gpu/ipu-v3/ipu-prv.h b/drivers/gpu/ipu-v3/ipu-prv.h
index 90fc02a..b7b8a52 100644
--- a/drivers/gpu/ipu-v3/ipu-prv.h
+++ b/drivers/gpu/ipu-v3/ipu-prv.h
@@ -68,6 +68,7 @@ struct ipu_soc;
 #define IPU_DISP_TASK_STAT		IPU_CM_REG(0x0254)
 #define IPU_CHA_BUF0_RDY(ch)		IPU_CM_REG(0x0268 + 4 * ((ch) / 32))
 #define IPU_CHA_BUF1_RDY(ch)		IPU_CM_REG(0x0270 + 4 * ((ch) / 32))
+#define IPU_CHA_BUF2_RDY(ch)		IPU_CM_REG(0x0288 + 4 * ((ch) / 32))
 #define IPU_ALT_CHA_BUF0_RDY(ch)	IPU_CM_REG(0x0278 + 4 * ((ch) / 32))
 #define IPU_ALT_CHA_BUF1_RDY(ch)	IPU_CM_REG(0x0280 + 4 * ((ch) / 32))
 
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 44e337b..aeb8e63 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -201,6 +201,7 @@ int ipu_idmac_wait_busy(struct ipuv3_channel *channel, int ms);
 void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 		bool doublebuffer);
 int ipu_idmac_get_current_buffer(struct ipuv3_channel *channel);
+bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num);
 void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num);
 
 /*
-- 
1.7.9.5


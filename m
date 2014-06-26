Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58624 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629AbaFZBH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:26 -0400
Received: by mail-pd0-f182.google.com with SMTP id y13so2313186pdi.41
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:26 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 14/28] gpu: ipu-v3: Add ipu_idmac_clear_buffer()
Date: Wed, 25 Jun 2014 18:05:41 -0700
Message-Id: <1403744755-24944-15-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the reverse of ipu_idmac_select_buffer(), that is, clear a buffer
ready status in a channel.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   28 ++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |    1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 35442f20..63f2cf2 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -807,6 +807,34 @@ void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num)
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index aeb8e63..9ed1c75 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -203,6 +203,7 @@ void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 int ipu_idmac_get_current_buffer(struct ipuv3_channel *channel);
 bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num);
 void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num);
+void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num);
 
 /*
  * IPU Display Controller (dc) functions
-- 
1.7.9.5


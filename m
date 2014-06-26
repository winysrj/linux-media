Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50872 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091AbaFZBH3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:29 -0400
Received: by mail-pb0-f47.google.com with SMTP id up15so2399332pbc.6
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:28 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 17/28] gpu: ipu-v3: Add ipu_idmac_enable_watermark()
Date: Wed, 25 Jun 2014 18:05:44 -0700
Message-Id: <1403744755-24944-18-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the function ipu_idmac_enable_watermark(), which enables or disables
watermarking in the IDMAC channel. Enabling watermarking can increase a
channel's AXI bus arbitration priority.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   25 +++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |    1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 30afef4..7be56b6 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -986,6 +986,31 @@ int ipu_idmac_disable_channel(struct ipuv3_channel *channel)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_disable_channel);
 
+/*
+ * The imx6 rev. D TRM says that enabling the WM feature will increase
+ * a channel's priority. Refer to Table 36-8 Calculated priority value.
+ * The sub-module that is the sink or source for the channel must enable
+ * watermark signal for this to take effect (SMFC_WM for instance).
+ */
+void ipu_idmac_enable_watermark(struct ipuv3_channel *channel, bool enable)
+{
+	struct ipu_soc *ipu = channel->ipu;
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	val = ipu_idmac_read(ipu, IDMAC_WM_EN(channel->num));
+	if (enable)
+		val |= 1 << (channel->num % 32);
+	else
+		val &= ~(1 << (channel->num % 32));
+	ipu_idmac_write(ipu, val, IDMAC_WM_EN(channel->num));
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_enable_watermark);
+
 static int ipu_memory_reset(struct ipu_soc *ipu)
 {
 	unsigned long timeout;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 17a0bb8..df9863a 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -196,6 +196,7 @@ void ipu_idmac_put(struct ipuv3_channel *);
 
 int ipu_idmac_enable_channel(struct ipuv3_channel *channel);
 int ipu_idmac_disable_channel(struct ipuv3_channel *channel);
+void ipu_idmac_enable_watermark(struct ipuv3_channel *channel, bool enable);
 int ipu_idmac_wait_busy(struct ipuv3_channel *channel, int ms);
 
 void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
-- 
1.7.9.5


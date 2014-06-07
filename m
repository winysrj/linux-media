Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35113 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbaFGV5T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:19 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so3806019pdj.6
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:18 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 18/43] imx-drm: ipu-v3: Add ipu_idmac_enable_watermark()
Date: Sat,  7 Jun 2014 14:56:20 -0700
Message-Id: <1402178205-22697-19-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds the function ipu_idmac_enable_watermark(), which enables or disables
watermarking in the IDMAC channel. Enabling watermarking can increase a
channel's AXI bus arbitration priority.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   25 +++++++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 32a51d6..8c5b8d3 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -982,6 +982,31 @@ int ipu_idmac_disable_channel(struct ipuv3_channel *channel)
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
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 681b9fd..d1def4d 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -202,6 +202,7 @@ void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num);
 void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num);
 bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num);
 int ipu_idmac_current_buffer(struct ipuv3_channel *channel);
+void ipu_idmac_enable_watermark(struct ipuv3_channel *channel, bool enable);
 
 /*
  * IPU Display Controller (dc) functions
-- 
1.7.9.5


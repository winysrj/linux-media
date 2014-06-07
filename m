Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47790 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaFGV5U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:20 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so3833677pdj.20
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:19 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 19/43] imx-drm: ipu-v3: Add ipu_idmac_lock_enable()
Date: Sat,  7 Jun 2014 14:56:21 -0700
Message-Id: <1402178205-22697-20-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_idmac_lock_enable(), which enables or disables channel
burst locking.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   69 +++++++++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    1 +
 2 files changed, 70 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 8c5b8d3..dfa6cf3 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -757,6 +757,75 @@ void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_set_double_buffer);
 
+static const struct {
+	int chnum;
+	u32 reg;
+	int shift;
+} idmac_lock_en_info[] = {
+	{ .chnum =  5, .reg = IDMAC_CH_LOCK_EN_1, .shift =  0, },
+	{ .chnum = 11, .reg = IDMAC_CH_LOCK_EN_1, .shift =  2, },
+	{ .chnum = 12, .reg = IDMAC_CH_LOCK_EN_1, .shift =  4, },
+	{ .chnum = 14, .reg = IDMAC_CH_LOCK_EN_1, .shift =  6, },
+	{ .chnum = 15, .reg = IDMAC_CH_LOCK_EN_1, .shift =  8, },
+	{ .chnum = 20, .reg = IDMAC_CH_LOCK_EN_1, .shift = 10, },
+	{ .chnum = 21, .reg = IDMAC_CH_LOCK_EN_1, .shift = 12, },
+	{ .chnum = 22, .reg = IDMAC_CH_LOCK_EN_1, .shift = 14, },
+	{ .chnum = 23, .reg = IDMAC_CH_LOCK_EN_1, .shift = 16, },
+	{ .chnum = 27, .reg = IDMAC_CH_LOCK_EN_1, .shift = 18, },
+	{ .chnum = 28, .reg = IDMAC_CH_LOCK_EN_1, .shift = 20, },
+	{ .chnum = 45, .reg = IDMAC_CH_LOCK_EN_2, .shift =  0, },
+	{ .chnum = 46, .reg = IDMAC_CH_LOCK_EN_2, .shift =  2, },
+	{ .chnum = 47, .reg = IDMAC_CH_LOCK_EN_2, .shift =  4, },
+	{ .chnum = 48, .reg = IDMAC_CH_LOCK_EN_2, .shift =  6, },
+	{ .chnum = 49, .reg = IDMAC_CH_LOCK_EN_2, .shift =  8, },
+	{ .chnum = 50, .reg = IDMAC_CH_LOCK_EN_2, .shift = 10, },
+};
+
+int ipu_idmac_lock_enable(struct ipuv3_channel *channel, int num_bursts)
+{
+	struct ipu_soc *ipu = channel->ipu;
+	unsigned long flags;
+	u32 bursts, regval;
+	int i;
+
+	switch (num_bursts) {
+	case 0:
+	case 1:
+		bursts = 0x00; /* locking disabled */
+		break;
+	case 2:
+		bursts = 0x01;
+		break;
+	case 4:
+		bursts = 0x02;
+		break;
+	case 8:
+		bursts = 0x03;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(idmac_lock_en_info); i++) {
+		if (channel->num == idmac_lock_en_info[i].chnum)
+			break;
+	}
+	if (i >= ARRAY_SIZE(idmac_lock_en_info))
+		return -EINVAL;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	regval = ipu_idmac_read(ipu, idmac_lock_en_info[i].reg);
+	regval &= ~(0x03 << idmac_lock_en_info[i].shift);
+	regval |= (bursts << idmac_lock_en_info[i].shift);
+	ipu_idmac_write(ipu, regval, idmac_lock_en_info[i].reg);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_lock_enable);
+
 int ipu_module_enable(struct ipu_soc *ipu, u32 mask)
 {
 	unsigned long lock_flags;
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index d1def4d..949beec 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -203,6 +203,7 @@ void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num);
 bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num);
 int ipu_idmac_current_buffer(struct ipuv3_channel *channel);
 void ipu_idmac_enable_watermark(struct ipuv3_channel *channel, bool enable);
+int ipu_idmac_lock_enable(struct ipuv3_channel *channel, int num_bursts);
 
 /*
  * IPU Display Controller (dc) functions
-- 
1.7.9.5


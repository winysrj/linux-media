Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48440 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757563AbaFZBHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:30 -0400
Received: by mail-pa0-f53.google.com with SMTP id ey11so2423691pad.12
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:29 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 18/28] gpu: ipu-v3: Add ipu_idmac_lock_enable()
Date: Wed, 25 Jun 2014 18:05:45 -0700
Message-Id: <1403744755-24944-19-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_idmac_lock_enable(), which enables or disables channel
burst locking.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   69 +++++++++++++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |    1 +
 2 files changed, 70 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 7be56b6..b808ee0 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -755,6 +755,75 @@ void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
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
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index df9863a..bcd5141 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -197,6 +197,7 @@ void ipu_idmac_put(struct ipuv3_channel *);
 int ipu_idmac_enable_channel(struct ipuv3_channel *channel);
 int ipu_idmac_disable_channel(struct ipuv3_channel *channel);
 void ipu_idmac_enable_watermark(struct ipuv3_channel *channel, bool enable);
+int ipu_idmac_lock_enable(struct ipuv3_channel *channel, int num_bursts);
 int ipu_idmac_wait_busy(struct ipuv3_channel *channel, int ms);
 
 void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
-- 
1.7.9.5


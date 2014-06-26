Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56872 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaFZBH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 21:07:27 -0400
Received: by mail-pd0-f180.google.com with SMTP id fp1so2327980pdb.39
        for <linux-media@vger.kernel.org>; Wed, 25 Jun 2014 18:07:27 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 15/28] gpu: ipu-v3: Add __ipu_idmac_reset_current_buffer()
Date: Wed, 25 Jun 2014 18:05:42 -0700
Message-Id: <1403744755-24944-16-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds __ipu_idmac_reset_current_buffer() that resets a channel's
internal current buffer pointer so that transfers start from buffer
0 on the next channel enable.

This operation is required for channel linking to work correctly,
for instance video capture pipelines that carry out image rotations
will fail after the first streaming unless this function is called
for each channel before re-enabling the channels.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 63f2cf2..7701974 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -684,6 +684,25 @@ EXPORT_SYMBOL_GPL(ipu_idmac_put);
 
 #define idma_mask(ch)			(1 << ((ch) & 0x1f))
 
+/*
+ * This is an undocumented feature, a write one to a channel bit in
+ * IPU_CHA_CUR_BUF and IPU_CHA_TRIPLE_CUR_BUF will reset the channel's
+ * internal current buffer pointer so that transfers start from buffer
+ * 0 on the next channel enable (that's the theory anyway, the imx6 TRM
+ * only says these are read-only registers). This operation is required
+ * for channel linking to work correctly, for instance video capture
+ * pipelines that carry out image rotations will fail after the first
+ * streaming unless this function is called for each channel before
+ * re-enabling the channels.
+ */
+static void __ipu_idmac_reset_current_buffer(struct ipuv3_channel *channel)
+{
+	struct ipu_soc *ipu = channel->ipu;
+	unsigned int chno = channel->num;
+
+	ipu_cm_write(ipu, idma_mask(chno), IPU_CHA_CUR_BUF(chno));
+}
+
 void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 		bool doublebuffer)
 {
@@ -700,6 +719,8 @@ void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 		reg &= ~idma_mask(channel->num);
 	ipu_cm_write(ipu, reg, IPU_CHA_DB_MODE_SEL(channel->num));
 
+	__ipu_idmac_reset_current_buffer(channel);
+
 	spin_unlock_irqrestore(&ipu->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_set_double_buffer);
@@ -905,6 +926,8 @@ int ipu_idmac_disable_channel(struct ipuv3_channel *channel)
 	val &= ~idma_mask(channel->num);
 	ipu_idmac_write(ipu, val, IDMAC_CHA_EN(channel->num));
 
+	__ipu_idmac_reset_current_buffer(channel);
+
 	/* Set channel buffers NOT to be ready */
 	ipu_cm_write(ipu, 0xf0000000, IPU_GPR); /* write one to clear */
 
-- 
1.7.9.5


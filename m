Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:33594 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaFGV5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:17 -0400
Received: by mail-pb0-f51.google.com with SMTP id ma3so3917151pbc.38
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:16 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 16/43] imx-drm: ipu-v3: Add __ipu_idmac_reset_current_buffer()
Date: Sat,  7 Jun 2014 14:56:18 -0700
Message-Id: <1402178205-22697-17-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
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
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 4839893..07b025f 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -686,6 +686,25 @@ EXPORT_SYMBOL_GPL(ipu_idmac_put);
 #define tri_cur_buf_mask(ch)		(idma_mask((ch) * 2) * 3)
 #define tri_cur_buf_shift(ch)		(ffs(idma_mask((ch) * 2)) - 1)
 
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
@@ -702,6 +721,8 @@ void ipu_idmac_set_double_buffer(struct ipuv3_channel *channel,
 		reg &= ~idma_mask(channel->num);
 	ipu_cm_write(ipu, reg, IPU_CHA_DB_MODE_SEL(channel->num));
 
+	__ipu_idmac_reset_current_buffer(channel);
+
 	spin_unlock_irqrestore(&ipu->lock, flags);
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_set_double_buffer);
@@ -901,6 +922,8 @@ int ipu_idmac_disable_channel(struct ipuv3_channel *channel)
 	val &= ~idma_mask(channel->num);
 	ipu_idmac_write(ipu, val, IDMAC_CHA_EN(channel->num));
 
+	__ipu_idmac_reset_current_buffer(channel);
+
 	/* Set channel buffers NOT to be ready */
 	ipu_cm_write(ipu, 0xf0000000, IPU_GPR); /* write one to clear */
 
-- 
1.7.9.5


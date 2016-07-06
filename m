Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35305 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbcGFXH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 19:07:27 -0400
Received: by mail-pf0-f195.google.com with SMTP id t190so96366pfb.2
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2016 16:07:27 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 05/28] gpu: ipu-v3: Add IDMA channel linking support
Date: Wed,  6 Jul 2016 16:06:35 -0700
Message-Id: <1467846418-12913-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds functions to link and unlink IDMAC source channels to sink
channels.

So far the following links are supported:

IPUV3_CHANNEL_IC_PRP_ENC_MEM -> IPUV3_CHANNEL_MEM_ROT_ENC
PUV3_CHANNEL_IC_PRP_VF_MEM   -> IPUV3_CHANNEL_MEM_ROT_VF
IPUV3_CHANNEL_IC_PP_MEM      -> IPUV3_CHANNEL_MEM_ROT_PP

More links can be added to the idmac_link_info[] array.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-common.c | 112 ++++++++++++++++++++++++++++++++++++++++
 include/video/imx-ipu-v3.h      |   3 ++
 2 files changed, 115 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index 49af121..6d1676e 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -730,6 +730,118 @@ void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi)
 }
 EXPORT_SYMBOL_GPL(ipu_set_ic_src_mux);
 
+
+/* IDMAC Channel Linking */
+
+struct idmac_link_reg_info {
+	int chno;
+	u32 reg;
+	int shift;
+	int bits;
+	u32 sel;
+};
+
+struct idmac_link_info {
+	struct idmac_link_reg_info src;
+	struct idmac_link_reg_info sink;
+};
+
+static const struct idmac_link_info idmac_link_info[] = {
+	{
+		.src  = { 20, IPU_FS_PROC_FLOW1,  0, 4, 7 },
+		.sink = { 45, IPU_FS_PROC_FLOW2,  0, 4, 1 },
+	}, {
+		.src =  { 21, IPU_FS_PROC_FLOW1,  8, 4, 8 },
+		.sink = { 46, IPU_FS_PROC_FLOW2,  4, 4, 1 },
+	}, {
+		.src =  { 22, IPU_FS_PROC_FLOW1, 16, 4, 5 },
+		.sink = { 47, IPU_FS_PROC_FLOW2, 12, 4, 3 },
+	},
+};
+
+static const struct idmac_link_info *find_idmac_link_info(
+	struct ipuv3_channel *src, struct ipuv3_channel *sink)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(idmac_link_info); i++) {
+		if (src->num == idmac_link_info[i].src.chno &&
+		    sink->num == idmac_link_info[i].sink.chno)
+			return &idmac_link_info[i];
+	}
+
+	return NULL;
+}
+
+/*
+ * Links an IDMAC source channel to a sink channel.
+ */
+int ipu_idmac_link(struct ipuv3_channel *src, struct ipuv3_channel *sink)
+{
+	struct ipu_soc *ipu = src->ipu;
+	const struct idmac_link_info *link;
+	u32 src_reg, sink_reg, src_mask, sink_mask;
+	unsigned long flags;
+
+	link = find_idmac_link_info(src, sink);
+	if (!link)
+		return -EINVAL;
+
+	src_mask = ((1 << link->src.bits) - 1) << link->src.shift;
+	sink_mask = ((1 << link->sink.bits) - 1) << link->sink.shift;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	src_reg = ipu_cm_read(ipu, link->src.reg);
+	sink_reg = ipu_cm_read(ipu, link->sink.reg);
+
+	src_reg &= ~src_mask;
+	src_reg |= (link->src.sel << link->src.shift);
+
+	sink_reg &= ~sink_mask;
+	sink_reg |= (link->sink.sel << link->sink.shift);
+
+	ipu_cm_write(ipu, src_reg, link->src.reg);
+	ipu_cm_write(ipu, sink_reg, link->sink.reg);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_link);
+
+/*
+ * Unlinks IDMAC source and sink channels.
+ */
+int ipu_idmac_unlink(struct ipuv3_channel *src, struct ipuv3_channel *sink)
+{
+	struct ipu_soc *ipu = src->ipu;
+	const struct idmac_link_info *link;
+	u32 src_reg, sink_reg, src_mask, sink_mask;
+	unsigned long flags;
+
+	link = find_idmac_link_info(src, sink);
+	if (!link)
+		return -EINVAL;
+
+	src_mask = ((1 << link->src.bits) - 1) << link->src.shift;
+	sink_mask = ((1 << link->sink.bits) - 1) << link->sink.shift;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	src_reg = ipu_cm_read(ipu, link->src.reg);
+	sink_reg = ipu_cm_read(ipu, link->sink.reg);
+
+	src_reg &= ~src_mask;
+	sink_reg &= ~sink_mask;
+
+	ipu_cm_write(ipu, src_reg, link->src.reg);
+	ipu_cm_write(ipu, sink_reg, link->sink.reg);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_idmac_unlink);
+
 struct ipu_devtype {
 	const char *name;
 	unsigned long cm_ofs;
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index b174f8a..0a39c64 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -128,6 +128,7 @@ enum ipu_channel_irq {
 #define IPUV3_CHANNEL_ROT_VF_MEM		49
 #define IPUV3_CHANNEL_ROT_PP_MEM		50
 #define IPUV3_CHANNEL_MEM_BG_SYNC_ALPHA		51
+#define IPUV3_NUM_CHANNELS			64
 
 int ipu_map_irq(struct ipu_soc *ipu, int irq);
 int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
@@ -171,6 +172,8 @@ int ipu_idmac_get_current_buffer(struct ipuv3_channel *channel);
 bool ipu_idmac_buffer_is_ready(struct ipuv3_channel *channel, u32 buf_num);
 void ipu_idmac_select_buffer(struct ipuv3_channel *channel, u32 buf_num);
 void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num);
+int ipu_idmac_link(struct ipuv3_channel *src, struct ipuv3_channel *sink);
+int ipu_idmac_unlink(struct ipuv3_channel *src, struct ipuv3_channel *sink);
 
 /*
  * IPU Channel Parameter Memory (cpmem) functions
-- 
1.9.1


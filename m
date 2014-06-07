Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:42314 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaFGV5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:21 -0400
Received: by mail-pd0-f172.google.com with SMTP id fp1so3830138pdb.17
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:20 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 20/43] imx-drm: ipu-v3: Add idmac channel linking support
Date: Sat,  7 Jun 2014 14:56:22 -0700
Message-Id: <1402178205-22697-21-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add idmac channel linking/unlinking functions for specific IPU
client use cases. The following linkings are currently needed:

- ipu_link_prp_enc_rot_enc():

Link IPUV3_CHANNEL_IC_PRP_ENC_MEM to IPUV3_CHANNEL_MEM_ROT_ENC.

- ipu_link_prpvf_rot_prpvf():

Links IPUV3_CHANNEL_IC_PRP_VF_MEM to IPUV3_CHANNEL_MEM_ROT_VF.

- ipu_link_pp_rot_pp():

Links IPUV3_CHANNEL_IC_PP_MEM to IPUV3_CHANNEL_MEM_ROT_PP.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-common.c |  159 +++++++++++++++++++++++++++
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |   58 ++++++++++
 include/linux/platform_data/imx-ipu-v3.h    |    7 ++
 3 files changed, 224 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index dfa6cf3..de66d02 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -973,6 +973,165 @@ void ipu_idmac_clear_buffer(struct ipuv3_channel *channel, u32 buf_num)
 }
 EXPORT_SYMBOL_GPL(ipu_idmac_clear_buffer);
 
+/*
+ * Links IPUV3_CHANNEL_IC_PRP_ENC_MEM to IPUV3_CHANNEL_MEM_ROT_ENC
+ */
+int ipu_link_prp_enc_rot_enc(struct ipu_soc *ipu)
+{
+	unsigned long flags;
+	u32 fs_proc_flow1;
+	u32 fs_proc_flow2;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	fs_proc_flow1 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	fs_proc_flow2 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW2);
+
+	fs_proc_flow1 &= ~FS_PRPENC_ROT_SRC_SEL_MASK;
+	fs_proc_flow1 |= (0x07 << FS_PRPENC_ROT_SRC_SEL_OFFSET);
+
+	fs_proc_flow2 &= ~FS_PRPENC_DEST_SEL_MASK;
+	fs_proc_flow2 |= (0x01 << FS_PRPENC_DEST_SEL_OFFSET);
+
+	ipu_cm_write(ipu, fs_proc_flow1, IPU_FS_PROC_FLOW1);
+	ipu_cm_write(ipu, fs_proc_flow2, IPU_FS_PROC_FLOW2);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_link_prp_enc_rot_enc);
+
+/*
+ * Unlinks IPUV3_CHANNEL_IC_PRP_ENC_MEM from IPUV3_CHANNEL_MEM_ROT_ENC
+ */
+int ipu_unlink_prp_enc_rot_enc(struct ipu_soc *ipu)
+{
+	unsigned long flags;
+	u32 fs_proc_flow1;
+	u32 fs_proc_flow2;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	fs_proc_flow1 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	fs_proc_flow2 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW2);
+
+	fs_proc_flow1 &= ~FS_PRPENC_ROT_SRC_SEL_MASK;
+	fs_proc_flow2 &= ~FS_PRPENC_DEST_SEL_MASK;
+
+	ipu_cm_write(ipu, fs_proc_flow1, IPU_FS_PROC_FLOW1);
+	ipu_cm_write(ipu, fs_proc_flow2, IPU_FS_PROC_FLOW2);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_unlink_prp_enc_rot_enc);
+
+/*
+ * Links IPUV3_CHANNEL_IC_PRP_VF_MEM to IPUV3_CHANNEL_MEM_ROT_VF
+ */
+int ipu_link_prpvf_rot_prpvf(struct ipu_soc *ipu)
+{
+	unsigned long flags;
+	u32 fs_proc_flow1;
+	u32 fs_proc_flow2;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	fs_proc_flow1 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	fs_proc_flow2 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW2);
+
+	fs_proc_flow1 &= ~FS_PRPVF_ROT_SRC_SEL_MASK;
+	fs_proc_flow1 |= (0x08 << FS_PRPVF_ROT_SRC_SEL_OFFSET);
+
+	fs_proc_flow2 &= ~FS_PRPVF_DEST_SEL_MASK;
+	fs_proc_flow2 |= (0x01 << FS_PRPVF_DEST_SEL_OFFSET);
+
+	ipu_cm_write(ipu, fs_proc_flow1, IPU_FS_PROC_FLOW1);
+	ipu_cm_write(ipu, fs_proc_flow2, IPU_FS_PROC_FLOW2);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_link_prpvf_rot_prpvf);
+
+/*
+ * Unlinks IPUV3_CHANNEL_IC_PRP_VF_MEM from IPUV3_CHANNEL_MEM_ROT_VF
+ */
+int ipu_unlink_prpvf_rot_prpvf(struct ipu_soc *ipu)
+{
+	unsigned long flags;
+	u32 fs_proc_flow1;
+	u32 fs_proc_flow2;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	fs_proc_flow1 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	fs_proc_flow2 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW2);
+
+	fs_proc_flow1 &= ~FS_PRPVF_ROT_SRC_SEL_MASK;
+	fs_proc_flow2 &= ~FS_PRPVF_DEST_SEL_MASK;
+
+	ipu_cm_write(ipu, fs_proc_flow1, IPU_FS_PROC_FLOW1);
+	ipu_cm_write(ipu, fs_proc_flow2, IPU_FS_PROC_FLOW2);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_unlink_prpvf_rot_prpvf);
+
+/*
+ * Links IPUV3_CHANNEL_IC_PP_MEM to IPUV3_CHANNEL_MEM_ROT_PP
+ */
+int ipu_link_pp_rot_pp(struct ipu_soc *ipu)
+{
+	unsigned long flags;
+	u32 fs_proc_flow1;
+	u32 fs_proc_flow2;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	fs_proc_flow1 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	fs_proc_flow2 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW2);
+
+	fs_proc_flow1 &= ~FS_PP_ROT_SRC_SEL_MASK;
+	fs_proc_flow1 |= (0x05 << FS_PP_ROT_SRC_SEL_OFFSET);
+
+	fs_proc_flow2 &= ~FS_PP_DEST_SEL_MASK;
+	fs_proc_flow2 |= (0x03 << FS_PP_DEST_SEL_OFFSET);
+
+	ipu_cm_write(ipu, fs_proc_flow1, IPU_FS_PROC_FLOW1);
+	ipu_cm_write(ipu, fs_proc_flow2, IPU_FS_PROC_FLOW2);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_link_pp_rot_pp);
+
+/*
+ * Unlinks IPUV3_CHANNEL_IC_PP_MEM from IPUV3_CHANNEL_MEM_ROT_PP
+ */
+int ipu_unlink_pp_rot_pp(struct ipu_soc *ipu)
+{
+	unsigned long flags;
+	u32 fs_proc_flow1;
+	u32 fs_proc_flow2;
+
+	spin_lock_irqsave(&ipu->lock, flags);
+
+	fs_proc_flow1 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW1);
+	fs_proc_flow2 = ipu_cm_read(ipu, IPU_FS_PROC_FLOW2);
+
+	fs_proc_flow1 &= ~FS_PP_ROT_SRC_SEL_MASK;
+	fs_proc_flow2 &= ~FS_PP_DEST_SEL_MASK;
+
+	ipu_cm_write(ipu, fs_proc_flow1, IPU_FS_PROC_FLOW1);
+	ipu_cm_write(ipu, fs_proc_flow2, IPU_FS_PROC_FLOW2);
+
+	spin_unlock_irqrestore(&ipu->lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_unlink_pp_rot_pp);
+
 int ipu_idmac_enable_channel(struct ipuv3_channel *channel)
 {
 	struct ipu_soc *ipu = channel->ipu;
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
index 446ed20..d10e624 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-prv.h
@@ -83,6 +83,64 @@ struct ipu_soc;
 #define IPU_DI0_COUNTER_RELEASE			(1 << 24)
 #define IPU_DI1_COUNTER_RELEASE			(1 << 25)
 
+#define FS_PRPENC_ROT_SRC_SEL_MASK     (0xf << 0)
+#define FS_PRPENC_ROT_SRC_SEL_OFFSET   0
+#define FS_PRPVF_ROT_SRC_SEL_MASK      (0xf << 8)
+#define FS_PRPVF_ROT_SRC_SEL_OFFSET    8
+#define FS_PP_ROT_SRC_SEL_MASK         (0xf << 16)
+#define FS_PP_ROT_SRC_SEL_OFFSET       16
+#define FS_PP_SRC_SEL_MASK             (0xf << 12)
+#define FS_PP_SRC_SEL_OFFSET           12
+#define FS_PP_SRC_SEL_VDOA             (1 << 15)
+#define FS_PRP_SRC_SEL_MASK            (0xf << 24)
+#define FS_PRP_SRC_SEL_OFFSET          24
+#define FS_VF_IN_VALID                 (1 << 31)
+#define FS_ENC_IN_VALID                (1 << 30)
+#define FS_VDI_SRC_SEL_MASK            (0x3 << 28)
+#define FS_VDI_SRC_SEL_VDOA            (0x2 << 28)
+#define FS_VDOA_DEST_SEL_MASK          (0x3 << 16)
+#define FS_VDOA_DEST_SEL_VDI           (0x2 << 16)
+#define FS_VDOA_DEST_SEL_IC            (0x1 << 16)
+#define FS_VDI_SRC_SEL_OFFSET          28
+
+#define FS_PRPENC_DEST_SEL_MASK        (0xf << 0)
+#define FS_PRPENC_DEST_SEL_OFFSET      0
+#define FS_PRPVF_DEST_SEL_MASK         (0xf << 4)
+#define FS_PRPVF_DEST_SEL_OFFSET       4
+#define FS_PRPVF_ROT_DEST_SEL_MASK     (0xf << 8)
+#define FS_PRPVF_ROT_DEST_SEL_OFFSET   8
+#define FS_PP_DEST_SEL_MASK            (0xf << 12)
+#define FS_PP_DEST_SEL_OFFSET          12
+#define FS_PP_ROT_DEST_SEL_MASK        (0xf << 16)
+#define FS_PP_ROT_DEST_SEL_OFFSET      16
+#define FS_PRPENC_ROT_DEST_SEL_MASK    (0xf << 20)
+#define FS_PRPENC_ROT_DEST_SEL_OFFSET  20
+
+#define FS_SMFC0_DEST_SEL_MASK         (0xf << 0)
+#define FS_SMFC0_DEST_SEL_OFFSET       0
+#define FS_SMFC1_DEST_SEL_MASK         (0x7 << 4)
+#define FS_SMFC1_DEST_SEL_OFFSET       4
+#define FS_SMFC2_DEST_SEL_MASK         (0xf << 7)
+#define FS_SMFC2_DEST_SEL_OFFSET       7
+#define FS_SMFC3_DEST_SEL_MASK         (0x7 << 11)
+#define FS_SMFC3_DEST_SEL_OFFSET       11
+
+#define FS_DC1_SRC_SEL_MASK            (0xf << 20)
+#define FS_DC1_SRC_SEL_OFFSET          20
+#define FS_DC2_SRC_SEL_MASK            (0xf << 16)
+#define FS_DC2_SRC_SEL_OFFSET          16
+#define FS_DP_SYNC0_SRC_SEL_MASK       (0xf << 0)
+#define FS_DP_SYNC0_SRC_SEL_OFFSET     0
+#define FS_DP_SYNC1_SRC_SEL_MASK       (0xf << 4)
+#define FS_DP_SYNC1_SRC_SEL_OFFSET     4
+#define FS_DP_ASYNC0_SRC_SEL_MASK      (0xf << 8)
+#define FS_DP_ASYNC0_SRC_SEL_OFFSET    8
+#define FS_DP_ASYNC1_SRC_SEL_MASK      (0xf << 12)
+#define FS_DP_ASYNC1_SRC_SEL_OFFSET    12
+
+#define FS_AUTO_REF_PER_MASK           0
+#define FS_AUTO_REF_PER_OFFSET         16
+
 #define IPU_IDMAC_REG(offset)	(offset)
 
 #define IDMAC_CONF			IPU_IDMAC_REG(0x0000)
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 949beec..75a6a5d 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -205,6 +205,13 @@ int ipu_idmac_current_buffer(struct ipuv3_channel *channel);
 void ipu_idmac_enable_watermark(struct ipuv3_channel *channel, bool enable);
 int ipu_idmac_lock_enable(struct ipuv3_channel *channel, int num_bursts);
 
+int ipu_link_prp_enc_rot_enc(struct ipu_soc *ipu);
+int ipu_unlink_prp_enc_rot_enc(struct ipu_soc *ipu);
+int ipu_link_prpvf_rot_prpvf(struct ipu_soc *ipu);
+int ipu_unlink_prpvf_rot_prpvf(struct ipu_soc *ipu);
+int ipu_link_pp_rot_pp(struct ipu_soc *ipu);
+int ipu_unlink_pp_rot_pp(struct ipu_soc *ipu);
+
 /*
  * IPU Display Controller (dc) functions
  */
-- 
1.7.9.5


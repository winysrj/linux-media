Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaFGV53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:29 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so3909479pbb.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:29 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 28/43] imx-drm: ipu-cpmem: Add ipu_cpmem_dump()
Date: Sat,  7 Jun 2014 14:56:30 -0700
Message-Id: <1402178205-22697-29-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds ipu_cpmem_dump() which dumps a channel's cpmem to debug.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c |   63 ++++++++++++++++++++++++++++
 include/linux/platform_data/imx-ipu-v3.h   |    1 +
 2 files changed, 64 insertions(+)

diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
index 1ee5e11..b1d7f60 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-cpmem.c
@@ -724,6 +724,69 @@ int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image)
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_image);
 
+void ipu_cpmem_dump(struct ipuv3_channel *ch)
+{
+	struct ipu_ch_param __iomem *p = ipu_get_cpmem(ch);
+	struct ipu_soc *ipu = ch->ipu;
+	int chno = ch->num;
+
+	dev_dbg(ipu->dev, "ch %d word 0 - %08X %08X %08X %08X %08X\n", chno,
+		readl(&p->word[0].data[0]),
+		readl(&p->word[0].data[1]),
+		readl(&p->word[0].data[2]),
+		readl(&p->word[0].data[3]),
+		readl(&p->word[0].data[4]));
+	dev_dbg(ipu->dev, "ch %d word 1 - %08X %08X %08X %08X %08X\n", chno,
+		readl(&p->word[1].data[0]),
+		readl(&p->word[1].data[1]),
+		readl(&p->word[1].data[2]),
+		readl(&p->word[1].data[3]),
+		readl(&p->word[1].data[4]));
+	dev_dbg(ipu->dev, "PFS 0x%x, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_PFS));
+	dev_dbg(ipu->dev, "BPP 0x%x, ",
+		ipu_ch_param_read_field(ch, IPU_FIELD_BPP));
+	dev_dbg(ipu->dev, "NPB 0x%x\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_NPB));
+
+	dev_dbg(ipu->dev, "FW %d, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_FW));
+	dev_dbg(ipu->dev, "FH %d, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_FH));
+	dev_dbg(ipu->dev, "EBA0 0x%x\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_EBA0) << 3);
+	dev_dbg(ipu->dev, "EBA1 0x%x\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_EBA1) << 3);
+	dev_dbg(ipu->dev, "Stride %d\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_SL));
+	dev_dbg(ipu->dev, "scan_order %d\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_SO));
+	dev_dbg(ipu->dev, "uv_stride %d\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_SLUV));
+	dev_dbg(ipu->dev, "u_offset 0x%x\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_UBO) << 3);
+	dev_dbg(ipu->dev, "v_offset 0x%x\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_VBO) << 3);
+
+	dev_dbg(ipu->dev, "Width0 %d+1, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_WID0));
+	dev_dbg(ipu->dev, "Width1 %d+1, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_WID1));
+	dev_dbg(ipu->dev, "Width2 %d+1, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_WID2));
+	dev_dbg(ipu->dev, "Width3 %d+1, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_WID3));
+	dev_dbg(ipu->dev, "Offset0 %d, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_OFS0));
+	dev_dbg(ipu->dev, "Offset1 %d, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_OFS1));
+	dev_dbg(ipu->dev, "Offset2 %d, ",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_OFS2));
+	dev_dbg(ipu->dev, "Offset3 %d\n",
+		 ipu_ch_param_read_field(ch, IPU_FIELD_OFS3));
+}
+EXPORT_SYMBOL_GPL(ipu_cpmem_dump);
+
 int ipu_cpmem_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
 {
 	struct ipu_cpmem *cpmem;
diff --git a/include/linux/platform_data/imx-ipu-v3.h b/include/linux/platform_data/imx-ipu-v3.h
index 4575657..811b93b 100644
--- a/include/linux/platform_data/imx-ipu-v3.h
+++ b/include/linux/platform_data/imx-ipu-v3.h
@@ -245,6 +245,7 @@ void ipu_cpmem_set_yuv_planar(struct ipuv3_channel *ch,
 			      u32 pixel_format, int stride, int height);
 int ipu_cpmem_set_fmt(struct ipuv3_channel *ch, u32 drm_fourcc);
 int ipu_cpmem_set_image(struct ipuv3_channel *ch, struct ipu_image *image);
+void ipu_cpmem_dump(struct ipuv3_channel *ch);
 
 /* Channel linking functions */
 int ipu_link_prp_enc_rot_enc(struct ipu_soc *ipu);
-- 
1.7.9.5


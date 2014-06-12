Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33003 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaFLRGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:44 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 03/26] gpu: ipu-v3: Add function to setup CP channel as interlaced
Date: Thu, 12 Jun 2014 19:06:17 +0200
Message-Id: <1402592800-2925-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a function to enable line interlaced buffer scanout
and writing.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-common.c | 19 +++++++++++++++++++
 include/video/imx-ipu-v3.h      |  1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index a4910d8..94b9e8e 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -525,6 +525,25 @@ int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 }
 EXPORT_SYMBOL_GPL(ipu_cpmem_set_image);
 
+int ipu_ch_cpmem_set_interlaced_scan(struct ipuv3_channel *channel)
+{
+	u32 stride;
+	struct ipu_soc *ipu = channel->ipu;
+	struct ipu_ch_param __iomem *p = ipu_get_cpmem(channel);
+
+	stride = ipu_ch_param_read_field(p, IPU_FIELD_SL) + 1;
+	if (stride % 8)
+		dev_warn(ipu->dev,
+			 "IDMAC%d's ILO is not 8-byte aligned\n", channel->num);
+
+	ipu_ch_param_write_field(p, IPU_FIELD_SO, 1);
+	ipu_ch_param_write_field(p, IPU_FIELD_ILO, stride / 8);
+	ipu_ch_param_write_field(p, IPU_FIELD_SL, 2 * stride - 1);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ipu_ch_cpmem_set_interlaced_scan);
+
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat)
 {
 	switch (pixelformat) {
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 2d14425..77a82f5 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -320,6 +320,7 @@ void ipu_cpmem_set_yuv_planar_full(struct ipu_ch_param __iomem *p,
 int ipu_cpmem_set_fmt(struct ipu_ch_param __iomem *cpmem, u32 pixelformat);
 int ipu_cpmem_set_image(struct ipu_ch_param __iomem *cpmem,
 		struct ipu_image *image);
+int ipu_ch_cpmem_set_interlaced_scan(struct ipuv3_channel *channel);
 
 enum ipu_color_space ipu_drm_fourcc_to_colorspace(u32 drm_fourcc);
 enum ipu_color_space ipu_pixelformat_to_colorspace(u32 pixelformat);
-- 
2.0.0.rc2


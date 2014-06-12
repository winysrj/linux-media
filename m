Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33005 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaFLRGo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:44 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 04/26] gpu: ipu-v3: Add ipu_cpmem_get_buffer function
Date: Thu, 12 Jun 2014 19:06:18 +0200
Message-Id: <1402592800-2925-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is needed for imx-ipu-vout to extract the buffer address from a
saved CPMEM block.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/video/imx-ipu-v3.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 77a82f5..e8764dc 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -268,6 +268,15 @@ static inline void ipu_cpmem_set_buffer(struct ipu_ch_param __iomem *p,
 		ipu_ch_param_write_field(p, IPU_FIELD_EBA0, buf >> 3);
 }
 
+static inline dma_addr_t ipu_cpmem_get_buffer(struct ipu_ch_param __iomem *p,
+		int bufnum)
+{
+	if (bufnum)
+		return ipu_ch_param_read_field(p, IPU_FIELD_EBA1) << 3;
+	else
+		return ipu_ch_param_read_field(p, IPU_FIELD_EBA0) << 3;
+}
+
 static inline void ipu_cpmem_set_resolution(struct ipu_ch_param __iomem *p,
 		int xres, int yres)
 {
-- 
2.0.0.rc2


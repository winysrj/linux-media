Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43341 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbeJSUVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 02/22] gpu: ipu-cpmem: add WARN_ON_ONCE() for unaligned dma buffers
Date: Fri, 19 Oct 2018 14:15:19 +0200
Message-Id: <20181019121539.12778-3-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Steve Longerbeam <slongerbeam@gmail.com>

Add a WARN_ON_ONCE() if either the Y/packed buffer, or the U/V offsets,
are not aligned on 8-byte boundaries. This will catch alignment
bugs in DRM, V4L2.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
No changes since v3.
---
 drivers/gpu/ipu-v3/ipu-cpmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index a9d2501500a1..7e65954f13c2 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -259,6 +259,8 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_high_priority);
 
 void ipu_cpmem_set_buffer(struct ipuv3_channel *ch, int bufnum, dma_addr_t buf)
 {
+	WARN_ON_ONCE(buf & 0x7);
+
 	if (bufnum)
 		ipu_ch_param_write_field(ch, IPU_FIELD_EBA1, buf >> 3);
 	else
@@ -268,6 +270,8 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_buffer);
 
 void ipu_cpmem_set_uv_offset(struct ipuv3_channel *ch, u32 u_off, u32 v_off)
 {
+	WARN_ON_ONCE((u_off & 0x7) || (v_off & 0x7));
+
 	ipu_ch_param_write_field(ch, IPU_FIELD_UBO, u_off / 8);
 	ipu_ch_param_write_field(ch, IPU_FIELD_VBO, v_off / 8);
 }
@@ -435,6 +439,8 @@ void ipu_cpmem_set_yuv_planar_full(struct ipuv3_channel *ch,
 				   unsigned int uv_stride,
 				   unsigned int u_offset, unsigned int v_offset)
 {
+	WARN_ON_ONCE((u_offset & 0x7) || (v_offset & 0x7));
+
 	ipu_ch_param_write_field(ch, IPU_FIELD_SLUV, uv_stride - 1);
 	ipu_ch_param_write_field(ch, IPU_FIELD_UBO, u_offset / 8);
 	ipu_ch_param_write_field(ch, IPU_FIELD_VBO, v_offset / 8);
-- 
2.19.0

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:37089 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbeHAU76 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 16:59:58 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 05/14] gpu: ipu-v3: Allow negative offsets for interlaced scanning
Date: Wed,  1 Aug 2018 12:12:18 -0700
Message-Id: <1533150747-30677-6-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

The IPU also supports interlaced buffers that start with the bottom field.
To achieve this, the the base address EBA has to be increased by a stride
length and the interlace offset ILO has to be set to the negative stride.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index e68e473..8cd9e37 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -269,9 +269,20 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
 
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
 {
+	u32 ilo, sly;
+
+	if (stride < 0) {
+		stride = -stride;
+		ilo = 0x100000 - (stride / 8);
+	} else {
+		ilo = stride / 8;
+	}
+
+	sly = (stride * 2) - 1;
+
 	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
-	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
-	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);
+	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
+	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, sly);
 };
 EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);
 
-- 
2.7.4

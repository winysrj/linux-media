Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55857 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751788AbeFANNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2018 09:13:20 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced scanning
Date: Fri,  1 Jun 2018 15:13:16 +0200
Message-Id: <20180601131316.18728-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IPU also supports interlaced buffers that start with the bottom field.
To achieve this, the the base address EBA has to be increased by a stride
length and the interlace offset ILO has to be set to the negative stride.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-cpmem.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-cpmem.c b/drivers/gpu/ipu-v3/ipu-cpmem.c
index 9f2d9ec42add..c1028f38c553 100644
--- a/drivers/gpu/ipu-v3/ipu-cpmem.c
+++ b/drivers/gpu/ipu-v3/ipu-cpmem.c
@@ -269,8 +269,14 @@ EXPORT_SYMBOL_GPL(ipu_cpmem_set_uv_offset);
 
 void ipu_cpmem_interlaced_scan(struct ipuv3_channel *ch, int stride)
 {
+	u32 ilo;
+
 	ipu_ch_param_write_field(ch, IPU_FIELD_SO, 1);
-	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, stride / 8);
+	if (stride >= 0)
+		ilo = stride / 8;
+	else
+		ilo = 0x100000 - (-stride / 8);
+	ipu_ch_param_write_field(ch, IPU_FIELD_ILO, ilo);
 	ipu_ch_param_write_field(ch, IPU_FIELD_SLY, (stride * 2) - 1);
 };
 EXPORT_SYMBOL_GPL(ipu_cpmem_interlaced_scan);
-- 
2.17.1

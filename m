Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:37497 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751435AbeDGNEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 09:04:34 -0400
From: Marek Vasut <marex@denx.de>
To: linux-media@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] gpu: ipu-v3: Fix BT1120 interlaced CCIR codes
Date: Sat,  7 Apr 2018 15:04:28 +0200
Message-Id: <20180407130428.24833-1-marex@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The BT1120 interlaced CCIR codes are the same as BT656 ones
and different than BT656 progressive CCIR codes, fix this.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index caa05b0702e1..301a729581ce 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -435,12 +435,16 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
 		break;
 	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_DDR:
 	case IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR:
-	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
-	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
 		ipu_csi_write(csi, 0x40030 | CSI_CCIR_ERR_DET_EN,
 				   CSI_CCIR_CODE_1);
 		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
 		break;
+	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_DDR:
+	case IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR:
+		ipu_csi_write(csi, 0x40596 | CSI_CCIR_ERR_DET_EN, CSI_CCIR_CODE_1);
+		ipu_csi_write(csi, 0xD07DF, CSI_CCIR_CODE_2);
+		ipu_csi_write(csi, 0xFF0000, CSI_CCIR_CODE_3);
+		break;
 	case IPU_CSI_CLK_MODE_GATED_CLK:
 	case IPU_CSI_CLK_MODE_NONGATED_CLK:
 		ipu_csi_write(csi, 0, CSI_CCIR_CODE_1);
-- 
2.16.2

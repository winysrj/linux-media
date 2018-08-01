Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:35667 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbeHAU7x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 16:59:53 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS FOR FREESCALE
        IMX), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 02/14] gpu: ipu-csi: Check for field type alternate
Date: Wed,  1 Aug 2018 12:12:15 -0700
Message-Id: <1533150747-30677-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
References: <1533150747-30677-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the CSI is receiving from a bt.656 bus, include a check for
field type 'alternate' when determining whether to set CSI clock
mode to CCIR656_INTERLACED or CCIR656_PROGRESSIVE.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index caa05b0..5450a2d 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -339,7 +339,8 @@ static void fill_csi_bus_cfg(struct ipu_csi_bus_config *csicfg,
 		break;
 	case V4L2_MBUS_BT656:
 		csicfg->ext_vsync = 0;
-		if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field))
+		if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field) ||
+		    mbus_fmt->field == V4L2_FIELD_ALTERNATE)
 			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_INTERLACED;
 		else
 			csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE;
-- 
2.7.4

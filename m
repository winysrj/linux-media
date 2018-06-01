Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37631 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750844AbeFAAbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 20:31:04 -0400
Received: by mail-pl0-f66.google.com with SMTP id 31-v6so4295929plc.4
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 17:31:04 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 02/10] gpu: ipu-csi: Check for field type alternate
Date: Thu, 31 May 2018 17:30:41 -0700
Message-Id: <1527813049-3231-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527813049-3231-1-git-send-email-steve_longerbeam@mentor.com>
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

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33123 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030721AbeEYXxs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 19:53:48 -0400
Received: by mail-pf0-f194.google.com with SMTP id a20-v6so3269760pfo.0
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 16:53:48 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 2/6] gpu: ipu-csi: Check for field type alternate
Date: Fri, 25 May 2018 16:53:32 -0700
Message-Id: <1527292416-26187-3-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
References: <1527292416-26187-1-git-send-email-steve_longerbeam@mentor.com>
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

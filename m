Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49568 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933618AbeCEJfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 04:35:51 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH 6/7] media: sun6i: Invert the polarities
Date: Mon,  5 Mar 2018 10:35:33 +0100
Message-Id: <20180305093535.11801-7-maxime.ripard@bootlin.com>
In-Reply-To: <20180305093535.11801-1-maxime.ripard@bootlin.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
 <20180305093535.11801-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A good look at an oscilloscope and test with a camera have shown that the
polarity of all signals are actually reversed compared to the polarity
documented in the datasheet for the clock, HSYNC and VSYNC signals.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
index e0b39ea641aa..a93bc25ff372 100644
--- a/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
+++ b/drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c
@@ -398,12 +398,12 @@ static void sun6i_csi_setup_bus(struct sun6i_csi_dev *sdev)
 		if (flags & V4L2_MBUS_FIELD_EVEN_LOW)
 			cfg |= CSI_IF_CFG_FIELD_POSITIVE;
 
-		if (flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
+		if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
 			cfg |= CSI_IF_CFG_VREF_POL_POSITIVE;
-		if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
+		if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 			cfg |= CSI_IF_CFG_HREF_POL_POSITIVE;
 
-		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+		if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 			cfg |= CSI_IF_CFG_CLK_POL_FALLING_EDGE;
 		break;
 	case V4L2_MBUS_BT656:
-- 
2.14.3

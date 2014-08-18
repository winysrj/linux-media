Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaHRMEf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Aug 2014 08:04:35 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] au0828: fill tuner type on all boards
Date: Mon, 18 Aug 2014 06:51:29 -0500
Message-Id: <1408362689-25583-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1408362689-25583-1-git-send-email-m.chehab@samsung.com>
References: <1408362689-25583-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is used by the I2C code in order to slow down the
speed to 20 kHz on devices with xc5000 or xc5000c.

So, we need it to be filled for all devices.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-cards.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 8f2fc2fe6a89..814cc15e8c2f 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -97,20 +97,20 @@ struct au0828_board au0828_boards[] = {
 	},
 	[AU0828_BOARD_HAUPPAUGE_HVR950Q_MXL] = {
 		.name	= "Hauppauge HVR950Q rev xxF8",
-		.tuner_type = UNSET,
-		.tuner_addr = ADDR_UNSET,
+		.tuner_type = TUNER_XC5000,
+		.tuner_addr = 0x61,
 		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 	},
 	[AU0828_BOARD_DVICO_FUSIONHDTV7] = {
 		.name	= "DViCO FusionHDTV USB",
-		.tuner_type = UNSET,
-		.tuner_addr = ADDR_UNSET,
+		.tuner_type = TUNER_XC5000,
+		.tuner_addr = 0x61,
 		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 	},
 	[AU0828_BOARD_HAUPPAUGE_WOODBURY] = {
 		.name = "Hauppauge Woodbury",
-		.tuner_type = UNSET,
-		.tuner_addr = ADDR_UNSET,
+		.tuner_type = TUNER_NXP_TDA18271,
+		.tuner_addr = 0x60,
 		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
 	},
 };
-- 
1.9.3


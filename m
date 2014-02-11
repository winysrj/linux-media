Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54792 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaBKBye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 20:54:34 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N0T0093P6MX23A0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Feb 2014 10:54:33 +0900 (KST)
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, dheitmueller@kernellabs.com
Subject: [PATCH] au0828: fix i2c clock speed for DViCO FusionHDTV7
Date: Tue, 11 Feb 2014 10:54:34 +0900
Message-id: <1392083674-18940-1-git-send-email-jy0922.shim@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DViCO FusionHDTV7 device that use au0828 can fail to communicate with
xc5000 using i2c interface because of high i2c clock speed - i2c clock
stretching bug. It causes to fail xc5000 firmware loading normally at
the current driver.

Already this problem fixed as changing to low i2c clock speed at
HVR-950q device, also DViCO FusionHDTV7 device can solve it as using low
i2c clock speed - 20KHz.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/usb/au0828/au0828-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index dd32dec..6b569f4 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -108,7 +108,7 @@ struct au0828_board au0828_boards[] = {
 		.name	= "DViCO FusionHDTV USB",
 		.tuner_type = UNSET,
 		.tuner_addr = ADDR_UNSET,
-		.i2c_clk_divider = AU0828_I2C_CLK_250KHZ,
+		.i2c_clk_divider = AU0828_I2C_CLK_20KHZ,
 	},
 	[AU0828_BOARD_HAUPPAUGE_WOODBURY] = {
 		.name = "Hauppauge Woodbury",
-- 
1.8.1.2


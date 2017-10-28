Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:42452 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751269AbdJ1Nil (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 09:38:41 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH 4/5] Fix NTSC/PAL on Evromedia USB Full Hybrid Full HD
Date: Sat, 28 Oct 2017 16:38:19 +0300
Message-Id: <20171028133820.18246-4-oleg@kaa.org.ua>
In-Reply-To: <20171028133820.18246-1-oleg@kaa.org.ua>
References: <20171028133820.18246-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f327ae73c1f0..fc9f09573fec 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -847,6 +847,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.demod_addr = 0x64, /* 0xc8 >> 1 */
 		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
+		.decoder = CX231XX_AVDECODER,
 		.norm = V4L2_STD_PAL,
 		.output_mode = OUT_MODE_VIP11,
 		.tuner_addr = 0x60, /* 0xc0 >> 1 */
-- 
2.13.6

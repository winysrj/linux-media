Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:42452 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751402AbdJ1Nim (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 09:38:42 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH 5/5] Fix NTSC/PAL on Astrometa T2hybrid
Date: Sat, 28 Oct 2017 16:38:20 +0300
Message-Id: <20171028133820.18246-5-oleg@kaa.org.ua>
In-Reply-To: <20171028133820.18246-1-oleg@kaa.org.ua>
References: <20171028133820.18246-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index fc9f09573fec..4ac5c5676c28 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -872,6 +872,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.name = "Astrometa T2hybrid",
 		.tuner_type = TUNER_ABSENT,
 		.has_dvb = 1,
+		.decoder = CX231XX_AVDECODER,
 		.output_mode = OUT_MODE_VIP11,
 		.agc_analog_digital_select_gpio = 0x01,
 		.ctl_pin_status_mask = 0xffffffc4,
-- 
2.13.6

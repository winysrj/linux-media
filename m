Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41095 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751484AbeA0OFj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Jan 2018 09:05:39 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: Andi Shyti <andi.shyti@samsung.com>
Subject: [PATCH] media: rc: ir-spi: fix duty cycle
Date: Sat, 27 Jan 2018 14:05:37 +0000
Message-Id: <20180127140537.12606-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calculate the pulse rather than having a few preset values.

Cc: Andi Shyti <andi.shyti@samsung.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-spi.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
index a32a84ae2d0b..7163d5ce2e64 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -15,21 +15,11 @@
 
 #define IR_SPI_DRIVER_NAME		"ir-spi"
 
-/* pulse value for different duty cycles */
-#define IR_SPI_PULSE_DC_50		0xff00
-#define IR_SPI_PULSE_DC_60		0xfc00
-#define IR_SPI_PULSE_DC_70		0xf800
-#define IR_SPI_PULSE_DC_75		0xf000
-#define IR_SPI_PULSE_DC_80		0xc000
-#define IR_SPI_PULSE_DC_90		0x8000
-
 #define IR_SPI_DEFAULT_FREQUENCY	38000
-#define IR_SPI_BIT_PER_WORD		    8
 #define IR_SPI_MAX_BUFSIZE		 4096
 
 struct ir_spi_data {
 	u32 freq;
-	u8 duty_cycle;
 	bool negated;
 
 	u16 tx_buf[IR_SPI_MAX_BUFSIZE];
@@ -105,19 +95,9 @@ static int ir_spi_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 static int ir_spi_set_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
 {
 	struct ir_spi_data *idata = dev->priv;
+	int bits = (duty_cycle * 15) / 100;
 
-	if (duty_cycle >= 90)
-		idata->pulse = IR_SPI_PULSE_DC_90;
-	else if (duty_cycle >= 80)
-		idata->pulse = IR_SPI_PULSE_DC_80;
-	else if (duty_cycle >= 75)
-		idata->pulse = IR_SPI_PULSE_DC_75;
-	else if (duty_cycle >= 70)
-		idata->pulse = IR_SPI_PULSE_DC_70;
-	else if (duty_cycle >= 60)
-		idata->pulse = IR_SPI_PULSE_DC_60;
-	else
-		idata->pulse = IR_SPI_PULSE_DC_50;
+	idata->pulse = GENMASK(bits, 0);
 
 	if (idata->negated) {
 		idata->pulse = ~idata->pulse;
-- 
2.14.3

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:43703 "EHLO
	mail-1-out2.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3GSRqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 13:46:39 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] radio-aztech: Convert to generic lm7000 implementation
Date: Fri, 19 Jul 2013 19:46:17 +0200
Message-Id: <1374255978-1362-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aztech radio card is based on LM7001 chip which is (software) compatible with LM7000.
So remove the LM7000-specific code from the driver and use generic code.

Also found that the card does not have A0..A2 ISA pins connected, which means that the region size is 8 bytes.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/radio/radio-aztech.c |   68 +++++++++++++-----------------------
 1 files changed, 24 insertions(+), 44 deletions(-)

diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index 177bcbd..2f5671f 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include "radio-isa.h"
+#include "lm7000.h"
 
 MODULE_AUTHOR("Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the Aztech radio card.");
@@ -54,18 +55,29 @@ struct aztech {
 	int curvol;
 };
 
-static void send_0_byte(struct aztech *az)
-{
-	udelay(radio_wait_time);
-	outb_p(2 + az->curvol, az->isa.io);
-	outb_p(64 + 2 + az->curvol, az->isa.io);
-}
+/* bit definitions for register read */
+#define AZTECH_BIT_NOT_TUNED	(1 << 0)
+#define AZTECH_BIT_MONO		(1 << 1)
+/* bit definitions for register write */
+#define AZTECH_BIT_TUN_CE	(1 << 1)
+#define AZTECH_BIT_TUN_CLK	(1 << 6)
+#define AZTECH_BIT_TUN_DATA	(1 << 7)
+/* bits 0 and 2 are volume control, bits 3..5 are not connected */
 
-static void send_1_byte(struct aztech *az)
+static void aztech_set_pins(void *handle, u8 pins)
 {
-	udelay(radio_wait_time);
-	outb_p(128 + 2 + az->curvol, az->isa.io);
-	outb_p(128 + 64 + 2 + az->curvol, az->isa.io);
+	struct radio_isa_card *isa = handle;
+	struct aztech *az = container_of(isa, struct aztech, isa);
+	u8 bits = az->curvol;
+
+	if (pins & LM7000_DATA)
+		bits |= AZTECH_BIT_TUN_DATA;
+	if (pins & LM7000_CLK)
+		bits |= AZTECH_BIT_TUN_CLK;
+	if (pins & LM7000_CE)
+		bits |= AZTECH_BIT_TUN_CE;
+
+	outb_p(bits, az->isa.io);
 }
 
 static struct radio_isa_card *aztech_alloc(void)
@@ -77,39 +89,7 @@ static struct radio_isa_card *aztech_alloc(void)
 
 static int aztech_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
-	struct aztech *az = container_of(isa, struct aztech, isa);
-	int  i;
-
-	freq += 171200;			/* Add 10.7 MHz IF		*/
-	freq /= 800;			/* Convert to 50 kHz units	*/
-
-	send_0_byte(az);		/*  0: LSB of frequency       */
-
-	for (i = 0; i < 13; i++)	/*   : frequency bits (1-13)  */
-		if (freq & (1 << i))
-			send_1_byte(az);
-		else
-			send_0_byte(az);
-
-	send_0_byte(az);		/* 14: test bit - always 0    */
-	send_0_byte(az);		/* 15: test bit - always 0    */
-	send_0_byte(az);		/* 16: band data 0 - always 0 */
-	if (isa->stereo)		/* 17: stereo (1 to enable)   */
-		send_1_byte(az);
-	else
-		send_0_byte(az);
-
-	send_1_byte(az);		/* 18: band data 1 - unknown  */
-	send_0_byte(az);		/* 19: time base - always 0   */
-	send_0_byte(az);		/* 20: spacing (0 = 25 kHz)   */
-	send_1_byte(az);		/* 21: spacing (1 = 25 kHz)   */
-	send_0_byte(az);		/* 22: spacing (0 = 25 kHz)   */
-	send_1_byte(az);		/* 23: AM/FM (FM = 1, always) */
-
-	/* latch frequency */
-
-	udelay(radio_wait_time);
-	outb_p(128 + 64 + az->curvol, az->isa.io);
+	lm7000_set_freq(freq, isa, aztech_set_pins);
 
 	return 0;
 }
@@ -165,7 +145,7 @@ static struct radio_isa_driver aztech_driver = {
 	.radio_nr_params = radio_nr,
 	.io_ports = aztech_ioports,
 	.num_of_io_ports = ARRAY_SIZE(aztech_ioports),
-	.region_size = 2,
+	.region_size = 8,
 	.card = "Aztech Radio",
 	.ops = &aztech_ops,
 	.has_stereo = true,
-- 
Ondrej Zary


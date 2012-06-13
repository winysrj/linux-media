Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:56716 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754218Ab2FMV0E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:26:04 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 2/3] radio-aimslab: Use LM7000 driver
Cc: linux-media@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 13 Jun 2012 23:25:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206132325.41925.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert radio-aimslab to use generic LM7000 driver.
Tested with Reveal RA300.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -37,6 +37,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include "radio-isa.h"
+#include "lm7000.h"
 
 MODULE_AUTHOR("M. Kirkwood");
 MODULE_DESCRIPTION("A driver for the RadioTrack/RadioReveal radio card.");
@@ -72,55 +73,38 @@ static struct radio_isa_card *rtrack_alloc(void)
 	return rt ? &rt->isa : NULL;
 }
 
-/* The 128+64 on these outb's is to keep the volume stable while tuning.
- * Without them, the volume _will_ creep up with each frequency change
- * and bit 4 (+16) is to keep the signal strength meter enabled.
- */
+#define AIMS_BIT_TUN_CE		(1 << 0)
+#define AIMS_BIT_TUN_CLK	(1 << 1)
+#define AIMS_BIT_TUN_DATA	(1 << 2)
+#define AIMS_BIT_VOL_CE		(1 << 3)
+#define AIMS_BIT_TUN_STRQ	(1 << 4)
+/* bit 5 is not connected */
+#define AIMS_BIT_VOL_UP		(1 << 6)	/* active low */
+#define AIMS_BIT_VOL_DN		(1 << 7)	/* active low */
 
-static void send_0_byte(struct radio_isa_card *isa, int on)
+void rtrack_set_pins(void *handle, u8 pins)
 {
-	outb_p(128+64+16+on+1, isa->io);	/* wr-enable + data low */
-	outb_p(128+64+16+on+2+1, isa->io);	/* clock */
-	msleep(1);
-}
+	struct radio_isa_card *isa = handle;
+	struct rtrack *rt = container_of(isa, struct rtrack, isa);
+	u8 bits = AIMS_BIT_VOL_DN | AIMS_BIT_VOL_UP | AIMS_BIT_TUN_STRQ;
 
-static void send_1_byte(struct radio_isa_card *isa, int on)
-{
-	outb_p(128+64+16+on+4+1, isa->io);	/* wr-enable+data high */
-	outb_p(128+64+16+on+4+2+1, isa->io);	/* clock */
-	msleep(1);
+	if (!v4l2_ctrl_g_ctrl(rt->isa.mute))
+		bits |= AIMS_BIT_VOL_CE;
+
+	if (pins & LM7000_DATA)
+		bits |= AIMS_BIT_TUN_DATA;
+	if (pins & LM7000_CLK)
+		bits |= AIMS_BIT_TUN_CLK;
+	if (pins & LM7000_CE)
+		bits |= AIMS_BIT_TUN_CE;
+
+	outb_p(bits, rt->isa.io);
 }
 
 static int rtrack_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
-	int on = v4l2_ctrl_g_ctrl(isa->mute) ? 0 : 8;
-	int i;
-
-	freq += 171200;			/* Add 10.7 MHz IF 		*/
-	freq /= 800;			/* Convert to 50 kHz units	*/
-
-	send_0_byte(isa, on);		/*  0: LSB of frequency		*/
-
-	for (i = 0; i < 13; i++)	/*   : frequency bits (1-13)	*/
-		if (freq & (1 << i))
-			send_1_byte(isa, on);
-		else
-			send_0_byte(isa, on);
-
-	send_0_byte(isa, on);		/* 14: test bit - always 0    */
-	send_0_byte(isa, on);		/* 15: test bit - always 0    */
-
-	send_0_byte(isa, on);		/* 16: band data 0 - always 0 */
-	send_0_byte(isa, on);		/* 17: band data 1 - always 0 */
-	send_0_byte(isa, on);		/* 18: band data 2 - always 0 */
-	send_0_byte(isa, on);		/* 19: time base - always 0   */
-
-	send_0_byte(isa, on);		/* 20: spacing (0 = 25 kHz)   */
-	send_1_byte(isa, on);		/* 21: spacing (1 = 25 kHz)   */
-	send_0_byte(isa, on);		/* 22: spacing (0 = 25 kHz)   */
-	send_1_byte(isa, on);		/* 23: AM/FM (FM = 1, always) */
+	lm7000_set_freq(freq, isa, rtrack_set_pins);
 
-	outb(0xd0 + on, isa->io);	/* volume steady + sigstr */
 	return 0;
 }
 


-- 
Ondrej Zary

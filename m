Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:58011 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754339Ab2FMV0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 17:26:10 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 3/3] radio-sf16fmi: Use LM7000 driver
Cc: linux-media@vger.kernel.org
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Wed, 13 Jun 2012 23:25:44 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206132325.48390.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert radio-sf16fmi to use generic LM7000 driver.
Tested with SF16-FMI, SF16-FMP and SF16-FMD.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -27,6 +27,7 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include "lm7000.h"
 
 MODULE_AUTHOR("Petr Vandrovec, vandrove@vc.cvut.cz and M. Kirkwood");
 MODULE_DESCRIPTION("A driver for the SF16-FMI, SF16-FMP and SF16-FMD radio.");
@@ -54,31 +55,33 @@ static struct fmi fmi_card;
 static struct pnp_dev *dev;
 bool pnp_attached;
 
-/* freq is in 1/16 kHz to internal number, hw precision is 50 kHz */
-/* It is only useful to give freq in interval of 800 (=0.05Mhz),
- * other bits will be truncated, e.g 92.7400016 -> 92.7, but
- * 92.7400017 -> 92.75
- */
-#define RSF16_ENCODE(x)	((x) / 800 + 214)
 #define RSF16_MINFREQ (87 * 16000)
 #define RSF16_MAXFREQ (108 * 16000)
 
-static void outbits(int bits, unsigned int data, int io)
+#define FMI_BIT_TUN_CE		(1 << 0)
+#define FMI_BIT_TUN_CLK		(1 << 1)
+#define FMI_BIT_TUN_DATA	(1 << 2)
+#define FMI_BIT_VOL_SW		(1 << 3)
+#define FMI_BIT_TUN_STRQ	(1 << 4)
+
+void fmi_set_pins(void *handle, u8 pins)
 {
-	while (bits--) {
-		if (data & 1) {
-			outb(5, io);
-			udelay(6);
-			outb(7, io);
-			udelay(6);
-		} else {
-			outb(1, io);
-			udelay(6);
-			outb(3, io);
-			udelay(6);
-		}
-		data >>= 1;
-	}
+	struct fmi *fmi = handle;
+	u8 bits = FMI_BIT_TUN_STRQ;
+
+	if (!fmi->mute)
+		bits |= FMI_BIT_VOL_SW;
+
+	if (pins & LM7000_DATA)
+		bits |= FMI_BIT_TUN_DATA;
+	if (pins & LM7000_CLK)
+		bits |= FMI_BIT_TUN_CLK;
+	if (pins & LM7000_CE)
+		bits |= FMI_BIT_TUN_CE;
+
+	mutex_lock(&fmi->lock);
+	outb_p(bits, fmi->io);
+	mutex_unlock(&fmi->lock);
 }
 
 static inline void fmi_mute(struct fmi *fmi)
@@ -95,20 +98,6 @@ static inline void fmi_unmute(struct fmi *fmi)
 	mutex_unlock(&fmi->lock);
 }
 
-static inline int fmi_setfreq(struct fmi *fmi, unsigned long freq)
-{
-	mutex_lock(&fmi->lock);
-	fmi->curfreq = freq;
-
-	outbits(16, RSF16_ENCODE(freq), fmi->io);
-	outbits(8, 0xC0, fmi->io);
-	msleep(143);		/* was schedule_timeout(HZ/7) */
-	mutex_unlock(&fmi->lock);
-	if (!fmi->mute)
-		fmi_unmute(fmi);
-	return 0;
-}
-
 static inline int fmi_getsigstr(struct fmi *fmi)
 {
 	int val;
@@ -173,7 +162,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 		return -EINVAL;
 	/* rounding in steps of 800 to match the freq
 	   that will be used */
-	fmi_setfreq(fmi, (f->frequency / 800) * 800);
+	lm7000_set_freq((f->frequency / 800) * 800, fmi, fmi_set_pins);
 	return 0;
 }
 
 

-- 
Ondrej Zary

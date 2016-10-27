Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33096 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755392AbcJ0JO2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 05:14:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id m83so1653030wmc.0
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 02:14:27 -0700 (PDT)
Received: from arch-desktop ([2a02:908:672:a420:922b:34ff:fe11:2b9f])
        by smtp.gmail.com with ESMTPSA id n6sm7033717wjg.30.2016.10.27.01.20.30
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Oct 2016 01:20:30 -0700 (PDT)
Date: Thu, 27 Oct 2016 10:20:24 +0200
From: Marcel Hasler <mahasler@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/2] stk1160: Check whether to use AC97 codec or internal ADC.
Message-ID: <20161027082024.GA3576@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some STK1160-based devices use the chip's internal 8-bit ADC. This is configured through a strap
pin. The value of this and other pins can be read through the POSVA register. If the internal
ADC is used, there's no point trying to setup the unavailable AC97 codec.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 15 +++++++++++++++
 drivers/media/usb/stk1160/stk1160-core.c |  3 +--
 drivers/media/usb/stk1160/stk1160-reg.h  |  3 +++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index d3665ce..0199fad 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -90,8 +90,23 @@ void stk1160_ac97_dump_regs(struct stk1160 *dev)
 }
 #endif
 
+int stk1160_has_ac97(struct stk1160 *dev)
+{
+	u8 value;
+
+	stk1160_read_reg(dev, STK1160_POSVA, &value);
+
+	/* Bit 2 high means internal ADC */
+	return !(value & 0x04);
+}
+
 void stk1160_ac97_setup(struct stk1160 *dev)
 {
+	if (!stk1160_has_ac97(dev)) {
+		stk1160_dbg("Device uses internal ADC, skipping AC97 setup.");
+		return;
+	}
+
 	/* Two-step reset AC97 interface and hardware codec */
 	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x94);
 	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index f3c9b8a..c86eb61 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -20,8 +20,7 @@
  *
  * TODO:
  *
- * 1. (Try to) detect if we must register ac97 mixer
- * 2. Support stream at lower speed: lower frame rate or lower frame size.
+ * 1. Support stream at lower speed: lower frame rate or lower frame size.
  *
  */
 
diff --git a/drivers/media/usb/stk1160/stk1160-reg.h b/drivers/media/usb/stk1160/stk1160-reg.h
index 81ff3a1..a4ab586 100644
--- a/drivers/media/usb/stk1160/stk1160-reg.h
+++ b/drivers/media/usb/stk1160/stk1160-reg.h
@@ -26,6 +26,9 @@
 /* Remote Wakup Control */
 #define STK1160_RMCTL			0x00c
 
+/* Power-on Strapping Data */
+#define STK1160_POSVA			0x010
+
 /*
  * Decoder Control Register:
  * This byte controls capture start/stop
-- 
2.10.1


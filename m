Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33367 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754251AbcLOWOE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:14:04 -0500
Received: by mail-wm0-f67.google.com with SMTP id u144so940052wmu.0
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 14:13:40 -0800 (PST)
Date: Thu, 15 Dec 2016 23:13:34 +0100
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 2/3] stk1160: Check whether to use AC97 codec.
Message-ID: <20161215221334.GA14811@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215221146.GA9398@arch-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some STK1160-based devices use the chip's internal 8-bit ADC. This is configured through a strap
pin. The value of this and other pins can be read through the POSVA register. If the internal
ADC is used, or if audio is disabled altogether, there's no point trying to setup the AC97
codec.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 26 ++++++++++++++++++++++++++
 drivers/media/usb/stk1160/stk1160-core.c |  3 +--
 drivers/media/usb/stk1160/stk1160-reg.h  |  8 ++++++++
 3 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index 502fc8e..5e9b76e 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -91,8 +91,34 @@ void stk1160_ac97_dump_regs(struct stk1160 *dev)
 }
 #endif
 
+int stk1160_has_audio(struct stk1160 *dev)
+{
+	u8 value;
+
+	stk1160_read_reg(dev, STK1160_POSV_L, &value);
+	return !(value & STK1160_POSV_L_ACDOUT);
+}
+
+int stk1160_has_ac97(struct stk1160 *dev)
+{
+	u8 value;
+
+	stk1160_read_reg(dev, STK1160_POSV_L, &value);
+	return !(value & STK1160_POSV_L_ACSYNC);
+}
+
 void stk1160_ac97_setup(struct stk1160 *dev)
 {
+	if (!stk1160_has_audio(dev)) {
+		stk1160_info("Device doesn't support audio, skipping AC97 setup.");
+		return;
+	}
+
+	if (!stk1160_has_ac97(dev)) {
+		stk1160_info("Device uses internal 8-bit ADC, skipping AC97 setup.");
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
index 81ff3a1..296a9e7 100644
--- a/drivers/media/usb/stk1160/stk1160-reg.h
+++ b/drivers/media/usb/stk1160/stk1160-reg.h
@@ -26,6 +26,14 @@
 /* Remote Wakup Control */
 #define STK1160_RMCTL			0x00c
 
+/* Power-on Strapping Data */
+#define STK1160_POSVA			0x010
+#define STK1160_POSV_L			0x010
+#define STK1160_POSV_M			0x011
+#define STK1160_POSV_H			0x012
+#define  STK1160_POSV_L_ACDOUT		BIT(3)
+#define  STK1160_POSV_L_ACSYNC		BIT(2)
+
 /*
  * Decoder Control Register:
  * This byte controls capture start/stop
-- 
2.10.2


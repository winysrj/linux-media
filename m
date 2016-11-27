Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35517 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbcK0LLy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Nov 2016 06:11:54 -0500
Received: by mail-wm0-f67.google.com with SMTP id a20so14456817wme.2
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2016 03:11:53 -0800 (PST)
Date: Sun, 27 Nov 2016 12:11:48 +0100
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 3/4] stk1160: Add module param for setting the record gain.
Message-ID: <20161127111148.GA30483@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161127110732.GA5338@arch-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow setting a custom record gain for the internal AC97 codec (if available). This can be
a value between 0 and 15, 8 is the default and should be suitable for most users. The Windows
driver also sets this to 8 without any possibility for changing it.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index 95648ac..60327af 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -28,6 +28,11 @@
 #include "stk1160.h"
 #include "stk1160-reg.h"
 
+static u8 gain = 8;
+
+module_param(gain, byte, 0444);
+MODULE_PARM_DESC(gain, "Set capture gain level if AC97 codec is available (0-15, default: 8)");
+
 static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value)
 {
 	/* Set codec register address */
@@ -136,7 +141,10 @@ void stk1160_ac97_setup(struct stk1160 *dev)
 	stk1160_write_ac97(dev, 0x16, 0x0808); /* Aux volume */
 	stk1160_write_ac97(dev, 0x1a, 0x0404); /* Record select */
 	stk1160_write_ac97(dev, 0x02, 0x0000); /* Master volume */
-	stk1160_write_ac97(dev, 0x1c, 0x0808); /* Record gain */
+
+	/* Record gain */
+	gain = (gain > 15) ? 15 : gain;
+	stk1160_write_ac97(dev, 0x1c, (gain<<8) | gain);
 
 #ifdef DEBUG
 	stk1160_ac97_dump_regs(dev);
-- 
2.10.2


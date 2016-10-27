Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36151 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938699AbcJ0Uf3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 16:35:29 -0400
Received: by mail-wm0-f65.google.com with SMTP id c17so4401417wmc.3
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2016 13:35:29 -0700 (PDT)
Date: Thu, 27 Oct 2016 22:35:15 +0200
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v2 3/3] stk1160: Add module param for setting the record gain.
Message-ID: <20161027203515.GA847@arch-desktop>
References: <cover.1477592284.git.mahasler@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1477592284.git.mahasler@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow setting a custom record gain for the internal AC97 codec (if available). This can be
a value between 0 and 15, 8 is the default and should be suitable for most users. The Windows
driver also sets this to 8 without any possibility for changing it.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index 6dbc39f..31bdd60d 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -25,6 +25,11 @@
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
@@ -122,7 +127,11 @@ void stk1160_ac97_setup(struct stk1160 *dev)
 	stk1160_write_ac97(dev, 0x16, 0x0808); /* Aux volume */
 	stk1160_write_ac97(dev, 0x1a, 0x0404); /* Record select */
 	stk1160_write_ac97(dev, 0x02, 0x0000); /* Master volume */
-	stk1160_write_ac97(dev, 0x1c, 0x0808); /* Record gain */
+
+	/* Record gain */
+	gain = (gain > 15) ? 15 : gain;
+	stk1160_info("Setting capture gain to %d.", gain);
+	stk1160_write_ac97(dev, 0x1c, (gain<<8) | gain);
 
 #ifdef DEBUG
 	stk1160_ac97_dump_regs(dev);
-- 
2.10.1


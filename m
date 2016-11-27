Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34264 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753640AbcK0LMm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Nov 2016 06:12:42 -0500
Received: by mail-wj0-f195.google.com with SMTP id xy5so10599365wjc.1
        for <linux-media@vger.kernel.org>; Sun, 27 Nov 2016 03:12:41 -0800 (PST)
Date: Sun, 27 Nov 2016 12:12:36 +0100
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v3 4/4] stk1160: Give the chip some time to retrieve data
 from AC97 codec.
Message-ID: <20161127111236.GA1691@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161127110732.GA5338@arch-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The STK1160 needs some time to transfer data from the AC97 registers into its own. On some
systems reading the chip's own registers to soon will return wrong values. The "proper" way to
handle this would be to poll STK1160_AC97CTL_0 after every read or write command until the
command bit has been cleared, but this may not be worth the hassle.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index 60327af..b39f51b 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/delay.h>
 #include <linux/module.h>
 
 #include "stk1160.h"
@@ -64,6 +65,14 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
 	 */
 	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
 
+	/*
+	 * Give the chip some time to transfer the data.
+	 * The proper way would be to poll STK1160_AC97CTL_0
+	 * until the command bit has been cleared, but this
+	 * may not be worth the hassle.
+	 */
+	usleep_range(20, 40);
+
 	/* Retrieve register value */
 	stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
 	stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
-- 
2.10.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36640 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbcJ1Iwc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 04:52:32 -0400
Received: by mail-wm0-f66.google.com with SMTP id c17so6410706wmc.3
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 01:52:31 -0700 (PDT)
Date: Fri, 28 Oct 2016 10:52:24 +0200
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] stk1160: Give the chip some time to retrieve data from AC97
 codec.
Message-ID: <20161028085224.GA9826@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The STK1160 needs some time to transfer data from the AC97 registers into its own. On some
systems reading the chip's own registers to soon will return wrong values. The "proper" way to
handle this would be to poll STK1160_AC97CTL_0 after every read or write command until the
command bit has been cleared, but this may not be worth the hassle.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index 31bdd60d..caa65a8 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/delay.h>
 #include <linux/module.h>
 
 #include "stk1160.h"
@@ -61,6 +62,9 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
 	 */
 	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
 
+	/* Give the chip some time to transfer data */
+	usleep_range(20, 40);
+
 	/* Retrieve register value */
 	stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
 	stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
-- 
2.10.1


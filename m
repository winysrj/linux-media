Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:35249 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753973AbcLOWd3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 17:33:29 -0500
Received: by mail-wj0-f194.google.com with SMTP id he10so11989538wjc.2
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2016 14:32:54 -0800 (PST)
Date: Thu, 15 Dec 2016 23:14:03 +0100
From: Marcel Hasler <mahasler@gmail.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 3/3] stk1160: Wait for completion of transfers to and from
 AC97 codec.
Message-ID: <20161215221403.GA18007@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215221146.GA9398@arch-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The STK1160 needs some time to transfer data to and from the AC97 codec. The transfer completion
is indicated by command read/write bits in the chip's audio control register. The driver should
poll these bits and wait until they have been cleared by hardware before trying to retrive the
results of a read operation or setting a new write command.

Signed-off-by: Marcel Hasler <mahasler@gmail.com>
---
 drivers/media/usb/stk1160/stk1160-ac97.c | 39 +++++++++++++++++++++++++-------
 drivers/media/usb/stk1160/stk1160-reg.h  |  2 ++
 drivers/media/usb/stk1160/stk1160.h      |  2 ++
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
index 5e9b76e..439d1b7 100644
--- a/drivers/media/usb/stk1160/stk1160-ac97.c
+++ b/drivers/media/usb/stk1160/stk1160-ac97.c
@@ -23,9 +23,30 @@
  *
  */
 
+#include <linux/delay.h>
+
 #include "stk1160.h"
 #include "stk1160-reg.h"
 
+static int stk1160_ac97_wait_transfer_complete(struct stk1160 *dev)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(STK1160_AC97_TIMEOUT);
+	u8 value;
+
+	/* Wait for AC97 transfer to complete */
+	while (time_is_after_jiffies(timeout)) {
+		stk1160_read_reg(dev, STK1160_AC97CTL_0, &value);
+
+		if (!(value & (STK1160_AC97CTL_0_CR | STK1160_AC97CTL_0_CW)))
+			return 0;
+
+		usleep_range(50, 100);
+	}
+
+	stk1160_err("AC97 transfer took too long, this should never happen!");
+	return -EBUSY;
+}
+
 static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value)
 {
 	/* Set codec register address */
@@ -35,11 +56,11 @@ static void stk1160_write_ac97(struct stk1160 *dev, u16 reg, u16 value)
 	stk1160_write_reg(dev, STK1160_AC97_CMD, value & 0xff);
 	stk1160_write_reg(dev, STK1160_AC97_CMD + 1, (value & 0xff00) >> 8);
 
-	/*
-	 * Set command write bit to initiate write operation.
-	 * The bit will be cleared when transfer is done.
-	 */
+	/* Set command write bit to initiate write operation */
 	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8c);
+
+	/* Wait for command write bit to be cleared */
+	stk1160_ac97_wait_transfer_complete(dev);
 }
 
 #ifdef DEBUG
@@ -51,12 +72,14 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
 	/* Set codec register address */
 	stk1160_write_reg(dev, STK1160_AC97_ADDR, reg);
 
-	/*
-	 * Set command read bit to initiate read operation.
-	 * The bit will be cleared when transfer is done.
-	 */
+	/* Set command read bit to initiate read operation */
 	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
 
+	/* Wait for command read bit to be cleared */
+	if (stk1160_ac97_wait_transfer_complete(dev) < 0) {
+		return 0;
+	}
+
 	/* Retrieve register value */
 	stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
 	stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
diff --git a/drivers/media/usb/stk1160/stk1160-reg.h b/drivers/media/usb/stk1160/stk1160-reg.h
index 296a9e7..7b08a3c 100644
--- a/drivers/media/usb/stk1160/stk1160-reg.h
+++ b/drivers/media/usb/stk1160/stk1160-reg.h
@@ -122,6 +122,8 @@
 /* AC97 Audio Control */
 #define STK1160_AC97CTL_0		0x500
 #define STK1160_AC97CTL_1		0x504
+#define  STK1160_AC97CTL_0_CR		BIT(1)
+#define  STK1160_AC97CTL_0_CW		BIT(2)
 
 /* Use [0:6] bits of register 0x504 to set codec command address */
 #define STK1160_AC97_ADDR		0x504
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index e85e12e..acd1c81 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -50,6 +50,8 @@
 #define STK1160_MAX_INPUT 4
 #define STK1160_SVIDEO_INPUT 4
 
+#define STK1160_AC97_TIMEOUT 50
+
 #define STK1160_I2C_TIMEOUT 100
 
 /* TODO: Print helpers
-- 
2.10.2


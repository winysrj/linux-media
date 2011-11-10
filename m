Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab1KJXe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Nov 2011 18:34:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3520899iag.19
        for <linux-media@vger.kernel.org>; Thu, 10 Nov 2011 15:34:57 -0800 (PST)
From: Patrick Dickey <pdickeybeta@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Dickey <pdickeybeta@gmail.com>
Subject: [PATCH 08/25] added drx39_dummy for pctv80e support
Date: Thu, 10 Nov 2011 17:31:28 -0600
Message-Id: <1320967905-7932-9-git-send-email-pdickeybeta@gmail.com>
In-Reply-To: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
References: <1320967905-7932-1-git-send-email-pdickeybeta@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/drx39xxj_dummy.c |  135 ++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/dvb/frontends/drx39xxj_dummy.c

diff --git a/drivers/media/dvb/frontends/drx39xxj_dummy.c b/drivers/media/dvb/frontends/drx39xxj_dummy.c
new file mode 100644
index 0000000..3ed2c39
--- /dev/null
+++ b/drivers/media/dvb/frontends/drx39xxj_dummy.c
@@ -0,0 +1,135 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/types.h>
+
+#include "drx_driver.h"
+#include "bsp_types.h"
+#include "bsp_tuner.h"
+#include "drx39xxj.h"
+
+/* Dummy function to satisfy drxj.c */
+DRXStatus_t DRXBSP_TUNER_Open(pTUNERInstance_t tuner)
+{
+	return DRX_STS_OK;
+}
+
+DRXStatus_t DRXBSP_TUNER_Close(pTUNERInstance_t tuner)
+{
+	return DRX_STS_OK;
+}
+
+DRXStatus_t DRXBSP_TUNER_SetFrequency(pTUNERInstance_t tuner,
+				TUNERMode_t mode,
+				DRXFrequency_t centerFrequency)
+{
+	return DRX_STS_OK;
+}
+
+DRXStatus_t
+DRXBSP_TUNER_GetFrequency(pTUNERInstance_t tuner,
+			TUNERMode_t      mode,
+			pDRXFrequency_t  RFfrequency,
+			pDRXFrequency_t  IFfrequency)
+{
+	return DRX_STS_OK;
+}
+
+DRXStatus_t DRXBSP_HST_Sleep(u32_t n)
+{
+	msleep(n);
+	return DRX_STS_OK;
+}
+
+u32_t DRXBSP_HST_Clock(void)
+{
+	return jiffies_to_msecs(jiffies);
+}
+
+int DRXBSP_HST_Memcmp(void *s1, void *s2, u32_t n)
+{
+	return (memcmp(s1, s2, (size_t) n));
+}
+
+void* DRXBSP_HST_Memcpy(void *to, void *from, u32_t n)
+{
+	return (memcpy(to, from, (size_t) n));
+}
+
+DRXStatus_t DRXBSP_I2C_WriteRead(pI2CDeviceAddr_t wDevAddr,
+				u16_t            wCount,
+				pu8_t            wData,
+				pI2CDeviceAddr_t rDevAddr,
+				u16_t            rCount,
+				pu8_t            rData)
+{
+	struct drx39xxj_state *state;
+	struct i2c_msg msg[2];
+	unsigned int num_msgs;
+
+	if (wDevAddr == NULL) {
+		/* Read only */
+		state = rDevAddr->userData;
+		msg[0].addr = rDevAddr->i2cAddr >> 1;
+		msg[0].flags = I2C_M_RD;
+		msg[0].buf = rData;
+		msg[0].len = rCount;
+		num_msgs = 1;
+	} else if (rDevAddr == NULL) {
+		/* Write only */
+		state = wDevAddr->userData;
+		msg[0].addr = wDevAddr->i2cAddr >> 1;
+		msg[0].flags = 0;
+		msg[0].buf = wData;
+		msg[0].len = wCount;
+		num_msgs = 1;
+	} else {
+		/* Both write and read */
+		state = wDevAddr->userData;
+		msg[0].addr = wDevAddr->i2cAddr >> 1;
+		msg[0].flags = 0;
+		msg[0].buf = wData;
+		msg[0].len = wCount;
+		msg[1].addr = rDevAddr->i2cAddr >> 1;
+		msg[1].flags = I2C_M_RD;
+		msg[1].buf = rData;
+		msg[1].len = rCount;
+		num_msgs = 2;
+	}
+
+	if (state->i2c == NULL) {
+	  printk("i2c was zero, aborting\n");
+	  return 0;
+	}
+	if (i2c_transfer(state->i2c, msg, num_msgs) != num_msgs) {
+		printk(KERN_WARNING "drx3933: I2C write/read failed\n");
+		return -EREMOTEIO;
+	}
+
+	return DRX_STS_OK;
+
+#ifdef DJH_DEBUG
+
+	struct drx39xxj_state *state = wDevAddr->userData;
+
+	struct i2c_msg msg[2] = {
+		{ .addr = wDevAddr->i2cAddr,
+		  .flags = 0, .buf = wData, .len = wCount },
+		{ .addr = rDevAddr->i2cAddr,
+		  .flags = I2C_M_RD, .buf = rData, .len = rCount },
+	};
+
+	printk("drx3933 i2c operation addr=%x i2c=%p, wc=%x rc=%x\n",
+	       wDevAddr->i2cAddr, state->i2c, wCount, rCount);
+
+	if (i2c_transfer(state->i2c, msg, 2) != 2) {
+		printk(KERN_WARNING "drx3933: I2C write/read failed\n");
+		return -EREMOTEIO;
+	}
+#endif
+	return 0;
+}
-- 
1.7.5.4


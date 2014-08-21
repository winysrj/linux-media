Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3540 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaHUUTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/12] cx231xx: fix sparse warnings
Date: Thu, 21 Aug 2014 22:19:28 +0200
Message-Id: <1408652376-39525-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/cx231xx/cx231xx-avcore.c:2226:15: warning: cast to restricted __le32
drivers/media/usb/cx231xx/cx231xx-avcore.c:2447:15: warning: cast to restricted __le32
drivers/media/usb/cx231xx/cx231xx-avcore.c:2475:15: warning: cast to restricted __le32
drivers/media/usb/cx231xx/cx231xx-avcore.c:2500:15: warning: cast to restricted __le32
drivers/media/usb/cx231xx/cx231xx-avcore.c:2647:18: warning: incorrect type in assignment (different base types)
drivers/media/usb/cx231xx/cx231xx-avcore.c:2659:21: warning: cast to restricted __le32
drivers/media/usb/cx231xx/cx231xx-dvb.c:743:57: warning: Using plain integer as NULL pointer
drivers/media/usb/cx231xx/cx231xx-dvb.c:776:57: warning: Using plain integer as NULL pointer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 12 ++++++------
 drivers/media/usb/cx231xx/cx231xx-core.c   |  2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c    |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index a428c10..51872b9 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2223,7 +2223,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 	if (status < 0)
 		return status;
 
-	tmp = le32_to_cpu(*((u32 *) value));
+	tmp = le32_to_cpu(*((__le32 *) value));
 
 	switch (mode) {
 	case POLARIS_AVMODE_ENXTERNAL_AV:
@@ -2444,7 +2444,7 @@ int cx231xx_power_suspend(struct cx231xx *dev)
 	if (status > 0)
 		return status;
 
-	tmp = le32_to_cpu(*((u32 *) value));
+	tmp = le32_to_cpu(*((__le32 *) value));
 	tmp &= (~PWR_MODE_MASK);
 
 	value[0] = (u8) tmp;
@@ -2472,7 +2472,7 @@ int cx231xx_start_stream(struct cx231xx *dev, u32 ep_mask)
 	if (status < 0)
 		return status;
 
-	tmp = le32_to_cpu(*((u32 *) value));
+	tmp = le32_to_cpu(*((__le32 *) value));
 	tmp |= ep_mask;
 	value[0] = (u8) tmp;
 	value[1] = (u8) (tmp >> 8);
@@ -2497,7 +2497,7 @@ int cx231xx_stop_stream(struct cx231xx *dev, u32 ep_mask)
 	if (status < 0)
 		return status;
 
-	tmp = le32_to_cpu(*((u32 *) value));
+	tmp = le32_to_cpu(*((__le32 *) value));
 	tmp &= (~ep_mask);
 	value[0] = (u8) tmp;
 	value[1] = (u8) (tmp >> 8);
@@ -2644,7 +2644,7 @@ static int cx231xx_set_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u32 gpio_val)
 {
 	int status = 0;
 
-	gpio_val = cpu_to_le32(gpio_val);
+	gpio_val = (__force u32)cpu_to_le32(gpio_val);
 	status = cx231xx_send_gpio_cmd(dev, gpio_bit, (u8 *)&gpio_val, 4, 0, 0);
 
 	return status;
@@ -2652,7 +2652,7 @@ static int cx231xx_set_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u32 gpio_val)
 
 static int cx231xx_get_gpio_bit(struct cx231xx *dev, u32 gpio_bit, u32 *gpio_val)
 {
-	u32 tmp;
+	__le32 tmp;
 	int status = 0;
 
 	status = cx231xx_send_gpio_cmd(dev, gpio_bit, (u8 *)&tmp, 4, 0, 1);
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 513194a..180103e 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1491,7 +1491,7 @@ int cx231xx_mode_register(struct cx231xx *dev, u16 address, u32 mode)
 	if (status < 0)
 		return status;
 
-	tmp = le32_to_cpu(*((u32 *) value));
+	tmp = le32_to_cpu(*((__le32 *) value));
 	tmp |= mode;
 
 	value[0] = (u8) tmp;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 1fa7974..2adfecf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -740,7 +740,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dev->dvb->frontend->ops.i2c_gate_ctrl = 0;
+		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;
@@ -773,7 +773,7 @@ static int dvb_init(struct cx231xx *dev)
 			goto out_free;
 		}
 
-		dev->dvb->frontend->ops.i2c_gate_ctrl = 0;
+		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
 		dvb->frontend->callback = cx231xx_tuner_callback;
-- 
2.1.0.rc1


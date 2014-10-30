Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35018 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161068AbaJ3UNM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:13:12 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v4 08/14] cx231xx: remember status of i2c port_3 switch
Date: Thu, 30 Oct 2014 21:12:29 +0100
Message-Id: <1414699955-5760-9-git-send-email-zzam@gentoo.org>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is used later for is_tuner function that switches i2c behaviour for
some tuners.

V2: Add comments about possible improvements for port_3 switch function.
V3: Fix coding style.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 12 ++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h        |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 40a6987..0a5fec4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1272,6 +1272,14 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 
 	if (dev->board.dont_use_port_3)
 		is_port_3 = false;
+
+	/*
+	 * Should this code check dev->port_3_switch_enabled first
+	 * to skip unnecessary reading of the register?
+	 * If yes, the flag dev->port_3_switch_enabled must be initialized
+	 * correctly.
+	 */
+
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
 				       PWR_CTL_EN, value, 4);
 	if (status < 0)
@@ -1294,6 +1302,10 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
 					PWR_CTL_EN, value, 4);
 
+	/* remember status of the switch for usage in is_tuner */
+	if (status >= 0)
+		dev->port_3_switch_enabled = is_port_3;
+
 	return status;
 
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index f03338b..8a3c97b 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -629,6 +629,7 @@ struct cx231xx {
 	/* I2C adapters: Master 1 & 2 (External) & Master 3 (Internal only) */
 	struct cx231xx_i2c i2c_bus[3];
 	unsigned int xc_fw_load_done:1;
+	unsigned int port_3_switch_enabled:1;
 	/* locks */
 	struct mutex gpio_i2c_lock;
 	struct mutex i2c_lock;
-- 
2.1.2


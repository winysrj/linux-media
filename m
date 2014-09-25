Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43846 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaIYFI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 01:08:26 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 07/12] cx231xx: remember status of port_3 switch
Date: Thu, 25 Sep 2014 07:07:59 +0200
Message-Id: <1411621684-8295-7-git-send-email-zzam@gentoo.org>
In-Reply-To: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
References: <1411621684-8295-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is remembering stable enough, or must this state be queried from the register when needed.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 3 +++
 drivers/media/usb/cx231xx/cx231xx.h        | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 51872b9..d31ea57 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1294,6 +1294,9 @@ int cx231xx_enable_i2c_port_3(struct cx231xx *dev, bool is_port_3)
 	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
 					PWR_CTL_EN, value, 4);
 
+	if (status >= 0)
+		dev->port_3_switch_enabled = is_port_3;
+
 	return status;
 
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 2118d00..cefeb30 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -628,6 +628,7 @@ struct cx231xx {
 	/* I2C adapters: Master 1 & 2 (External) & Master 3 (Internal only) */
 	struct cx231xx_i2c i2c_bus[3];
 	unsigned int xc_fw_load_done:1;
+	unsigned int port_3_switch_enabled:1;
 	/* locks */
 	struct mutex gpio_i2c_lock;
 	struct mutex i2c_lock;
-- 
2.1.1


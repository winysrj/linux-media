Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34770 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaJAFUo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 01:20:44 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH V2 08/13] cx231xx: remember status of i2c port_3 switch
Date: Wed,  1 Oct 2014 07:20:16 +0200
Message-Id: <1412140821-16285-9-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If remembering is not stable enough, this must be changed to query from the register when needed.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 3 +++
 drivers/media/usb/cx231xx/cx231xx.h        | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 40a6987..4c85b6f 100644
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
2.1.1


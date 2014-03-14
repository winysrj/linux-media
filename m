Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41317 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163AbaCNAOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:48 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/17] rtl28xxu: depends on I2C_MUX
Date: Fri, 14 Mar 2014 02:14:25 +0200
Message-Id: <1394756071-22410-12-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need depend on I2C_MUX as rtl2832 demod used requires it.

All error/warnings:
warning: (DVB_USB_RTL28XXU) selects DVB_RTL2832 which has unmet direct dependencies (MEDIA_SUPPORT && DVB_CORE && I2C && I2C_MUX)
ERROR: "i2c_add_mux_adapter" [drivers/media/dvb-frontends/rtl2832.ko] undefined!
ERROR: "i2c_del_mux_adapter" [drivers/media/dvb-frontends/rtl2832.ko] undefined!

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index bfb7378..037e519 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -126,7 +126,7 @@ config DVB_USB_MXL111SF
 
 config DVB_USB_RTL28XXU
 	tristate "Realtek RTL28xxU DVB USB support"
-	depends on DVB_USB_V2
+	depends on DVB_USB_V2 && I2C_MUX
 	select DVB_RTL2830
 	select DVB_RTL2832
 	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
-- 
1.8.5.3


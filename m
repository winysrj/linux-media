Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56223 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaGYJnA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 05:43:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] Kconfig: rtl2832_sdr must depends on USB
Date: Fri, 25 Jul 2014 12:42:44 +0300
Message-Id: <1406281364-19497-2-git-send-email-crope@iki.fi>
In-Reply-To: <1406281364-19497-1-git-send-email-crope@iki.fi>
References: <1406281364-19497-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes error:
[next:master 7435/8702] ERROR: "usb_alloc_urb
[drivers/media/dvb-frontends/rtl2832_sdr.ko] undefined!

rtl2832_sdr driver implements own USB streaming for SDR data.
Logically that functionality belongs to USB interface driver, but
currently it is implemented here.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 78a95a6..5b8b04c 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -448,7 +448,7 @@ config DVB_RTL2832
 
 config DVB_RTL2832_SDR
 	tristate "Realtek RTL2832 SDR"
-	depends on DVB_CORE && I2C && I2C_MUX && VIDEO_V4L2 && MEDIA_SDR_SUPPORT
+	depends on DVB_CORE && I2C && I2C_MUX && VIDEO_V4L2 && MEDIA_SDR_SUPPORT && USB
 	select DVB_RTL2832
 	select VIDEOBUF2_VMALLOC
 	default m if !MEDIA_SUBDRV_AUTOSELECT
-- 
http://palosaari.fi/


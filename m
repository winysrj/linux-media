Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48897 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752124AbeCWMpf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 08:45:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] media: dvb-usb-v2: fix a missing dependency of I2C_MUX
Date: Fri, 23 Mar 2018 08:45:28 -0400
Message-Id: <0d2a531d00a36e378fce570cb96dbddee1f825f7.1521809120.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that af9015 requires I2C_MUX, all drivers that select
it should also depend on it.

   drivers/media/dvb-frontends/af9013.o: In function `af9013_remove':
>> drivers/media/dvb-frontends/af9013.c:1560: undefined reference to `i2c_mux_del_adapters'
   drivers/media/dvb-frontends/af9013.o: In function `af9013_probe':
>> drivers/media/dvb-frontends/af9013.c:1488: undefined reference to `i2c_mux_alloc'
>> drivers/media/dvb-frontends/af9013.c:1495: undefined reference to `i2c_mux_add_adapter'
   drivers/media/dvb-frontends/af9013.c:1544: undefined reference to `i2c_mux_del_adapters'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 09a52aae299a..37053477b84d 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -15,7 +15,7 @@ config DVB_USB_V2
 
 config DVB_USB_AF9015
 	tristate "Afatech AF9015 DVB-T USB2.0 support"
-	depends on DVB_USB_V2
+	depends on DVB_USB_V2 && I2C_MUX
 	select REGMAP
 	select DVB_AF9013
 	select DVB_PLL              if MEDIA_SUBDRV_AUTOSELECT
-- 
2.14.3

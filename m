Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaG1Nif (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 09:38:35 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] si2135: Declare the structs even if frontend is not enabled
Date: Mon, 28 Jul 2014 10:38:25 -0300
Message-Id: <1406554705-10296-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Kbuildtest:

   In file included from drivers/media/usb/cx231xx/cx231xx-dvb.c:35:0:
   drivers/media/dvb-frontends/si2165.h:57:9: warning: 'struct si2165_config' declared inside parameter list [enabled by default]
     struct i2c_adapter *i2c)
            ^
   drivers/media/dvb-frontends/si2165.h:57:9: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c:157:21: error: variable 'hauppauge_930C_HD_1113xx_si2165_config' has initializer but incomplete type
    static const struct si2165_config hauppauge_930C_HD_1113xx_si2165_config = {
                        ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:158:2: error: unknown field 'i2c_addr' specified in initializer
     .i2c_addr = 0x64,
     ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:158:2: warning: excess elements in struct initializer [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c:158:2: warning: (near initialization for 'hauppauge_930C_HD_1113xx_si2165_config') [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c:159:2: error: unknown field 'chip_mode' specified in initializer
     .chip_mode = SI2165_MODE_PLL_XTAL,
     ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:159:15: error: 'SI2165_MODE_PLL_XTAL' undeclared here (not in a function)
     .chip_mode = SI2165_MODE_PLL_XTAL,
                  ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:159:2: warning: excess elements in struct initializer [enabled by default]
     .chip_mode = SI2165_MODE_PLL_XTAL,
     ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:159:2: warning: (near initialization for 'hauppauge_930C_HD_1113xx_si2165_config') [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c:160:2: error: unknown field 'ref_freq_Hz' specified in initializer
     .ref_freq_Hz = 16000000,
     ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:160:2: warning: excess elements in struct initializer [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c:160:2: warning: (near initialization for 'hauppauge_930C_HD_1113xx_si2165_config') [enabled by default]
>> drivers/media/usb/cx231xx/cx231xx-dvb.c:163:21: error: variable 'pctv_quatro_stick_1114xx_si2165_config' has initializer but incomplete type
    static const struct si2165_config pctv_quatro_stick_1114xx_si2165_config = {
                        ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:164:2: error: unknown field 'i2c_addr' specified in initializer
     .i2c_addr = 0x64,
     ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:164:2: warning: excess elements in struct initializer [enabled by default]
>> drivers/media/usb/cx231xx/cx231xx-dvb.c:164:2: warning: (near initialization for 'pctv_quatro_stick_1114xx_si2165_config') [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c:165:2: error: unknown field 'chip_mode' specified in initializer
     .chip_mode = SI2165_MODE_PLL_EXT,
     ^
>> drivers/media/usb/cx231xx/cx231xx-dvb.c:165:15: error: 'SI2165_MODE_PLL_EXT' undeclared here (not in a function)
     .chip_mode = SI2165_MODE_PLL_EXT,
                  ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:165:2: warning: excess elements in struct initializer [enabled by default]
     .chip_mode = SI2165_MODE_PLL_EXT,
     ^
>> drivers/media/usb/cx231xx/cx231xx-dvb.c:165:2: warning: (near initialization for 'pctv_quatro_stick_1114xx_si2165_config') [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c:166:2: error: unknown field 'ref_freq_Hz' specified in initializer
     .ref_freq_Hz = 24000000,
     ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:166:2: warning: excess elements in struct initializer [enabled by default]
>> drivers/media/usb/cx231xx/cx231xx-dvb.c:166:2: warning: (near initialization for 'pctv_quatro_stick_1114xx_si2165_config') [enabled by default]
   drivers/media/usb/cx231xx/cx231xx-dvb.c: In function 'dvb_init':
   drivers/media/usb/cx231xx/cx231xx-dvb.c:731:3: warning: passing argument 1 of 'si2165_attach' from incompatible pointer type [enabled by default]
      dev->dvb->frontend = dvb_attach(si2165_attach,
      ^
   In file included from drivers/media/usb/cx231xx/cx231xx-dvb.c:35:0:
   drivers/media/dvb-frontends/si2165.h:55:36: note: expected 'const struct si2165_config *' but argument is of type 'const struct si2165_config *'
    static inline struct dvb_frontend *si2165_attach(
                                       ^
   drivers/media/usb/cx231xx/cx231xx-dvb.c:764:3: warning: passing argument 1 of 'si2165_attach' from incompatible pointer type [enabled by default]
      dev->dvb->frontend = dvb_attach(si2165_attach,
      ^
   In file included from drivers/media/usb/cx231xx/cx231xx-dvb.c:35:0:
   drivers/media/dvb-frontends/si2165.h:55:36: note: expected 'const struct si2165_config *' but argument is of type 'const struct si2165_config *'
    static inline struct dvb_frontend *si2165_attach(
                                       ^

That happens because the frontend was disabled by .config, but the
si2165_attach void stub require those structs, and also the
drivers that call it.

While here, remove the duplicated info about the possible I2C
addresses.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/si2165.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.h b/drivers/media/dvb-frontends/si2165.h
index 7a6b59ded4e2..efaa08123b92 100644
--- a/drivers/media/dvb-frontends/si2165.h
+++ b/drivers/media/dvb-frontends/si2165.h
@@ -22,8 +22,6 @@
 
 #include <linux/dvb/frontend.h>
 
-#if IS_ENABLED(CONFIG_DVB_SI2165)
-
 enum {
 	SI2165_MODE_OFF = 0x00,
 	SI2165_MODE_PLL_EXT = 0x20,
@@ -47,7 +45,7 @@ struct si2165_config {
 	bool inversion;
 };
 
-/* Addresses: 0x64,0x65,0x66,0x67 */
+#if IS_ENABLED(CONFIG_DVB_SI2165)
 struct dvb_frontend *si2165_attach(
 	const struct si2165_config *config,
 	struct i2c_adapter *i2c);
-- 
1.9.3


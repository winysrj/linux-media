Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55116 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbcGZHJk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 03:09:40 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 4/7] cx231xx: attach si2165 driver via i2c_client
Date: Tue, 26 Jul 2016 09:09:05 +0200
Message-Id: <20160726070908.10135-4-zzam@gentoo.org>
In-Reply-To: <20160726070908.10135-1-zzam@gentoo.org>
References: <20160726070908.10135-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use new style attach.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 73 ++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 25 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index f030345..1417515 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -151,18 +151,6 @@ static struct tda18271_config pv_tda18271_config = {
 	.small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
 };
 
-static const struct si2165_config hauppauge_930C_HD_1113xx_si2165_config = {
-	.i2c_addr	= 0x64,
-	.chip_mode	= SI2165_MODE_PLL_XTAL,
-	.ref_freq_Hz	= 16000000,
-};
-
-static const struct si2165_config pctv_quatro_stick_1114xx_si2165_config = {
-	.i2c_addr	= 0x64,
-	.chip_mode	= SI2165_MODE_PLL_EXT,
-	.ref_freq_Hz	= 24000000,
-};
-
 static struct lgdt3306a_config hauppauge_955q_lgdt3306a_config = {
 	.i2c_addr           = 0x59,
 	.qam_if_khz         = 4000,
@@ -756,19 +744,38 @@ static int dvb_init(struct cx231xx *dev)
 		break;
 
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
+	{
+		struct i2c_client *client;
+		struct i2c_board_info info;
+		struct si2165_platform_data si2165_pdata;
 
-		dev->dvb->frontend = dvb_attach(si2165_attach,
-			&hauppauge_930C_HD_1113xx_si2165_config,
-			demod_i2c
-			);
+		/* attach demod */
+		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
+		si2165_pdata.fe = &dev->dvb->frontend;
+		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
+		si2165_pdata.ref_freq_Hz = 16000000,
 
-		if (dev->dvb->frontend == NULL) {
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+		info.addr = 0x64;
+		info.platform_data = &si2165_pdata;
+		request_module(info.type);
+		client = i2c_new_device(demod_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
 
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dvb->i2c_client_demod = client;
+
 		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
@@ -781,27 +788,43 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->cx231xx_reset_analog_tuner = NULL;
 		break;
-
+	}
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
 	{
 		struct i2c_client *client;
 		struct i2c_board_info info;
+		struct si2165_platform_data si2165_pdata;
 		struct si2157_config si2157_config;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
+		/* attach demod */
+		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
+		si2165_pdata.fe = &dev->dvb->frontend;
+		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT,
+		si2165_pdata.ref_freq_Hz = 24000000,
 
-		dev->dvb->frontend = dvb_attach(si2165_attach,
-			&pctv_quatro_stick_1114xx_si2165_config,
-			demod_i2c
-			);
-
-		if (dev->dvb->frontend == NULL) {
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+		info.addr = 0x64;
+		info.platform_data = &si2165_pdata;
+		request_module(info.type);
+		client = i2c_new_device(demod_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
 
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dvb->i2c_client_demod = client;
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+
 		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
-- 
2.9.2


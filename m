Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.bgcomp.co.uk ([81.187.35.205]:58371 "EHLO
        mailgate.bgcomp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387409AbeKFEkn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 23:40:43 -0500
Received: from eth7.localnet (ns1.bgcomp.co.uk [IPv6:2001:8b0:ca:2::fd])
        by mailgate.bgcomp.co.uk (Postfix) with ESMTP id 395C7233A1
        for <linux-media@vger.kernel.org>; Mon,  5 Nov 2018 19:12:32 +0000 (GMT)
From: Abuse <abuse@2.abuse.bgcomp.co.uk>
To: linux-media@vger.kernel.org
Subject: Astrometa DVB-T2 2018 update
Date: Mon, 05 Nov 2018 19:12:32 +0000
Message-ID: <1566884.Tliu45TtRX@eth7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable Sony CXD2837ER slave demon on the Astrometa DVB-T2, known as the 2018 update.

Originally based on the patch by kapitanf at https://github.com/torvalds/linux/pull/567, it was not quite right. This is more correct, but probably still wrong. I'm not a kernel dev, but someone may be better positioned to handle the niceties.



diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index df4412245a8a..d44ddd5ee29e 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -137,6 +137,7 @@ config DVB_USB_RTL28XXU
 	select DVB_RTL2832
 	select DVB_RTL2832_SDR if (MEDIA_SUBDRV_AUTOSELECT && MEDIA_SDR_SUPPORT)
 	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_E4000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC0012 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC0013 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a970224a94bd..db4f4da43781 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -386,6 +386,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_mn88473 = {0xff38, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_si2157 = {0x00c0, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_si2168 = {0x00c8, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_cxd2837er = {0x68d8, CMD_I2C_RD, 1, buf};
 
 	dev_dbg(&d->intf->dev, "\n");
 
@@ -567,6 +568,13 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 			dev->slave_demod = SLAVE_DEMOD_MN88473;
 			goto demod_found;
 		}
+
+		ret = rtl28xxu_ctrl_msg(d, &req_cxd2837er);
+		if (ret == 0 && buf[0] == 0x03) {
+			dev_dbg(&d->intf->dev, "CXD2837ER found");
+			dev->slave_demod = SLAVE_DEMOD_CXD2841ER;
+			goto demod_found;
+		}
 	}
 	if (dev->tuner == TUNER_RTL2832_SI2157) {
 		/* check Si2168 ID register; reg=c8 val=80 */
@@ -988,6 +996,27 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 				goto err_slave_demod_failed;
 			}
 
+			dev->i2c_client_slave_demod = client;
+		} else if (dev->slave_demod == SLAVE_DEMOD_CXD2841ER) {
+			struct cxd2841er_config cxd2837er_config = {};
+			cxd2837er_config.i2c_addr = 0xd8;
+			cxd2837er_config.xtal = SONY_XTAL_20500;
+			cxd2837er_config.flags = CXD2841ER_AUTO_IFHZ    | CXD2841ER_EARLY_TUNE |
+				    CXD2841ER_NO_WAIT_LOCK | CXD2841ER_NO_AGCNEG  |
+				    CXD2841ER_TSBITS       | CXD2841ER_TS_SERIAL;
+
+			adap->fe[1] = dvb_attach( cxd2841er_attach_t_c, &cxd2837er_config, &d->i2c_adap );
+			if (!adap->fe[1]) {
+				dev_err(&d->intf->dev, "CXD2837ER attach failed!\n");
+				return -ENODEV;
+			}
+
+			if (!try_module_get(client->dev.driver->owner)) {
+				i2c_unregister_device(client);
+				dev->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+
 			dev->i2c_client_slave_demod = client;
 		} else {
 			struct si2168_config si2168_config = {};
@@ -1046,10 +1075,14 @@ static int rtl28xxu_frontend_detach(struct dvb_usb_adapter *adap)
 	dev_dbg(&d->intf->dev, "\n");
 
 	/* remove I2C slave demod */
-	client = dev->i2c_client_slave_demod;
-	if (client) {
-		module_put(client->dev.driver->owner);
-		i2c_unregister_device(client);
+	if (dev->slave_demod == SLAVE_DEMOD_CXD2841ER) {
+		dev_info(&d->intf->dev,"Sony CXD2837ER detached automatically.");
+	} else {
+		client = dev->i2c_client_slave_demod;
+		if (client) {
+			module_put(client->dev.driver->owner);
+			i2c_unregister_device(client);
+		}
 	}
 
 	/* remove I2C demod */
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 138062960a73..5a615d73fc34 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -43,6 +43,7 @@
 #include "r820t.h"
 #include "si2168.h"
 #include "si2157.h"
+#include "cxd2841er.h"
 
 /*
  * USB commands
@@ -87,7 +88,8 @@ struct rtl28xxu_dev {
 	#define SLAVE_DEMOD_MN88472        1
 	#define SLAVE_DEMOD_MN88473        2
 	#define SLAVE_DEMOD_SI2168         3
-	unsigned int slave_demod:2;
+	#define SLAVE_DEMOD_CXD2841ER      4
+	unsigned int slave_demod:3;
 	union {
 		struct rtl2830_platform_data rtl2830_platform_data;
 		struct rtl2832_platform_data rtl2832_platform_data;

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59546 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab2IBBJy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Sep 2012 21:09:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] rtl28xxu: add support for Elonics E4000 tuner
Date: Sun,  2 Sep 2012 04:09:22 +0300
Message-Id: <1346548162-21168-2-git-send-email-crope@iki.fi>
In-Reply-To: <1346548162-21168-1-git-send-email-crope@iki.fi>
References: <1346548162-21168-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig    |  1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 9671151..329d222 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -141,6 +141,7 @@ config DVB_USB_RTL28XXU
 	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC0012 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC0013 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_E4000 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 7d11c5d..88b5ea1 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -30,6 +30,7 @@
 #include "mxl5005s.h"
 #include "fc0012.h"
 #include "fc0013.h"
+#include "e4000.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -625,10 +626,11 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	ret = rtl28xxu_ctrl_msg(d, &req_e4000);
 	if (ret == 0 && buf[0] == 0x40) {
 		priv->tuner = TUNER_RTL2832_E4000;
-		/* TODO implement tuner */
+		/* FIXME: do not abuse fc0012 settings */
+		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
 		dev_info(&d->udev->dev, "%s: E4000 tuner found",
 				KBUILD_MODNAME);
-		goto unsupported;
+		goto found;
 	}
 
 	/* check TDA18272 ID register; reg=00 val=c760  */
@@ -746,6 +748,11 @@ err:
 	return ret;
 }
 
+static const struct e4000_config rtl2832u_e4000_config = {
+	.i2c_addr = 0x64,
+	.clock = 28800000,
+};
+
 static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -774,6 +781,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		adap->fe[0]->ops.read_signal_strength =
 				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		return 0;
+	case TUNER_RTL2832_E4000:
+		fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
+				&rtl2832u_e4000_config);
+		break;
 	default:
 		fe = NULL;
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
@@ -1223,6 +1234,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "G-Tek Electronics Group Lifeview LV5TDLX DVB-T", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
 		&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_REALTEK, 0x2838,
+		&rtl2832u_props, "Realtek RTL2832U reference design", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.11.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46640 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab2IICHy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Sep 2012 22:07:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] rtl28xxu: add support for FCI FC2580 silicon tuner driver
Date: Sun,  9 Sep 2012 05:07:25 +0300
Message-Id: <1347156446-12439-2-git-send-email-crope@iki.fi>
In-Reply-To: <1347156446-12439-1-git-send-email-crope@iki.fi>
References: <1347156446-12439-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/Kconfig    |  1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 329d222..e09930c 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -142,6 +142,7 @@ config DVB_USB_RTL28XXU
 	select MEDIA_TUNER_FC0012 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC0013 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_E4000 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_FC2580 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index d0d23f2..f195b77 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -31,6 +31,7 @@
 #include "fc0012.h"
 #include "fc0013.h"
 #include "e4000.h"
+#include "fc2580.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -576,10 +577,11 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	ret = rtl28xxu_ctrl_msg(d, &req_fc2580);
 	if (ret == 0 && buf[0] == 0x56) {
 		priv->tuner = TUNER_RTL2832_FC2580;
-		/* TODO implement tuner */
+		/* FIXME: do not abuse fc0012 settings */
+		rtl2832_config = &rtl28xxu_rtl2832_fc0012_config;
 		dev_info(&d->udev->dev, "%s: FC2580 tuner found",
 				KBUILD_MODNAME);
-		goto unsupported;
+		goto found;
 	}
 
 	/* check MT2063 ID register; reg=00 val=9e || 9c */
@@ -753,6 +755,11 @@ static const struct e4000_config rtl2832u_e4000_config = {
 	.clock = 28800000,
 };
 
+static const struct fc2580_config rtl2832u_fc2580_config = {
+	.i2c_addr = 0x56,
+	.clock = 16384000,
+};
+
 static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -785,6 +792,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
 				&rtl2832u_e4000_config);
 		break;
+	case TUNER_RTL2832_FC2580:
+		fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
+				&rtl2832u_fc2580_config);
+		break;
 	default:
 		fe = NULL;
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
-- 
1.7.11.4


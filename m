Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab3DQAm5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Apr 2013 20:42:57 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3H0gu4q031262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Apr 2013 20:42:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2 02/31] [media] rtl28xxu: add support for Rafael Micro r820t
Date: Tue, 16 Apr 2013 21:42:13 -0300
Message-Id: <1366159362-3773-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
References: <1366159362-3773-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This tuner is used on some rtl2882 dongles. Add it to the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/dvb-usb-v2/Kconfig    |  1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 30 ++++++++++++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  1 +
 3 files changed, 32 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index 9aff035..a3c8ecf 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -143,6 +143,7 @@ config DVB_USB_RTL28XXU
 	select MEDIA_TUNER_FC0013 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_E4000 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_FC2580 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_R820T if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y here to support the Realtek RTL28xxU DVB USB receiver.
 
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 3d128a5..18756a6 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -33,6 +33,7 @@
 #include "e4000.h"
 #include "fc2580.h"
 #include "tua9001.h"
+#include "r820t.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -375,6 +376,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_mxl5007t = {0xd9c0, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_e4000 = {0x02c8, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
+	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 5, buf};
 
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
@@ -479,6 +481,14 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 		goto found;
 	}
 
+	/* check R820T by reading tuner stats at I2C addr 0x1a */
+	ret = rtl28xxu_ctrl_msg(d, &req_r820t);
+	if (ret == 0) {
+		priv->tuner = TUNER_RTL2832_R820T;
+		priv->tuner_name = "R820T";
+		goto found;
+	}
+
 found:
 	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
 
@@ -589,6 +599,12 @@ static struct rtl2832_config rtl28xxu_rtl2832_e4000_config = {
 	.tuner = TUNER_RTL2832_E4000,
 };
 
+static struct rtl2832_config rtl28xxu_rtl2832_r820t_config = {
+	.i2c_addr = 0x10,
+	.xtal = 28800000,
+	.tuner = TUNER_RTL2832_R820T,
+};
+
 static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -728,6 +744,9 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 	case TUNER_RTL2832_E4000:
 		rtl2832_config = &rtl28xxu_rtl2832_e4000_config;
 		break;
+	case TUNER_RTL2832_R820T:
+		rtl2832_config = &rtl28xxu_rtl2832_r820t_config;
+		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
 				KBUILD_MODNAME, priv->tuner_name);
@@ -840,6 +859,13 @@ static const struct fc0012_config rtl2832u_fc0012_config = {
 	.xtal_freq = FC_XTAL_28_8_MHZ,
 };
 
+static const struct r820t_config rtl2832u_r820t_config = {
+	.i2c_addr = 0x1a,
+	.xtal = 28800000,
+	.max_i2c_msg_len = 2,
+	.rafael_chip = CHIP_R820T,
+};
+
 static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	int ret;
@@ -889,6 +915,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		fe = dvb_attach(tua9001_attach, adap->fe[0], &d->i2c_adap,
 				&rtl2832u_tua9001_config);
 		break;
+	case TUNER_RTL2832_R820T:
+		fe = dvb_attach(r820t_attach, adap->fe[0], &d->i2c_adap,
+				&rtl2832u_r820t_config);
+		break;
 	default:
 		fe = NULL;
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 2f3af2d..533a331 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -82,6 +82,7 @@ enum rtl28xxu_tuner {
 	TUNER_RTL2832_E4000,
 	TUNER_RTL2832_TDA18272,
 	TUNER_RTL2832_FC0013,
+	TUNER_RTL2832_R820T,
 };
 
 struct rtl28xxu_req {
-- 
1.8.1.4


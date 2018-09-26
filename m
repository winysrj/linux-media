Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward101o.mail.yandex.net ([37.140.190.181]:35034 "EHLO
        forward101o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725722AbeI0EJj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 00:09:39 -0400
Date: Thu, 27 Sep 2018 00:44:45 +0300
From: Nikita Gerasimov <nikitych@yandex.ru>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: [PATCH] media: rtl28xxu: add support for Sony CXD2837ER slave demod
Message-ID: <20180926214445.GA1344@NMT>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since 2018 some new revisions of RTL2832P based devices having
Sony CXD2837ER as a slave demodulator instead of Panasonic MN88473.
CXD2837ER handled in DVB_CXD2841ER module but it's has a lack of control.
So slave demod has to be reseted by GPIO0 before detecting to woke up
CXD2837ER.

Signed-off-by: Nikita Gerasimov <nikitych@yandex.ru>
---
 drivers/media/usb/dvb-usb-v2/Kconfig    |  1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 40 +++++++++++++++++++++++--
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h |  4 ++-
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
index df4412245a8a..511e3f270308 100644
--- a/drivers/media/usb/dvb-usb-v2/Kconfig
+++ b/drivers/media/usb/dvb-usb-v2/Kconfig
@@ -133,6 +133,7 @@ config DVB_USB_RTL28XXU
 	depends on DVB_USB_V2 && I2C_MUX
 	select DVB_MN88472 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MN88473 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_CXD2841ER if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_RTL2830
 	select DVB_RTL2832
 	select DVB_RTL2832_SDR if (MEDIA_SUBDRV_AUTOSELECT && MEDIA_SDR_SUPPORT)
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a970224a94bd..917129404668 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -384,6 +384,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 	struct rtl28xxu_req req_r828d = {0x0074, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_mn88472 = {0xff38, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_mn88473 = {0xff38, CMD_I2C_RD, 1, buf};
+	struct rtl28xxu_req req_cxd2837er = {0xfdd8, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_si2157 = {0x00c0, CMD_I2C_RD, 1, buf};
 	struct rtl28xxu_req req_si2168 = {0x00c8, CMD_I2C_RD, 1, buf};
 
@@ -540,7 +541,18 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 
 	/* probe slave demod */
 	if (dev->tuner == TUNER_RTL2832_R828D) {
-		/* power on MN88472 demod on GPIO0 */
+		/* power off slave demod on GPIO0 to reset CXD2837ER */
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x00, 0x01);
+		if (ret)
+			goto err;
+
+		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x00, 0x01);
+		if (ret)
+			goto err;
+
+		msleep(50);
+
+		/* power on slave demod on GPIO0 */
 		ret = rtl28xxu_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x01, 0x01);
 		if (ret)
 			goto err;
@@ -553,7 +565,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 		if (ret)
 			goto err;
 
-		/* check MN88472 answers */
+		/* check slave answers */
 		ret = rtl28xxu_ctrl_msg(d, &req_mn88472);
 		if (ret == 0 && buf[0] == 0x02) {
 			dev_dbg(&d->intf->dev, "MN88472 found\n");
@@ -567,6 +579,13 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 			dev->slave_demod = SLAVE_DEMOD_MN88473;
 			goto demod_found;
 		}
+
+		ret = rtl28xxu_ctrl_msg(d, &req_cxd2837er);
+		if (ret == 0 && buf[0] == 0xb1) {
+			dev_dbg(&d->intf->dev, "CXD2837ER found\n");
+			dev->slave_demod = SLAVE_DEMOD_CXD2837ER;
+			goto demod_found;
+		}
 	}
 	if (dev->tuner == TUNER_RTL2832_SI2157) {
 		/* check Si2168 ID register; reg=c8 val=80 */
@@ -989,6 +1008,23 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			}
 
 			dev->i2c_client_slave_demod = client;
+		} else if (dev->slave_demod == SLAVE_DEMOD_CXD2837ER) {
+			struct cxd2841er_config cxd2837er_config = {};
+
+			cxd2837er_config.i2c_addr = 0xd8;
+			cxd2837er_config.xtal = SONY_XTAL_20500;
+			cxd2837er_config.flags = (CXD2841ER_AUTO_IFHZ |
+				CXD2841ER_NO_AGCNEG | CXD2841ER_TSBITS |
+				CXD2841ER_EARLY_TUNE | CXD2841ER_TS_SERIAL);
+			adap->fe[1] = dvb_attach(cxd2841er_attach_t_c,
+						 &cxd2837er_config,
+						 &d->i2c_adap);
+			if (!adap->fe[1]) {
+				dev->slave_demod = SLAVE_DEMOD_NONE;
+				goto err_slave_demod_failed;
+			}
+			adap->fe[1]->id = 1;
+			dev->i2c_client_slave_demod = NULL;
 		} else {
 			struct si2168_config si2168_config = {};
 			struct i2c_adapter *adapter;
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
index 138062960a73..197f4e339605 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
@@ -31,6 +31,7 @@
 #include "rtl2832_sdr.h"
 #include "mn88472.h"
 #include "mn88473.h"
+#include "cxd2841er.h"
 
 #include "qt1010.h"
 #include "mt2060.h"
@@ -87,7 +88,8 @@ struct rtl28xxu_dev {
 	#define SLAVE_DEMOD_MN88472        1
 	#define SLAVE_DEMOD_MN88473        2
 	#define SLAVE_DEMOD_SI2168         3
-	unsigned int slave_demod:2;
+	#define SLAVE_DEMOD_CXD2837ER      4
+	unsigned int slave_demod:3;
 	union {
 		struct rtl2830_platform_data rtl2830_platform_data;
 		struct rtl2832_platform_data rtl2832_platform_data;
-- 
2.17.1

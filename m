Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47071 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab1LDMUq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Dec 2011 07:20:46 -0500
Received: by wgbds13 with SMTP id ds13so4678137wgb.1
        for <linux-media@vger.kernel.org>; Sun, 04 Dec 2011 04:20:45 -0800 (PST)
Message-ID: <1323001237.1960.11.camel@tvbox>
Subject: [PATCH] it913x multiple devices on system. Copy ite_config to priv
 area.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 04 Dec 2011 12:20:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there are two or more different it913x devices on the system they share the same
ite_config and over write its settings.

To over come this, the ite_config is copied to the priv area.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index e847527..1aa3872 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -63,6 +63,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 struct it913x_state {
 	u8 id;
+	struct ite_config it913x_config;
 };
 
 struct ite_config it913x_config;
@@ -624,6 +625,7 @@ static int it913x_name(struct dvb_usb_adapter *adap)
 static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct usb_device *udev = adap->dev->udev;
+	struct it913x_state *st = adap->dev->priv;
 	int ret = 0;
 	u8 adap_addr = I2C_BASE_ADDR + (adap->id << 5);
 	u16 ep_size = adap->props.fe[0].stream.u.bulk.buffersize / 4;
@@ -634,8 +636,12 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 
 	it913x_config.adf = it913x_read_reg(udev, IO_MUX_POWER_CLK);
 
+	if (adap->id == 0)
+		memcpy(&st->it913x_config, &it913x_config,
+			sizeof(struct ite_config));
+
 	adap->fe_adap[0].fe = dvb_attach(it913x_fe_attach,
-		&adap->dev->i2c_adap, adap_addr, &it913x_config);
+		&adap->dev->i2c_adap, adap_addr, &st->it913x_config);
 
 	if (adap->id == 0 && adap->fe_adap[0].fe) {
 		ret = it913x_wr_reg(udev, DEV_0_DMOD, MP2_SW_RST, 0x1);
-- 
1.7.7.3




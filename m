Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38734 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbaLWVUf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:20:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 62/66] rtl28xxu: add heuristic to detect chip type
Date: Tue, 23 Dec 2014 22:49:55 +0200
Message-Id: <1419367799-14263-62-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detect automatically whether chip is old RTL2831U or newer
RTL2832U/RTL2832P. Detection is based I2C command that is found only
from newer RTL2832U models.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index b0d2467..5bc7774 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -523,6 +523,35 @@ err:
 	return ret;
 }
 
+static int rtl28xxu_identify_state(struct dvb_usb_device *d, const char **name)
+{
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+	int ret;
+	struct rtl28xxu_req req_demod_i2c = {0x0020, CMD_I2C_DA_RD, 0, NULL};
+
+	dev_dbg(&d->intf->dev, "\n");
+
+	/*
+	 * Detect chip type using I2C command that is not supported
+	 * by old RTL2831U.
+	 */
+	ret = rtl28xxu_ctrl_msg(d, &req_demod_i2c);
+	if (ret == -EPIPE) {
+		dev->chip_id = CHIP_ID_RTL2831U;
+	} else if (ret == 0) {
+		dev->chip_id = CHIP_ID_RTL2832U;
+	} else {
+		dev_err(&d->intf->dev, "chip type detection failed %d\n", ret);
+		goto err;
+	}
+	dev_dbg(&d->intf->dev, "chip_id=%u\n", dev->chip_id);
+
+	return WARM;
+err:
+	dev_dbg(&d->intf->dev, "failed=%d\n", ret);
+	return ret;
+}
+
 static const struct rtl2830_platform_data rtl2830_mt2060_platform_data = {
 	.clk = 28800000,
 	.spec_inv = 1,
@@ -1590,6 +1619,7 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 	.adapter_nr = adapter_nr,
 	.size_of_priv = sizeof(struct rtl28xxu_dev),
 
+	.identify_state = rtl28xxu_identify_state,
 	.power_ctrl = rtl2831u_power_ctrl,
 	.i2c_algo = &rtl28xxu_i2c_algo,
 	.read_config = rtl2831u_read_config,
@@ -1620,6 +1650,7 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.adapter_nr = adapter_nr,
 	.size_of_priv = sizeof(struct rtl28xxu_dev),
 
+	.identify_state = rtl28xxu_identify_state,
 	.power_ctrl = rtl2832u_power_ctrl,
 	.frontend_ctrl = rtl2832u_frontend_ctrl,
 	.i2c_algo = &rtl28xxu_i2c_algo,
-- 
http://palosaari.fi/


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50860 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbaHVK63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 06:58:29 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [GIT PULL FINAL 09/21] cxusb: Add read_mac_address for TT CT2-4400 and CT2-4650
Date: Fri, 22 Aug 2014 13:58:01 +0300
Message-Id: <1408705093-5167-10-git-send-email-crope@iki.fi>
In-Reply-To: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

Read MAC address from the EEPROM.

This version two corrects a flaw in the result code returning that
did exist in the first version.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb/cxusb.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 4ab3459..187d529 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -673,6 +673,39 @@ static struct rc_map_table rc_map_d680_dmb_table[] = {
 	{ 0x0025, KEY_POWER },
 };
 
+static int cxusb_tt_ct2_4400_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
+{
+	u8 wbuf[2];
+	u8 rbuf[6];
+	int ret;
+	struct i2c_msg msg[] = {
+		{
+			.addr = 0x51,
+			.flags = 0,
+			.buf = wbuf,
+			.len = 2,
+		}, {
+			.addr = 0x51,
+			.flags = I2C_M_RD,
+			.buf = rbuf,
+			.len = 6,
+		}
+	};
+
+	wbuf[0] = 0x1e;
+	wbuf[1] = 0x00;
+	ret = cxusb_i2c_xfer(&d->i2c_adap, msg, 2);
+
+	if (ret == 2) {
+		memcpy(mac, rbuf, 6);
+		return 0;
+	} else {
+		if (ret < 0)
+			return ret;
+		return -EIO;
+	}
+}
+
 static int cxusb_tt_ct2_4650_ci_ctrl(void *priv, u8 read, int addr,
 					u8 data, int *mem)
 {
@@ -2316,6 +2349,8 @@ static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties = {
 	.size_of_priv     = sizeof(struct cxusb_state),
 
 	.num_adapters = 1,
+	.read_mac_address = cxusb_tt_ct2_4400_read_mac_address,
+
 	.adapter = {
 		{
 		.num_frontends = 1,
-- 
http://palosaari.fi/


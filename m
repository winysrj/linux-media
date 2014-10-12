Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33901 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaJLKDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 06:03:40 -0400
Received: by mail-la0-f51.google.com with SMTP id ge10so5347886lab.10
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 03:03:38 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: nibble.max@gmail.com, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/4] dvbsky: added debug logging
Date: Sun, 12 Oct 2014 13:03:09 +0300
Message-Id: <1413108191-32510-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi>
References: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added debug logging using dev_dgb.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 502b52c..fabe3f5 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -68,6 +68,9 @@ static int dvbsky_stream_ctrl(struct dvb_usb_device *d, u8 onoff)
 	u8 obuf_pre[3] = { 0x37, 0, 0 };
 	u8 obuf_post[3] = { 0x36, 3, 0 };
 
+	dev_dbg(&d->udev->dev, "state: %s\n", (onoff == 1)
+			? "on" : "off");
+
 	mutex_lock(&state->stream_mutex);
 	ret = dvbsky_usb_generic_rw(d, obuf_pre, 3, NULL, 0);
 	if (!ret && onoff) {
@@ -91,6 +94,8 @@ static int dvbsky_gpio_ctrl(struct dvb_usb_device *d, u8 gport, u8 value)
 	int ret;
 	u8 obuf[3], ibuf[2];
 
+	dev_dbg(&d->udev->dev, "gport: %d, value: %d\n", gport, value);
+
 	obuf[0] = 0x0e;
 	obuf[1] = gport;
 	obuf[2] = value;
@@ -234,6 +239,9 @@ static int dvbsky_usb_set_voltage(struct dvb_frontend *fe,
 	struct dvbsky_state *state = d_to_priv(d);
 	u8 value;
 
+	dev_dbg(&d->udev->dev, "voltage: %s\n",
+			(voltage == SEC_VOLTAGE_OFF) ? "off" : "on");
+
 	if (voltage == SEC_VOLTAGE_OFF)
 		value = 0;
 	else
@@ -262,8 +270,10 @@ static int dvbsky_read_mac_addr(struct dvb_usb_adapter *adap, u8 mac[6])
 		}
 	};
 
-	if (i2c_transfer(&d->i2c_adap, msg, 2) == 2)
+	if (i2c_transfer(&d->i2c_adap, msg, 2) == 2) {
 		memcpy(mac, ibuf, 6);
+		dev_dbg(&d->udev->dev, "MAC: %pM\n", ibuf);
+	}
 
 	return 0;
 }
@@ -274,6 +284,8 @@ static int dvbsky_usb_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	struct dvbsky_state *state = d_to_priv(d);
 	int ret;
 
+	dev_dbg(&d->udev->dev, "\n");
+
 	ret = state->fe_read_status(fe, status);
 
 	/* it need resync slave fifo when signal change from unlock to lock.*/
@@ -309,6 +321,9 @@ static int dvbsky_s960_attach(struct dvb_usb_adapter *adap)
 	struct m88ts2022_config m88ts2022_config = {
 			.clock = 27000000,
 		};
+
+	dev_dbg(&d->udev->dev, "\n");
+
 	memset(&info, 0, sizeof(struct i2c_board_info));
 
 	/* attach demod */
@@ -362,6 +377,8 @@ fail_attach:
 
 static int dvbsky_identify_state(struct dvb_usb_device *d, const char **name)
 {
+	dev_dbg(&d->udev->dev, "\n");
+
 	dvbsky_gpio_ctrl(d, 0x04, 1);
 	msleep(20);
 	dvbsky_gpio_ctrl(d, 0x83, 0);
@@ -378,6 +395,8 @@ static int dvbsky_init(struct dvb_usb_device *d)
 {
 	struct dvbsky_state *state = d_to_priv(d);
 
+	dev_dbg(&d->udev->dev, "\n");
+
 	/* use default interface */
 	/*
 	ret = usb_set_interface(d->udev, 0, 0);
@@ -396,6 +415,8 @@ static void dvbsky_exit(struct dvb_usb_device *d)
 	struct dvbsky_state *state = d_to_priv(d);
 	struct i2c_client *client;
 
+	dev_dbg(&d->udev->dev, "\n");
+
 	client = state->i2c_client_tuner;
 	/* remove I2C tuner */
 	if (client) {
-- 
1.9.1


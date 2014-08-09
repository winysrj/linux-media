Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56974 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/14] af9035: make checkpatch.pl happy
Date: Sat,  9 Aug 2014 23:27:10 +0300
Message-Id: <1407616032-2722-13-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct issues reported by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 85f2c4b..f37cf7d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -536,6 +536,7 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	u8 tmp;
 	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
 	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf };
+
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/*
@@ -974,6 +975,7 @@ static int af9035_frontend_callback(void *adapter_priv, int component,
 static int af9035_get_adapter_count(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
+
 	return state->dual_mode + 1;
 }
 
@@ -982,6 +984,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
+
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	if (!state->af9033_config[adap->id].tuner) {
@@ -1068,6 +1071,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dvb_frontend *fe;
 	struct i2c_msg msg[1];
 	u8 tuner_addr;
+
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/*
@@ -1393,6 +1397,7 @@ static int af9035_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 		struct usb_data_stream_properties *stream)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
+
 	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, fe_to_adap(fe)->id);
 
 	if (d->udev->speed == USB_SPEED_FULL)
@@ -1554,7 +1559,8 @@ static const struct usb_device_id af9035_id_table[] = {
 							RC_MAP_IT913X_V1) },
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
-		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
+		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)",
+		NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a05,
 		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
-- 
http://palosaari.fi/


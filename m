Return-path: <linux-media-owner@vger.kernel.org>
Received: from buzzloop.caiaq.de ([212.112.241.133]:53483 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0EXK55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 May 2010 06:57:57 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>,
	Wolfram Sang <w.sang@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 2/2] drivers/media/dvb/dvb-usb/dib0700: CodingStyle fixes
Date: Mon, 24 May 2010 12:57:15 +0200
Message-Id: <1274698635-19512-2-git-send-email-daniel@caiaq.de>
In-Reply-To: <AANLkTikffmoWofbIo2h6zw-VW5aKEH8T_b0vMfKdo3KJ@mail.gmail.com>
References: <AANLkTikffmoWofbIo2h6zw-VW5aKEH8T_b0vMfKdo3KJ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |   66 ++++++++++++++++--------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index d2dabac..45aec3a 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -53,7 +53,7 @@ static int dib0700_ctrl_wr(struct dvb_usb_device *d, u8 *tx, u8 txlen)
 	int status;
 
 	deb_data(">>> ");
-	debug_dump(tx,txlen,deb_data);
+	debug_dump(tx, txlen, deb_data);
 
 	status = usb_control_msg(d->udev, usb_sndctrlpipe(d->udev,0),
 		tx[0], USB_TYPE_VENDOR | USB_DIR_OUT, 0, 0, tx, txlen,
@@ -98,7 +98,7 @@ int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen
 		deb_info("ep 0 read error (status = %d)\n",status);
 
 	deb_data("<<< ");
-	debug_dump(rx,rxlen,deb_data);
+	debug_dump(rx, rxlen, deb_data);
 
 	return status; /* length in case of success */
 }
@@ -106,28 +106,29 @@ int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen
 int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_dir, u8 gpio_val)
 {
 	u8 buf[3] = { REQUEST_SET_GPIO, gpio, ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6) };
-	return dib0700_ctrl_wr(d,buf,3);
+	return dib0700_ctrl_wr(d, buf, sizeof(buf));
 }
 
 static int dib0700_set_usb_xfer_len(struct dvb_usb_device *d, u16 nb_ts_packets)
 {
-    struct dib0700_state *st = d->priv;
-    u8 b[3];
-    int ret;
-
-    if (st->fw_version >= 0x10201) {
-	b[0] = REQUEST_SET_USB_XFER_LEN;
-	b[1] = (nb_ts_packets >> 8)&0xff;
-	b[2] = nb_ts_packets & 0xff;
-
-	deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
-
-	ret = dib0700_ctrl_wr(d, b, 3);
-    } else {
-	deb_info("this firmware does not allow to change the USB xfer len\n");
-	ret = -EIO;
-    }
-    return ret;
+	struct dib0700_state *st = d->priv;
+	u8 b[3];
+	int ret;
+
+	if (st->fw_version >= 0x10201) {
+		b[0] = REQUEST_SET_USB_XFER_LEN;
+		b[1] = (nb_ts_packets >> 8) & 0xff;
+		b[2] = nb_ts_packets & 0xff;
+
+		deb_info("set the USB xfer len to %i Ts packet\n", nb_ts_packets);
+
+		ret = dib0700_ctrl_wr(d, b, 3);
+	} else {
+		deb_info("this firmware does not allow to change the USB xfer len\n");
+		ret = -EIO;
+	}
+
+	return ret;
 }
 
 /*
@@ -178,7 +179,8 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 			value = ((en_start << 7) | (en_stop << 6) |
 				 (msg[i].len & 0x3F)) << 8 | i2c_dest;
 			/* I2C ctrl + FE bus; */
-			index = ((gen_mode<<6)&0xC0) | ((bus_mode<<4)&0x30);
+			index = ((gen_mode << 6) & 0xC0) |
+				((bus_mode << 4) & 0x30);
 
 			result = usb_control_msg(d->udev,
 						 usb_rcvctrlpipe(d->udev, 0),
@@ -198,11 +200,12 @@ static int dib0700_i2c_xfer_new(struct i2c_adapter *adap, struct i2c_msg *msg,
 		} else {
 			/* Write request */
 			buf[0] = REQUEST_NEW_I2C_WRITE;
-			buf[1] = (msg[i].addr << 1);
+			buf[1] = msg[i].addr << 1;
 			buf[2] = (en_start << 7) | (en_stop << 6) |
 				(msg[i].len & 0x3F);
 			/* I2C ctrl + FE bus; */
-			buf[3] = ((gen_mode<<6)&0xC0) | ((bus_mode<<4)&0x30);
+			buf[3] = ((gen_mode << 6) & 0xC0) |
+				 ((bus_mode << 4) & 0x30);
 			/* The Actual i2c payload */
 			memcpy(&buf[4], msg[i].buf, msg[i].len);
 
@@ -240,7 +243,7 @@ static int dib0700_i2c_xfer_legacy(struct i2c_adapter *adap,
 
 	for (i = 0; i < num; i++) {
 		/* fill in the address */
-		buf[1] = (msg[i].addr << 1);
+		buf[1] = msg[i].addr << 1;
 		/* fill the buffer */
 		memcpy(&buf[2], msg[i].buf, msg[i].len);
 
@@ -368,7 +371,8 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 	u8 buf[260];
 
 	while ((ret = dvb_usb_get_hexline(fw, &hx, &pos)) > 0) {
-		deb_fwdata("writing to address 0x%08x (buffer: 0x%02x %02x)\n",hx.addr, hx.len, hx.chk);
+		deb_fwdata("writing to address 0x%08x (buffer: 0x%02x %02x)\n",
+				hx.addr, hx.len, hx.chk);
 
 		buf[0] = hx.len;
 		buf[1] = (hx.addr >> 8) & 0xff;
@@ -408,16 +412,16 @@ int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw
 				  REQUEST_GET_VERSION,
 				  USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
 				  b, sizeof(b), USB_CTRL_GET_TIMEOUT);
-	fw_version = (b[8] << 24)  | (b[9] << 16)  | (b[10] << 8) | b[11];
+	fw_version = (b[8] << 24) | (b[9] << 16) | (b[10] << 8) | b[11];
 
 	/* set the buffer size - DVB-USB is allocating URB buffers
 	 * only after the firwmare download was successful */
 	for (i = 0; i < dib0700_device_count; i++) {
 		for (adap_num = 0; adap_num < dib0700_devices[i].num_adapters;
 				adap_num++) {
-			if (fw_version >= 0x10201)
+			if (fw_version >= 0x10201) {
 				dib0700_devices[i].adapter[adap_num].stream.u.bulk.buffersize = 188*nb_packet_buffer_size;
-			else {
+			} else {
 				/* for fw version older than 1.20.1,
 				 * the buffersize has to be n times 512 */
 				dib0700_devices[i].adapter[adap_num].stream.u.bulk.buffersize = ((188*nb_packet_buffer_size+188/2)/512)*512;
@@ -453,7 +457,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	if (st->disable_streaming_master_mode == 1)
 		b[2] = 0x00;
 	else
-		b[2] = (0x01 << 4); /* Master mode */
+		b[2] = 0x01 << 4; /* Master mode */
 
 	b[3] = 0x00;
 
@@ -466,7 +470,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 
 	b[2] |= st->channel_state;
 
-	deb_info("data for streaming: %x %x\n",b[1],b[2]);
+	deb_info("data for streaming: %x %x\n", b[1], b[2]);
 
 	return dib0700_ctrl_wr(adap->dev, b, 4);
 }
@@ -631,7 +635,7 @@ resubmit:
 int dib0700_rc_setup(struct dvb_usb_device *d)
 {
 	struct dib0700_state *st = d->priv;
-	u8 rc_setup[3] = {REQUEST_SET_RC, dvb_usb_dib0700_ir_proto, 0};
+	u8 rc_setup[3] = { REQUEST_SET_RC, dvb_usb_dib0700_ir_proto, 0 };
 	struct urb *purb;
 	int ret;
 	int i;
-- 
1.7.1


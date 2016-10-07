Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46767 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938850AbcJGRYq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 13:24:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>
Subject: [PATCH 01/26] af9005: don't do DMA on stack
Date: Fri,  7 Oct 2016 14:24:11 -0300
Message-Id: <f04a83858232b0a3b39f270bc26ce43a8387ca94.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/af9005.c | 211 +++++++++++++++++++------------------
 1 file changed, 111 insertions(+), 100 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/af9005.c b/drivers/media/usb/dvb-usb/af9005.c
index efa782ed6e2d..cc5815de1cfb 100644
--- a/drivers/media/usb/dvb-usb/af9005.c
+++ b/drivers/media/usb/dvb-usb/af9005.c
@@ -52,17 +52,15 @@ u8 regmask[8] = { 0x01, 0x03, 0x07, 0x0f, 0x1f, 0x3f, 0x7f, 0xff };
 struct af9005_device_state {
 	u8 sequence;
 	int led_state;
+	unsigned char data[256];
 };
 
 static int af9005_generic_read_write(struct dvb_usb_device *d, u16 reg,
 			      int readwrite, int type, u8 * values, int len)
 {
 	struct af9005_device_state *st = d->priv;
-	u8 obuf[16] = { 0 };
-	u8 ibuf[17] = { 0 };
-	u8 command;
-	int i;
-	int ret;
+	u8 command, seq;
+	int i, ret;
 
 	if (len < 1) {
 		err("generic read/write, less than 1 byte. Makes no sense.");
@@ -73,16 +71,16 @@ static int af9005_generic_read_write(struct dvb_usb_device *d, u16 reg,
 		return -EINVAL;
 	}
 
-	obuf[0] = 14;		/* rest of buffer length low */
-	obuf[1] = 0;		/* rest of buffer length high */
+	st->data[0] = 14;		/* rest of buffer length low */
+	st->data[1] = 0;		/* rest of buffer length high */
 
-	obuf[2] = AF9005_REGISTER_RW;	/* register operation */
-	obuf[3] = 12;		/* rest of buffer length */
+	st->data[2] = AF9005_REGISTER_RW;	/* register operation */
+	st->data[3] = 12;		/* rest of buffer length */
 
-	obuf[4] = st->sequence++;	/* sequence number */
+	st->data[4] = seq = st->sequence++;	/* sequence number */
 
-	obuf[5] = (u8) (reg >> 8);	/* register address */
-	obuf[6] = (u8) (reg & 0xff);
+	st->data[5] = (u8) (reg >> 8);	/* register address */
+	st->data[6] = (u8) (reg & 0xff);
 
 	if (type == AF9005_OFDM_REG) {
 		command = AF9005_CMD_OFDM_REG;
@@ -96,49 +94,43 @@ static int af9005_generic_read_write(struct dvb_usb_device *d, u16 reg,
 	command |= readwrite;
 	if (readwrite == AF9005_CMD_WRITE)
 		for (i = 0; i < len; i++)
-			obuf[8 + i] = values[i];
+			st->data[8 + i] = values[i];
 	else if (type == AF9005_TUNER_REG)
 		/* read command for tuner, the first byte contains the i2c address */
-		obuf[8] = values[0];
-	obuf[7] = command;
+		st->data[8] = values[0];
+	st->data[7] = command;
 
-	ret = dvb_usb_generic_rw(d, obuf, 16, ibuf, 17, 0);
+	ret = dvb_usb_generic_rw(d, st->data, 16, st->data, 17, 0);
 	if (ret)
 		return ret;
 
 	/* sanity check */
-	if (ibuf[2] != AF9005_REGISTER_RW_ACK) {
+	if (st->data[2] != AF9005_REGISTER_RW_ACK) {
 		err("generic read/write, wrong reply code.");
 		return -EIO;
 	}
-	if (ibuf[3] != 0x0d) {
+	if (st->data[3] != 0x0d) {
 		err("generic read/write, wrong length in reply.");
 		return -EIO;
 	}
-	if (ibuf[4] != obuf[4]) {
+	if (st->data[4] != seq) {
 		err("generic read/write, wrong sequence in reply.");
 		return -EIO;
 	}
 	/*
-	   Windows driver doesn't check these fields, in fact sometimes
-	   the register in the reply is different that what has been sent
-
-	   if (ibuf[5] != obuf[5] || ibuf[6] != obuf[6]) {
-	   err("generic read/write, wrong register in reply.");
-	   return -EIO;
-	   }
-	   if (ibuf[7] != command) {
-	   err("generic read/write wrong command in reply.");
-	   return -EIO;
-	   }
+	 * In thesis, both input and output buffers should have
+	 * identical values for st->data[5] to st->data[8].
+	 * However, windows driver doesn't check these fields, in fact
+	 * sometimes the register in the reply is different that what
+	 * has been sent
 	 */
-	if (ibuf[16] != 0x01) {
+	if (st->data[16] != 0x01) {
 		err("generic read/write wrong status code in reply.");
 		return -EIO;
 	}
 	if (readwrite == AF9005_CMD_READ)
 		for (i = 0; i < len; i++)
-			values[i] = ibuf[8 + i];
+			values[i] = st->data[8 + i];
 
 	return 0;
 
@@ -464,8 +456,7 @@ int af9005_send_command(struct dvb_usb_device *d, u8 command, u8 * wbuf,
 	struct af9005_device_state *st = d->priv;
 
 	int ret, i, packet_len;
-	u8 buf[64];
-	u8 ibuf[64];
+	u8 seq;
 
 	if (wlen < 0) {
 		err("send command, wlen less than 0 bytes. Makes no sense.");
@@ -480,37 +471,37 @@ int af9005_send_command(struct dvb_usb_device *d, u8 command, u8 * wbuf,
 		return -EINVAL;
 	}
 	packet_len = wlen + 5;
-	buf[0] = (u8) (packet_len & 0xff);
-	buf[1] = (u8) ((packet_len & 0xff00) >> 8);
+	st->data[0] = (u8) (packet_len & 0xff);
+	st->data[1] = (u8) ((packet_len & 0xff00) >> 8);
 
-	buf[2] = 0x26;		/* packet type */
-	buf[3] = wlen + 3;
-	buf[4] = st->sequence++;
-	buf[5] = command;
-	buf[6] = wlen;
+	st->data[2] = 0x26;		/* packet type */
+	st->data[3] = wlen + 3;
+	st->data[4] = seq = st->sequence++;
+	st->data[5] = command;
+	st->data[6] = wlen;
 	for (i = 0; i < wlen; i++)
-		buf[7 + i] = wbuf[i];
-	ret = dvb_usb_generic_rw(d, buf, wlen + 7, ibuf, rlen + 7, 0);
+		st->data[7 + i] = wbuf[i];
+	ret = dvb_usb_generic_rw(d, st->data, wlen + 7, st->data, rlen + 7, 0);
 	if (ret)
 		return ret;
-	if (ibuf[2] != 0x27) {
+	if (st->data[2] != 0x27) {
 		err("send command, wrong reply code.");
 		return -EIO;
 	}
-	if (ibuf[4] != buf[4]) {
+	if (st->data[4] != seq) {
 		err("send command, wrong sequence in reply.");
 		return -EIO;
 	}
-	if (ibuf[5] != 0x01) {
+	if (st->data[5] != 0x01) {
 		err("send command, wrong status code in reply.");
 		return -EIO;
 	}
-	if (ibuf[6] != rlen) {
+	if (st->data[6] != rlen) {
 		err("send command, invalid data length in reply.");
 		return -EIO;
 	}
 	for (i = 0; i < rlen; i++)
-		rbuf[i] = ibuf[i + 7];
+		rbuf[i] = st->data[i + 7];
 	return 0;
 }
 
@@ -518,56 +509,56 @@ int af9005_read_eeprom(struct dvb_usb_device *d, u8 address, u8 * values,
 		       int len)
 {
 	struct af9005_device_state *st = d->priv;
-	u8 obuf[16], ibuf[14];
+	u8 seq;
 	int ret, i;
 
-	memset(obuf, 0, sizeof(obuf));
-	memset(ibuf, 0, sizeof(ibuf));
+	memset(st->data, 0, sizeof(st->data));
 
-	obuf[0] = 14;		/* length of rest of packet low */
-	obuf[1] = 0;		/* length of rest of packer high */
+	st->data[0] = 14;		/* length of rest of packet low */
+	st->data[1] = 0;		/* length of rest of packer high */
 
-	obuf[2] = 0x2a;		/* read/write eeprom */
+	st->data[2] = 0x2a;		/* read/write eeprom */
 
-	obuf[3] = 12;		/* size */
+	st->data[3] = 12;		/* size */
 
-	obuf[4] = st->sequence++;
+	st->data[4] = seq = st->sequence++;
 
-	obuf[5] = 0;		/* read */
+	st->data[5] = 0;		/* read */
 
-	obuf[6] = len;
-	obuf[7] = address;
-	ret = dvb_usb_generic_rw(d, obuf, 16, ibuf, 14, 0);
+	st->data[6] = len;
+	st->data[7] = address;
+	ret = dvb_usb_generic_rw(d, st->data, 16, st->data, 14, 0);
 	if (ret)
 		return ret;
-	if (ibuf[2] != 0x2b) {
+	if (st->data[2] != 0x2b) {
 		err("Read eeprom, invalid reply code");
 		return -EIO;
 	}
-	if (ibuf[3] != 10) {
+	if (st->data[3] != 10) {
 		err("Read eeprom, invalid reply length");
 		return -EIO;
 	}
-	if (ibuf[4] != obuf[4]) {
+	if (st->data[4] != seq) {
 		err("Read eeprom, wrong sequence in reply ");
 		return -EIO;
 	}
-	if (ibuf[5] != 1) {
+	if (st->data[5] != 1) {
 		err("Read eeprom, wrong status in reply ");
 		return -EIO;
 	}
 	for (i = 0; i < len; i++) {
-		values[i] = ibuf[6 + i];
+		values[i] = st->data[6 + i];
 	}
 	return 0;
 }
 
-static int af9005_boot_packet(struct usb_device *udev, int type, u8 * reply)
+static int af9005_boot_packet(struct usb_device *udev, int type, u8 *reply,
+			      u8 *buf, int size)
 {
-	u8 buf[FW_BULKOUT_SIZE + 2];
 	u16 checksum;
 	int act_len, i, ret;
-	memset(buf, 0, sizeof(buf));
+
+	memset(buf, 0, size);
 	buf[0] = (u8) (FW_BULKOUT_SIZE & 0xff);
 	buf[1] = (u8) ((FW_BULKOUT_SIZE >> 8) & 0xff);
 	switch (type) {
@@ -720,15 +711,21 @@ static int af9005_download_firmware(struct usb_device *udev, const struct firmwa
 {
 	int i, packets, ret, act_len;
 
-	u8 buf[FW_BULKOUT_SIZE + 2];
+	u8 *buf;
 	u8 reply;
 
-	ret = af9005_boot_packet(udev, FW_CONFIG, &reply);
+	buf = kmalloc(FW_BULKOUT_SIZE + 2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = af9005_boot_packet(udev, FW_CONFIG, &reply, buf,
+				 FW_BULKOUT_SIZE + 2);
 	if (ret)
-		return ret;
+		goto err;
 	if (reply != 0x01) {
 		err("before downloading firmware, FW_CONFIG expected 0x01, received 0x%x", reply);
-		return -EIO;
+		ret = -EIO;
+		goto err;
 	}
 	packets = fw->size / FW_BULKOUT_SIZE;
 	buf[0] = (u8) (FW_BULKOUT_SIZE & 0xff);
@@ -743,28 +740,35 @@ static int af9005_download_firmware(struct usb_device *udev, const struct firmwa
 				   buf, FW_BULKOUT_SIZE + 2, &act_len, 1000);
 		if (ret) {
 			err("firmware download failed at packet %d with code %d", i, ret);
-			return ret;
+			goto err;
 		}
 	}
-	ret = af9005_boot_packet(udev, FW_CONFIRM, &reply);
+	ret = af9005_boot_packet(udev, FW_CONFIRM, &reply,
+				 buf, FW_BULKOUT_SIZE + 2);
 	if (ret)
-		return ret;
+		goto err;
 	if (reply != (u8) (packets & 0xff)) {
 		err("after downloading firmware, FW_CONFIRM expected 0x%x, received 0x%x", packets & 0xff, reply);
-		return -EIO;
+		ret = -EIO;
+		goto err;
 	}
-	ret = af9005_boot_packet(udev, FW_BOOT, &reply);
+	ret = af9005_boot_packet(udev, FW_BOOT, &reply, buf,
+				 FW_BULKOUT_SIZE + 2);
 	if (ret)
-		return ret;
-	ret = af9005_boot_packet(udev, FW_CONFIG, &reply);
+		goto err;
+	ret = af9005_boot_packet(udev, FW_CONFIG, &reply, buf,
+				 FW_BULKOUT_SIZE + 2);
 	if (ret)
-		return ret;
+		goto err;
 	if (reply != 0x02) {
 		err("after downloading firmware, FW_CONFIG expected 0x02, received 0x%x", reply);
-		return -EIO;
+		ret = -EIO;
+		goto err;
 	}
 
-	return 0;
+err:
+	kfree(buf);
+	return ret;
 
 }
 
@@ -823,9 +827,7 @@ static int af9005_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 {
 	struct af9005_device_state *st = d->priv;
 	int ret, len;
-
-	u8 obuf[5];
-	u8 ibuf[256];
+	u8 seq;
 
 	*state = REMOTE_NO_KEY_PRESSED;
 	if (rc_decode == NULL) {
@@ -833,33 +835,33 @@ static int af9005_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 		return 0;
 	}
 	/* deb_info("rc_query\n"); */
-	obuf[0] = 3;		/* rest of packet length low */
-	obuf[1] = 0;		/* rest of packet lentgh high */
-	obuf[2] = 0x40;		/* read remote */
-	obuf[3] = 1;		/* rest of packet length */
-	obuf[4] = st->sequence++;	/* sequence number */
-	ret = dvb_usb_generic_rw(d, obuf, 5, ibuf, 256, 0);
+	st->data[0] = 3;		/* rest of packet length low */
+	st->data[1] = 0;		/* rest of packet lentgh high */
+	st->data[2] = 0x40;		/* read remote */
+	st->data[3] = 1;		/* rest of packet length */
+	st->data[4] = seq = st->sequence++;	/* sequence number */
+	ret = dvb_usb_generic_rw(d, st->data, 5, st->data, 256, 0);
 	if (ret) {
 		err("rc query failed");
 		return ret;
 	}
-	if (ibuf[2] != 0x41) {
+	if (st->data[2] != 0x41) {
 		err("rc query bad header.");
 		return -EIO;
 	}
-	if (ibuf[4] != obuf[4]) {
+	if (st->data[4] != seq) {
 		err("rc query bad sequence.");
 		return -EIO;
 	}
-	len = ibuf[5];
+	len = st->data[5];
 	if (len > 246) {
 		err("rc query invalid length");
 		return -EIO;
 	}
 	if (len > 0) {
 		deb_rc("rc data (%d) ", len);
-		debug_dump((ibuf + 6), len, deb_rc);
-		ret = rc_decode(d, &ibuf[6], len, event, state);
+		debug_dump((st->data + 6), len, deb_rc);
+		ret = rc_decode(d, &st->data[6], len, event, state);
 		if (ret) {
 			err("rc_decode failed");
 			return ret;
@@ -953,10 +955,16 @@ static int af9005_identify_state(struct usb_device *udev,
 				 int *cold)
 {
 	int ret;
-	u8 reply;
-	ret = af9005_boot_packet(udev, FW_CONFIG, &reply);
+	u8 reply, *buf;
+
+	buf = kmalloc(FW_BULKOUT_SIZE + 2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = af9005_boot_packet(udev, FW_CONFIG, &reply,
+				 buf, FW_BULKOUT_SIZE + 2);
 	if (ret)
-		return ret;
+		goto err;
 	deb_info("result of FW_CONFIG in identify state %d\n", reply);
 	if (reply == 0x01)
 		*cold = 1;
@@ -965,7 +973,10 @@ static int af9005_identify_state(struct usb_device *udev,
 	else
 		return -EIO;
 	deb_info("Identify state cold = %d\n", *cold);
-	return 0;
+
+err:
+	kfree(buf);
+	return ret;
 }
 
 static struct dvb_usb_device_properties af9005_properties;
-- 
2.7.4



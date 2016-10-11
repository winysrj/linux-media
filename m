Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39723 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752433AbcJKKf1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 06:35:27 -0400
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
        =?UTF-8?q?J=C3=B6rg=20Otte?= <jrg.otte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 09/31] dibusb: don't do DMA on stack
Date: Tue, 11 Oct 2016 07:09:24 -0300
Message-Id: <61de69abf011c9514a4222cc3571a81436d869a3.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476179975.git.mchehab@s-opensource.com>
References: <cover.1476179975.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB control messages require DMA to work. We cannot pass
a stack-allocated buffer, as it is not warranted that the
stack would be into a DMA enabled area.

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 107 +++++++++++++++++++++++-------
 drivers/media/usb/dvb-usb/dibusb.h        |   3 +
 2 files changed, 85 insertions(+), 25 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index 4b08c2a47ae2..951f3dac9082 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -63,72 +63,117 @@ EXPORT_SYMBOL(dibusb_pid_filter_ctrl);
 
 int dibusb_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	u8 b[3];
+	u8 *b;
 	int ret;
+
+	b = kmalloc(3, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
 	b[0] = DIBUSB_REQ_SET_IOCTL;
 	b[1] = DIBUSB_IOCTL_CMD_POWER_MODE;
 	b[2] = onoff ? DIBUSB_IOCTL_POWER_WAKEUP : DIBUSB_IOCTL_POWER_SLEEP;
-	ret = dvb_usb_generic_write(d,b,3);
+
+	ret = dvb_usb_generic_write(d, b, 3);
+
+	kfree(b);
+
 	msleep(10);
+
 	return ret;
 }
 EXPORT_SYMBOL(dibusb_power_ctrl);
 
 int dibusb2_0_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	u8 b[3] = { 0 };
 	int ret;
+	u8 *b;
+
+	b = kmalloc(3, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
 
 	if ((ret = dibusb_streaming_ctrl(adap,onoff)) < 0)
-		return ret;
+		goto ret;
 
 	if (onoff) {
 		b[0] = DIBUSB_REQ_SET_STREAMING_MODE;
 		b[1] = 0x00;
-		if ((ret = dvb_usb_generic_write(adap->dev,b,2)) < 0)
-			return ret;
+		ret = dvb_usb_generic_write(adap->dev, b, 2);
+		if (ret  < 0)
+			goto ret;
 	}
 
 	b[0] = DIBUSB_REQ_SET_IOCTL;
 	b[1] = onoff ? DIBUSB_IOCTL_CMD_ENABLE_STREAM : DIBUSB_IOCTL_CMD_DISABLE_STREAM;
-	return dvb_usb_generic_write(adap->dev,b,3);
+	ret = dvb_usb_generic_write(adap->dev, b, 3);
+
+ret:
+	kfree(b);
+	return ret;
 }
 EXPORT_SYMBOL(dibusb2_0_streaming_ctrl);
 
 int dibusb2_0_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
-	if (onoff) {
-		u8 b[3] = { DIBUSB_REQ_SET_IOCTL, DIBUSB_IOCTL_CMD_POWER_MODE, DIBUSB_IOCTL_POWER_WAKEUP };
-		return dvb_usb_generic_write(d,b,3);
-	} else
+	u8 *b;
+	int ret;
+
+	if (!onoff)
 		return 0;
+
+	b = kmalloc(3, GFP_KERNEL);
+	if (!b)
+		return -ENOMEM;
+
+	b[0] = DIBUSB_REQ_SET_IOCTL;
+	b[1] = DIBUSB_IOCTL_CMD_POWER_MODE;
+	b[2] = DIBUSB_IOCTL_POWER_WAKEUP;
+
+	ret = dvb_usb_generic_write(d, b, 3);
+
+	kfree(b);
+
+	return ret;
 }
 EXPORT_SYMBOL(dibusb2_0_power_ctrl);
 
 static int dibusb_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
-	u8 sndbuf[MAX_XFER_SIZE]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */
+	u8 *sndbuf;
+	int ret, wo, len;
+
 	/* write only ? */
-	int wo = (rbuf == NULL || rlen == 0),
-		len = 2 + wlen + (wo ? 0 : 2);
+	wo = (rbuf == NULL || rlen == 0);
 
-	if (4 + wlen > sizeof(sndbuf)) {
+	len = 2 + wlen + (wo ? 0 : 2);
+
+	sndbuf = kmalloc(MAX_XFER_SIZE, GFP_KERNEL);
+	if (!sndbuf)
+		return -ENOMEM;
+
+	if (4 + wlen > MAX_XFER_SIZE) {
 		warn("i2c wr: len=%d is too big!\n", wlen);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto ret;
 	}
 
 	sndbuf[0] = wo ? DIBUSB_REQ_I2C_WRITE : DIBUSB_REQ_I2C_READ;
 	sndbuf[1] = (addr << 1) | (wo ? 0 : 1);
 
-	memcpy(&sndbuf[2],wbuf,wlen);
+	memcpy(&sndbuf[2], wbuf, wlen);
 
 	if (!wo) {
-		sndbuf[wlen+2] = (rlen >> 8) & 0xff;
-		sndbuf[wlen+3] = rlen & 0xff;
+		sndbuf[wlen + 2] = (rlen >> 8) & 0xff;
+		sndbuf[wlen + 3] = rlen & 0xff;
 	}
 
-	return dvb_usb_generic_rw(d,sndbuf,len,rbuf,rlen,0);
+	ret = dvb_usb_generic_rw(d, sndbuf, len, rbuf, rlen, 0);
+
+ret:
+	kfree(sndbuf);
+	return ret;
 }
 
 /*
@@ -320,11 +365,23 @@ EXPORT_SYMBOL(rc_map_dibusb_table);
 
 int dibusb_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	u8 key[5],cmd = DIBUSB_REQ_POLL_REMOTE;
-	dvb_usb_generic_rw(d,&cmd,1,key,5,0);
-	dvb_usb_nec_rc_key_to_event(d,key,event,state);
-	if (key[0] != 0)
-		deb_info("key: %*ph\n", 5, key);
+	u8 *buf;
+
+	buf = kmalloc(5, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	buf[0] = DIBUSB_REQ_POLL_REMOTE;
+
+	dvb_usb_generic_rw(d, buf, 1, buf, 5, 0);
+
+	dvb_usb_nec_rc_key_to_event(d, buf, event, state);
+
+	if (buf[0] != 0)
+		deb_info("key: %*ph\n", 5, buf);
+
+	kfree(buf);
+
 	return 0;
 }
 EXPORT_SYMBOL(dibusb_rc_query);
diff --git a/drivers/media/usb/dvb-usb/dibusb.h b/drivers/media/usb/dvb-usb/dibusb.h
index 3f82163d8ab8..697be2a17ade 100644
--- a/drivers/media/usb/dvb-usb/dibusb.h
+++ b/drivers/media/usb/dvb-usb/dibusb.h
@@ -96,6 +96,9 @@
 #define DIBUSB_IOCTL_CMD_ENABLE_STREAM	0x01
 #define DIBUSB_IOCTL_CMD_DISABLE_STREAM	0x02
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct dibusb_state {
 	struct dib_fe_xfer_ops ops;
 	int mt2060_present;
-- 
2.7.4



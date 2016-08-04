Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:52625 "EHLO smtp.220.in.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758999AbcHDUxc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 16:53:32 -0400
Subject: Evromedia USB Full Hybrid Full HD works!!!
To: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
References: <1470297242-32129-1-git-send-email-oleg@kaa.org.ua>
 <CAAZRmGxM8U+PBfP4RWfnLDH0gdw+2oSuMAivzYBxRqSqTPM4FQ@mail.gmail.com>
 <57A31865.7030100@kaa.org.ua>
 <CAAZRmGykv5LOmBxKYNUgi07+Rt=OTN3_+Cdu7BUGT0KbY0LPiA@mail.gmail.com>
 <57A32F2A.5010505@kaa.org.ua> <57A34D1E.8070306@kaa.org.ua>
From: Oleh Kravchenko <oleg@kaa.org.ua>
Cc: linux-media <linux-media@vger.kernel.org>
Message-ID: <56406d96-8a2b-cd47-dca6-a52649beb530@kaa.org.ua>
Date: Thu, 4 Aug 2016 23:46:05 +0300
MIME-Version: 1.0
In-Reply-To: <57A34D1E.8070306@kaa.org.ua>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Antti, Olli!

I tried media-video/kaffeine and now I have all 32 channels which
translated in Kyiv, Ukraine!
https://owncloud.kaa.org.ua/index.php/s/SvyIiTry3u7zZqj

What I should do with `si2157_ops` structure?
si2147 and si2157 have 42-870 MHz frequency range, but si2158 have
42-1002 MHz frequency range!
Should I define second `dvb_tuner_ops` structure?

Also, Evromedia USB Full Hybrid Full HD require changes in
cx231xx_i2c_send_bytes(), like this:
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -171,6 +171,43 @@ static int cx231xx_i2c_send_bytes(
	bus->i2c_nostop = 0;
	bus->i2c_reserve = 0;
+//} else if (is_tuner(dev, bus, msg, TUNER_SI2158)) {
+} else if (0x60 == msg->addr && msg->len > 4) {
+	size = msg->len;
+
+	/* special case for Evromedia USB Full Hybrid Full HD */
+	saddr_len = 1;
+
+	/* adjust the length to correct length */
+	size -= saddr_len;
+
+	buf_ptr = (u8 *) (msg->buf + 1);
+
+	do {
+		/* prepare xfer_data struct */
+		req_data.dev_addr = msg->addr;
+		req_data.direction = msg->flags;
+		req_data.saddr_len = saddr_len;
+		req_data.saddr_dat = msg->buf[0];
+		req_data.buf_size = size > 4 ? 4 : size;
+		req_data.p_buffer = (u8 *) (buf_ptr + loop * 4);
+
+		bus->i2c_nostop = (size > 4) ? 1 : 0;
+		bus->i2c_reserve = (loop == 0) ? 0 : 1;
+
+		/* usb send command */
+		status = dev->cx231xx_send_usb_command(bus, &req_data);
+		++ loop;
+
+		if (size >= 4)
+			size -= 4;
+		else
+			size = 0;
+
+	} while (size > 0);
+
+	bus->i2c_nostop = 0;
+	bus->i2c_reserve = 0;
How I can implement this in right way? :) Any ideas?

PS:
\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01
also fine for si2158, I have signal!


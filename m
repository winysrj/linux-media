Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60807 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3KBQe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:34:56 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 24/29] dibusb-common: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:32 -0200
Message-Id: <1383399097-11615-25-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/usb/dvb-usb/dibusb-common.c:124:1: warning: 'dibusb_i2c_msg' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (80 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index c2dded92f1d3..ae9eed810bc2 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -105,11 +105,16 @@ EXPORT_SYMBOL(dibusb2_0_power_ctrl);
 static int dibusb_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
-	u8 sndbuf[wlen+4]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */
+	u8 sndbuf[80]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */
 	/* write only ? */
 	int wo = (rbuf == NULL || rlen == 0),
 		len = 2 + wlen + (wo ? 0 : 2);
 
+	if (4 + wlen > sizeof(sndbuf)) {
+		warn("i2c wr: len=%d is too big!\n", wlen);
+		return -EREMOTEIO;
+	}
+
 	sndbuf[0] = wo ? DIBUSB_REQ_I2C_WRITE : DIBUSB_REQ_I2C_READ;
 	sndbuf[1] = (addr << 1) | (wo ? 0 : 1);
 
-- 
1.8.3.1


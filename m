Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43301 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3KENDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:51 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 23/29] [media] dibusb-common: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:36 -0200
Message-Id: <1383645702-30636-24-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb/dibusb-common.c:124:1: warning: 'dibusb_i2c_msg' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/dvb-usb/dibusb-common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/dibusb-common.c b/drivers/media/usb/dvb-usb/dibusb-common.c
index c2dded92f1d3..6d68af0c49c8 100644
--- a/drivers/media/usb/dvb-usb/dibusb-common.c
+++ b/drivers/media/usb/dvb-usb/dibusb-common.c
@@ -12,6 +12,9 @@
 #include <linux/kconfig.h>
 #include "dibusb.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info (|-able))." DVB_USB_DEBUG_STATUS);
@@ -105,11 +108,16 @@ EXPORT_SYMBOL(dibusb2_0_power_ctrl);
 static int dibusb_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			  u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
-	u8 sndbuf[wlen+4]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */
+	u8 sndbuf[MAX_XFER_SIZE]; /* lead(1) devaddr,direction(1) addr(2) data(wlen) (len(2) (when reading)) */
 	/* write only ? */
 	int wo = (rbuf == NULL || rlen == 0),
 		len = 2 + wlen + (wo ? 0 : 2);
 
+	if (4 + wlen > sizeof(sndbuf)) {
+		warn("i2c wr: len=%d is too big!\n", wlen);
+		return -EOPNOTSUPP;
+	}
+
 	sndbuf[0] = wo ? DIBUSB_REQ_I2C_WRITE : DIBUSB_REQ_I2C_READ;
 	sndbuf[1] = (addr << 1) | (wo ? 0 : 1);
 
-- 
1.8.3.1


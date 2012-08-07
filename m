Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab2HGQmz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:55 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/11] dvb-usb: use %*ph to dump small buffers
Date: Tue,  7 Aug 2012 19:43:04 +0300
Message-Id: <1344357792-18202-4-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb/af9015.c   |    3 +--
 drivers/media/dvb/dvb-usb/af9035.c   |    3 +--
 drivers/media/dvb/dvb-usb/pctv452e.c |    7 +++----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 677fed7..ae1a01b 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1053,8 +1053,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
-		deb_rc("%s: key pressed %02x %02x %02x %02x\n", __func__,
-			buf[12], buf[13], buf[14], buf[15]);
+		deb_rc("%s: key pressed %*ph\n", __func__, 4, buf + 12);
 
 		/* Reset the canary */
 		ret = af9015_write_reg(d, 0x98e9, 0xff);
diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index e83b39d..01e3321 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -393,8 +393,7 @@ static int af9035_identify_state(struct usb_device *udev,
 	if (ret < 0)
 		goto err;
 
-	pr_debug("%s: reply=%02x %02x %02x %02x\n", __func__,
-		rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
+	pr_debug("%s: reply=%*ph\n", __func__, 4, rbuf);
 	if (rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])
 		*cold = 0;
 	else
diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-usb/pctv452e.c
index f526eb0..02e8785 100644
--- a/drivers/media/dvb/dvb-usb/pctv452e.c
+++ b/drivers/media/dvb/dvb-usb/pctv452e.c
@@ -136,8 +136,8 @@ static int tt3650_ci_msg(struct dvb_usb_device *d, u8 cmd, u8 *data,
 	return 0;
 
 failed:
-	err("CI error %d; %02X %02X %02X -> %02X %02X %02X.",
-	     ret, SYNC_BYTE_OUT, id, cmd, buf[0], buf[1], buf[2]);
+	err("CI error %d; %02X %02X %02X -> %*ph.",
+	     ret, SYNC_BYTE_OUT, id, cmd, 3, buf);
 
 	return ret;
 }
@@ -556,8 +556,7 @@ static int pctv452e_rc_query(struct dvb_usb_device *d)
 		return ret;
 
 	if (debug > 3) {
-		info("%s: read: %2d: %02x %02x %02x: ", __func__,
-				ret, rx[0], rx[1], rx[2]);
+		info("%s: read: %2d: %*ph: ", __func__, ret, 3, rx);
 		for (i = 0; (i < rx[3]) && ((i+3) < PCTV_ANSWER_LEN); i++)
 			info(" %02x", rx[i+3]);
 
-- 
1.7.10.4


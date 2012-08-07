Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52414 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031112Ab2HGW5F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 18:57:05 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] dvb-usb: use %*ph to dump small buffers
Date: Wed,  8 Aug 2012 01:56:35 +0300
Message-Id: <1344380196-9488-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[crope@iki.fi: fix trivial merge conflict]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/dvb-usb-v2/af9015.c | 3 +--
 drivers/media/dvb/dvb-usb-v2/af9035.c | 3 +--
 drivers/media/dvb/dvb-usb/pctv452e.c  | 7 +++----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/af9015.c b/drivers/media/dvb/dvb-usb-v2/af9015.c
index 10363f6..e77429b 100644
--- a/drivers/media/dvb/dvb-usb-v2/af9015.c
+++ b/drivers/media/dvb/dvb-usb-v2/af9015.c
@@ -1199,8 +1199,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
-		deb_rc("%s: key pressed %02x %02x %02x %02x\n", __func__,
-			buf[12], buf[13], buf[14], buf[15]);
+		deb_rc("%s: key pressed %*ph\n", __func__, 4, buf + 12);
 
 		/* Reset the canary */
 		ret = af9015_write_reg(d, 0x98e9, 0xff);
diff --git a/drivers/media/dvb/dvb-usb-v2/af9035.c b/drivers/media/dvb/dvb-usb-v2/af9035.c
index 79197f4..bb90b87 100644
--- a/drivers/media/dvb/dvb-usb-v2/af9035.c
+++ b/drivers/media/dvb/dvb-usb-v2/af9035.c
@@ -290,8 +290,7 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	if (ret < 0)
 		goto err;
 
-	pr_debug("%s: reply=%02x %02x %02x %02x\n", __func__,
-		rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
+	pr_debug("%s: reply=%*ph\n", __func__, 4, rbuf);
 	if (rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])
 		ret = WARM;
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
1.7.11.2


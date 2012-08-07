Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2HGQmz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:55 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/11] dvb: frontends: use %*ph to dump small buffers
Date: Tue,  7 Aug 2012 19:43:05 +0300
Message-Id: <1344357792-18202-5-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/cxd2820r_t.c |    3 +--
 drivers/media/dvb/frontends/nxt200x.c    |    8 +++-----
 drivers/media/dvb/frontends/rtl2830.c    |    2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r_t.c b/drivers/media/dvb/frontends/cxd2820r_t.c
index 1a02623..e5dd22b 100644
--- a/drivers/media/dvb/frontends/cxd2820r_t.c
+++ b/drivers/media/dvb/frontends/cxd2820r_t.c
@@ -389,8 +389,7 @@ int cxd2820r_read_status_t(struct dvb_frontend *fe, fe_status_t *status)
 		}
 	}
 
-	dbg("%s: lock=%02x %02x %02x %02x", __func__,
-		buf[0], buf[1], buf[2], buf[3]);
+	dbg("%s: lock=%*ph", __func__, 4, buf);
 
 	return ret;
 error:
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index 03af52e..8e28894 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -331,7 +331,7 @@ static int nxt200x_writetuner (struct nxt200x_state* state, u8* data)
 
 	dprintk("%s\n", __func__);
 
-	dprintk("Tuner Bytes: %02X %02X %02X %02X\n", data[1], data[2], data[3], data[4]);
+	dprintk("Tuner Bytes: %*ph\n", 4, data + 1);
 
 	/* if NXT2004, write directly to tuner. if NXT2002, write through NXT chip.
 	 * direct write is required for Philips TUV1236D and ALPS TDHU2 */
@@ -1161,8 +1161,7 @@ struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 
 	/* read card id */
 	nxt200x_readbytes(state, 0x00, buf, 5);
-	dprintk("NXT info: %02X %02X %02X %02X %02X\n",
-		buf[0], buf[1], buf[2],	buf[3], buf[4]);
+	dprintk("NXT info: %*ph\n", 5, buf);
 
 	/* set demod chip */
 	switch (buf[0]) {
@@ -1201,8 +1200,7 @@ struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 
 error:
 	kfree(state);
-	printk("Unknown/Unsupported NXT chip: %02X %02X %02X %02X %02X\n",
-		buf[0], buf[1], buf[2], buf[3], buf[4]);
+	pr_err("Unknown/Unsupported NXT chip: %*ph\n", 5, buf);
 	return NULL;
 }
 
diff --git a/drivers/media/dvb/frontends/rtl2830.c b/drivers/media/dvb/frontends/rtl2830.c
index 93612eb..8fa8b08 100644
--- a/drivers/media/dvb/frontends/rtl2830.c
+++ b/drivers/media/dvb/frontends/rtl2830.c
@@ -392,7 +392,7 @@ static int rtl2830_get_frontend(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	dbg("%s: TPS=%02x %02x %02x", __func__, buf[0], buf[1], buf[2]);
+	dbg("%s: TPS=%*ph", __func__, 3, buf);
 
 	switch ((buf[0] >> 2) & 3) {
 	case 0:
-- 
1.7.10.4


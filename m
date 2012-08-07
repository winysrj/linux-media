Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49633 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab2HGQmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:54 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 03/11] common: tunners: use %*ph to dump small buffers
Date: Tue,  7 Aug 2012 19:43:03 +0300
Message-Id: <1344357792-18202-3-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |    3 +--
 drivers/media/common/tuners/xc4000.c       |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index ea0550e..5d86b26 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -1126,8 +1126,7 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 
 	priv->frequency = freq;
 
-	tuner_dbg("divisor= %02x %02x %02x %02x (freq=%d.%03d)\n",
-	       buf[0], buf[1], buf[2], buf[3],
+	tuner_dbg("divisor= %*ph (freq=%d.%03d)\n", 4, buf,
 	       freq / 1000000, (freq % 1000000) / 1000);
 
 	rc = 0;
diff --git a/drivers/media/common/tuners/xc4000.c b/drivers/media/common/tuners/xc4000.c
index 6839711..4937712 100644
--- a/drivers/media/common/tuners/xc4000.c
+++ b/drivers/media/common/tuners/xc4000.c
@@ -263,8 +263,7 @@ static int xc_send_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
 			printk(KERN_ERR "xc4000: I2C write failed (len=%i)\n",
 			       len);
 			if (len == 4) {
-				printk(KERN_ERR "bytes %02x %02x %02x %02x\n", buf[0],
-				       buf[1], buf[2], buf[3]);
+				printk(KERN_ERR "bytes %*ph\n", 4, buf);
 			}
 			return -EREMOTEIO;
 		}
-- 
1.7.10.4


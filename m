Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44706 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab2HBQGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 12:06:18 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 05/12] staging: lirc: use %*ph to print small buffers
Date: Thu,  2 Aug 2012 19:05:45 +0300
Message-Id: <1343923552-8683-5-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1343923552-8683-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1343923552-8683-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/staging/media/lirc/lirc_igorplugusb.c |    4 ++--
 drivers/staging/media/lirc/lirc_zilog.c       |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
index 7a25017..939a801 100644
--- a/drivers/staging/media/lirc/lirc_igorplugusb.c
+++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
@@ -325,8 +325,8 @@ static int igorplugusb_remote_poll(void *data, struct lirc_buffer *buf)
 		if (ret < DEVICE_HEADERLEN)
 			return -ENODATA;
 
-		dprintk(DRIVER_NAME ": Got %d bytes. Header: %02x %02x %02x\n",
-			ret, ir->buf_in[0], ir->buf_in[1], ir->buf_in[2]);
+		dprintk(DRIVER_NAME ": Got %d bytes. Header: %*ph\n",
+			ret, 3, ir->buf_in);
 
 		do_gettimeofday(&now);
 		timediff = now.tv_sec - ir->last_time.tv_sec;
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 76ea4a8..11d5338 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -658,8 +658,7 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
 		buf[0] = (unsigned char)(i + 1);
 		for (j = 0; j < tosend; ++j)
 			buf[1 + j] = data_block[i + j];
-		dprintk("%02x %02x %02x %02x %02x",
-			buf[0], buf[1], buf[2], buf[3], buf[4]);
+		dprintk("%*ph", 5, buf);
 		ret = i2c_master_send(tx->c, buf, tosend + 1);
 		if (ret != tosend + 1) {
 			zilog_error("i2c_master_send failed with %d\n", ret);
-- 
1.7.10.4


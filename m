Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:41482 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab2HMTzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 15:55:07 -0400
Message-Id: <E1T10ix-0000as-0D@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Mon, 13 Aug 2012 21:31:12 +0200
Subject: [git:v4l-dvb/for_v3.7] [media] staging: lirc: use %*ph to print small buffers
To: linuxtv-commits@linuxtv.org
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] staging: lirc: use %*ph to print small buffers
Author:  Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date:    Thu Aug 2 12:05:45 2012 -0300

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/staging/media/lirc/lirc_igorplugusb.c |    4 ++--
 drivers/staging/media/lirc/lirc_zilog.c       |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=727b81da25dd7a7374837c0d0e6189bb3f6ae202

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

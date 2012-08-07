Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6113 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab2HGQnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:43:03 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 08/11] dvb: use %*ph to hexdump small buffers
Date: Tue,  7 Aug 2012 19:43:08 +0300
Message-Id: <1344357792-18202-8-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/dvb/b2c2/flexcop-usb.c |    5 +----
 drivers/media/dvb/bt8xx/dst_ca.c     |    3 ++-
 drivers/media/dvb/dvb-core/dmxdev.c  |    4 +---
 drivers/media/dvb/ngene/ngene-core.c |   14 ++++----------
 4 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/b2c2/flexcop-usb.c b/drivers/media/dvb/b2c2/flexcop-usb.c
index 26c666d..8b6275f 100644
--- a/drivers/media/dvb/b2c2/flexcop-usb.c
+++ b/drivers/media/dvb/b2c2/flexcop-usb.c
@@ -324,10 +324,7 @@ static void flexcop_usb_process_frame(struct flexcop_usb *fc_usb,
 					flexcop_pass_dmx_packets(
 							fc_usb->fc_dev, b+2, 1);
 				else
-					deb_ts(
-					"not ts packet %02x %02x %02x %02x \n",
-						*(b+2), *(b+3),
-						*(b+4), *(b+5));
+					deb_ts("not ts packet %*ph\n", 4, b+2);
 				b += 190;
 				l -= 190;
 				break;
diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 66f52f1..ee3884f 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -321,7 +321,8 @@ static int ca_get_message(struct dst_state *state, struct ca_msg *p_ca_message,
 		return -EFAULT;
 
 	if (p_ca_message->msg) {
-		dprintk(verbose, DST_CA_NOTICE, 1, " Message = [%02x %02x %02x]", p_ca_message->msg[0], p_ca_message->msg[1], p_ca_message->msg[2]);
+		dprintk(verbose, DST_CA_NOTICE, 1, " Message = [%*ph]",
+			3, p_ca_message->msg);
 
 		for (i = 0; i < 3; i++) {
 			command = command | p_ca_message->msg[i];
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index 73970cd..889c9c1 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -370,9 +370,7 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 		return 0;
 	}
 	del_timer(&dmxdevfilter->timer);
-	dprintk("dmxdev: section callback %02x %02x %02x %02x %02x %02x\n",
-		buffer1[0], buffer1[1],
-		buffer1[2], buffer1[3], buffer1[4], buffer1[5]);
+	dprintk("dmxdev: section callback %*ph\n", 6, buffer1);
 	ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer1,
 				      buffer1_len);
 	if (ret == buffer1_len) {
diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index 3985738..c8e0d5b 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -258,22 +258,16 @@ static void dump_command_io(struct ngene *dev)
 	u8 buf[8], *b;
 
 	ngcpyfrom(buf, HOST_TO_NGENE, 8);
-	printk(KERN_ERR "host_to_ngene (%04x): %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		HOST_TO_NGENE, buf[0], buf[1], buf[2], buf[3],
-		buf[4], buf[5], buf[6], buf[7]);
+	printk(KERN_ERR "host_to_ngene (%04x): %*ph\n", HOST_TO_NGENE, 8, buf);
 
 	ngcpyfrom(buf, NGENE_TO_HOST, 8);
-	printk(KERN_ERR "ngene_to_host (%04x): %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		NGENE_TO_HOST, buf[0], buf[1], buf[2], buf[3],
-		buf[4], buf[5], buf[6], buf[7]);
+	printk(KERN_ERR "ngene_to_host (%04x): %*ph\n", NGENE_TO_HOST, 8, buf);
 
 	b = dev->hosttongene;
-	printk(KERN_ERR "dev->hosttongene (%p): %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		b, b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7]);
+	printk(KERN_ERR "dev->hosttongene (%p): %*ph\n", b, 8, b);
 
 	b = dev->ngenetohost;
-	printk(KERN_ERR "dev->ngenetohost (%p): %02x %02x %02x %02x %02x %02x %02x %02x\n",
-		b, b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7]);
+	printk(KERN_ERR "dev->ngenetohost (%p): %*ph\n", b, 8, b);
 }
 
 static int ngene_command_mutex(struct ngene *dev, struct ngene_command *com)
-- 
1.7.10.4


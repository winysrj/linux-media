Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46768 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756337Ab2JZNkz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 09:40:55 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] dvb-frontends: use %*ph[N] to dump small buffers
Date: Fri, 26 Oct 2012 16:40:45 +0300
Message-Id: <1351258846-17829-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/dvb-frontends/ix2505v.c |    2 +-
 drivers/media/dvb-frontends/or51211.c |    5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/ix2505v.c b/drivers/media/dvb-frontends/ix2505v.c
index bc5a820..0e3387e 100644
--- a/drivers/media/dvb-frontends/ix2505v.c
+++ b/drivers/media/dvb-frontends/ix2505v.c
@@ -212,7 +212,7 @@ static int ix2505v_set_params(struct dvb_frontend *fe)
 		lpf = 0xb;
 
 	deb_info("Osc=%x b_w=%x lpf=%x\n", local_osc, b_w, lpf);
-	deb_info("Data 0=[%x%x%x%x]\n", data[0], data[1], data[2], data[3]);
+	deb_info("Data 0=[%4phN]\n", data);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index c625b57..1af997e 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -471,10 +471,7 @@ static int or51211_init(struct dvb_frontend* fe)
 			  i--;
 			}
 		}
-		dprintk("read_fwbits %x %x %x %x %x %x %x %x %x %x\n",
-			rec_buf[0], rec_buf[1], rec_buf[2], rec_buf[3],
-			rec_buf[4], rec_buf[5], rec_buf[6], rec_buf[7],
-			rec_buf[8], rec_buf[9]);
+		dprintk("read_fwbits %10ph\n", rec_buf);
 
 		printk(KERN_INFO "or51211: ver TU%02x%02x%02x VSB mode %02x"
 		       " Status %02x\n",
-- 
1.7.10.4


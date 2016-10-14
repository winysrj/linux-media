Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59075 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756557AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 38/57] [media] dvb-usb-v2: don't break long lines
Date: Fri, 14 Oct 2016 17:20:26 -0300
Message-Id: <4d9d911d653b33d5f0a9e014fb07dd7aad8633a9.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c | 10 +++-------
 drivers/media/usb/dvb-usb-v2/mxl111sf.c     |  9 +++------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
index 283495c84ba3..ea39056412c5 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
@@ -666,8 +666,7 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
 
 				if (rd_status[i] == 0x04) {
 					if (i < 7) {
-						mxl_i2c("i2c fifo empty!"
-							" @ %d", i);
+						mxl_i2c("i2c fifo empty! @ %d", i);
 						msg->buf[(index*8)+i] =
 							i2c_r_data[(i*3)+1];
 						/* read again */
@@ -692,8 +691,7 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
 							}
 							goto stop_copy;
 						} else {
-							mxl_i2c("readagain "
-								"ERROR!");
+							mxl_i2c("readagain ERROR!");
 						}
 					} else {
 						msg->buf[(index*8)+i] =
@@ -827,9 +825,7 @@ int mxl111sf_i2c_xfer(struct i2c_adapter *adap,
 			mxl111sf_i2c_hw_xfer_msg(state, &msg[i]) :
 			mxl111sf_i2c_sw_xfer_msg(state, &msg[i]);
 		if (mxl_fail(ret)) {
-			mxl_debug_adv("failed with error %d on i2c "
-				      "transaction %d of %d, %sing %d bytes "
-				      "to/from 0x%02x", ret, i+1, num,
+			mxl_debug_adv("failed with error %d on i2c transaction %d of %d, %sing %d bytes to/from 0x%02x", ret, i+1, num,
 				      (msg[i].flags & I2C_M_RD) ?
 				      "read" : "writ",
 				      msg[i].len, msg[i].addr);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 5d676b533a3a..58da619b7c59 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -29,8 +29,7 @@
 
 int dvb_usb_mxl111sf_debug;
 module_param_named(debug, dvb_usb_mxl111sf_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level "
-		 "(1=info, 2=xfer, 4=i2c, 8=reg, 16=adv (or-able)).");
+MODULE_PARM_DESC(debug, "set debugging level (1=info, 2=xfer, 4=i2c, 8=reg, 16=adv (or-able)).");
 
 static int dvb_usb_mxl111sf_isoc;
 module_param_named(isoc, dvb_usb_mxl111sf_isoc, int, 0644);
@@ -137,8 +136,7 @@ int mxl111sf_write_reg_mask(struct mxl111sf_state *state,
 #if 1
 		/* dont know why this usually errors out on the first try */
 		if (mxl_fail(ret))
-			pr_err("error writing addr: 0x%02x, mask: 0x%02x, "
-			    "data: 0x%02x, retrying...", addr, mask, data);
+			pr_err("error writing addr: 0x%02x, mask: 0x%02x, data: 0x%02x, retrying...", addr, mask, data);
 
 		ret = mxl111sf_read_reg(state, addr, &val);
 #endif
@@ -946,8 +944,7 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 	case 138001:
 		break;
 	default:
-		printk(KERN_WARNING "%s: warning: "
-		       "unknown hauppauge model #%d\n",
+		printk(KERN_WARNING "%s: warning: unknown hauppauge model #%d\n",
 		       __func__, state->tv.model);
 	}
 #endif
-- 
2.7.4



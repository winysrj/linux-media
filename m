Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935636AbcJRUqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 36/58] dvb-usb-v2: don't break long lines
Date: Tue, 18 Oct 2016 18:45:48 -0200
Message-Id: <901831899f2a4f1b2de42b423cdec32f18806952.1476822925.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c | 12 +++++-------
 drivers/media/usb/dvb-usb-v2/mxl111sf.c     | 10 ++++------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
index 283495c84ba3..6427137a09ef 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
@@ -666,8 +666,8 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
 
 				if (rd_status[i] == 0x04) {
 					if (i < 7) {
-						mxl_i2c("i2c fifo empty!"
-							" @ %d", i);
+						mxl_i2c("i2c fifo empty! @ %d",
+							i);
 						msg->buf[(index*8)+i] =
 							i2c_r_data[(i*3)+1];
 						/* read again */
@@ -692,8 +692,7 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
 							}
 							goto stop_copy;
 						} else {
-							mxl_i2c("readagain "
-								"ERROR!");
+							mxl_i2c("readagain ERROR!");
 						}
 					} else {
 						msg->buf[(index*8)+i] =
@@ -827,9 +826,8 @@ int mxl111sf_i2c_xfer(struct i2c_adapter *adap,
 			mxl111sf_i2c_hw_xfer_msg(state, &msg[i]) :
 			mxl111sf_i2c_sw_xfer_msg(state, &msg[i]);
 		if (mxl_fail(ret)) {
-			mxl_debug_adv("failed with error %d on i2c "
-				      "transaction %d of %d, %sing %d bytes "
-				      "to/from 0x%02x", ret, i+1, num,
+			mxl_debug_adv("failed with error %d on i2c transaction %d of %d, %sing %d bytes to/from 0x%02x",
+				      ret, i+1, num,
 				      (msg[i].flags & I2C_M_RD) ?
 				      "read" : "writ",
 				      msg[i].len, msg[i].addr);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 5d676b533a3a..80c635980526 100644
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
@@ -137,8 +136,8 @@ int mxl111sf_write_reg_mask(struct mxl111sf_state *state,
 #if 1
 		/* dont know why this usually errors out on the first try */
 		if (mxl_fail(ret))
-			pr_err("error writing addr: 0x%02x, mask: 0x%02x, "
-			    "data: 0x%02x, retrying...", addr, mask, data);
+			pr_err("error writing addr: 0x%02x, mask: 0x%02x, data: 0x%02x, retrying...",
+			       addr, mask, data);
 
 		ret = mxl111sf_read_reg(state, addr, &val);
 #endif
@@ -946,8 +945,7 @@ static int mxl111sf_init(struct dvb_usb_device *d)
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



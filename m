Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792Ab0D0VMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:12:07 -0400
Message-Id: <201004272111.o3RLBKix019982@imap1.linux-foundation.org>
Subject: [patch 02/11] dib7000p: reduce large stack usage
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	randy.dunlap@oracle.com, pboettcher@dibcom.fr
From: akpm@linux-foundation.org
Date: Tue, 27 Apr 2010 14:11:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Reduce the static stack usage of one of the 2 top offenders as listed by
'make checkstack':

Building with CONFIG_FRAME_WARN=2048 produces:

drivers/media/dvb/frontends/dib7000p.c:1367: warning: the frame size of 2320 bytes is larger than 2048 bytes

and in 'make checkstack', the stack usage goes from:
0x00002409 dib7000p_i2c_enumeration [dib7000p]:		2328
to unlisted with this patch.

Also change one caller of dib7000p_i2c_enumeration() to check its
return value.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Patrick Boettcher <pboettcher@dibcom.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-usb/cxusb.c      |    5 +--
 drivers/media/dvb/frontends/dib7000p.c |   36 ++++++++++++++---------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff -puN drivers/media/dvb/dvb-usb/cxusb.c~dib7000p-reduce-large-stack-usage drivers/media/dvb/dvb-usb/cxusb.c
--- a/drivers/media/dvb/dvb-usb/cxusb.c~dib7000p-reduce-large-stack-usage
+++ a/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1025,8 +1025,9 @@ static int cxusb_dualdig4_rev2_frontend_
 
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
 
-	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
-				 &cxusb_dualdig4_rev2_config);
+	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+				 &cxusb_dualdig4_rev2_config) < 0)
+		return -ENODEV;
 
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
 			      &cxusb_dualdig4_rev2_config);
diff -puN drivers/media/dvb/frontends/dib7000p.c~dib7000p-reduce-large-stack-usage drivers/media/dvb/frontends/dib7000p.c
--- a/drivers/media/dvb/frontends/dib7000p.c~dib7000p-reduce-large-stack-usage
+++ a/drivers/media/dvb/frontends/dib7000p.c
@@ -1324,46 +1324,54 @@ EXPORT_SYMBOL(dib7000p_pid_filter);
 
 int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
 {
-	struct dib7000p_state st = { .i2c_adap = i2c };
+	struct dib7000p_state *dpst;
 	int k = 0;
 	u8 new_addr = 0;
 
+	dpst = kzalloc(sizeof(struct dib7000p_state), GFP_KERNEL);
+	if (!dpst)
+		return -ENODEV;
+
+	dpst->i2c_adap = i2c;
+
 	for (k = no_of_demods-1; k >= 0; k--) {
-		st.cfg = cfg[k];
+		dpst->cfg = cfg[k];
 
 		/* designated i2c address */
 		new_addr          = (0x40 + k) << 1;
-		st.i2c_addr = new_addr;
-		dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
-		if (dib7000p_identify(&st) != 0) {
-			st.i2c_addr = default_addr;
-			dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
-			if (dib7000p_identify(&st) != 0) {
+		dpst->i2c_addr = new_addr;
+		dib7000p_write_word(dpst, 1287, 0x0003); /* sram lead in, rdy */
+		if (dib7000p_identify(dpst) != 0) {
+			dpst->i2c_addr = default_addr;
+			dib7000p_write_word(dpst, 1287, 0x0003); /* sram lead in, rdy */
+			if (dib7000p_identify(dpst) != 0) {
 				dprintk("DiB7000P #%d: not identified\n", k);
+				kfree(dpst);
 				return -EIO;
 			}
 		}
 
 		/* start diversity to pull_down div_str - just for i2c-enumeration */
-		dib7000p_set_output_mode(&st, OUTMODE_DIVERSITY);
+		dib7000p_set_output_mode(dpst, OUTMODE_DIVERSITY);
 
 		/* set new i2c address and force divstart */
-		dib7000p_write_word(&st, 1285, (new_addr << 2) | 0x2);
+		dib7000p_write_word(dpst, 1285, (new_addr << 2) | 0x2);
 
 		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
-		st.cfg = cfg[k];
-		st.i2c_addr = (0x40 + k) << 1;
+		dpst->cfg = cfg[k];
+		dpst->i2c_addr = (0x40 + k) << 1;
 
 		// unforce divstr
-		dib7000p_write_word(&st, 1285, st.i2c_addr << 2);
+		dib7000p_write_word(dpst, 1285, dpst->i2c_addr << 2);
 
 		/* deactivate div - it was just for i2c-enumeration */
-		dib7000p_set_output_mode(&st, OUTMODE_HIGH_Z);
+		dib7000p_set_output_mode(dpst, OUTMODE_HIGH_Z);
 	}
 
+	kfree(dpst);
 	return 0;
 }
 EXPORT_SYMBOL(dib7000p_i2c_enumeration);
_

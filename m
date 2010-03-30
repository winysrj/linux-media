Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61388 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab0C3SCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 14:02:51 -0400
Received: by vws20 with SMTP id 20so910588vws.19
        for <linux-media@vger.kernel.org>; Tue, 30 Mar 2010 11:02:50 -0700 (PDT)
Message-ID: <4BB23CB0.1080501@gmail.com>
Date: Tue, 30 Mar 2010 15:02:24 -0300
From: Ricardo Maraschini <xrmarsx@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: dougsland@gmail.com, mchehab@infradead.org
Subject: [PATCH] dib7000p.c: Fix for warning: the frame size of 1236 bytes
 is larger than 1024 bytes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When compiling the last version of v4l-dvb tree I got the following message:

/data/Projects/kernel/v4l-dvb/v4l/dib7000p.c: In function 'dib7000p_i2c_enumeration':
/data/Projects/kernel/v4l-dvb/v4l/dib7000p.c:1393: warning: the frame size of 1236 bytes is larger than 1024 bytes

I believe that this problem is related to stack size, because we are allocating memory for a big structure.
I changed the approach to dinamic allocated memory and the warning disappears.
The same problem appears on dib3000 as well, and I can fix that too if this patch get in.

Any comment on that?
I'll appreciate to read any comment from more experienced code makers.


Signed-off-by: Ricardo Maraschini <xrmarsx@gmail.com>


--- a/linux/drivers/media/dvb/frontends/dib7000p.c	Sat Mar 27 23:09:47 2010 -0300
+++ b/linux/drivers/media/dvb/frontends/dib7000p.c	Tue Mar 30 13:03:59 2010 -0300
@@ -1349,46 +1349,57 @@
 
 int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
 {
-	struct dib7000p_state st = { .i2c_adap = i2c };
+	struct dib7000p_state *st = NULL;
 	int k = 0;
 	u8 new_addr = 0;
 
+	st = kmalloc(sizeof(struct dib7000p_state), GFP_KERNEL);
+	if (!st) {
+		dprintk("DiB7000P: Unable to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	st->i2c_adap = i2c;
+
+
 	for (k = no_of_demods-1; k >= 0; k--) {
-		st.cfg = cfg[k];
+		st->cfg = cfg[k];
 
 		/* designated i2c address */
 		new_addr          = (0x40 + k) << 1;
-		st.i2c_addr = new_addr;
-		dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
-		if (dib7000p_identify(&st) != 0) {
-			st.i2c_addr = default_addr;
-			dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
-			if (dib7000p_identify(&st) != 0) {
+		st->i2c_addr = new_addr;
+		dib7000p_write_word(st, 1287, 0x0003); /* sram lead in, rdy */
+		if (dib7000p_identify(st) != 0) {
+			st->i2c_addr = default_addr;
+			dib7000p_write_word(st, 1287, 0x0003); /* sram lead in, rdy */
+			if (dib7000p_identify(st) != 0) {
 				dprintk("DiB7000P #%d: not identified\n", k);
+				kfree(st);
 				return -EIO;
 			}
 		}
 
 		/* start diversity to pull_down div_str - just for i2c-enumeration */
-		dib7000p_set_output_mode(&st, OUTMODE_DIVERSITY);
+		dib7000p_set_output_mode(st, OUTMODE_DIVERSITY);
 
 		/* set new i2c address and force divstart */
-		dib7000p_write_word(&st, 1285, (new_addr << 2) | 0x2);
+		dib7000p_write_word(st, 1285, (new_addr << 2) | 0x2);
 
 		dprintk("IC %d initialized (to i2c_address 0x%x)", k, new_addr);
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
-		st.cfg = cfg[k];
-		st.i2c_addr = (0x40 + k) << 1;
+		st->cfg = cfg[k];
+		st->i2c_addr = (0x40 + k) << 1;
 
 		// unforce divstr
-		dib7000p_write_word(&st, 1285, st.i2c_addr << 2);
+		dib7000p_write_word(st, 1285, st->i2c_addr << 2);
 
 		/* deactivate div - it was just for i2c-enumeration */
-		dib7000p_set_output_mode(&st, OUTMODE_HIGH_Z);
+		dib7000p_set_output_mode(st, OUTMODE_HIGH_Z);
 	}
 
+	kfree(st);
 	return 0;
 }
 EXPORT_SYMBOL(dib7000p_i2c_enumeration);


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0ELSzu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 14:55:50 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4CItnbi019925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 12 May 2010 14:55:49 -0400
Date: Wed, 12 May 2010 14:55:49 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-media@vger.kernel.org, mchehab@infradead.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100512185311.20801.86954.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH] checkstack fixes for drivers/media/dvb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When compiling 2.6.34-rc7 I see the following warnings

drivers/media/dvb/frontends/dib3000mc.c: In function 'dib3000mc_i2c_enumeration':
drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2224 bytes is larger than 2048 bytes
drivers/media/dvb/frontends/dib7000p.c: In function 'dib7000p_i2c_enumeration':
drivers/media/dvb/frontends/dib7000p.c:1346: warning: the frame size of 2304 bytes is larger than 2048 bytes

because the dib*_state structs are large and they are alloc'd on the stack.

This patch moves the structures off the stack.

I also noticed that the cxusb driver doesn't check the return value from
dib7000p_i2c_enumeration().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index 960376d..8141b10 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1025,8 +1025,11 @@ static int cxusb_dualdig4_rev2_frontend_attach(struct dvb_usb_adapter *adap)
 
 	cxusb_bluebird_gpio_pulse(adap->dev, 0x02, 1);
 
-	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
-				 &cxusb_dualdig4_rev2_config);
+	if (dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
+				     &cxusb_dualdig4_rev2_config)) {
+		printk(KERN_WARNING "Unable to enumerate dib7000p\n");
+		return -ENODEV;
+	}
 
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap, 0x80,
 			      &cxusb_dualdig4_rev2_config);
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index 40a0998..6a178f1 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -814,42 +814,52 @@ EXPORT_SYMBOL(dib3000mc_set_config);
 
 int dib3000mc_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib3000mc_config cfg[])
 {
-	struct dib3000mc_state st = { .i2c_adap = i2c };
+	struct dib3000mc_state *st;
 	int k;
 	u8 new_addr;
-
 	static u8 DIB3000MC_I2C_ADDRESS[] = {20,22,24,26};
 
+	st = kzalloc(sizeof(*st), GFP_KERNEL);
+	if (!st)
+		return -ENOMEM;
+	st->i2c_adap = i2c;
+
 	for (k = no_of_demods-1; k >= 0; k--) {
-		st.cfg = &cfg[k];
+		st->cfg = &cfg[k];
 
 		/* designated i2c address */
-		new_addr          = DIB3000MC_I2C_ADDRESS[k];
-		st.i2c_addr = new_addr;
-		if (dib3000mc_identify(&st) != 0) {
-			st.i2c_addr = default_addr;
-			if (dib3000mc_identify(&st) != 0) {
-				dprintk("-E-  DiB3000P/MC #%d: not identified\n", k);
+		new_addr = DIB3000MC_I2C_ADDRESS[k];
+		st->i2c_addr = new_addr;
+		if (dib3000mc_identify(st) != 0) {
+			st->i2c_addr = default_addr;
+			if (dib3000mc_identify(st) != 0) {
+				dprintk("-E-  DiB3000P/MC #%d: not"
+					" identified\n", k);
+				kfree(st);
 				return -ENODEV;
 			}
 		}
 
-		dib3000mc_set_output_mode(&st, OUTMODE_MPEG2_PAR_CONT_CLK);
+		dib3000mc_set_output_mode(st, OUTMODE_MPEG2_PAR_CONT_CLK);
 
-		// set new i2c address and force divstr (Bit 1) to value 0 (Bit 0)
-		dib3000mc_write_word(&st, 1024, (new_addr << 3) | 0x1);
-		st.i2c_addr = new_addr;
+		/* set new i2c address and force divstr (Bit 1) to
+		 * value 0 (Bit 0)
+		 */
+		dib3000mc_write_word(st, 1024, (new_addr << 3) | 0x1);
+		st->i2c_addr = new_addr;
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
-		st.cfg = &cfg[k];
-		st.i2c_addr = DIB3000MC_I2C_ADDRESS[k];
+		st->cfg = &cfg[k];
+		st->i2c_addr = DIB3000MC_I2C_ADDRESS[k];
 
-		dib3000mc_write_word(&st, 1024, st.i2c_addr << 3);
+		dib3000mc_write_word(st, 1024, st->i2c_addr << 3);
 
 		/* turn off data output */
-		dib3000mc_set_output_mode(&st, OUTMODE_HIGH_Z);
+		dib3000mc_set_output_mode(st, OUTMODE_HIGH_Z);
 	}
+
+	kfree(st);
 	return 0;
 }
 EXPORT_SYMBOL(dib3000mc_i2c_enumeration);
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 85468a4..08ea982 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -1322,48 +1322,59 @@ int dib7000p_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 }
 EXPORT_SYMBOL(dib7000p_pid_filter);
 
-int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib7000p_config cfg[])
+int dib7000p_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods,
+			     u8 default_addr, struct dib7000p_config cfg[])
 {
-	struct dib7000p_state st = { .i2c_adap = i2c };
+	struct dib7000p_state *st;
 	int k = 0;
 	u8 new_addr = 0;
 
+	st = kmalloc(sizeof(*st), GFP_KERNEL);
+	if (!st)
+		return -ENOMEM;
+	st->i2c_adap = i2c;
+
 	for (k = no_of_demods-1; k >= 0; k--) {
-		st.cfg = cfg[k];
+		st->cfg = cfg[k];
 
 		/* designated i2c address */
-		new_addr          = (0x40 + k) << 1;
-		st.i2c_addr = new_addr;
-		dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
-		if (dib7000p_identify(&st) != 0) {
-			st.i2c_addr = default_addr;
-			dib7000p_write_word(&st, 1287, 0x0003); /* sram lead in, rdy */
-			if (dib7000p_identify(&st) != 0) {
+		new_addr = (0x40 + k) << 1;
+		st->i2c_addr = new_addr;
+		dib7000p_write_word(st, 1287, 0x0003); /* sram lead in, rdy */
+		if (dib7000p_identify(st) != 0) {
+			st->i2c_addr = default_addr;
+			/* sram lead in, rdy */
+			dib7000p_write_word(st, 1287, 0x0003);
+			if (dib7000p_identify(st) != 0) {
 				dprintk("DiB7000P #%d: not identified\n", k);
+				kfree(st);
 				return -EIO;
 			}
 		}
 
-		/* start diversity to pull_down div_str - just for i2c-enumeration */
-		dib7000p_set_output_mode(&st, OUTMODE_DIVERSITY);
+		/* start diversity to pull_down div_str - just for
+		 * i2c-enumeration
+		 */
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
 
-		// unforce divstr
-		dib7000p_write_word(&st, 1285, st.i2c_addr << 2);
+		/* unforce divstr */
+		dib7000p_write_word(st, 1285, st->i2c_addr << 2);
 
 		/* deactivate div - it was just for i2c-enumeration */
-		dib7000p_set_output_mode(&st, OUTMODE_HIGH_Z);
+		dib7000p_set_output_mode(st, OUTMODE_HIGH_Z);
 	}
 
+	kfree(st);
 	return 0;
 }
 EXPORT_SYMBOL(dib7000p_i2c_enumeration);

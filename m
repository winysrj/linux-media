Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:52458 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0BHXce (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 18:32:34 -0500
Message-ID: <4B709E99.8050405@oracle.com>
Date: Mon, 08 Feb 2010 15:30:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Morton <akpm@osdl.org>
CC: Patrick Boettcher <pboettcher@dibcom.fr>
Subject: [PATCH] dib3000mc: reduce large stack usage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

This patch reduces static stack usage of one of the 2 top offenders
as listed by 'make checkstack':

Building with CONFIG_FRAME_WARN=2048 produces:

drivers/media/dvb/frontends/dib3000mc.c:853: warning: the frame size of 2224 bytes is larger than 2048 bytes

and in 'make checkstack', the stack usage goes from:
0x00000bbd dib3000mc_i2c_enumeration [dib3000mc]:	2232
to unlisted with this patch.

I don't have the hardware that is needed to test this patch.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Patrick Boettcher <pboettcher@dibcom.fr>
---
 drivers/media/dvb/frontends/dib3000mc.c |   35 +++++++++++++---------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- lnx-2633-rc7.orig/drivers/media/dvb/frontends/dib3000mc.c
+++ lnx-2633-rc7/drivers/media/dvb/frontends/dib3000mc.c
@@ -813,42 +813,51 @@ EXPORT_SYMBOL(dib3000mc_set_config);
 
 int dib3000mc_i2c_enumeration(struct i2c_adapter *i2c, int no_of_demods, u8 default_addr, struct dib3000mc_config cfg[])
 {
-	struct dib3000mc_state st = { .i2c_adap = i2c };
+	struct dib3000mc_state *dmcst;
 	int k;
 	u8 new_addr;
 
 	static u8 DIB3000MC_I2C_ADDRESS[] = {20,22,24,26};
 
+	dmcst = kzalloc(sizeof(struct dib3000mc_state), GFP_KERNEL);
+	if (dmcst == NULL)
+		return -ENODEV;
+
+	dmcst->i2c_adap = i2c;
+
 	for (k = no_of_demods-1; k >= 0; k--) {
-		st.cfg = &cfg[k];
+		dmcst->cfg = &cfg[k];
 
 		/* designated i2c address */
 		new_addr          = DIB3000MC_I2C_ADDRESS[k];
-		st.i2c_addr = new_addr;
-		if (dib3000mc_identify(&st) != 0) {
-			st.i2c_addr = default_addr;
-			if (dib3000mc_identify(&st) != 0) {
+		dmcst->i2c_addr = new_addr;
+		if (dib3000mc_identify(dmcst) != 0) {
+			dmcst->i2c_addr = default_addr;
+			if (dib3000mc_identify(dmcst) != 0) {
 				dprintk("-E-  DiB3000P/MC #%d: not identified\n", k);
+				kfree(dmcst);
 				return -ENODEV;
 			}
 		}
 
-		dib3000mc_set_output_mode(&st, OUTMODE_MPEG2_PAR_CONT_CLK);
+		dib3000mc_set_output_mode(dmcst, OUTMODE_MPEG2_PAR_CONT_CLK);
 
 		// set new i2c address and force divstr (Bit 1) to value 0 (Bit 0)
-		dib3000mc_write_word(&st, 1024, (new_addr << 3) | 0x1);
-		st.i2c_addr = new_addr;
+		dib3000mc_write_word(dmcst, 1024, (new_addr << 3) | 0x1);
+		dmcst->i2c_addr = new_addr;
 	}
 
 	for (k = 0; k < no_of_demods; k++) {
-		st.cfg = &cfg[k];
-		st.i2c_addr = DIB3000MC_I2C_ADDRESS[k];
+		dmcst->cfg = &cfg[k];
+		dmcst->i2c_addr = DIB3000MC_I2C_ADDRESS[k];
 
-		dib3000mc_write_word(&st, 1024, st.i2c_addr << 3);
+		dib3000mc_write_word(dmcst, 1024, dmcst->i2c_addr << 3);
 
 		/* turn off data output */
-		dib3000mc_set_output_mode(&st, OUTMODE_HIGH_Z);
+		dib3000mc_set_output_mode(dmcst, OUTMODE_HIGH_Z);
 	}
+
+	kfree(dmcst);
 	return 0;
 }
 EXPORT_SYMBOL(dib3000mc_i2c_enumeration);

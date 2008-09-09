Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Tue, 9 Sep 2008 19:31:01 +0300
References: <48BF6A09.3020205@linuxtv.org>
	<200809082334.04511.liplianin@tut.by>
	<200809091750.38009.liplianin@tut.by>
In-Reply-To: <200809091750.38009.liplianin@tut.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_FTqxIf+Xig4vSpE"
Message-Id: <200809091931.01831.liplianin@tut.by>
Subject: [linux-dvb] [PATCH] S2 cx24116: Above 30000 kSym/s symbol rates
	patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_FTqxIf+Xig4vSpE
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Steven,
Please apply this patch

Above 30000 kSym/s symbol rates patch
Tested on 44948 transponders (Express AM2)

Igor M. Liplianin

--Boundary-00=_FTqxIf+Xig4vSpE
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8863.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8863.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1220977349 -10800
# Node ID c16df309144fe4971cbdbb1e6fb67eb6df0ec727
# Parent  49c174f134f86203f892857b33832c2ff8bd850a
cx24116: Fix lock for high (above 30000 kSyms) symbol rates

From: Igor M. Liplianin <liplianin@me.by>

cx24116: Fix lock for high (above 30000 kSyms) symbol rates

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 49c174f134f8 -r c16df309144f linux/drivers/media/dvb/frontends/cx24116.c
--- a/linux/drivers/media/dvb/frontends/cx24116.c	Tue Sep 09 17:29:43 2008 +0300
+++ b/linux/drivers/media/dvb/frontends/cx24116.c	Tue Sep 09 19:22:29 2008 +0300
@@ -29,6 +29,11 @@
  * August
  *	Sync with legacy version.
  *	Some clean ups.
+ */
+/* Updates by Igor Liplianin
+ *
+ * September, 9th 2008
+ *	Fixed locking on high symbol rates (>30000).
  */
 
 #include <linux/slab.h>
@@ -809,7 +814,7 @@
 	struct tv_frontend_properties *c = &fe->tv_property_cache;
 	struct cx24116_cmd cmd;
 	fe_status_t tunerstat;
-	int ret;
+	int ret, above30msps;
 	u8 retune=4;
 
 	dprintk("%s()\n",__func__);
@@ -839,6 +844,16 @@
 	if (state->config->set_ts_params)
 		state->config->set_ts_params(fe, 0);
 
+	above30msps = (state->dcur.symbol_rate > 30000000);
+
+	if (above30msps){
+		cx24116_writereg(state, 0xF9, 0x01);
+		cx24116_writereg(state, 0xF3, 0x44);
+	} else {	
+		cx24116_writereg(state, 0xF9, 0x00);
+		cx24116_writereg(state, 0xF3, 0x46);
+	}
+
 	/* Prepare a tune request */
 	cmd.args[0x00] = CMD_TUNEREQUEST;
 
@@ -866,11 +881,21 @@
 	cmd.args[0x0b] = 0x00;
 	cmd.args[0x0c] = 0x02;
 	cmd.args[0x0d] = state->dcur.fec_mask;
-	cmd.args[0x0e] = 0x06;
-	cmd.args[0x0f] = 0x00;
-	cmd.args[0x10] = 0x00;
-	cmd.args[0x11] = 0xFA;
-	cmd.args[0x12] = 0x24;
+
+	if (above30msps){
+		cmd.args[0x0e] = 0x04;
+		cmd.args[0x0f] = 0x00;
+		cmd.args[0x10] = 0x01;
+		cmd.args[0x11] = 0x77;
+		cmd.args[0x12] = 0x36;
+	} else {
+		cmd.args[0x0e] = 0x06;
+		cmd.args[0x0f] = 0x00;
+		cmd.args[0x10] = 0x00;
+		cmd.args[0x11] = 0xFA;
+		cmd.args[0x12] = 0x24;
+	}
+
 	cmd.len= 0x13;
 
 	/* We need to support pilot and non-pilot tuning in the

--Boundary-00=_FTqxIf+Xig4vSpE
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_FTqxIf+Xig4vSpE--

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: "Igor M. Liplianin" <liplianin@tut.by>
To: linux-dvb@linuxtv.org
Date: Tue, 9 Sep 2008 20:12:04 +0300
References: <48BF6A09.3020205@linuxtv.org>
	<200809082334.04511.liplianin@tut.by>
	<200809091750.38009.liplianin@tut.by>
In-Reply-To: <200809091750.38009.liplianin@tut.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_k5qxI8Zr2E6M+2p"
Message-Id: <200809092012.04927.liplianin@tut.by>
Subject: [linux-dvb]  [PATCH] S2 cx24116:  MPEG initialization
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

--Boundary-00=_k5qxI8Zr2E6M+2p
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi again Steven,

Please apply this patch.
Patch to adjust MPEG initialization in cx24116 in order to accomodate 
different MPEG CLK positions and polarities for different cards.

Igor Liplianin

--Boundary-00=_k5qxI8Zr2E6M+2p
Content-Type: text/x-diff;
  charset="koi8-r";
  name="8867.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="8867.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1220979467 -10800
# Node ID 77293218655c3d272705232dc40ad9925473b8c1
# Parent  ed37fbee40febc38e74833387ec7d317087056d1
Adjust MPEG initialization in cx24116

From: Igor M. Liplianin <liplianin@me.by>

Adjust MPEG initialization in cx24116 in order to accomodate different
MPEG CLK position and polarity in different cards.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r ed37fbee40fe -r 77293218655c linux/drivers/media/dvb/dvb-usb/dw2102.c
--- a/linux/drivers/media/dvb/dvb-usb/dw2102.c	Tue Sep 09 19:22:29 2008 +0300
+++ b/linux/drivers/media/dvb/dvb-usb/dw2102.c	Tue Sep 09 19:57:47 2008 +0300
@@ -284,7 +284,7 @@
 
 static struct cx24116_config dw2104_config = {
 	.demod_address = 0x55,
-	/*.mpg_clk_pos_pol = 0x01,*/
+	.mpg_clk_pos_pol = 0x01,
 };
 
 static int dw2104_frontend_attach(struct dvb_usb_adapter *d)
diff -r ed37fbee40fe -r 77293218655c linux/drivers/media/dvb/frontends/cx24116.c
--- a/linux/drivers/media/dvb/frontends/cx24116.c	Tue Sep 09 19:22:29 2008 +0300
+++ b/linux/drivers/media/dvb/frontends/cx24116.c	Tue Sep 09 19:57:47 2008 +0300
@@ -478,7 +478,10 @@
 	cmd.args[0x01] = 0x01;
 	cmd.args[0x02] = 0x75;
 	cmd.args[0x03] = 0x00;
-	cmd.args[0x04] = 0x02;
+	if (state->config->mpg_clk_pos_pol)
+		cmd.args[0x04] = state->config->mpg_clk_pos_pol;
+	else
+		cmd.args[0x04] = 0x02;
 	cmd.args[0x05] = 0x00;
 	cmd.len= 0x06;
 	ret = cx24116_cmd_execute(fe, &cmd);
diff -r ed37fbee40fe -r 77293218655c linux/drivers/media/dvb/frontends/cx24116.h
--- a/linux/drivers/media/dvb/frontends/cx24116.h	Tue Sep 09 19:22:29 2008 +0300
+++ b/linux/drivers/media/dvb/frontends/cx24116.h	Tue Sep 09 19:57:47 2008 +0300
@@ -33,6 +33,9 @@
 
 	/* Need to reset device during firmware loading */
 	int (*reset_device)(struct dvb_frontend* fe);
+
+	/* Need to set MPEG parameters */
+	u8 mpg_clk_pos_pol:0x02;
 };
 
 #if defined(CONFIG_DVB_CX24116) || defined(CONFIG_DVB_CX24116_MODULE)

--Boundary-00=_k5qxI8Zr2E6M+2p
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_k5qxI8Zr2E6M+2p--

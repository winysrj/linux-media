Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout3.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1KpJzd-0004UF-Ja
	for linux-dvb@linuxtv.org; Mon, 13 Oct 2008 11:45:39 +0200
Received: from jar.dominio (80.25.230.35) by ctsmtpout3.frontal.correo
	(7.3.135) (authenticated as jareguero$telefonica.net)
	id 48EF043E0014EFF5 for linux-dvb@linuxtv.org;
	Mon, 13 Oct 2008 11:45:03 +0200
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org
Date: Mon, 13 Oct 2008 11:45:01 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dix8I7cJHVLu8a2"
Message-Id: <200810131145.01604.jareguero@telefonica.net>
Subject: [linux-dvb] [PATCH] Fix initialization in mxl5005s
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

--Boundary-00=_dix8I7cJHVLu8a2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I think that the initialization in the mxl5005s driver is wrong.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto



--Boundary-00=_dix8I7cJHVLu8a2
Content-Type: text/x-patch;
  charset="us-ascii";
  name="mxl5005s.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mxl5005s.diff"

diff -r 4abf15af7eae linux/drivers/media/common/tuners/mxl5005s.c
--- a/linux/drivers/media/common/tuners/mxl5005s.c	Mon Oct 06 21:46:08 2008 -0400
+++ b/linux/drivers/media/common/tuners/mxl5005s.c	Mon Oct 13 00:55:03 2008 +0200
@@ -3912,7 +3912,10 @@
 
 static int mxl5005s_init(struct dvb_frontend *fe)
 {
-	dprintk(1, "%s()\n", __func__);
+	struct mxl5005s_state *state = fe->tuner_priv;
+
+	dprintk(1, "%s()\n", __func__);
+	state->current_mode = MXL_QAM;
 	return mxl5005s_reconfigure(fe, MXL_QAM, MXL5005S_BANDWIDTH_6MHZ);
 }
 
@@ -4094,7 +4097,6 @@
 	state->frontend = fe;
 	state->config = config;
 	state->i2c = i2c;
-	state->current_mode = MXL_QAM;
 
 	printk(KERN_INFO "MXL5005S: Attached at address 0x%02x\n",
 		config->i2c_address);

--Boundary-00=_dix8I7cJHVLu8a2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_dix8I7cJHVLu8a2--

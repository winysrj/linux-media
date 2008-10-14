Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2f.orange.fr ([80.12.242.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KpgII-0008LD-DR
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 11:34:23 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f27.orange.fr (SMTP Server) with ESMTP id 9F46A70000B3
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 11:33:48 +0200 (CEST)
Received: from [10.0.0.1] (ANantes-256-1-138-204.w86-214.abo.wanadoo.fr
	[86.214.81.204])
	by mwinf2f27.orange.fr (SMTP Server) with ESMTP id 752F17000082
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 11:33:48 +0200 (CEST)
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Tue, 14 Oct 2008 11:33:36 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wdG9I2ltglxT+JJ"
Message-Id: <200810141133.36559.hftom@free.fr>
Subject: [linux-dvb] [PATCH] cx24116 DVB-S modulation fix
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

--Boundary-00=_wdG9I2ltglxT+JJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This patch makes cx24116 to behave like other dvb-s frontends.
This is needed especially because QAM_AUTO is used in a lot of scan files.


-- 
Christophe Thommeret

--Boundary-00=_wdG9I2ltglxT+JJ
Content-Type: text/x-diff;
  charset="utf-8";
  name="cx24116-dvbs_modulation-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="cx24116-dvbs_modulation-fix.diff"

diff -r 6b6e9be35963 linux/drivers/media/dvb/frontends/cx24116.c
--- a/linux/drivers/media/dvb/frontends/cx24116.c	Mon Oct 13 18:35:50 2008 -0400
+++ b/linux/drivers/media/dvb/frontends/cx24116.c	Tue Oct 14 11:20:57 2008 +0200
@@ -1230,23 +1230,14 @@ static int cx24116_set_frontend(struct d
 	case SYS_DVBS:
 		dprintk("%s: DVB-S delivery system selected\n", __func__);
 
-		/* Only QPSK is supported for DVB-S */
-		if (c->modulation != QPSK) {
-			dprintk("%s: unsupported modulation selected (%d)\n",
-				__func__, c->modulation);
-			return -EOPNOTSUPP;
-		}
+		/* Only QPSK is supported for DVB-S,then .. */
+		state->dnxt.modulation = QPSK;
 
 		/* Pilot doesn't exist in DVB-S, turn bit off */
 		state->dnxt.pilot_val = CX24116_PILOT_OFF;
 		retune = 1;
 
-		/* DVB-S only supports 0.35 */
-		if (c->rolloff != ROLLOFF_35) {
-			dprintk("%s: unsupported rolloff selected (%d)\n",
-				__func__, c->rolloff);
-			return -EOPNOTSUPP;
-		}
+		/* DVB-S only supports 0.35, then .. */
 		state->dnxt.rolloff_val = CX24116_ROLLOFF_035;
 		break;
 
@@ -1262,6 +1253,7 @@ static int cx24116_set_frontend(struct d
 				__func__, c->modulation);
 			return -EOPNOTSUPP;
 		}
+		state->dnxt.modulation = c->modulation;
 
 		switch (c->pilot) {
 		case PILOT_AUTO:	/* Not supported but emulated */
@@ -1301,7 +1293,6 @@ static int cx24116_set_frontend(struct d
 			__func__, c->delivery_system);
 		return -EOPNOTSUPP;
 	}
-	state->dnxt.modulation = c->modulation;
 	state->dnxt.frequency = c->frequency;
 	state->dnxt.pilot = c->pilot;
 	state->dnxt.rolloff = c->rolloff;
@@ -1311,7 +1302,7 @@ static int cx24116_set_frontend(struct d
 		return ret;
 
 	/* FEC_NONE/AUTO for DVB-S2 is not supported and detected here */
-	ret = cx24116_set_fec(state, c->modulation, c->fec_inner);
+	ret = cx24116_set_fec(state, state->dnxt.modulation, c->fec_inner);
 	if (ret !=  0)
 		return ret;
 

--Boundary-00=_wdG9I2ltglxT+JJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_wdG9I2ltglxT+JJ--

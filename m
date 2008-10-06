Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]
	helo=ctsmtpout3.frontal.correo)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jareguero@telefonica.net>) id 1Kmp7J-00074Z-He
	for linux-dvb@linuxtv.org; Mon, 06 Oct 2008 14:23:14 +0200
Received: from jar.dominio (80.25.230.35) by ctsmtpout3.frontal.correo
	(7.3.135) (authenticated as jareguero$telefonica.net)
	id 48E8006C00179A9E for linux-dvb@linuxtv.org;
	Mon, 6 Oct 2008 14:22:39 +0200
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-dvb@linuxtv.org
Date: Mon, 6 Oct 2008 14:22:37 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OMg6I/28+j3guAq"
Message-Id: <200810061422.38176.jareguero@telefonica.net>
Subject: [linux-dvb] Problems with new S2API and DVB-T
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

--Boundary-00=_OMg6I/28+j3guAq
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I am trying to use the new API for DVB-T and I have some problems. They are 
not way to set code_rate_HP, code_rate_LP, transmission_mode, and 
guard_interval , and the default values are 0, that are not the AUTO ones.
Also the bandwidth is not treated well. The attached patch is a workaround 
that works for me.

Thanks.
Jose Alberto



--Boundary-00=_OMg6I/28+j3guAq
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb_frontend.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dvb_frontend.diff"

diff -r 979d14edeb2e linux/drivers/media/dvb/dvb-core/dvb_frontend.c
--- a/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Sat Oct 04 21:37:36 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-core/dvb_frontend.c	Mon Oct 06 14:14:39 2008 +0200
@@ -974,15 +974,7 @@
 		c->delivery_system = SYS_DVBC_ANNEX_AC;
 		break;
 	case FE_OFDM:
-		if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
-			c->bandwidth_hz = 6000000;
-		else if (p->u.ofdm.bandwidth == BANDWIDTH_7_MHZ)
-			c->bandwidth_hz = 7000000;
-		else if (p->u.ofdm.bandwidth == BANDWIDTH_8_MHZ)
-			c->bandwidth_hz = 8000000;
-		else
-			/* Including BANDWIDTH_AUTO */
-			c->bandwidth_hz = 0;
+		c->bandwidth_hz = p->u.ofdm.bandwidth;
 		c->code_rate_HP = p->u.ofdm.code_rate_HP;
 		c->code_rate_LP = p->u.ofdm.code_rate_LP;
 		c->modulation = p->u.ofdm.constellation;
@@ -1031,19 +1023,12 @@
 		break;
 	case FE_OFDM:
 		printk("%s() Preparing OFDM req\n", __FUNCTION__);
-		if (c->bandwidth_hz == 6000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_6_MHZ;
-		else if (c->bandwidth_hz == 7000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_7_MHZ;
-		else if (c->bandwidth_hz == 8000000)
-			p->u.ofdm.bandwidth = BANDWIDTH_8_MHZ;
-		else
-			p->u.ofdm.bandwidth = BANDWIDTH_AUTO;
-		p->u.ofdm.code_rate_HP = c->code_rate_HP;
-		p->u.ofdm.code_rate_LP = c->code_rate_LP;
+		p->u.ofdm.bandwidth = c->bandwidth_hz;
+		p->u.ofdm.code_rate_HP = FEC_AUTO;
+		p->u.ofdm.code_rate_LP = FEC_AUTO;
 		p->u.ofdm.constellation = c->modulation;
-		p->u.ofdm.transmission_mode = c->transmission_mode;
-		p->u.ofdm.guard_interval = c->guard_interval;
+		p->u.ofdm.transmission_mode = TRANSMISSION_MODE_AUTO;
+		p->u.ofdm.guard_interval = GUARD_INTERVAL_AUTO;
 		p->u.ofdm.hierarchy_information = c->hierarchy;
 		c->delivery_system = SYS_DVBT;
 		break;

--Boundary-00=_OMg6I/28+j3guAq
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_OMg6I/28+j3guAq--

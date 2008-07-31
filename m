Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex@lisas.de>) id 1KOf3J-00088t-2t
	for linux-dvb@linuxtv.org; Thu, 31 Jul 2008 22:47:15 +0200
Received: from mail-in-18-z2.arcor-online.net (mail-in-18-z2.arcor-online.net
	[151.189.8.35])
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id 61A6D32E839
	for <linux-dvb@linuxtv.org>; Thu, 31 Jul 2008 22:47:09 +0200 (CEST)
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mail-in-18-z2.arcor-online.net (Postfix) with ESMTP id 468AD510042
	for <linux-dvb@linuxtv.org>; Thu, 31 Jul 2008 22:47:09 +0200 (CEST)
Received: from gatenix.springfield.example
	(dslb-084-056-188-130.pools.arcor-ip.net [84.56.188.130])
	by mail-in-04.arcor-online.net (Postfix) with ESMTP id 1B7F01BF3D8
	for <linux-dvb@linuxtv.org>; Thu, 31 Jul 2008 22:47:09 +0200 (CEST)
Received: from gatenix.springfield.example ([192.168.192.3] ident=alex)
	by gatenix.springfield.example with smtp (Exim 4.63)
	(envelope-from <alex@lisas.de>) id 1KOf3E-0000EV-Iw
	for linux-dvb@linuxtv.org; Thu, 31 Jul 2008 22:47:08 +0200
Date: Thu, 31 Jul 2008 22:47:08 +0200
From: Alexander Koenig <alex@lisas.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080731204708.GA869@lisas.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Subject: [linux-dvb] stv0297: QAM256 improvement for TT-C2300 revisited
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


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

last October Hartmut Birr submitted a patch that greatly improves
reception of QAM256 modulated channels on the TT-C2300.
(http://www.linuxtv.org/pipermail/linux-dvb/2007-October/021422.html)=20

The patch was not applied as there were a few reports that it was
causing problems. However, the end of the thread suggests that some of
these issues were a result of using the patch in combination with
other frequency shifting patches that also tried to address QAM256
issues.

Other issues were reported on different hardware (CableStar), so I
extended the patch to change the demodulation frequency only for
Nexus-CA.=20

The patch was tested successfully on two TT-C2300 based systems, it
would be great if someone could test whether the patch does hurt
QAM256 reception with CableStar devices or not.

Alexander K=F6nig
--OgqxwSJOaUobr8KG
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="stv0297-qam256-nexusca-only-fix.diff"

diff -ru v4l-dvb.org/linux/drivers/media/dvb/frontends/stv0297.c v4l-dvb/linux/drivers/media/dvb/frontends/stv0297.c
--- v4l-dvb.org/linux/drivers/media/dvb/frontends/stv0297.c	2008-07-26 18:14:23.000000000 +0200
+++ v4l-dvb/linux/drivers/media/dvb/frontends/stv0297.c	2008-07-26 18:16:38.000000000 +0200
@@ -463,7 +463,9 @@
 	stv0297_writereg(state, 0x82, 0x0);
 
 	/* set initial demodulation frequency */
-	stv0297_set_initialdemodfreq(state, 7250);
+	stv0297_set_initialdemodfreq(state, 
+		state->config->qam256_reduced_demodfreq & 
+		(p->u.qam.modulation == QAM_256) ? 6718 : 7250);
 
 	/* setup AGC */
 	stv0297_writereg_mask(state, 0x43, 0x10, 0x00);
diff -ru v4l-dvb.org/linux/drivers/media/dvb/frontends/stv0297.h v4l-dvb/linux/drivers/media/dvb/frontends/stv0297.h
--- v4l-dvb.org/linux/drivers/media/dvb/frontends/stv0297.h	2008-07-26 18:14:23.000000000 +0200
+++ v4l-dvb/linux/drivers/media/dvb/frontends/stv0297.h	2008-07-26 18:16:38.000000000 +0200
@@ -40,6 +40,11 @@
 
 	/* set to 1 if the device requires an i2c STOP during reading */
 	u8 stop_during_read:1;
+
+	/* set to 1 if the device requires reduced demodulation frequency 
+	* for QAM256.
+	*/
+	u8 qam256_reduced_demodfreq:1;
 };
 
 #if defined(CONFIG_DVB_STV0297) || (defined(CONFIG_DVB_STV0297_MODULE) && defined(MODULE))
diff -ru v4l-dvb.org/linux/drivers/media/dvb/ttpci/av7110.c v4l-dvb/linux/drivers/media/dvb/ttpci/av7110.c
--- v4l-dvb.org/linux/drivers/media/dvb/ttpci/av7110.c	2008-07-26 18:14:23.000000000 +0200
+++ v4l-dvb/linux/drivers/media/dvb/ttpci/av7110.c	2008-07-26 18:16:38.000000000 +0200
@@ -1874,6 +1874,7 @@
 	.inittab = nexusca_stv0297_inittab,
 	.invert = 1,
 	.stop_during_read = 1,
+	.qam256_reduced_demodfreq = 1,
 };
 
 
diff -ru v4l-dvb.org/linux/drivers/media/dvb/ttpci/budget-ci.c v4l-dvb/linux/drivers/media/dvb/ttpci/budget-ci.c
--- v4l-dvb.org/linux/drivers/media/dvb/ttpci/budget-ci.c	2008-07-26 18:14:23.000000000 +0200
+++ v4l-dvb/linux/drivers/media/dvb/ttpci/budget-ci.c	2008-07-26 18:16:38.000000000 +0200
@@ -1061,6 +1061,7 @@
 	.inittab = dvbc_philips_tdm1316l_inittab,
 	.invert = 0,
 	.stop_during_read = 1,
+	.qam256_reduced_demodfreq = 0,
 };
 
 static struct tda10023_config tda10023_config = {
diff -ru v4l-dvb.org/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c v4l-dvb/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
--- v4l-dvb.org/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c	2008-07-26 18:14:23.000000000 +0200
+++ v4l-dvb/linux/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c	2008-07-26 18:16:38.000000000 +0200
@@ -1572,6 +1572,7 @@
 	.demod_address = 0x1c,
 	.inittab = dvbc_philips_tdm1316l_inittab,
 	.invert = 0,
+	.qam256_reduced_demodfreq = 0,
 };
 
 static void frontend_init(struct ttusb* ttusb)

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--OgqxwSJOaUobr8KG--

Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:44135 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758112Ab1DYNZf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2011 09:25:35 -0400
Message-ID: <4DB57662.8080705@gmx.net>
Date: Mon, 25 Apr 2011 15:25:54 +0200
From: Lutz Sammer <johns98@gmx.net>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: linux-media@vger.kernel.org
Subject: RE: stb0899/stb6100 tuning problems
Content-Type: multipart/mixed;
 boundary="------------070509050602090201090605"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------070509050602090201090605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Have you tried s2-liplianin version of drivers?
http://mercurial.intuxication.org/hg/s2-liplianin/summary

With s2-liplianin + patches I can lock it with the TT-3600-S2

*** Zapping to 1706 '[012e];':
Delivery 6, modulation 8PSK
sat 1, frequency 11681 MHz H, symbolrate 27500000, coderate 3/4, rolloff
0.35
vpid 0x0209, apid 0x020a, sid 0x012e
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1b | signal 18437 | noise 38026 | ber       0 | unc -2 | tim    0
|FE_HAS_LOCK |  0
status 1b | signal 18437 | noise 37839 | ber 5333333 | unc -2 | tim    0
|FE_HAS_LOCK |  0

On DVB-S2 12692000 H 27500000 3/4 20 8PSK I can't get a lock or scan result.

Johns



--------------070509050602090201090605
Content-Type: text/plain;
 name="stb0899_fec_fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="stb0899_fec_fix.diff"

diff -r 7e47ba1d4ae8 linux/drivers/media/dvb/frontends/stb0899_drv.c
--- a/s2-liplianin/linux/drivers/media/dvb/frontends/stb0899_drv.c	Tue Mar 08 13:38:29 2011 +0200
+++ b/s2-liplianin/linux/drivers/media/dvb/frontends/stb0899_drv.c	Mon Apr 25 15:01:55 2011 +0200
@@ -1431,9 +1431,9 @@
 	if (iter_scale > config->ldpc_max_iter)
 		iter_scale = config->ldpc_max_iter;
 
-	reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
+	reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
 	STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
-	stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
+	stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
 }
 
 static int stb0899_set_property(struct dvb_frontend *fe, struct dtv_property* tvp)

--------------070509050602090201090605--

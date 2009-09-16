Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:41335 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751845AbZIPNuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 09:50:25 -0400
Message-ID: <4AB0ED11.3090205@stud.uni-hannover.de>
Date: Wed, 16 Sep 2009 15:50:09 +0200
From: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
MIME-Version: 1.0
To: pboettcher@kernellabs.com
CC: linux-media@vger.kernel.org, odanet@caramail.com
Subject: dib0700 i2c problem / mt2266 patch
References: <4A16A8FF.2050308@stud.uni-hannover.de> <4AAE1975.6050707@stud.uni-hannover.de>
In-Reply-To: <4AAE1975.6050707@stud.uni-hannover.de>
Content-Type: multipart/mixed;
 boundary="------------050303030901010304080301"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050303030901010304080301
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick,

when you are discussing dib0700 issues with dibcom, there is an
additional one for the list:
When using dib0700 in dual mode (on my nova-td stick), from
time to time a tuner hangs up. I never observed this behavior in
single mode. It seems to me that there is no proper locking within
the dib0700 firmware when accessing both tuner i2c buses
"simultaneously".

Since I only need UHF channels, I use the attached patch to decrease
the number of i2c transactions and tuner registers, which are involved
in the channel switch. This solved the tuning problems.

Besides the i2c problem, maybe it might be a good idea to integrate
this patch into the mt2266 driver anyway, because it considerably
speeds up the channel switch.

Regards,
S:oren




--------------050303030901010304080301
Content-Type: text/x-patch;
 name="mt2266.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mt2266.patch"

--- drivers/media/common/tuners/mt2266.c.orig	2009-06-29 22:11:08.000000000 +0200
+++ drivers/media/common/tuners/mt2266.c	2009-06-29 22:21:01.000000000 +0200
@@ -137,7 +137,6 @@ static int mt2266_set_params(struct dvb_
 	freq = params->frequency / 1000; // Hz -> kHz
 	if (freq < 470000 && freq > 230000)
 		return -EINVAL; /* Gap between VHF and UHF bands */
-	priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
 	priv->frequency = freq * 1000;
 
 	tune = 2 * freq * (8192/16) / (FREF/16);
@@ -145,21 +144,24 @@ static int mt2266_set_params(struct dvb_
 	if (band == MT2266_VHF)
 		tune *= 2;
 
-	switch (params->u.ofdm.bandwidth) {
-	case BANDWIDTH_6_MHZ:
-		mt2266_writeregs(priv, mt2266_init_6mhz,
-				 sizeof(mt2266_init_6mhz));
-		break;
-	case BANDWIDTH_7_MHZ:
-		mt2266_writeregs(priv, mt2266_init_7mhz,
-				 sizeof(mt2266_init_7mhz));
-		break;
-	case BANDWIDTH_8_MHZ:
-	default:
-		mt2266_writeregs(priv, mt2266_init_8mhz,
-				 sizeof(mt2266_init_8mhz));
-		break;
-	}
+        if (priv->bandwidth != params->u.ofdm.bandwidth) {
+          priv->bandwidth = (fe->ops.info.type == FE_OFDM) ? params->u.ofdm.bandwidth : 0;
+          switch (params->u.ofdm.bandwidth) {
+          case BANDWIDTH_6_MHZ:
+            mt2266_writeregs(priv, mt2266_init_6mhz,
+                             sizeof(mt2266_init_6mhz));
+            break;
+          case BANDWIDTH_7_MHZ:
+            mt2266_writeregs(priv, mt2266_init_7mhz,
+                             sizeof(mt2266_init_7mhz));
+            break;
+          case BANDWIDTH_8_MHZ:
+          default:
+            mt2266_writeregs(priv, mt2266_init_8mhz,
+                             sizeof(mt2266_init_8mhz));
+            break;
+          }
+        }
 
 	if (band == MT2266_VHF && priv->band == MT2266_UHF) {
 		dprintk("Switch from UHF to VHF");
@@ -327,6 +329,7 @@ struct dvb_frontend * mt2266_attach(stru
 
 	priv->cfg      = cfg;
 	priv->i2c      = i2c;
+	priv->bandwidth= BANDWIDTH_8_MHZ;
 	priv->band     = MT2266_UHF;
 
 	if (mt2266_readreg(priv, 0, &id)) {

--------------050303030901010304080301--

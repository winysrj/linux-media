Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:47521 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752936AbZKTNJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 08:09:16 -0500
Message-ID: <4B0694F7.7070604@stud.uni-hannover.de>
Date: Fri, 20 Nov 2009 14:09:11 +0100
From: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pboettcher@kernellabs.com
Subject: Re: SV: [linux-dvb] NOVA-TD exeriences?
References: <4AEF5FE5.2000607@stud.uni-hannover.de> <4AF162BC.4010700@stud.uni-hannover.de>
In-Reply-To: <4AF162BC.4010700@stud.uni-hannover.de>
Content-Type: multipart/mixed;
 boundary="------------050403010702030105060802"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050403010702030105060802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 > > >
 > > > Very strange. Playing of two different muxes is also no problem 
for me,
 > > as
 > > > long
 > > > as no new stream is started (of course after switching off one of the
 > > > streams
 > > > before). In the start moment of the new the stream the already 
running
 > > > stream
 > > > is disturbed and I see a demaged group of pictures in the old stream.
 > > After
 > > > these few pictures the stream is running fine again.
 > > >
 > > > I cannot imagine that this is a specific problem of my stick, 
however,
 > > > thank you for testing!
 > >
 > >
 > > Hmm - well I haven't made a close inspection (frame by frame) of every
 > > frame during the startup of second player.
 > > Kaffaine seems to have blocked screen refresh because Xorg gets locked
 > > via starting mplayer.
 > > So there is definitely frame skipping viewing experience - but that's
 > > the flaw of Xorg - sound is played just fine.
 > >
 > > If I should check whether there are no TS stream errors only at the
 > > moment of startup, I'll need to grab both streams and make a better
 > > analysis.  My current statement was purely based on the fact, that I
 > > could watch both channels without any picture artefacts or sound
 > > distorsion - but during startup there is surelly a period, when some
 > > frames are not even visibile, because kaffeine cannot even refresh
 > > playing window - but that's another story....
 > >
 > >
 > > Zdenek
 >
 >
 > Hi again. Just got my two new NOVA-TD's and at a first glance they 
seemed to
 > perform well. Closer inspections however revealed that I see exactly 
the same
 > issues as Soeren. Watching live TV with VDR on one adaptor while 
constantly
 > retuning the other one using:
 > while true;do tzap -x svt1;done
 > gives a short glitch in the VDR stream on almost every tzap. Another 
100EUR down
 > the drain. I'll probably buy four NOVA-T's instead just like I 
planned to at
 > first.
 >
 > /Magnus H

Slowly, slowly. Magnus, you want to support dibcom with another 100EUR for
there poor performance in fixing the firmware?
Please test my patches, the nova-td is running fine with these patches, 
at least for me.

Patrick, any progress here? Will dibcom fix the firmware, or will you 
integrate the
patches? Or what can I do to go on?

Regards,
Soeren



--------------050403010702030105060802
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

--------------050403010702030105060802
Content-Type: text/x-patch;
 name="nova-td.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nova-td.patch"

--- drivers/media/dvb/dvb-usb/dib0700_devices.c.orig	2009-04-18 16:45:12.000000000 +0200
+++ drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-04-18 18:58:54.000000000 +0200
@@ -290,6 +290,9 @@ static int stk7700d_frontend_attach(stru
 	adap->fe = dvb_attach(dib7000p_attach, &adap->dev->i2c_adap,0x80+(adap->id << 1),
 				&stk7700d_dib7000p_mt2266_config[adap->id]);
 
+        adap->props.streaming_ctrl = NULL;
+        dib0700_streaming_ctrl(adap, 1);
+
 	return adap->fe == NULL ? -ENODEV : 0;
 }
 
@@ -1414,7 +1417,7 @@ MODULE_DEVICE_TABLE(usb, dib0700_usb_id_
 	.streaming_ctrl   = dib0700_streaming_ctrl, \
 	.stream = { \
 		.type = USB_BULK, \
-		.count = 4, \
+		.count = 1, \
 		.endpoint = ep, \
 		.u = { \
 			.bulk = { \

--------------050403010702030105060802--

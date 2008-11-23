Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L4CbF-0004Eg-Fm
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 11:54:00 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mANArr7g006932
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 11:53:53 +0100
Message-ID: <49293640.10808@cadsoft.de>
Date: Sun, 23 Nov 2008 11:53:52 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------020806030200010908080909"
Subject: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

This is a multi-part message in MIME format.
--------------020806030200010908080909
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The attached patch adds a capability flag that allows an application
to determine whether a particular device can handle "second generation
modulation" transponders. This is necessary in order for applications
to be able to decide which device to use for a given channel in
a multi device environment, where DVB-S and DVB-S2 devices are mixed.

It is assumed that a device capable of handling "second generation
modulation" can implicitly handle "first generation modulation".
The flag is not named anything with DVBS2 in order to allow its
use with future DVBT2 devices as well (should they ever come).

Signed-off by: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>


PS: why an API named *S2*API didn't contain this in the first place
    is totally beyond me...

--------------020806030200010908080909
Content-Type: text/x-patch;
 name="v4l-dvb-s2api-add-s2-capability.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="v4l-dvb-s2api-add-s2-capability.diff"

diff -ru v4l-dvb-17754ef554b0/linux/drivers/media/dvb/frontends/cx24116.c v4l-dvb-2008-11-22-17754ef554b0/linux/drivers/media/dvb/frontends/cx24116.c
--- v4l-dvb-17754ef554b0/linux/drivers/media/dvb/frontends/cx24116.c	2008-11-21 23:00:55.000000000 +0100
+++ v4l-dvb-2008-11-22-17754ef554b0/linux/drivers/media/dvb/frontends/cx24116.c	2008-11-23 11:36:31.000000000 +0100
@@ -1459,6 +1459,7 @@
 			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
 			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
 			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+			FE_CAN_2ND_GEN_MODULATION |
 			FE_CAN_QPSK | FE_CAN_RECOVER
 	},
 
diff -ru v4l-dvb-17754ef554b0/linux/drivers/media/dvb/frontends/stb0899_drv.c v4l-dvb-2008-11-22-17754ef554b0/linux/drivers/media/dvb/frontends/stb0899_drv.c
--- v4l-dvb-17754ef554b0/linux/drivers/media/dvb/frontends/stb0899_drv.c	2008-11-21 23:00:55.000000000 +0100
+++ v4l-dvb-2008-11-22-17754ef554b0/linux/drivers/media/dvb/frontends/stb0899_drv.c	2008-11-23 11:37:01.000000000 +0100
@@ -1913,6 +1913,7 @@
 
 		.caps 			= FE_CAN_INVERSION_AUTO	|
 					  FE_CAN_FEC_AUTO	|
+					  FE_CAN_2ND_GEN_MODULATION |
 					  FE_CAN_QPSK
 	},
 
diff -ru v4l-dvb-17754ef554b0/linux/include/linux/dvb/frontend.h v4l-dvb-2008-11-22-17754ef554b0/linux/include/linux/dvb/frontend.h
--- v4l-dvb-17754ef554b0/linux/include/linux/dvb/frontend.h	2008-11-21 23:00:55.000000000 +0100
+++ v4l-dvb-2008-11-22-17754ef554b0/linux/include/linux/dvb/frontend.h	2008-11-23 11:27:21.000000000 +0100
@@ -63,6 +63,7 @@
 	FE_CAN_8VSB			= 0x200000,
 	FE_CAN_16VSB			= 0x400000,
 	FE_HAS_EXTENDED_CAPS		= 0x800000,   // We need more bitspace for newer APIs, indicate this.
+        FE_CAN_2ND_GEN_MODULATION       = 0x10000000, // frontend supports "2nd generation modulation" (DVB-S2)
 	FE_NEEDS_BENDING		= 0x20000000, // not supported anymore, don't use (frontend requires frequency bending)
 	FE_CAN_RECOVER			= 0x40000000, // frontend can recover from a cable unplug automatically
 	FE_CAN_MUTE_TS			= 0x80000000  // frontend can stop spurious TS data output

--------------020806030200010908080909
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020806030200010908080909--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxin.ulb.ac.be ([164.15.128.112]:17755 "EHLO mxin.ulb.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629Ab0G0I6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 04:58:00 -0400
Subject: Patch for TwinHan VT DST and compatible DVB-T cards
From: Arnuschky <arnuschky@xylon.de>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 10:48:08 +0200
Message-ID: <1280220488.21267.8.camel@edison>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

here a small patch to get a TwinHan VT DST DVB-T card working with
kernels >= 2.6.32. Analogously to
http://linuxtv.org/hg/v4l-dvb/rev/0e735b509163 I had to:

"Fill in the .caps field in struct dst_dvbt_ops (around line 1763) with
all the supported QAM modulation methods to match the capabilities of
the card as implemented in function dst_set_modulation (around line
502). Note that beginning with linux kernel version 2.6.32 the
modulation method is checked (by function dvb_frontend_check_parameters
in file drivers/media/dvb/dvb-core/dvb_frontend.c) and thus tuning fails
if you use a modulation method that is not present in the .caps field."

Patch:

diff -r 9652f85e688a linux/drivers/media/dvb/bt8xx/dst.c
--- a/linux/drivers/media/dvb/bt8xx/dst.c	Thu May 27 02:02:09 2010 -0300
+++ b/linux/drivers/media/dvb/bt8xx/dst.c	Tue Jul 27 09:34:38 2010 +0200
@@ -1763,7 +1763,15 @@
 		.frequency_min = 137000000,
 		.frequency_max = 858000000,
 		.frequency_stepsize = 166667,
-		.caps = FE_CAN_FEC_AUTO | FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO | FE_CAN_GUARD_INTERVAL_AUTO
+		.caps = FE_CAN_FEC_AUTO			|
+			FE_CAN_QAM_AUTO 		|
+			FE_CAN_QAM_16			|
+			FE_CAN_QAM_32			|
+			FE_CAN_QAM_64			|
+			FE_CAN_QAM_128			|
+			FE_CAN_QAM_256			|
+			FE_CAN_TRANSMISSION_MODE_AUTO	|
+			FE_CAN_GUARD_INTERVAL_AUTO
 	},
 
 	.release = dst_release,
---------------------8<--------------------------

Tested on 2.6.32-24, works fine. Thanks to Klaas de Waal for creating
the original patch for the DVB-C cards.

Hope this helps someone,
Arne


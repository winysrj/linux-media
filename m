Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm2.telefonica.net ([213.4.138.18]:60348 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751688Ab2A0Wf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 17:35:26 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix drxk get_tune_settings for DVB-T
Date: Fri, 27 Jan 2012 23:34:49 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JayIPtjyEZNUrWV"
Message-Id: <201201272334.50166.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_JayIPtjyEZNUrWV
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

DVB-T also use step_size=0.

Jose Alberto

--Boundary-00=_JayIPtjyEZNUrWV
Content-Type: text/x-patch;
  charset="UTF-8";
  name="drxk_hard.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="drxk_hard.diff"

diff -ur linux/drivers/media/dvb/frontends/drxk_hard.c linux.new/drivers/media/dvb/frontends/drxk_hard.c
--- linux/drivers/media/dvb/frontends/drxk_hard.c	2012-01-22 02:53:17.000000000 +0100
+++ linux.new/drivers/media/dvb/frontends/drxk_hard.c	2012-01-23 21:18:12.909138061 +0100
@@ -6317,15 +6317,12 @@
 	switch (p->delivery_system) {
 	case SYS_DVBC_ANNEX_A:
 	case SYS_DVBC_ANNEX_C:
+	case SYS_DVBT:
 		sets->min_delay_ms = 3000;
 		sets->max_drift = 0;
 		sets->step_size = 0;
 		return 0;
 	default:
-		/*
-		 * For DVB-T, let it use the default DVB core way, that is:
-		 *	fepriv->step_size = fe->ops.info.frequency_stepsize * 2
-		 */
 		return -EINVAL;
 	}
 }

--Boundary-00=_JayIPtjyEZNUrWV--

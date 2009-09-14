Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:39278
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZINAPC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 20:15:02 -0400
Date: Mon, 14 Sep 2009 02:14:47 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Henk.Vergonet@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH] tda18271 add FM filter selction + minor fixes
Message-ID: <20090914001447.GA15770@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com> <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com> <20090907124934.GA8339@systol-ng.god.lan> <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com> <20090907151809.GA12556@systol-ng.god.lan> <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com> <20090908212733.GA19438@systol-ng.god.lan> <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com> <20090909140147.GA24722@systol-ng.god.lan> <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


This patch adds support for FM filter selection. The tda18271 has two rf
inputs RF_IN (45-864 MHz) and FM_IN (65-108 MHz). The code automatically
enables the antialiasing filter for radio reception and depending on the
FM input selected configures EB23 register.

Additional fixes:
- Fixed the temerature comensation, see revision history of TDA18271HD_4
  spec.
- Minor cosmetic change in the tda18271_rf_band[]
- Fixed one value and removed a duplicate in tda18271_cid_target[]

Signed-off-by: Henk.Vergonet@gmail.com


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=tda18271-add-FM-filter-selection

diff -r 2b49813f8482 linux/drivers/media/common/tuners/tda18271-fe.c
--- a/linux/drivers/media/common/tuners/tda18271-fe.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/common/tuners/tda18271-fe.c	Mon Sep 14 01:45:49 2009 +0200
@@ -99,6 +99,22 @@
 	if (tda_fail(ret))
 		goto fail;
 
+	/* update FM filter selection */
+	if (map->std == 0) {
+		/* std == FM radio */
+		regs[R_EB23] |=  0x06; /* 1.5 Mhz cut-off freq */
+	} else if (map->fm_rfn) {
+		/* antenna FM_IN, std != FM radio */
+		regs[R_EB23] |=  0x04; /* set FORCELP */
+		regs[R_EB23] &= ~0x02; /* clear LP_FC */
+	} else {
+		/* antenna RF_IN, std != FM radio */
+		regs[R_EB23] &= ~0x06; /* clear FORCELP, LP_FC */
+	}
+	ret = tda18271_write_regs(fe, R_EB23, 1);
+	if (tda_fail(ret))
+		goto fail;
+
 	/* --------------------------------------------------------------- */
 
 	/* disable Power Level Indicator */
@@ -272,7 +288,7 @@
 	tda18271_lookup_map(fe, RF_CAL_DC_OVER_DT, &freq, &dc_over_dt);
 
 	/* calculate temperature compensation */
-	rfcal_comp = dc_over_dt * (tm_current - priv->tm_rfcal);
+	rfcal_comp = dc_over_dt * (tm_current - priv->tm_rfcal) / 1000;
 
 	regs[R_EB14] = approx + rfcal_comp;
 	ret = tda18271_write_regs(fe, R_EB14, 1);
diff -r 2b49813f8482 linux/drivers/media/common/tuners/tda18271-maps.c
--- a/linux/drivers/media/common/tuners/tda18271-maps.c	Thu Sep 03 09:06:34 2009 -0300
+++ b/linux/drivers/media/common/tuners/tda18271-maps.c	Mon Sep 14 01:45:49 2009 +0200
@@ -229,8 +229,8 @@
 static struct tda18271_map tda18271_rf_band[] = {
 	{ .rfmax =  47900, .val = 0x00 },
 	{ .rfmax =  61100, .val = 0x01 },
+	{ .rfmax = 121200, .val = 0x02 },
 /*	{ .rfmax = 152600, .val = 0x02 }, */
-	{ .rfmax = 121200, .val = 0x02 },
 	{ .rfmax = 164700, .val = 0x03 },
 	{ .rfmax = 203500, .val = 0x04 },
 	{ .rfmax = 457800, .val = 0x05 },
@@ -962,10 +962,10 @@
 static struct tda18271_cid_target_map tda18271_cid_target[] = {
 	{ .rfmax =  46000, .target = 0x04, .limit =  1800 },
 	{ .rfmax =  52200, .target = 0x0a, .limit =  1500 },
-	{ .rfmax =  79100, .target = 0x01, .limit =  4000 },
+	{ .rfmax =  70100, .target = 0x01, .limit =  4000 },
+/*	{ .rfmax =  79100, .target = 0x01, .limit =  4000 },	*/
 	{ .rfmax = 136800, .target = 0x18, .limit =  4000 },
 	{ .rfmax = 156700, .target = 0x18, .limit =  4000 },
-	{ .rfmax = 156700, .target = 0x18, .limit =  4000 },
 	{ .rfmax = 186250, .target = 0x0a, .limit =  4000 },
 	{ .rfmax = 230000, .target = 0x0a, .limit =  4000 },
 	{ .rfmax = 345000, .target = 0x18, .limit =  4000 },

--EVF5PPMfhYS0aIcm--

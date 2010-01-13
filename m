Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1086 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987Ab0AMG7S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 01:59:18 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/3] drivers/media/dvb/frontends/si21xx.c: Remove #define TRUE/FALSE, use bool
Date: Tue, 12 Jan 2010 22:59:15 -0800
Message-Id: <2b78279a02083e0f1e32bd91ca0b6362ac5fcf97.1263365754.git.joe@perches.com>
In-Reply-To: <cover.1263365754.git.joe@perches.com>
References: <cover.1263365754.git.joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

And a little code refactoring/neatening around the removals

Reduces object size a little bit:

new:
$ size drivers/media/dvb/frontends/si21xx.o
   text	   data	    bss	    dec	    hex	filename
   8984	     56	   1816	  10856	   2a68	drivers/media/dvb/frontends/si21xx.o
old:
$ size drivers/media/dvb/frontends/si21xx.o
   text	   data	    bss	    dec	    hex	filename
   9084	     56	   1792	  10932	   2ab4	drivers/media/dvb/frontends/si21xx.o

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/frontends/si21xx.c |   38 ++++++++++++++-------------------
 1 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb/frontends/si21xx.c
index 9552a22..d21a327 100644
--- a/drivers/media/dvb/frontends/si21xx.c
+++ b/drivers/media/dvb/frontends/si21xx.c
@@ -97,8 +97,6 @@
 #define	LNB_SUPPLY_CTRL_REG_4		0xce
 #define	LNB_SUPPLY_STATUS_REG		0xcf
 
-#define FALSE	0
-#define TRUE	1
 #define FAIL	-1
 #define PASS	0
 
@@ -718,7 +716,7 @@ static int si21xx_set_frontend(struct dvb_frontend *fe,
 	int fine_tune_freq;
 	unsigned char sample_rate = 0;
 	/* boolean */
-	unsigned int inband_interferer_ind;
+	bool inband_interferer_ind;
 
 	/* INTERMEDIATE VALUES */
 	int icoarse_tune_freq; /* MHz */
@@ -728,15 +726,8 @@ static int si21xx_set_frontend(struct dvb_frontend *fe,
 	unsigned int x1;
 	unsigned int x2;
 	int i;
-	unsigned int inband_interferer_div2[ALLOWABLE_FS_COUNT] = {
-			FALSE, FALSE, FALSE, FALSE, FALSE,
-			FALSE, FALSE, FALSE, FALSE, FALSE
-	};
-	unsigned int inband_interferer_div4[ALLOWABLE_FS_COUNT] = {
-			FALSE, FALSE, FALSE, FALSE, FALSE,
-			FALSE, FALSE, FALSE, FALSE, FALSE
-	};
-
+	bool inband_interferer_div2[ALLOWABLE_FS_COUNT];
+	bool inband_interferer_div4[ALLOWABLE_FS_COUNT];
 	int status;
 
 	/* allowable sample rates for ADC in MHz */
@@ -762,7 +753,7 @@ static int si21xx_set_frontend(struct dvb_frontend *fe,
 	}
 
 	for (i = 0; i < ALLOWABLE_FS_COUNT; ++i)
-		inband_interferer_div2[i] = inband_interferer_div4[i] = FALSE;
+		inband_interferer_div2[i] = inband_interferer_div4[i] = false;
 
 	if_limit_high = -700000;
 	if_limit_low = -100000;
@@ -798,7 +789,7 @@ static int si21xx_set_frontend(struct dvb_frontend *fe,
 
 		if (((band_low < x1) && (x1 < band_high)) ||
 					((band_low < x2) && (x2 < band_high)))
-					inband_interferer_div4[i] = TRUE;
+					inband_interferer_div4[i] = true;
 
 	}
 
@@ -811,25 +802,28 @@ static int si21xx_set_frontend(struct dvb_frontend *fe,
 
 		if (((band_low < x1) && (x1 < band_high)) ||
 					((band_low < x2) && (x2 < band_high)))
-					inband_interferer_div2[i] = TRUE;
+					inband_interferer_div2[i] = true;
 	}
 
-	inband_interferer_ind = TRUE;
-	for (i = 0; i < ALLOWABLE_FS_COUNT; ++i)
-		inband_interferer_ind &= inband_interferer_div2[i] |
-						inband_interferer_div4[i];
+	inband_interferer_ind = true;
+	for (i = 0; i < ALLOWABLE_FS_COUNT; ++i) {
+		if (inband_interferer_div2[i] || inband_interferer_div4[i]) {
+			inband_interferer_ind = false;
+			break;
+		}
+	}
 
 	if (inband_interferer_ind) {
 		for (i = 0; i < ALLOWABLE_FS_COUNT; ++i) {
-			if (inband_interferer_div2[i] == FALSE) {
+			if (!inband_interferer_div2[i]) {
 				sample_rate = (u8) afs[i];
 				break;
 			}
 		}
 	} else {
 		for (i = 0; i < ALLOWABLE_FS_COUNT; ++i) {
-			if ((inband_interferer_div2[i] |
-					inband_interferer_div4[i]) == FALSE) {
+			if ((inband_interferer_div2[i] ||
+			     !inband_interferer_div4[i])) {
 				sample_rate = (u8) afs[i];
 				break;
 			}
-- 
1.6.6.rc0.57.gad7a


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34454 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162Ab2EXWDH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 18:03:07 -0400
Received: by wgbdr13 with SMTP id dr13so224736wgb.1
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 15:03:05 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 2/2] LNB calculation fixed
Date: Fri, 25 May 2012 00:02:10 +0200
Message-Id: <1337896930-19554-2-git-send-email-neolynx@gmail.com>
In-Reply-To: <1337896930-19554-1-git-send-email-neolynx@gmail.com>
References: <1337896930-19554-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/libdvbv5/dvb-sat.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index 0cef091..c93b882 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -349,7 +349,7 @@ int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 {
 	struct dvb_sat_lnb *lnb = parms->lnb;
 	enum dvb_sat_polarization pol;
-	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION,& pol);
+	dvb_fe_retrieve_parm(parms, DTV_POLARIZATION, &pol);
 	uint32_t freq;
 	uint16_t t = 0;
 	uint32_t voltage = SEC_VOLTAGE_13;
@@ -364,27 +364,27 @@ int dvb_sat_set_parms(struct dvb_v5_fe_parms *parms)
 
 	/* Simple case: LNBf with just Single LO */
 	if (!lnb->highfreq) {
-		parms->freq_offset = lnb->lowfreq;
+		parms->freq_offset = lnb->lowfreq * 1000;
 		goto ret;
 	}
 
 	/* polarization-controlled multi LNBf */
 	if (!lnb->rangeswitch) {
 		if ((pol == POLARIZATION_V) || (pol == POLARIZATION_R))
-			parms->freq_offset = lnb->lowfreq;
+			parms->freq_offset = lnb->lowfreq * 1000;
 		else
-			parms->freq_offset = lnb->highfreq;
+			parms->freq_offset = lnb->highfreq * 1000;
 		goto ret;
 	}
 
 	/* Voltage-controlled multiband switch */
-	parms->high_band = (freq > lnb->rangeswitch) ? 1 : 0;
+	parms->high_band = (freq > lnb->rangeswitch * 1000) ? 1 : 0;
 
 	/* Adjust frequency */
 	if (parms->high_band)
-		parms->freq_offset = lnb->highfreq;
+		parms->freq_offset = lnb->highfreq * 1000;
 	else
-		parms->freq_offset = lnb->lowfreq;
+		parms->freq_offset = lnb->lowfreq * 1000;
 
 	/* For SCR/Unicable setups */
 	if (parms->freq_bpf) {
-- 
1.7.2.5


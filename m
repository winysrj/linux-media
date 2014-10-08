Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39277 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbaJHMKQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 08:10:16 -0400
Received: by mail-pd0-f182.google.com with SMTP id y10so6832068pdj.13
        for <linux-media@vger.kernel.org>; Wed, 08 Oct 2014 05:10:15 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH 2/4] v4l-utils/libdvbv5: add support for ISDB-S tuning
Date: Wed,  8 Oct 2014 21:09:39 +0900
Message-Id: <1412770181-5420-3-git-send-email-tskd08@gmail.com>
In-Reply-To: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Added LNB support for Japanese satellites.
Currently tested with dvbv5-zap, dvb-fe-tool.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/libdvbv5/dvb-sat.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index e8df06b..70b1021 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -91,6 +91,13 @@ static const struct dvb_sat_lnb lnb[] = {
 		.freqrange = {
 			{ 12200, 12700 }
 		}
+	}, {
+		.name = "Japan 110BS/CS LNBf",
+		.alias = "110BS",
+		.lowfreq = 10678,
+		.freqrange = {
+			{ 11727, 12731 }
+		}
 	},
 };
 
@@ -304,6 +311,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 		 */
 		pol_v = 0;
 		high_band = 1;
+		if (lnb == &lnb[8])
+			vol_high = 1;
 	} else {
 		/* Adjust voltage/tone accordingly */
 		if (parms->p.sat_number < 2) {
@@ -316,6 +325,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 	rc = dvb_fe_sec_voltage(&parms->p, 1, vol_high);
 	if (rc)
 		return rc;
+	if (parms->p.current_sys == SYS_ISDBS)
+		return 0;
 
 	if (parms->p.sat_number > 0) {
 		rc = dvb_fe_sec_tone(&parms->p, SEC_TONE_OFF);
-- 
2.1.2


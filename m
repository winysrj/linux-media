Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63876 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932646AbaJaNOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:25 -0400
Received: by mail-pa0-f44.google.com with SMTP id bj1so7696916pad.17
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:14:24 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 4/7] v4l-utils/libdvbv5: add support for ISDB-S tuning
Date: Fri, 31 Oct 2014 22:13:41 +0900
Message-Id: <1414761224-32761-5-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Added LNB support for Japanese satellites.
Currently tested with dvbv5-zap, dvb-fe-tool.
At least the charset conversion and the parser of
extended event descriptors are not implemented now,
as they require some ISDB-S(/T) specific modification.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/libdvbv5/dvb-sat.c    | 9 +++++++++
 lib/libdvbv5/dvb-v5-std.c | 4 ----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index e8df06b..010aebe 100644
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
+			{ 11710, 12751 }
+		}
 	},
 };
 
@@ -304,6 +311,8 @@ static int dvbsat_diseqc_set_input(struct dvb_v5_fe_parms_priv *parms,
 		 */
 		pol_v = 0;
 		high_band = 1;
+		if (parms->p.current_sys == SYS_ISDBS)
+			vol_high = 1;
 	} else {
 		/* Adjust voltage/tone accordingly */
 		if (parms->p.sat_number < 2) {
diff --git a/lib/libdvbv5/dvb-v5-std.c b/lib/libdvbv5/dvb-v5-std.c
index 871de95..50365cb 100644
--- a/lib/libdvbv5/dvb-v5-std.c
+++ b/lib/libdvbv5/dvb-v5-std.c
@@ -154,11 +154,7 @@ const unsigned int sys_turbo_props[] = {
 
 const unsigned int sys_isdbs_props[] = {
 	DTV_FREQUENCY,
-	DTV_INVERSION,
-	DTV_SYMBOL_RATE,
-	DTV_INNER_FEC,
 	DTV_STREAM_ID,
-	DTV_POLARIZATION,
 	0
 };
 
-- 
2.1.3


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50494 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKBMCS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 07:02:18 -0500
Received: by mail-pd0-f179.google.com with SMTP id g10so9969067pdj.10
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 04:02:18 -0800 (PST)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] v4l-utils/libdvbv5: restore deleted functions to keep API/ABI compatible
Date: Sun,  2 Nov 2014 21:01:59 +0900
Message-Id: <1414929719-11748-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

dvb_new_freq_is_needed() was integrated to dvb_new_entry_is_needed(),
and dvb_scan_add_entry() was added a new parameter.
As those changes broke API/ABI compatibility,
restore the original functions.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/include/libdvbv5/dvb-scan.h | 21 ++++++++++++-----
 lib/libdvbv5/dvb-scan.c         | 50 +++++++++++++++++++++++++++--------------
 2 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
index aad6d01..c480426 100644
--- a/lib/include/libdvbv5/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -385,17 +385,26 @@ void dvb_add_scaned_transponders(struct dvb_v5_fe_parms *parms,
  */
 int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *parms);
 
-int dvb_new_entry_is_needed(struct dvb_entry *entry,
-			   struct dvb_entry *last_entry,
-			   uint32_t freq, int shift,
-			   enum dvb_sat_polarization pol, uint32_t stream_id);
+int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
+			   uint32_t freq, enum dvb_sat_polarization pol, int shift);
 
 struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *parms,
 				     struct dvb_entry *first_entry,
 			             struct dvb_entry *entry,
 			             uint32_t freq, uint32_t shift,
-			             enum dvb_sat_polarization pol,
-			             uint32_t stream_id);
+			             enum dvb_sat_polarization pol);
+
+int dvb_new_entry_is_needed(struct dvb_entry *entry,
+			    struct dvb_entry *last_entry,
+			    uint32_t freq, int shift,
+			    enum dvb_sat_polarization pol, uint32_t stream_id);
+
+struct dvb_entry *dvb_scan_add_entry_ex(struct dvb_v5_fe_parms *parms,
+					struct dvb_entry *first_entry,
+					struct dvb_entry *entry,
+					uint32_t freq, uint32_t shift,
+					enum dvb_sat_polarization pol,
+					uint32_t stream_id);
 
 void dvb_update_transponders(struct dvb_v5_fe_parms *parms,
 			     struct dvb_v5_descriptors *dvb_scan_handler,
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 6c94e8d..637c64e 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -693,6 +693,23 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
 	return shift;
 }
 
+int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
+			   uint32_t freq, enum dvb_sat_polarization pol, int shift)
+{
+	return dvb_new_entry_is_needed(entry, last_entry, freq, shift,
+					 pol, NO_STREAM_ID_FILTER);
+}
+
+struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *__p,
+				     struct dvb_entry *first_entry,
+			             struct dvb_entry *entry,
+			             uint32_t freq, uint32_t shift,
+			             enum dvb_sat_polarization pol)
+{
+	return dvb_scan_add_entry_ex(__p, first_entry, entry, freq, shift,
+					pol, NO_STREAM_ID_FILTER);
+}
+
 int dvb_new_entry_is_needed(struct dvb_entry *entry,
 			    struct dvb_entry *last_entry,
 			    uint32_t freq, int shift,
@@ -729,12 +746,12 @@ int dvb_new_entry_is_needed(struct dvb_entry *entry,
 	return 1;
 }
 
-struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *__p,
-				     struct dvb_entry *first_entry,
-			             struct dvb_entry *entry,
-			             uint32_t freq, uint32_t shift,
-			             enum dvb_sat_polarization pol,
-				     uint32_t stream_id)
+struct dvb_entry *dvb_scan_add_entry_ex(struct dvb_v5_fe_parms *__p,
+					struct dvb_entry *first_entry,
+					struct dvb_entry *entry,
+					uint32_t freq, uint32_t shift,
+					enum dvb_sat_polarization pol,
+					uint32_t stream_id)
 {
 	struct dvb_v5_fe_parms_priv *parms = (void *)__p;
 	struct dvb_entry *new_entry;
@@ -819,7 +836,7 @@ static void add_update_nit_dvbc(struct dvb_table_nit *nit,
 		new = tr->entry;
 	} else {
 		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-					 d->frequency, tr->shift, tr->pol, 0);
+					 d->frequency, tr->shift, tr->pol);
 		if (!new)
 			return;
 	}
@@ -853,8 +870,7 @@ static void add_update_nit_isdbt(struct dvb_table_nit *nit,
 
 	for (i = 0; i < d->num_freqs; i++) {
 		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-					 d->frequency[i], tr->shift,
-					 tr->pol, 0);
+					 d->frequency[i], tr->shift, tr->pol);
 		if (!new)
 			return;
 	}
@@ -928,9 +944,10 @@ static void add_update_nit_dvbt2(struct dvb_table_nit *nit,
 		return;
 
 	for (i = 0; i < t2->frequency_loop_length; i++) {
-		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-					 t2->centre_frequency[i] * 10,
-					 tr->shift, tr->pol, t2->plp_id);
+		new = dvb_scan_add_entry_ex(tr->parms,
+					    tr->first_entry, tr->entry,
+					    t2->centre_frequency[i] * 10,
+					    tr->shift, tr->pol, t2->plp_id);
 		if (!new)
 			continue;
 
@@ -960,8 +977,7 @@ static void add_update_nit_dvbt(struct dvb_table_nit *nit,
 		return;
 
 	new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-				d->centre_frequency * 10, tr->shift,
-				tr->pol, 0);
+				d->centre_frequency * 10, tr->shift, tr->pol);
 	if (!new)
 		return;
 
@@ -1000,7 +1016,7 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
 		new = tr->entry;
 	} else {
 		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-					 d->frequency, tr->shift, tr->pol, 0);
+					 d->frequency, tr->shift, tr->pol);
 		if (!new)
 			return;
 	}
@@ -1042,8 +1058,8 @@ static void add_update_nit_isdbs(struct dvb_table_nit *nit,
 		return;
 
 	ts_id = tran->transport_id;
-	new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-				 d->frequency, tr->shift, tr->pol, ts_id);
+	new = dvb_scan_add_entry_ex(tr->parms, tr->first_entry, tr->entry,
+				    d->frequency, tr->shift, tr->pol, ts_id);
 	if (!new)
 		return;
 
-- 
2.1.3


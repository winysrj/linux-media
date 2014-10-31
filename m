Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40089 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbaJaNON (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:13 -0400
Received: by mail-pd0-f182.google.com with SMTP id fp1so7288182pdb.13
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:14:12 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 1/7] v4l-utils/libdvbv5, dvbv5-scan: generalize channel duplication check
Date: Fri, 31 Oct 2014 22:13:38 +0900
Message-Id: <1414761224-32761-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

When a new channel entry is to be added to the channel list,
it is checked if there's already similar entry in the list.
This check was based only on freq, polarity, allowable frequency shift,
so it could not be used for delivery systems that use stream_id
and mulplex multiple TS's (channels) into one frequency.
This patch adds stream_id to the check.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/include/libdvbv5/dvb-scan.h |  9 ++++---
 lib/libdvbv5/dvb-scan.c         | 56 ++++++++++++++++++++++++++---------------
 utils/dvb/dvbv5-scan.c          |  8 ++++--
 3 files changed, 48 insertions(+), 25 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
index fe50687..aad6d01 100644
--- a/lib/include/libdvbv5/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -385,14 +385,17 @@ void dvb_add_scaned_transponders(struct dvb_v5_fe_parms *parms,
  */
 int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *parms);
 
-int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
-			   uint32_t freq, enum dvb_sat_polarization pol, int shift);
+int dvb_new_entry_is_needed(struct dvb_entry *entry,
+			   struct dvb_entry *last_entry,
+			   uint32_t freq, int shift,
+			   enum dvb_sat_polarization pol, uint32_t stream_id);
 
 struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *parms,
 				     struct dvb_entry *first_entry,
 			             struct dvb_entry *entry,
 			             uint32_t freq, uint32_t shift,
-			             enum dvb_sat_polarization pol);
+			             enum dvb_sat_polarization pol,
+			             uint32_t stream_id);
 
 void dvb_update_transponders(struct dvb_v5_fe_parms *parms,
 			     struct dvb_v5_descriptors *dvb_scan_handler,
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 4a8bd66..31eb78f 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -686,24 +686,37 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
 	return shift;
 }
 
-int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
-			   uint32_t freq, enum dvb_sat_polarization pol, int shift)
+int dvb_new_entry_is_needed(struct dvb_entry *entry,
+			    struct dvb_entry *last_entry,
+			    uint32_t freq, int shift,
+			    enum dvb_sat_polarization pol, uint32_t stream_id)
 {
-	int i;
-	uint32_t data;
-
 	for (; entry != last_entry; entry = entry->next) {
+		int i;
+
 		for (i = 0; i < entry->n_props; i++) {
-			data = entry->props[i].u.data;
-			if (entry->props[i].cmd == DTV_POLARIZATION) {
+			uint32_t data = entry->props[i].u.data;
+
+			if (entry->props[i].cmd == DTV_FREQUENCY) {
+				if (freq < data - shift || freq > data + shift)
+					break;
+			}
+			if (pol != POLARIZATION_OFF
+			    && entry->props[i].cmd == DTV_POLARIZATION) {
 				if (data != pol)
-					continue;
+					break;
 			}
-			if (entry->props[i].cmd == DTV_FREQUENCY) {
-				if (( freq >= data - shift) && (freq <= data + shift))
-					return 0;
+			/* NO_STREAM_ID_FILTER: stream_id is not used.
+			 * 0: unspecified/auto. libdvbv5 default value.
+			 */
+			if (stream_id != NO_STREAM_ID_FILTER && stream_id != 0
+			    && entry->props[i].cmd == DTV_STREAM_ID) {
+				if (data != stream_id)
+					break;
 			}
 		}
+		if (i == entry->n_props && entry->n_props > 0)
+			return 0;
 	}
 
 	return 1;
@@ -713,19 +726,21 @@ struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *__p,
 				     struct dvb_entry *first_entry,
 			             struct dvb_entry *entry,
 			             uint32_t freq, uint32_t shift,
-			             enum dvb_sat_polarization pol)
+			             enum dvb_sat_polarization pol,
+				     uint32_t stream_id)
 {
 	struct dvb_v5_fe_parms_priv *parms = (void *)__p;
 	struct dvb_entry *new_entry;
 	int i, n = 2;
 
-	if (!dvb_new_freq_is_needed(first_entry, NULL, freq, pol, shift))
+	if (!dvb_new_entry_is_needed(first_entry, NULL, freq, shift, pol,
+				     stream_id))
 		return NULL;
 
 	/* Clone the current entry into a new entry */
 	new_entry = calloc(sizeof(*new_entry), 1);
 	if (!new_entry) {
-		dvb_perror("not enough memory for a new scanning frequency");
+		dvb_perror("not enough memory for a new scanning frequency/TS");
 		return NULL;
 	}
 
@@ -797,7 +812,7 @@ static void add_update_nit_dvbc(struct dvb_table_nit *nit,
 		new = tr->entry;
 	} else {
 		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-					 d->frequency, tr->shift, tr->pol);
+					 d->frequency, tr->shift, tr->pol, 0);
 		if (!new)
 			return;
 	}
@@ -831,7 +846,8 @@ static void add_update_nit_isdbt(struct dvb_table_nit *nit,
 
 	for (i = 0; i < d->num_freqs; i++) {
 		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-					 d->frequency[i], tr->shift, tr->pol);
+					 d->frequency[i], tr->shift,
+					 tr->pol, 0);
 		if (!new)
 			return;
 	}
@@ -907,7 +923,7 @@ static void add_update_nit_dvbt2(struct dvb_table_nit *nit,
 	for (i = 0; i < t2->frequency_loop_length; i++) {
 		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
 					 t2->centre_frequency[i] * 10,
-					 tr->shift, tr->pol);
+					 tr->shift, tr->pol, t2->plp_id);
 		if (!new)
 			return;
 
@@ -937,7 +953,8 @@ static void add_update_nit_dvbt(struct dvb_table_nit *nit,
 		return;
 
 	new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-				d->centre_frequency * 10, tr->shift, tr->pol);
+				d->centre_frequency * 10, tr->shift,
+				tr->pol, 0);
 	if (!new)
 		return;
 
@@ -976,7 +993,7 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
 		new = tr->entry;
 	} else {
 		new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
-					 d->frequency, tr->shift, tr->pol);
+					 d->frequency, tr->shift, tr->pol, 0);
 		if (!new)
 			return;
 	}
@@ -998,7 +1015,6 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
 				     SYS_DVBS2);
 }
 
-
 static void __dvb_add_update_transponders(struct dvb_v5_fe_parms_priv *parms,
 					  struct dvb_v5_descriptors *dvb_scan_handler,
 					  struct dvb_entry *first_entry,
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index 827c3c9..9c10e52 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -238,6 +238,7 @@ static int run_scan(struct arguments *args,
 
 	for (entry = dvb_file->first_entry; entry != NULL; entry = entry->next) {
 		struct dvb_v5_descriptors *dvb_scan_handler = NULL;
+		uint32_t stream_id;
 
 		/*
 		 * If the channel file has duplicated frequencies, or some
@@ -251,8 +252,11 @@ static int run_scan(struct arguments *args,
 		if (dvb_retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
 			pol = POLARIZATION_OFF;
 
-		if (!dvb_new_freq_is_needed(dvb_file->first_entry, entry,
-					    freq, pol, shift))
+		if (dvb_retrieve_entry_prop(entry, DTV_STREAM_ID, &stream_id))
+			stream_id = NO_STREAM_ID_FILTER;
+
+		if (!dvb_new_entry_is_needed(dvb_file->first_entry, entry,
+						  freq, shift, pol, stream_id))
 			continue;
 
 		count++;
-- 
2.1.3


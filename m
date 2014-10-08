Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44102 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbaJHMKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 08:10:20 -0400
Received: by mail-pa0-f51.google.com with SMTP id lj1so9037863pab.38
        for <linux-media@vger.kernel.org>; Wed, 08 Oct 2014 05:10:20 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH 3/4] v4l-utils/libdvbv5: add support for ISDB-S scanning
Date: Wed,  8 Oct 2014 21:09:40 +0900
Message-Id: <1412770181-5420-4-git-send-email-tskd08@gmail.com>
In-Reply-To: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

added NIT scan for ISDB-S,
fixed wrong/too-close frequency of the scanned entries,
when freq_offset/bandwith was not set properly.

ISDB-S/T specific charset conversion is separeted off
as an iconv module, and not implemented in this lib.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/include/libdvbv5/dvb-scan.h |   2 +
 lib/libdvbv5/dvb-fe.c           |   6 +-
 lib/libdvbv5/dvb-file.c         |  21 +++++--
 lib/libdvbv5/dvb-scan.c         | 125 +++++++++++++++++++++++++++++++++++++++-
 lib/libdvbv5/parse_string.c     |  23 ++++++++
 5 files changed, 170 insertions(+), 7 deletions(-)

diff --git a/lib/include/libdvbv5/dvb-scan.h b/lib/include/libdvbv5/dvb-scan.h
index fe50687..e3a0d24 100644
--- a/lib/include/libdvbv5/dvb-scan.h
+++ b/lib/include/libdvbv5/dvb-scan.h
@@ -387,6 +387,8 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *parms);
 
 int dvb_new_freq_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
 			   uint32_t freq, enum dvb_sat_polarization pol, int shift);
+int dvb_new_ts_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
+			   uint32_t freq, int shift, uint32_t ts_id);
 
 struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *parms,
 				     struct dvb_entry *first_entry,
diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index f535311..93c0b9b 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -372,6 +372,8 @@ int dvb_set_sys(struct dvb_v5_fe_parms *p, fe_delivery_system_t sys)
 	parms->p.current_sys = sys;
 	parms->n_props = rc;
 
+	if (sys == SYS_ISDBS /* || sys == SYS_ISDBT */)
+		parms->p.default_charset = "arib-std-b24";
 	return 0;
 }
 
@@ -683,8 +685,10 @@ int dvb_fe_set_parms(struct dvb_v5_fe_parms *p)
 			dvb_logdbg("LNA is %s", parms->p.lna ? "ON" : "OFF");
 	}
 
-	if (dvb_fe_is_satellite(tmp_parms.p.current_sys))
+	if (dvb_fe_is_satellite(tmp_parms.p.current_sys)) {
 		dvb_sat_set_parms(&tmp_parms.p);
+		parms->freq_offset = tmp_parms.freq_offset;
+	}
 
 	/* Filter out any user DTV_foo property such as DTV_POLARIZATION */
 	tmp_parms.n_props = dvb_copy_fe_props(tmp_parms.dvb_prop,
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index bcb1762..0a0e41a 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1125,12 +1125,25 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 		entry->props[j].cmd = parms->dvb_prop[j].cmd;
 		entry->props[j].u.data = parms->dvb_prop[j].u.data;
 
-		if ((!channel || !*channel) &&
-		    entry->props[j].cmd == DTV_FREQUENCY)
-			freq = parms->dvb_prop[j].u.data;
+		if (entry->props[j].cmd == DTV_STREAM_ID &&
+		    entry->props[j].u.data == 0 &&
+		    parms->p.current_sys == SYS_ISDBS)
+			entry->props[j].u.data = dvb_scan_handler->pat->header.id;
+
+		if (entry->props[j].cmd != DTV_FREQUENCY)
+			continue;
+
+		if (dvb_fe_is_satellite(parms->p.current_sys) &&
+		    entry->props[j].u.data < parms->freq_offset)
+			entry->props[j].u.data += parms->freq_offset;
+
+		if (!channel || !*channel)
+			freq = entry->props[j].u.data;
 	}
 	if (!channel || !*channel) {
-		r = asprintf(&channel, "%.2fMHz#%d", freq/1000000., service_id);
+		r = asprintf(&channel, "%.2f%cHz#%d", freq / 1000000.,
+			dvb_fe_is_satellite(parms->p.current_sys) ? 'G' : 'M',
+			service_id);
 		if (r < 0)
 			dvb_perror("asprintf");
 		if (parms->p.verbose)
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 3b70f5a..470ef61 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -635,7 +635,7 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
 		rolloff = 115;
 		break;
 	case SYS_DVBS:
-	case SYS_ISDBS:	/* FIXME: not sure if this rollof is right for ISDB-S */
+	case SYS_ISDBS:
 		divisor = 100000;
 		rolloff = 135;
 		break;
@@ -672,11 +672,14 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
 		 * purposes of estimating a max frequency shift here.
 		 */
 		dvb_fe_retrieve_parm(&parms->p, DTV_SYMBOL_RATE, &symbol_rate);
+		if (parms->p.current_sys == SYS_ISDBS)
+			symbol_rate = 28800;
 		bw = (symbol_rate * rolloff) / divisor;
 	}
 	if (!bw)
 		dvb_fe_retrieve_parm(&parms->p, DTV_BANDWIDTH_HZ, &bw);
-
+	if (!bw && parms->p.current_sys == SYS_ISDBT)
+		bw = 6000000;
 	/*
 	 * If the max frequency shift between two frequencies is below
 	 * than the used bandwidth / 8, it should be the same channel.
@@ -758,6 +761,87 @@ struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *__p,
 	return NULL;
 }
 
+int dvb_new_ts_is_needed(struct dvb_entry *entry, struct dvb_entry *last_entry,
+			 uint32_t freq, int shift, uint32_t ts_id)
+{
+	int i;
+	uint32_t data;
+
+	for (; entry != last_entry; entry = entry->next) {
+		for (i = 0; i < entry->n_props; i++) {
+			data = entry->props[i].u.data;
+			if (entry->props[i].cmd == DTV_STREAM_ID) {
+				if (data != ts_id)
+					break;
+			}
+			if (entry->props[i].cmd == DTV_FREQUENCY) {
+				if (freq < data - shift || freq > data + shift)
+					break;
+			}
+		}
+		if (i == entry->n_props && entry->n_props > 0)
+			return 0;
+	}
+
+	return 1;
+}
+
+static struct dvb_entry *
+dvb_scan_add_entry_isdbs(struct dvb_v5_fe_parms *__p,
+			 struct dvb_entry *first_entry, struct dvb_entry *entry,
+			 uint32_t freq, uint32_t shift, uint32_t ts_id)
+{
+	struct dvb_v5_fe_parms_priv *parms = (void *)__p;
+	struct dvb_entry *new_entry;
+	int i, n = 2;
+
+	if (!dvb_new_ts_is_needed(first_entry, NULL, freq, shift, ts_id))
+		return NULL;
+
+	/* Clone the current entry into a new entry */
+	new_entry = calloc(sizeof(*new_entry), 1);
+	if (!new_entry) {
+		dvb_perror("not enough memory for a new scanning frequency/TS");
+		return NULL;
+	}
+
+	memcpy(new_entry, entry, sizeof(*entry));
+	if (entry->channel)
+		new_entry->channel = strdup(entry->channel);
+	if (entry->vchannel)
+		new_entry->vchannel = strdup(entry->vchannel);
+	if (entry->location)
+		new_entry->location = strdup(entry->location);
+	if (entry->lnb)
+		new_entry->lnb = strdup(entry->lnb);
+
+	/*
+	 * The frequency should change to the new one. Seek for it and
+	 * replace its value to the desired one.
+	 */
+	for (i = 0; i < new_entry->n_props; i++) {
+		if (new_entry->props[i].cmd == DTV_FREQUENCY) {
+			new_entry->props[i].u.data = freq;
+			/* Navigate to the end of the entry list */
+			while (entry->next) {
+				entry = entry->next;
+				n++;
+			}
+			dvb_log("New transponder/channel found: #%d: %d",
+			        n, freq);
+			entry->next = new_entry;
+			new_entry->next = NULL;
+			return new_entry;
+		}
+	}
+
+	/* This should never happen */
+	dvb_logerr("BUG: Couldn't add %d to the scan frequency list.", freq);
+	free(new_entry);
+
+	return NULL;
+}
+
 struct update_transponders {
 	struct dvb_v5_fe_parms *parms;
 	struct dvb_v5_descriptors *dvb_scan_handler;
@@ -987,6 +1071,36 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
 				     SYS_DVBS2);
 }
 
+static void add_update_nit_isdbs(struct dvb_table_nit *nit,
+				 struct dvb_table_nit_transport *tran,
+				 struct dvb_desc *desc,
+				 void *priv)
+{
+	struct update_transponders *tr = priv;
+	struct dvb_entry *new;
+	struct dvb_desc_sat *d = (void *)desc;
+	uint32_t ts_id;
+
+	if (tr->update)
+		return;
+
+        ts_id = tran->transport_id;
+	new = dvb_scan_add_entry_isdbs(tr->parms, tr->first_entry, tr->entry,
+				       d->frequency, tr->shift, ts_id);
+	if (!new)
+		return;
+
+	/* Set NIT ISDB-S props for the transponder */
+	/* modulation is not defined here but in TMCC. */
+	/* skip setting it since no "AUTO" value in fe_modulation_t */
+	dvb_store_entry_prop(new, DTV_POLARIZATION,
+			     dvbs_polarization[d->polarization]);
+	dvb_store_entry_prop(new, DTV_SYMBOL_RATE,
+			     d->symbol_rate);
+	dvb_store_entry_prop(new, DTV_INNER_FEC,
+			     dvbs_dvbc_dvbs_freq_inner[d->fec]);
+}
+
 
 static void __dvb_add_update_transponders(struct dvb_v5_fe_parms_priv *parms,
 					  struct dvb_v5_descriptors *dvb_scan_handler,
@@ -1045,6 +1159,13 @@ static void __dvb_add_update_transponders(struct dvb_v5_fe_parms_priv *parms,
 				satellite_delivery_system_descriptor,
 				NULL, add_update_nit_dvbs, &tr);
 		return;
+	case SYS_ISDBS:
+		dvb_table_nit_descriptor_handler(
+				&parms->p, dvb_scan_handler->nit,
+				satellite_delivery_system_descriptor,
+				NULL, add_update_nit_isdbs, &tr);
+		return;
+
 	default:
 		dvb_log("Transponders detection not implemented for this standard yet.");
 		return;
diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
index 3750d04..6a4de2b 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -366,6 +366,22 @@ static void charset_conversion(struct dvb_v5_fe_parms *parms, char **dest, const
 				     parms->output_charset);
 }
 
+static void isdb_parse_string(struct dvb_v5_fe_parms *parms, char **dest,
+			      const unsigned char *src, size_t len)
+{
+	int destlen;
+
+	destlen = len * 4;
+	*dest = malloc(destlen + 1);
+	dvb_iconv_to_charset(parms, *dest, destlen, src, len,
+			     "ARIB-STD-B24", parms->output_charset);
+	/* The code had over-sized the space. Fix it. */
+	if (*dest)
+		*dest = realloc(*dest, strlen(*dest) + 1);
+	return;
+}
+
+
 void dvb_parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		      const unsigned char *src, size_t len)
 {
@@ -386,6 +402,13 @@ void dvb_parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 	if (!len)
 		return;
 
+	/* Strings in ISDB-S/T do not start with a charset identifier, */
+	/*  and can start with a control character. */
+	if (!strcasecmp(type, "ARIB-STD-B24")) {
+		isdb_parse_string(parms, dest, src, len);
+		return;
+	}
+
 	if (*src < 0x20) {
 		switch (*src) {
 		case 0x00:	type = "ISO-6937";		break;
-- 
2.1.2


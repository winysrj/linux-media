Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51294 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaJZLrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 07:47:22 -0400
Received: by mail-pd0-f182.google.com with SMTP id fp1so706537pdb.27
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 04:47:22 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v2 3/7] v4l-utils/libdvbv5: add support for ISDB-S scanning
Date: Sun, 26 Oct 2014 20:46:19 +0900
Message-Id: <1414323983-15996-4-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

added NIT scan for ISDB-S,
fixed wrong/too-close frequency of the scanned entries,
when "freq_offset"/bandwith was not set properly.
---
 lib/include/libdvbv5/dvb-scan.h |   2 +
 lib/libdvbv5/dvb-fe.c           |   6 +-
 lib/libdvbv5/dvb-file.c         |  23 ++++++-
 lib/libdvbv5/dvb-scan.c         | 138 +++++++++++++++++++++++++++++++++++++++-
 lib/libdvbv5/parse_string.c     |  15 ++++-
 utils/dvb/dvb-format-convert.c  |   3 +-
 utils/dvb/dvbv5-scan.c          |  19 ++++++
 7 files changed, 200 insertions(+), 6 deletions(-)

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
index 1ea14c4..fa4d370 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1125,7 +1125,28 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 		entry->props[j].cmd = parms->dvb_prop[j].cmd;
 		entry->props[j].u.data = parms->dvb_prop[j].u.data;
 
-		if (!*channel)
+		/* [ISDB-S]
+		 * Update DTV_STREAM_ID if it was not specified by a user
+		 * or set to a wrong one.
+		 * In those cases, demod must have selected the first TS_ID.
+		 * The update must be after the above dvb_fe_get_parms() call,
+		 * since a lazy FE driver that does not update stream_id prop
+		 * cache in FE.get_frontend() may overwrite the setting again
+		 * with the initial / user-specified wrong value.
+		 */
+		if (entry->props[j].cmd == DTV_STREAM_ID
+		    && entry->props[j].u.data == 0
+		    && parms->p.current_sys == SYS_ISDBS)
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
 			freq = entry->props[j].u.data;
 	}
 	if (!*channel) {
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 3b70f5a..f265f97 100644
--- a/lib/libdvbv5/dvb-scan.c
+++ b/lib/libdvbv5/dvb-scan.c
@@ -635,7 +635,6 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
 		rolloff = 115;
 		break;
 	case SYS_DVBS:
-	case SYS_ISDBS:	/* FIXME: not sure if this rollof is right for ISDB-S */
 		divisor = 100000;
 		rolloff = 135;
 		break;
@@ -662,6 +661,12 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
 	case SYS_DVBC_ANNEX_B:
 		bw = 6000000;
 		break;
+	case SYS_ISDBS:
+		/* since ISDBS uses fixed symbol_rate & rolloff,
+		 * those parameters are not mandatory in channel config file.
+		 */
+		bw = 28860 * 135 / 100;
+		break;
 	default:
 		break;
 	}
@@ -676,7 +681,9 @@ int dvb_estimate_freq_shift(struct dvb_v5_fe_parms *__p)
 	}
 	if (!bw)
 		dvb_fe_retrieve_parm(&parms->p, DTV_BANDWIDTH_HZ, &bw);
-
+	if (!bw)
+		dvb_log("Cannot calc frequency shift. " \
+			"Either bandwidth/symbol-rate is unavailable (yet).");
 	/*
 	 * If the max frequency shift between two frequencies is below
 	 * than the used bandwidth / 8, it should be the same channel.
@@ -758,6 +765,87 @@ struct dvb_entry *dvb_scan_add_entry(struct dvb_v5_fe_parms *__p,
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
@@ -987,6 +1075,44 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
 				     SYS_DVBS2);
 }
 
+static void add_update_nit_isdbs(struct dvb_table_nit *nit,
+				 struct dvb_table_nit_transport *tran,
+				 struct dvb_desc *desc,
+				 void *priv)
+{
+	struct update_transponders *tr = priv;
+	struct dvb_entry *new;
+	/* FIXME:
+	 * use the ISDB-S specific satellite delsys descriptor structure,
+	 * instead of overloading to the EN300-468's one, dvb_desc_sat.
+	 * The following members are incompatible:
+	 *  {.modulation_type, .modulation_system, .roll_off, .fec}
+	 */
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
+	/* Set (optional) ISDB-S props for the transponder */
+	/* FIXME: fill in other props like DTV_MODULATION, DTV_INNER_FEC.
+	 *   This requires extending the enum definitions in DVBv5 API
+	 *   to include the ISDB-S/T specific modulation/fec values,
+	 *   such as "BPSK" and "look TMCC".
+	 * Since even "AUTO" is not defined, skip setting them now.
+	 */
+	dvb_store_entry_prop(new, DTV_POLARIZATION,
+			     dvbs_polarization[d->polarization]);
+	dvb_store_entry_prop(new, DTV_SYMBOL_RATE,
+			     d->symbol_rate);
+}
+
 
 static void __dvb_add_update_transponders(struct dvb_v5_fe_parms_priv *parms,
 					  struct dvb_v5_descriptors *dvb_scan_handler,
@@ -1045,6 +1171,14 @@ static void __dvb_add_update_transponders(struct dvb_v5_fe_parms_priv *parms,
 				satellite_delivery_system_descriptor,
 				NULL, add_update_nit_dvbs, &tr);
 		return;
+	case SYS_ISDBS:
+		/* see the FIXME: in add_update_nit_isdbs() */
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
index 3750d04..c043ad5 100644
--- a/lib/libdvbv5/parse_string.c
+++ b/lib/libdvbv5/parse_string.c
@@ -319,6 +319,8 @@ void dvb_iconv_to_charset(struct dvb_v5_fe_parms *parms,
 		p[len] = '\0';
 		dvb_logerr("Conversion from %s to %s not supported\n",
 				input_charset, output_charset);
+		if (!strcasecmp(input_charset, "ARIB-STD-B24"))
+			dvb_log("Try setting GCONV_PATH to the bundled gconv dir.\n");
 	} else {
 		iconv(cd, (ICONV_CONST char **)&src, &len, &p, &destlen);
 		iconv_close(cd);
@@ -386,7 +388,11 @@ void dvb_parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 	if (!len)
 		return;
 
-	if (*src < 0x20) {
+	/*
+	 * Strings in ISDB-S/T(JP) do not start with a charset identifier,
+	 * and can start with a control character (< 0x20).
+	 */
+	if (strcasecmp(type, "ARIB-STD-B24") && *src < 0x20) {
 		switch (*src) {
 		case 0x00:	type = "ISO-6937";		break;
 		case 0x01:	type = "ISO-8859-5";		break;
@@ -466,6 +472,13 @@ void dvb_parse_string(struct dvb_v5_fe_parms *parms, char **dest, char **emph,
 		*p2 = '\0';
 		len = p - (char *)tmp1;
 		len2 = p2 - (char *)tmp2;
+	} else if (!strcasecmp(type, "ARIB-STD-B24")) {
+		/* do nothing */
+		/* NOTE: "ARIB-STD-B24" gconv module is required.
+		 * Until it is merged to upstream glibc(iconv),
+		 * set GCONV_PATH env. var. to use the bundled version of it,
+		 * otherwise, no conversion will be done.
+		 */
 	} else {
 		dvb_logerr("charset %s not implemented", type);
 		/*
diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
index 4f0e075..bf37945 100644
--- a/utils/dvb/dvb-format-convert.c
+++ b/utils/dvb/dvb-format-convert.c
@@ -125,7 +125,8 @@ int main(int argc, char **argv)
 		fprintf(stderr, "ERROR: Please specify a valid output file\n");
 		missing = 1;
 	} else if (((args.input_format == FILE_ZAP) ||
-		   (args.output_format == FILE_ZAP)) && args.delsys <= 0) {
+		   (args.output_format == FILE_ZAP)) &&
+		   (args.delsys <= 0 || args.delsys == SYS_ISDBS)) {
 		fprintf(stderr, "ERROR: Please specify a valid delivery system for ZAP format\n");
 		missing = 1;
 	}
diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index cdc82ec..45c8516 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -251,6 +251,16 @@ static int run_scan(struct arguments *args,
 		if (dvb_retrieve_entry_prop(entry, DTV_POLARIZATION, &pol))
 			pol = POLARIZATION_OFF;
 
+		if (parms->current_sys == SYS_ISDBS) {
+			uint32_t tsid = 0;
+
+			dvb_store_entry_prop(entry, DTV_POLARIZATION, POLARIZATION_R);
+
+			dvb_retrieve_entry_prop(entry, DTV_STREAM_ID, &tsid);
+			if (!dvb_new_ts_is_needed(dvb_file->first_entry, entry,
+						  freq, shift, tsid))
+				continue;
+		} else
 		if (!dvb_new_freq_is_needed(dvb_file->first_entry, entry,
 					    freq, pol, shift))
 			continue;
@@ -259,6 +269,15 @@ static int run_scan(struct arguments *args,
 		dvb_log("Scanning frequency #%d %d", count, freq);
 
 		/*
+		 * update params->lnb only if it differs from entry->lnb
+		 * (and "--lnbf" option was not provided),
+		 * to avoid linear search of LNB types for every entries.
+		 */
+		if (!args->lnb_name && entry->lnb &&
+		    (!parms->lnb || strcasecmp(entry->lnb, parms->lnb->alias)))
+			parms->lnb = dvb_sat_get_lnb(dvb_sat_search_lnb(entry->lnb));
+
+		/*
 		 * Run the scanning logic
 		 */
 
-- 
2.1.2


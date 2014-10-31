Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48151 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972AbaJaNOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:14:35 -0400
Received: by mail-pd0-f178.google.com with SMTP id fp1so7178986pdb.23
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 06:14:28 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH v3 5/7] v4l-utils/libdvbv5: add support for ISDB-S scanning
Date: Fri, 31 Oct 2014 22:13:42 +0900
Message-Id: <1414761224-32761-6-git-send-email-tskd08@gmail.com>
In-Reply-To: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
References: <1414761224-32761-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

added NIT scan for ISDB-S.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 lib/libdvbv5/dvb-fe.c          |  2 ++
 lib/libdvbv5/dvb-file.c        | 14 ++++++++++
 lib/libdvbv5/dvb-scan.c        | 58 ++++++++++++++++++++++++++++++++++++++++--
 lib/libdvbv5/parse_string.c    |  8 +++++-
 utils/dvb/dvb-format-convert.c |  3 ++-
 utils/dvb/dvbv5-scan.c         |  9 +++++++
 6 files changed, 90 insertions(+), 4 deletions(-)

diff --git a/lib/libdvbv5/dvb-fe.c b/lib/libdvbv5/dvb-fe.c
index 01b2848..09eb37e 100644
--- a/lib/libdvbv5/dvb-fe.c
+++ b/lib/libdvbv5/dvb-fe.c
@@ -372,6 +372,8 @@ int dvb_set_sys(struct dvb_v5_fe_parms *p, fe_delivery_system_t sys)
 	parms->p.current_sys = sys;
 	parms->n_props = rc;
 
+	if (sys == SYS_ISDBS /* || sys == SYS_ISDBT */)
+		parms->p.default_charset = "arib-std-b24";
 	return 0;
 }
 
diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
index 0347da4..89b09ff 100644
--- a/lib/libdvbv5/dvb-file.c
+++ b/lib/libdvbv5/dvb-file.c
@@ -1138,6 +1138,20 @@ static int get_program_and_store(struct dvb_v5_fe_parms_priv *parms,
 		entry->props[j].cmd = parms->dvb_prop[j].cmd;
 		entry->props[j].u.data = parms->dvb_prop[j].u.data;
 
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
 		if (!channel && entry->props[j].cmd == DTV_FREQUENCY)
 			freq = parms->dvb_prop[j].u.data;
 	}
diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
index 690e393..6c94e8d 100644
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
@@ -1015,6 +1022,45 @@ static void add_update_nit_dvbs(struct dvb_table_nit *nit,
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
+	ts_id = tran->transport_id;
+	new = dvb_scan_add_entry(tr->parms, tr->first_entry, tr->entry,
+				 d->frequency, tr->shift, tr->pol, ts_id);
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
+
 static void __dvb_add_update_transponders(struct dvb_v5_fe_parms_priv *parms,
 					  struct dvb_v5_descriptors *dvb_scan_handler,
 					  struct dvb_entry *first_entry,
@@ -1072,6 +1118,14 @@ static void __dvb_add_update_transponders(struct dvb_v5_fe_parms_priv *parms,
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
index 52390c9..8d07cac 100644
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
diff --git a/utils/dvb/dvb-format-convert.c b/utils/dvb/dvb-format-convert.c
index 2b2287f..d97bea2 100644
--- a/utils/dvb/dvb-format-convert.c
+++ b/utils/dvb/dvb-format-convert.c
@@ -126,7 +126,8 @@ int main(int argc, char **argv)
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
index 9c10e52..53a54f7 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -263,6 +263,15 @@ static int run_scan(struct arguments *args,
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
2.1.3


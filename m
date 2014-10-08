Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61408 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbaJHMKY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 08:10:24 -0400
Received: by mail-pa0-f43.google.com with SMTP id lf10so9005606pab.2
        for <linux-media@vger.kernel.org>; Wed, 08 Oct 2014 05:10:24 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH 4/4] v4l-utils/dvbv5-scan: add support for ISDB-S scanning
Date: Wed,  8 Oct 2014 21:09:41 +0900
Message-Id: <1412770181-5420-5-git-send-email-tskd08@gmail.com>
In-Reply-To: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
References: <1412770181-5420-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 utils/dvb/dvb-format-convert.c |  3 ++-
 utils/dvb/dvbv5-scan.c         | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

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
index cdc82ec..0ef95f3 100644
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
@@ -258,6 +268,10 @@ static int run_scan(struct arguments *args,
 		count++;
 		dvb_log("Scanning frequency #%d %d", count, freq);
 
+		if (!args->lnb_name && entry->lnb &&
+		    (!parms->lnb || strcasecmp(entry->lnb, parms->lnb->alias)))
+			parms->lnb = dvb_sat_get_lnb(dvb_sat_search_lnb(entry->lnb));
+
 		/*
 		 * Run the scanning logic
 		 */
-- 
2.1.2


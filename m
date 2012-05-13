Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56914 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2EMMST (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 May 2012 08:18:19 -0400
Received: by wibhj8 with SMTP id hj8so837375wib.1
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 05:18:18 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 6/8] fixed bw for DVB-S
Date: Sun, 13 May 2012 14:17:28 +0200
Message-Id: <1336911450-23661-6-git-send-email-neolynx@gmail.com>
In-Reply-To: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
References: <1336911450-23661-1-git-send-email-neolynx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 utils/dvb/dvbv5-scan.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/utils/dvb/dvbv5-scan.c b/utils/dvb/dvbv5-scan.c
index d54aa8c..63a8a44 100644
--- a/utils/dvb/dvbv5-scan.c
+++ b/utils/dvb/dvbv5-scan.c
@@ -138,7 +138,7 @@ static int new_freq_is_needed(struct dvb_entry *entry,
 		for (i = 0; i < entry->n_props; i++) {
 			data = entry->props[i].u.data;
 			if (entry->props[i].cmd == DTV_FREQUENCY) {
-				if (( freq >= data - shift) && (freq <= data + shift))
+				if (( freq >= data - shift) && (freq <= data + shift)) //FIXME: should consideer polarization for DVB-S
 					return 0;
 			}
 		}
@@ -186,6 +186,7 @@ static int estimate_freq_shift(struct dvb_v5_fe_parms *parms)
 {
 	uint32_t shift = 0, bw = 0, symbol_rate, ro;
 	int rolloff = 0;
+        int divisor = 100;
 
 	/* Need to handle only cable/satellite and ATSC standards */
 	switch (parms->current_sys) {
@@ -197,11 +198,13 @@ static int estimate_freq_shift(struct dvb_v5_fe_parms *parms)
 		break;
 	case SYS_DVBS:
 	case SYS_ISDBS:	/* FIXME: not sure if this rollof is right for ISDB-S */
+                divisor = 100000;
 		rolloff = 135;
 		break;
 	case SYS_DVBS2:
 	case SYS_DSS:
 	case SYS_TURBO:
+                divisor = 100000;
 		dvb_fe_retrieve_parm(parms, DTV_ROLLOFF, &ro);
 		switch (ro) {
 		case ROLLOFF_20:
@@ -231,7 +234,7 @@ static int estimate_freq_shift(struct dvb_v5_fe_parms *parms)
 		 * purposes of estimating a max frequency shift here.
 		 */
 		dvb_fe_retrieve_parm(parms, DTV_SYMBOL_RATE, &symbol_rate);
-		bw = (symbol_rate * rolloff) / 100;
+		bw = (symbol_rate * rolloff) / divisor;
 	}
 	if (!bw)
 		dvb_fe_retrieve_parm(parms, DTV_BANDWIDTH_HZ, &bw);
@@ -261,7 +264,9 @@ static void add_other_freq_entries(struct dvb_file *dvb_file,
 		freq = dvb_desc->nit_table.frequency[i];
 
 		if (new_freq_is_needed(dvb_file->first_entry, NULL, freq, shift))
+                {
 			add_new_freq(dvb_file->first_entry, freq);
+                }
 	}
 }
 
-- 
1.7.2.5


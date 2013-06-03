Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:44267 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3FCPYG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 11:24:06 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=endymion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1UjWc9-0000Xw-8Z
	(TLSv1:AES128-SHA:128)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Mon, 03 Jun 2013 17:24:05 +0200
Date: Mon, 3 Jun 2013 17:23:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] femon: Handle -EOPNOTSUPP
Message-ID: <20130603172359.442a8ee6@endymion.delvare>
In-Reply-To: <20130603171607.73d0b856@endymion.delvare>
References: <20130603171607.73d0b856@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frontend drivers don't have to implement all monitoring callbacks. So
expect -EOPNOTSUPP and handle it properly.
---
 util/femon/femon.c |   75 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 27 deletions(-)

--- dvb-apps-3ee111da5b3a.orig/util/femon/femon.c	2013-06-03 17:22:56.923398598 +0200
+++ dvb-apps-3ee111da5b3a/util/femon/femon.c	2013-06-03 17:23:16.946398895 +0200
@@ -67,6 +67,7 @@ int check_frontend (struct dvbfe_handle
 	struct dvbfe_info fe_info;
 	unsigned int samples = 0;
 	FILE *ttyFile=NULL;
+	int got_info;
 	
 	// We dont write the "beep"-codes to stdout but to /dev/tty1.
 	// This is neccessary for Thin-Client-Systems or Streaming-Boxes
@@ -89,39 +90,59 @@ int check_frontend (struct dvbfe_handle
 	}
 
 	do {
-		if (dvbfe_get_info(fe, FE_STATUS_PARAMS, &fe_info, DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0) != FE_STATUS_PARAMS) {
+		got_info = dvbfe_get_info(fe, FE_STATUS_PARAMS, &fe_info, DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0);
+		if (got_info & DVBFE_INFO_LOCKSTATUS) {
+			printf ("status %c%c%c%c%c | ",
+				fe_info.signal ? 'S' : ' ',
+				fe_info.carrier ? 'C' : ' ',
+				fe_info.viterbi ? 'V' : ' ',
+				fe_info.sync ? 'Y' : ' ',
+				fe_info.lock ? 'L' : ' ');
+		} else {
 			fprintf(stderr, "Problem retrieving frontend information: %m\n");
+			printf ("status ----- | ");
 		}
 
 
-		printf ("status %c%c%c%c%c | ",
-			fe_info.signal ? 'S' : ' ',
-			fe_info.carrier ? 'C' : ' ',
-			fe_info.viterbi ? 'V' : ' ',
-			fe_info.sync ? 'Y' : ' ',
-			fe_info.lock ? 'L' : ' ');
-
 		if (human_readable) {
-			// SNR should be in units of 0.1 dB but some drivers do
-			// not follow that rule, thus this heuristic.
-			if (fe_info.snr < 1000)
-				printf ("signal %3u%% | snr %4.1fdB | ber %d | unc %d | ",
-					(fe_info.signal_strength * 100) / 0xffff,
-					fe_info.snr / 10.,
-					fe_info.ber,
-					fe_info.ucblocks);
-			else
-				printf ("signal %3u%% | snr %3u%% | ber %d | unc %d | ",
-					(fe_info.signal_strength * 100) / 0xffff,
-					(fe_info.snr * 100) / 0xffff,
-					fe_info.ber,
-					fe_info.ucblocks);
+			if (got_info & DVBFE_INFO_SIGNAL_STRENGTH)
+				printf ("signal %3u%% | ", (fe_info.signal_strength * 100) / 0xffff);
+			else
+				printf ("signal ---%% | ");
+			if (got_info & DVBFE_INFO_SNR) {
+				// SNR should be in units of 0.1 dB but some drivers do
+				// not follow that rule, thus this heuristic.
+				if (fe_info.snr < 1000)
+					printf ("snr %4.1fdB | ", fe_info.snr / 10.);
+				else
+					printf ("snr %3u%% | ", (fe_info.snr * 100) / 0xffff);
+			} else
+				printf ("snr ---- | ");
+			if (got_info & DVBFE_INFO_BER)
+				printf ("ber %d | ", fe_info.ber);
+			else
+				printf ("ber - | ");
+			if (got_info & DVBFE_INFO_UNCORRECTED_BLOCKS)
+				printf ("unc %d | ", fe_info.ucblocks);
+			else
+				printf ("unc - | ");
 		} else {
-			printf ("signal %04x | snr %04x | ber %08x | unc %08x | ",
-				fe_info.signal_strength,
-				fe_info.snr,
-				fe_info.ber,
-				fe_info.ucblocks);
+			if (got_info & DVBFE_INFO_SIGNAL_STRENGTH)
+				printf ("signal %04x | ", fe_info.signal_strength);
+			else
+				printf ("signal ---- | ");
+			if (got_info & DVBFE_INFO_SNR)
+				printf ("snr %04x | ", fe_info.snr);
+			else
+				printf ("snr ---- | ");
+			if (got_info & DVBFE_INFO_BER)
+				printf ("ber %08x | ", fe_info.ber);
+			else
+				printf ("ber -------- | ");
+			if (got_info & DVBFE_INFO_UNCORRECTED_BLOCKS)
+				printf ("unc %08x | ", fe_info.ucblocks);
+			else
+				printf ("unc -------- | ");
 		}
 
 		if (fe_info.lock)

-- 
Jean Delvare

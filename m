Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:15573 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3FCPRg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 11:17:36 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=endymion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1UjWVr-0006QX-23
	(TLSv1:AES128-SHA:128)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Mon, 03 Jun 2013 17:17:35 +0200
Date: Mon, 3 Jun 2013 17:17:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH 1/3] femon: Share common code
Message-ID: <20130603171729.6c857ab5@endymion.delvare>
In-Reply-To: <20130603171607.73d0b856@endymion.delvare>
References: <20130603171607.73d0b856@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The status flags are printed the same in standard output mode and
human readable output mode, so use common code.
---
 util/femon/femon.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- dvb-apps-3ee111da5b3a.orig/util/femon/femon.c	2013-06-02 13:56:18.936297146 +0200
+++ dvb-apps-3ee111da5b3a/util/femon/femon.c	2013-06-02 13:59:03.383299584 +0200
@@ -94,25 +94,21 @@ int check_frontend (struct dvbfe_handle
 		}
 
 
+		printf ("status %c%c%c%c%c | ",
+			fe_info.signal ? 'S' : ' ',
+			fe_info.carrier ? 'C' : ' ',
+			fe_info.viterbi ? 'V' : ' ',
+			fe_info.sync ? 'Y' : ' ',
+			fe_info.lock ? 'L' : ' ');
 
 		if (human_readable) {
-                       printf ("status %c%c%c%c%c | signal %3u%% | snr %3u%% | ber %d | unc %d | ",
-				fe_info.signal ? 'S' : ' ',
-				fe_info.carrier ? 'C' : ' ',
-				fe_info.viterbi ? 'V' : ' ',
-				fe_info.sync ? 'Y' : ' ',
-				fe_info.lock ? 'L' : ' ',
+			printf ("signal %3u%% | snr %3u%% | ber %d | unc %d | ",
 				(fe_info.signal_strength * 100) / 0xffff,
 				(fe_info.snr * 100) / 0xffff,
 				fe_info.ber,
 				fe_info.ucblocks);
 		} else {
-			printf ("status %c%c%c%c%c | signal %04x | snr %04x | ber %08x | unc %08x | ",
-				fe_info.signal ? 'S' : ' ',
-				fe_info.carrier ? 'C' : ' ',
-				fe_info.viterbi ? 'V' : ' ',
-				fe_info.sync ? 'Y' : ' ',
-				fe_info.lock ? 'L' : ' ',
+			printf ("signal %04x | snr %04x | ber %08x | unc %08x | ",
 				fe_info.signal_strength,
 				fe_info.snr,
 				fe_info.ber,

-- 
Jean Delvare

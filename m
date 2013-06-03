Return-path: <linux-media-owner@vger.kernel.org>
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:33733 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3FCPV5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 11:21:57 -0400
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=endymion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1UjWa4-0006y9-5o
	(TLSv1:AES128-SHA:128)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Mon, 03 Jun 2013 17:21:56 +0200
Date: Mon, 3 Jun 2013 17:21:50 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linux Media <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] femon: Display SNR in dB
Message-ID: <20130603172150.1aaf1904@endymion.delvare>
In-Reply-To: <20130603171607.73d0b856@endymion.delvare>
References: <20130603171607.73d0b856@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

SNR is supposed to be reported by the frontend drivers in dB, so print
it that way for drivers which implement it properly.
---
 util/femon/femon.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- dvb-apps-3ee111da5b3a.orig/util/femon/femon.c	2013-06-02 14:05:00.988323437 +0200
+++ dvb-apps-3ee111da5b3a/util/femon/femon.c	2013-06-02 14:05:33.560792474 +0200
@@ -102,11 +102,20 @@ int check_frontend (struct dvbfe_handle
 			fe_info.lock ? 'L' : ' ');
 
 		if (human_readable) {
-			printf ("signal %3u%% | snr %3u%% | ber %d | unc %d | ",
-				(fe_info.signal_strength * 100) / 0xffff,
-				(fe_info.snr * 100) / 0xffff,
-				fe_info.ber,
-				fe_info.ucblocks);
+			// SNR should be in units of 0.1 dB but some drivers do
+			// not follow that rule, thus this heuristic.
+			if (fe_info.snr < 1000)
+				printf ("signal %3u%% | snr %4.1fdB | ber %d | unc %d | ",
+					(fe_info.signal_strength * 100) / 0xffff,
+					fe_info.snr / 10.,
+					fe_info.ber,
+					fe_info.ucblocks);
+			else
+				printf ("signal %3u%% | snr %3u%% | ber %d | unc %d | ",
+					(fe_info.signal_strength * 100) / 0xffff,
+					(fe_info.snr * 100) / 0xffff,
+					fe_info.ber,
+					fe_info.ucblocks);
 		} else {
 			printf ("signal %04x | snr %04x | ber %08x | unc %08x | ",
 				fe_info.signal_strength,

-- 
Jean Delvare

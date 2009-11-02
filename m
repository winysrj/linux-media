Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35258 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757155AbZKBWux (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Nov 2009 17:50:53 -0500
Message-ID: <4AEF624F.8030500@gmx.de>
Date: Mon, 02 Nov 2009 23:50:55 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH 1/9] stv090x: increase search range based on symbol rate
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch increases search range based on symbol rate.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>

diff -r 69d4b117a9e5 linux/drivers/media/dvb/frontends/stv090x.c
--- a/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 21:38:25 2009 +0100
+++ b/linux/drivers/media/dvb/frontends/stv090x.c	Mon Nov 02 21:43:27 2009 +0100
@@ -4108,7 +4108,13 @@
 	state->search_mode = STV090x_SEARCH_AUTO;
 	state->algo = STV090x_COLD_SEARCH;
 	state->fec = STV090x_PRERR;
-	state->search_range = 2000000;
+	if (state->srate > 10000000) {
+		dprintk(FE_DEBUG, 1, "Search range: 10 MHz");
+		state->search_range = 10000000;
+	} else {
+		dprintk(FE_DEBUG, 1, "Search range: 5 MHz");
+		state->search_range = 5000000;
+	}
 
 	if (stv090x_algo(state) == STV090x_RANGEOK) {
 		dprintk(FE_DEBUG, 1, "Search success!");

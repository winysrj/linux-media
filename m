Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56711 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3EIRfb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 May 2013 13:35:31 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MSXbW-1V1xDi17Ho-00RcNt for
 <linux-media@vger.kernel.org>; Thu, 09 May 2013 19:35:30 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH] stb0899: sign of CRL_FREQ doesn't depend on inversion
Date: Thu,  9 May 2013 19:10:59 +0200
Message-Id: <1368119459-4461-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Contrary to CFR (derotator frequency), which changes signedness
depending on inversion, CRL_FREQ does not.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index a338e06..93596e0 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -1504,9 +1504,7 @@ enum stb0899_status stb0899_dvbs2_algo(struct stb0899_state *state)
 		else
 			internal->inversion = IQ_SWAP_OFF;
 
-		offsetfreq *= internal->inversion;
-
-		internal->freq = internal->freq - offsetfreq;
+		internal->freq = internal->freq + offsetfreq;
 		internal->srate = stb0899_dvbs2_get_srate(state);
 
 		reg = STB0899_READ_S2REG(STB0899_S2DEMOD, UWP_STAT2);
-- 
1.8.1.4


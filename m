Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:54142 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab3EGVFC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 May 2013 17:05:02 -0400
Received: from mailout-de.gmx.net ([10.1.76.33]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M06gE-1UHBDc1uCC-00uKpF for
 <linux-media@vger.kernel.org>; Tue, 07 May 2013 23:05:00 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH] stb0899: sign extend raw CRL_FREQ value
Date: Tue,  7 May 2013 23:04:40 +0200
Message-Id: <1367960680-17663-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Contrary to the chip's specs, the register's value is signed, so we
need to sign extend the value before using it in calculations like
when determining the offset frequency.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index 117a569..bd9dbd7 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -1487,6 +1487,10 @@ enum stb0899_status stb0899_dvbs2_algo(struct stb0899_state *state)
 		/* Store signal parameters	*/
 		offsetfreq = STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_FREQ);
 
+		/* sign extend 30 bit value before using it in calculations */
+		if (offsetfreq & (1 << 29))
+			offsetfreq |= -1 << 30;
+
 		offsetfreq = offsetfreq / ((1 << 30) / 1000);
 		offsetfreq *= (internal->master_clk / 1000000);
 		reg = STB0899_READ_S2REG(STB0899_S2DEMOD, DMD_CNTRL2);
-- 
1.8.1.4


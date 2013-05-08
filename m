Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50357 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab3EHWvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 18:51:07 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MTdXC-1V0Zkw1Dc0-00QWgB for
 <linux-media@vger.kernel.org>; Thu, 09 May 2013 00:51:06 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH 2/3] stb0899: store autodetected inversion while tuning in non S2 mode
Date: Thu,  9 May 2013 00:50:55 +0200
Message-Id: <1368053456-18475-2-git-send-email-rnissl@gmx.de>
In-Reply-To: <1368053456-18475-1-git-send-email-rnissl@gmx.de>
References: <1368053456-18475-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In non S2 mode, the device is able to autodetect inversion. So
let's store it for tuning to S2 transponders.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index 4b49efb..4ce542c 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -425,6 +425,14 @@ static enum stb0899_status stb0899_search_data(struct stb0899_state *state)
 
 	if (internal->status == DATAOK) {
 		stb0899_read_regs(state, STB0899_CFRM, cfr, 2); /* get derotator frequency */
+
+		/* store autodetected IQ swapping as default for DVB-S2 tuning */
+		reg = stb0899_read_reg(state, STB0899_IQSWAP);
+		if (STB0899_GETFIELD(SYM, reg))
+			internal->inversion = IQ_SWAP_ON;
+		else
+			internal->inversion = IQ_SWAP_OFF;
+
 		internal->derot_freq = state->config->inversion * MAKEWORD16(cfr[0], cfr[1]);
 		dprintk(state->verbose, FE_DEBUG, 1, "------> DATAOK ! Derot Freq=%d", internal->derot_freq);
 	}
-- 
1.8.1.4


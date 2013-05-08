Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50441 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab3EHV5V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 17:57:21 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MZiPg-1Uq4WU1tUs-00LTc5 for
 <linux-media@vger.kernel.org>; Wed, 08 May 2013 23:57:20 +0200
From: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Reinhard=20Ni=C3=9Fl?= <rnissl@gmx.de>
Subject: [PATCH 1/2] stb0899: fix inversion enum values to match usage with CFR
Date: Wed,  8 May 2013 23:54:56 +0200
Message-Id: <1368050097-6079-1-git-send-email-rnissl@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Throughout the zig-zag-implementations, inversion is taken into
account when reading and writing the CFR register, which contains
the derotator frequency. As swapping IQ signals changes the sign
of that register for example, the idea is to compensate that sign
change by multiplying the register value with the inversion enum
value.
The current enum values 0 and 1 for IQ_SWAP_OFF and IQ_SWAP_ON
don't work in the case IQ_SWAP_OFF, due to the multiplication by
zero (I've only found a single device which actually uses
IQ_SWAP_OFF in it's config).
I've changed the enum values to +1 and -1 to accommodate to the
intended usage.

Signed-off-by: Reinhard Nißl <rnissl@gmx.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 4 ++--
 drivers/media/dvb-frontends/stb0899_drv.h  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index 14d720b..e0d31a2 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -444,7 +444,7 @@ static enum stb0899_status stb0899_check_range(struct stb0899_state *state)
 	int range_offst, tp_freq;
 
 	range_offst = internal->srch_range / 2000;
-	tp_freq = internal->freq + (internal->derot_freq * internal->mclk) / 1000;
+	tp_freq = internal->freq - (internal->derot_freq * internal->mclk) / 1000;
 
 	if ((tp_freq >= params->freq - range_offst) && (tp_freq <= params->freq + range_offst)) {
 		internal->status = RANGEOK;
@@ -638,7 +638,7 @@ enum stb0899_status stb0899_dvbs_algo(struct stb0899_state *state)
 							"RANGE OK ! derot freq=%d, mclk=%d",
 							internal->derot_freq, internal->mclk);
 
-						internal->freq = params->freq + ((internal->derot_freq * internal->mclk) / 1000);
+						internal->freq = params->freq - ((internal->derot_freq * internal->mclk) / 1000);
 						reg = stb0899_read_reg(state, STB0899_PLPARM);
 						internal->fecrate = STB0899_GETFIELD(VITCURPUN, reg);
 						dprintk(state->verbose, FE_DEBUG, 1,
diff --git a/drivers/media/dvb-frontends/stb0899_drv.h b/drivers/media/dvb-frontends/stb0899_drv.h
index 1ddad6a..139264d 100644
--- a/drivers/media/dvb-frontends/stb0899_drv.h
+++ b/drivers/media/dvb-frontends/stb0899_drv.h
@@ -45,8 +45,8 @@ struct stb0899_s2_reg {
 };
 
 enum stb0899_inversion {
-	IQ_SWAP_OFF	= 0,
-	IQ_SWAP_ON,
+	IQ_SWAP_OFF	= +1, /* inversion affects the sign of e. g. */
+	IQ_SWAP_ON	= -1, /* the derotator frequency register    */
 };
 
 #define STB0899_GPIO00				0xf140
-- 
1.8.1.4


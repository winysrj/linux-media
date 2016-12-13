Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59992 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752925AbcLMUVu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 15:21:50 -0500
Date: Tue, 13 Dec 2016 21:21:41 +0100
From: Martin Wache <M.Wache@gmx.net>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] dib7000p: avoid division by zero
Message-ID: <20161213202133.GA18056@Merkur>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dib7000p_read_word() may return zero on i2c errors, resulting in
dib7000p_get_internal_freq() returning zero.
So don't divide by the result of dib7000p_get_internal_freq()
without checking it for zero in dib7000p_set_dds().

On one of my machines the device
ID 2304:0229 Pinnacle Systems, Inc. PCTV Dual DVB-T 2001e
about once a day/every two days gets into a state, where
most (all?) I2C reads return with an error. Tuning during this
state will result in a divide by zero without this patch.
This patch doesn't fix the root cause for the device getting
into a bad state, but it allows me to unload/reload the drivers,
bringing it back into a usable state.

Signed-off-by: Martin Wache <M.Wache@gmx.net>
---
 drivers/media/dvb-frontends/dib7000p.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index a27c000..3815ea5 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -805,13 +805,19 @@ static int dib7000p_set_agc_config(struct dib7000p_state *state, u8 band)
 	return 0;
 }
 
-static void dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
+static int dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
 {
 	u32 internal = dib7000p_get_internal_freq(state);
-	s32 unit_khz_dds_val = 67108864 / (internal);	/* 2**26 / Fsampling is the unit 1KHz offset */
+	s32 unit_khz_dds_val;
 	u32 abs_offset_khz = ABS(offset_khz);
 	u32 dds = state->cfg.bw->ifreq & 0x1ffffff;
 	u8 invert = !!(state->cfg.bw->ifreq & (1 << 25));
+	if (internal == 0) {
+		pr_warn("DIB7000P: dib7000p_get_internal_freq returned 0\n");
+		return -1;
+	}
+	/* 2**26 / Fsampling is the unit 1KHz offset */
+	unit_khz_dds_val = 67108864 / (internal);
 
 	dprintk("setting a frequency offset of %dkHz internal freq = %d invert = %d\n", offset_khz, internal, invert);
 
@@ -828,6 +834,7 @@ static void dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
 		dib7000p_write_word(state, 21, (u16) (((dds >> 16) & 0x1ff) | (0 << 10) | (invert << 9)));
 		dib7000p_write_word(state, 22, (u16) (dds & 0xffff));
 	}
+	return 0;
 }
 
 static int dib7000p_agc_startup(struct dvb_frontend *demod)
@@ -867,7 +874,9 @@ static int dib7000p_agc_startup(struct dvb_frontend *demod)
 			frequency_offset = (s32)frequency_tuner / 1000 - ch->frequency / 1000;
 		}
 
-		dib7000p_set_dds(state, frequency_offset);
+		if (dib7000p_set_dds(state, frequency_offset) < 0)
+			return -1;
+
 		ret = 7;
 		(*agc_state)++;
 		break;
-- 
2.7.4


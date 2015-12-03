Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55465 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbbLCUNZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2015 15:13:25 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi, xpert-reactos@gmx.de,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] si2165: Reject DVB-T bandwidth auto mode
Date: Thu,  3 Dec 2015 21:12:50 +0100
Message-Id: <1449173570-11997-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <5660A1DC.8050701@gentoo.org>
References: <5660A1DC.8050701@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The si2165 does not support bandwidth auto-detection.
Reject the request.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 1cf6e52..6fcd3ba 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -825,19 +825,19 @@ static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
 	struct si2165_state *state = fe->demodulator_priv;
 	u32 dvb_rate = 0;
 	u16 bw10k;
+	u32 bw_hz = p->bandwidth_hz;
 
 	dprintk("%s: called\n", __func__);
 
 	if (!state->has_dvbt)
 		return -EINVAL;
 
-	if (p->bandwidth_hz > 0) {
-		dvb_rate = p->bandwidth_hz * 8 / 7;
-		bw10k = p->bandwidth_hz / 10000;
-	} else {
-		dvb_rate = 8 * 8 / 7;
-		bw10k = 800;
-	}
+	/* no bandwidth auto-detection */
+	if (bw_hz == 0)
+		return -EINVAL;
+
+	dvb_rate = bw_hz * 8 / 7;
+	bw10k = bw_hz / 10000;
 
 	ret = si2165_adjust_pll_divl(state, 12);
 	if (ret < 0)
-- 
2.6.3


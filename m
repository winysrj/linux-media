Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:54549 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753145Ab1AJJjW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 04:39:22 -0500
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [PATCH 14/16] stv090x: Fix losing lock in dual DVB-S2 mode
Date: Mon, 10 Jan 2011 10:36:22 +0100
Message-Id: <1294652184-12843-15-git-send-email-o.endriss@gmx.de>
In-Reply-To: <1294652184-12843-1-git-send-email-o.endriss@gmx.de>
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Do not clear registers ACLC/BCLC in DVB-S2 mode for Cut <= 20.
Otherwise, the demod could lose the lock periodically.
Verified with cineS2 and Duoflex.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>
---
 drivers/media/dvb/frontends/stv090x.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 57e229a..1675c2a 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -2894,10 +2894,12 @@ static int stv090x_optimize_track(struct stv090x_state *state)
 		STV090x_SETFIELD_Px(reg, DVBS2_ENABLE_FIELD, 1);
 		if (STV090x_WRITE_DEMOD(state, DMDCFGMD, reg) < 0)
 			goto err;
-		if (STV090x_WRITE_DEMOD(state, ACLC, 0) < 0)
-			goto err;
-		if (STV090x_WRITE_DEMOD(state, BCLC, 0) < 0)
-			goto err;
+		if (state->internal->dev_ver >= 0x30) {
+			if (STV090x_WRITE_DEMOD(state, ACLC, 0) < 0)
+				goto err;
+			if (STV090x_WRITE_DEMOD(state, BCLC, 0) < 0)
+				goto err;
+		}
 		if (state->frame_len == STV090x_LONG_FRAME) {
 			reg = STV090x_READ_DEMOD(state, DMDMODCOD);
 			modcod = STV090x_GETFIELD_Px(reg, DEMOD_MODCOD_FIELD);
-- 
1.6.5.3


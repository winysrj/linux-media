Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48183 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab1HZP7l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 11:59:41 -0400
Received: by wwf5 with SMTP id 5so3652488wwf.1
        for <linux-media@vger.kernel.org>; Fri, 26 Aug 2011 08:59:40 -0700 (PDT)
Date: Fri, 26 Aug 2011 16:59:30 +0100 (BST)
From: Edward Sheldrake <ejsheldrake@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] drxd: fix divide error
Message-ID: <alpine.LFD.2.02.1108261656270.31031@obsidian>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix division by zero in drxd triggered by running "femon" before any DVB
tuning has been done (by "scandvb" or anything else).

Signed-off-by: Edward Sheldrake <ejsheldrake@gmail.com>
---
 drivers/media/dvb/frontends/drxd_hard.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 2238bf0..bcad01c 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -889,10 +889,15 @@ static int ReadIFAgc(struct drxd_state *state, u32 * pValue)
 			u32 R2 = state->if_agc_cfg.R2;
 			u32 R3 = state->if_agc_cfg.R3;
 
-			u32 Vmax = (3300 * R2) / (R1 + R2);
-			u32 Rpar = (R2 * R3) / (R3 + R2);
-			u32 Vmin = (3300 * Rpar) / (R1 + Rpar);
-			u32 Vout = Vmin + ((Vmax - Vmin) * Value) / 1024;
+			u32 Vmax, Rpar, Vmin, Vout;
+
+			if (R2 == 0 && (R1 == 0 || R3 == 0))
+				return 0;
+
+			Vmax = (3300 * R2) / (R1 + R2);
+			Rpar = (R2 * R3) / (R3 + R2);
+			Vmin = (3300 * Rpar) / (R1 + Rpar);
+			Vout = Vmin + ((Vmax - Vmin) * Value) / 1024;
 
 			*pValue = Vout;
 		}
-- 
1.7.6


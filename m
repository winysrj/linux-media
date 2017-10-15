Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37304 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbdJOUwH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id r68so6159673wmr.4
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:06 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 7/8] [media] stv0910: read and update mod_cod in read_status()
Date: Sun, 15 Oct 2017 22:51:56 +0200
Message-Id: <20171015205157.14342-8-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add missing state->modcod update from upstream driver which needs to be
done when manage_matype_info() sets is_vcm on certain S2 transponders.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 8bf855c301f5..73f6df0abbfe 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1498,6 +1498,19 @@ static int read_status(struct dvb_frontend *fe, enum fe_status *status)
 				enable_puncture_rate(state,
 						     state->puncture_rate);
 		}
+
+		/* Use highest signaled ModCod for quality */
+		if (state->is_vcm) {
+			u8 tmp;
+			enum fe_stv0910_mod_cod mod_cod;
+
+			read_reg(state, RSTV0910_P2_DMDMODCOD + state->regoff,
+				 &tmp);
+			mod_cod = (enum fe_stv0910_mod_cod)((tmp & 0x7c) >> 2);
+
+			if (mod_cod > state->mod_cod)
+				state->mod_cod = mod_cod;
+		}
 	}
 
 	/* read signal statistics */
-- 
2.13.6

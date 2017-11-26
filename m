Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34988 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdKZNAT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 08:00:19 -0500
Received: by mail-wm0-f65.google.com with SMTP id w73so1121562wmw.0
        for <linux-media@vger.kernel.org>; Sun, 26 Nov 2017 05:00:19 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, rascobie@slingshot.co.nz, jasmin@anw.at
Subject: [PATCH 6/7] [media] dvb-frontends/stv0910: remove unneeded symbol rate inquiry
Date: Sun, 26 Nov 2017 14:00:08 +0100
Message-Id: <20171126130009.6798-7-d.scheller.oss@gmail.com>
In-Reply-To: <20171126130009.6798-1-d.scheller.oss@gmail.com>
References: <20171126130009.6798-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

tracking_optimization() doesn't make use of the symbol rate reported by
the demodulator, so remove the unneeded inquiry and the now unneeded
variable.

Reported-by: Richard Scobie <rascobie@slingshot.co.nz>
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
---
 drivers/media/dvb-frontends/stv0910.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index e9517e11b399..de8702fcffbd 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -533,10 +533,8 @@ static int get_signal_parameters(struct stv *state)
 
 static int tracking_optimization(struct stv *state)
 {
-	u32 symbol_rate = 0;
 	u8 tmp;
 
-	get_cur_symbol_rate(state, &symbol_rate);
 	read_reg(state, RSTV0910_P2_DMDCFGMD + state->regoff, &tmp);
 	tmp &= ~0xC0;
 
-- 
2.13.6

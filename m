Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51333 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753080AbeDBSYc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:32 -0400
Received: by mail-wm0-f65.google.com with SMTP id v21so27561474wmc.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:32 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 01/20] [media] dvb-frontends/stv0910: add init values for TSINSDELM/L
Date: Mon,  2 Apr 2018 20:24:08 +0200
Message-Id: <20180402182427.20918-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The TSINSDEL registers were lacking initialisation in the stv0910 demod
driver. Initialise them (both demods) in the probe() function.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 52355c14fd64..f5b5ce971c0c 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1220,6 +1220,12 @@ static int probe(struct stv *state)
 	write_reg(state, RSTV0910_P1_I2CRPT, state->i2crpt);
 	write_reg(state, RSTV0910_P2_I2CRPT, state->i2crpt);
 
+	write_reg(state, RSTV0910_P1_TSINSDELM, 0x17);
+	write_reg(state, RSTV0910_P1_TSINSDELL, 0xff);
+
+	write_reg(state, RSTV0910_P2_TSINSDELM, 0x17);
+	write_reg(state, RSTV0910_P2_TSINSDELL, 0xff);
+
 	init_diseqc(state);
 	return 0;
 }
-- 
2.16.1

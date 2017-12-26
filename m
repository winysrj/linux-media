Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33787 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbdLZXiE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 18:38:04 -0500
Received: by mail-wm0-f65.google.com with SMTP id g130so37554717wme.0
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 15:38:03 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 1/4] [media] dvb-frontends/stv0910: deduplicate writes in enable_puncture_rate()
Date: Wed, 27 Dec 2017 00:37:56 +0100
Message-Id: <20171226233759.16116-2-d.scheller.oss@gmail.com>
In-Reply-To: <20171226233759.16116-1-d.scheller.oss@gmail.com>
References: <20171226233759.16116-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

For all code rates, the same write is performed, only with a differing
value. Clean this up by putting that value into a variable instead and
perform the write at the end with that value.

Picked up from the dddvb upstream.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index a8c99f41478b..a6c473f3647f 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -908,27 +908,31 @@ static int init_search_param(struct stv *state)
 
 static int enable_puncture_rate(struct stv *state, enum fe_code_rate rate)
 {
+	u8 val;
+
 	switch (rate) {
 	case FEC_1_2:
-		return write_reg(state,
-				 RSTV0910_P2_PRVIT + state->regoff, 0x01);
+		val = 0x01;
+		break;
 	case FEC_2_3:
-		return write_reg(state,
-				 RSTV0910_P2_PRVIT + state->regoff, 0x02);
+		val = 0x02;
+		break;
 	case FEC_3_4:
-		return write_reg(state,
-				 RSTV0910_P2_PRVIT + state->regoff, 0x04);
+		val = 0x04;
+		break;
 	case FEC_5_6:
-		return write_reg(state,
-				 RSTV0910_P2_PRVIT + state->regoff, 0x08);
+		val = 0x08;
+		break;
 	case FEC_7_8:
-		return write_reg(state,
-				 RSTV0910_P2_PRVIT + state->regoff, 0x20);
+		val = 0x20;
+		break;
 	case FEC_NONE:
 	default:
-		return write_reg(state,
-				 RSTV0910_P2_PRVIT + state->regoff, 0x2f);
+		val = 0x2f;
+		break;
 	}
+
+	return write_reg(state, RSTV0910_P2_PRVIT + state->regoff, val);
 }
 
 static int set_vth_default(struct stv *state)
-- 
2.13.6

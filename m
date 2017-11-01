Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51313 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933427AbdKAVGV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:21 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Joerg Riechardt <J.Riechardt@gmx.de>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH v2 24/26] media: stv090x: Only print tuner lock if get_status is available
Date: Wed,  1 Nov 2017 17:06:01 -0400
Message-Id: <e60d158a5eb20359398cd90bc3f30ac88b557fed.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code doesn't report tuner lock properly if the
tuner get_status callback is not available, as reported by
smatch:
	drivers/media/dvb-frontends/stv090x.c:2220 stv090x_get_coldlock() error: uninitialized symbol 'reg'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/stv090x.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 7ef469c0c866..0f375df13fbe 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -2215,13 +2215,12 @@ static int stv090x_get_coldlock(struct stv090x_state *state, s32 timeout_dmd)
 		if (state->config->tuner_get_status) {
 			if (state->config->tuner_get_status(fe, &reg) < 0)
 				goto err_gateoff;
+			if (reg)
+				dprintk(FE_DEBUG, 1, "Tuner phase locked");
+			else
+				dprintk(FE_DEBUG, 1, "Tuner unlocked");
 		}
 
-		if (reg)
-			dprintk(FE_DEBUG, 1, "Tuner phase locked");
-		else
-			dprintk(FE_DEBUG, 1, "Tuner unlocked");
-
 		if (stv090x_i2c_gate_ctrl(state, 0) < 0)
 			goto err;
 
-- 
2.13.6

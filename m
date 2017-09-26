Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:54318 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934463AbdIZLdp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:33:45 -0400
Subject: [PATCH 5/6] [media] tda8261: Adjust three function calls together
 with a variable assignment
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Message-ID: <8e60d1bf-ebdb-a9f8-8cf2-3dee7a1c4c96@users.sourceforge.net>
Date: Tue, 26 Sep 2017 13:33:39 +0200
MIME-Version: 1.0
In-Reply-To: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 12:52:24 +0200

The script "checkpatch.pl" pointed information out like the following.

ERROR: do not use assignment in if condition

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/tda8261.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 492d8c03a5fa..20185ee8f253 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -42,7 +42,8 @@ static int tda8261_read(struct tda8261_state *state, u8 *buf)
 	int err = 0;
 	struct i2c_msg msg = { .addr	= config->addr, .flags = I2C_M_RD,.buf = buf,  .len = 1 };
 
-	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1)
+	err = i2c_transfer(state->i2c, &msg, 1);
+	if (err != 1)
 		pr_err("%s: read error, err=%d\n", __func__, err);
 
 	return err;
@@ -54,7 +55,8 @@ static int tda8261_write(struct tda8261_state *state, u8 *buf)
 	int err = 0;
 	struct i2c_msg msg = { .addr = config->addr, .flags = 0, .buf = buf, .len = 4 };
 
-	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1)
+	err = i2c_transfer(state->i2c, &msg, 1);
+	if (err != 1)
 		pr_err("%s: write error, err=%d\n", __func__, err);
 
 	return err;
@@ -67,8 +69,8 @@ static int tda8261_get_status(struct dvb_frontend *fe, u32 *status)
 	int err = 0;
 
 	*status = 0;
-
-	if ((err = tda8261_read(state, &result)) < 0) {
+	err = tda8261_read(state, &result);
+	if (err < 0) {
 		pr_err("%s: I/O Error\n", __func__);
 		return err;
 	}
-- 
2.14.1

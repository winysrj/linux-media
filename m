Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:60947 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934463AbdIZLet (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:34:49 -0400
Subject: [PATCH 6/6] [media] tda8261: Delete an unnecessary variable
 initialisation in three functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Message-ID: <78d9ff22-6bc0-ae3f-9930-e9606536c859@users.sourceforge.net>
Date: Tue, 26 Sep 2017 13:34:43 +0200
MIME-Version: 1.0
In-Reply-To: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 12:55:16 +0200

The local variable "err" is reassigned by a statement at the beginning.
Thus omit the explicit initialisation in these functions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/tda8261.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 20185ee8f253..33144a34e337 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -39,7 +39,7 @@ struct tda8261_state {
 static int tda8261_read(struct tda8261_state *state, u8 *buf)
 {
 	const struct tda8261_config *config = state->config;
-	int err = 0;
+	int err;
 	struct i2c_msg msg = { .addr	= config->addr, .flags = I2C_M_RD,.buf = buf,  .len = 1 };
 
 	err = i2c_transfer(state->i2c, &msg, 1);
@@ -52,7 +52,7 @@ static int tda8261_read(struct tda8261_state *state, u8 *buf)
 static int tda8261_write(struct tda8261_state *state, u8 *buf)
 {
 	const struct tda8261_config *config = state->config;
-	int err = 0;
+	int err;
 	struct i2c_msg msg = { .addr = config->addr, .flags = 0, .buf = buf, .len = 4 };
 
 	err = i2c_transfer(state->i2c, &msg, 1);
@@ -66,7 +66,7 @@ static int tda8261_get_status(struct dvb_frontend *fe, u32 *status)
 {
 	struct tda8261_state *state = fe->tuner_priv;
 	u8 result = 0;
-	int err = 0;
+	int err;
 
 	*status = 0;
 	err = tda8261_read(state, &result);
-- 
2.14.1

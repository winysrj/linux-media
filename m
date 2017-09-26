Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:65364 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968350AbdIZLcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 07:32:33 -0400
Subject: [PATCH 4/6] [media] tda8261: Delete an unnecessary variable
 initialisation in tda8261_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Message-ID: <f666b7ca-146e-6574-b066-2b1e034c26f5@users.sourceforge.net>
Date: Tue, 26 Sep 2017 13:32:26 +0200
MIME-Version: 1.0
In-Reply-To: <15d74bee-7467-4687-24e1-3501c22f6d75@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 26 Sep 2017 12:24:57 +0200

The local variable "state" is reassigned by a statement at the beginning.
Thus omit the explicit initialisation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/tda8261.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index e3b4183d00c2..492d8c03a5fa 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -183,7 +183,7 @@ struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
 				    const struct tda8261_config *config,
 				    struct i2c_adapter *i2c)
 {
-	struct tda8261_state *state = NULL;
+	struct tda8261_state *state;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
-- 
2.14.1

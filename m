Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59293 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbdH3HYQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 03:24:16 -0400
Subject: [PATCH 6/6] [media] cx24116: Delete jump targets in cx24116_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Message-ID: <5f395fa8-c931-b074-090a-9c97526834ad@users.sourceforge.net>
Date: Wed, 30 Aug 2017 09:24:10 +0200
MIME-Version: 1.0
In-Reply-To: <d01b4a11-6e93-bc40-72de-dab9ce7b997a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 08:44:29 +0200

* Return directly after a call of the function "kzalloc" failed
  at the beginning.

* Move a bit of exception handling code into an if branch.

* Delete two jump targets which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/cx24116.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index 902a60d2e1b5..8fb3f095e21c 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -1125,7 +1125,7 @@ struct dvb_frontend *cx24116_attach(const struct cx24116_config *config,
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
-		goto error1;
+		return NULL;
 
 	state->config = config;
 	state->i2c = i2c;
@@ -1134,8 +1134,9 @@ struct dvb_frontend *cx24116_attach(const struct cx24116_config *config,
 	ret = (cx24116_readreg(state, 0xFF) << 8) |
 		cx24116_readreg(state, 0xFE);
 	if (ret != 0x0501) {
+		kfree(state);
 		printk(KERN_INFO "Invalid probe, probably not a CX24116 device\n");
-		goto error2;
+		return NULL;
 	}
 
 	/* create dvb_frontend */
@@ -1143,9 +1144,6 @@ struct dvb_frontend *cx24116_attach(const struct cx24116_config *config,
 		sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 	return &state->frontend;
-
-error2: kfree(state);
-error1: return NULL;
 }
 EXPORT_SYMBOL(cx24116_attach);
 
-- 
2.14.1

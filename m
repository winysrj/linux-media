Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:63977 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751264AbdH3UYh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 16:24:37 -0400
Subject: [PATCH 4/4] [media] ds3000: Delete jump targets in ds3000_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c854b845-3b79-ca7a-a597-4abc5f32ec54@users.sourceforge.net>
Message-ID: <6845c215-eeb8-5286-6049-ea4befb645ae@users.sourceforge.net>
Date: Wed, 30 Aug 2017 22:24:26 +0200
MIME-Version: 1.0
In-Reply-To: <c854b845-3b79-ca7a-a597-4abc5f32ec54@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 30 Aug 2017 22:02:54 +0200

* Return directly after a call of the function "kzalloc" failed
  at the beginning.

* Move a bit of exception handling code into an if branch.

* Delete two jump targets which became unnecessary with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/ds3000.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 3e347d03acb3..bd4f8278c906 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -841,7 +841,7 @@ struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
-		goto error2;
+		return NULL;
 
 	state->config = config;
 	state->i2c = i2c;
@@ -850,8 +850,9 @@ struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 	/* check if the demod is present */
 	ret = ds3000_readreg(state, 0x00) & 0xfe;
 	if (ret != 0xe0) {
+		kfree(state);
 		printk(KERN_ERR "Invalid probe, probably not a DS3000\n");
-		goto error3;
+		return NULL;
 	}
 
 	printk(KERN_INFO "DS3000 chip version: %d.%d attached.\n",
@@ -869,11 +870,6 @@ struct dvb_frontend *ds3000_attach(const struct ds3000_config *config,
 	 */
 	ds3000_set_voltage(&state->frontend, SEC_VOLTAGE_OFF);
 	return &state->frontend;
-
-error3:
-	kfree(state);
-error2:
-	return NULL;
 }
 EXPORT_SYMBOL(ds3000_attach);
 
-- 
2.14.1

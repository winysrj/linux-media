Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:50689 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbdHaT7G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 15:59:06 -0400
Subject: [PATCH 3/3] [media] mb86a20s: Delete a jump target in
 mb86a20s_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <9571ee6c-5137-15f4-4cdb-9f03b5cb9268@users.sourceforge.net>
Message-ID: <6b7fbd7b-f25d-25c0-5473-41c11b308349@users.sourceforge.net>
Date: Thu, 31 Aug 2017 21:58:59 +0200
MIME-Version: 1.0
In-Reply-To: <9571ee6c-5137-15f4-4cdb-9f03b5cb9268@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 31 Aug 2017 21:34:58 +0200

* Return directly after a call of the function "kzalloc" failed
  at the beginning.

* Move a bit of exception handling code into an if branch.

* Adjust a condition check.

* Delete the jump target "error" which became unnecessary
  with this refactoring.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/mb86a20s.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index ba7a433dd424..bdaf9d235fed 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -2073,7 +2073,7 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
-		goto error;
+		return NULL;
 
 	/* setup the state */
 	state->config = config;
@@ -2086,22 +2086,16 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 
 	/* Check if it is a mb86a20s frontend */
 	rev = mb86a20s_readreg(state, 0);
-
-	if (rev == 0x13) {
-		dev_info(&i2c->dev,
-			 "Detected a Fujitsu mb86a20s frontend\n");
-	} else {
+	if (rev != 0x13) {
+		kfree(state);
 		dev_dbg(&i2c->dev,
 			"Frontend revision %d is unknown - aborting.\n",
 		       rev);
-		goto error;
+		return NULL;
 	}
 
+	dev_info(&i2c->dev, "Detected a Fujitsu mb86a20s frontend\n");
 	return &state->frontend;
-
-error:
-	kfree(state);
-	return NULL;
 }
 EXPORT_SYMBOL(mb86a20s_attach);
 
-- 
2.14.1

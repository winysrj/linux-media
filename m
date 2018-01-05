Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34162 "EHLO
        homiemail-a56.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751909AbeAEO51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Jan 2018 09:57:27 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 2/2] lgdt3306a: Fix a double kfree on i2c device remove
Date: Fri,  5 Jan 2018 08:57:13 -0600
Message-Id: <1515164233-2423-3-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515164233-2423-1-git-send-email-brad@nextdimension.cc>
References: <1515164233-2423-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both lgdt33606a_release and lgdt3306a_remove kfree state, but _release is
called first, then _remove operates on states members before kfree'ing it.
This can lead to random oops/GPF/etc on USB disconnect.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index d370671..3642e6e 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1768,7 +1768,13 @@ static void lgdt3306a_release(struct dvb_frontend *fe)
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 
 	dbg_info("\n");
-	kfree(state);
+
+	/*
+	 * If state->muxc is not NULL, then we are an i2c device
+	 * and lgdt3306a_remove will clean up state
+	 */
+	if (!state->muxc)
+		kfree(state);
 }
 
 static const struct dvb_frontend_ops lgdt3306a_ops;
-- 
2.7.4

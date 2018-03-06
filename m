Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44131 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753851AbeCFTPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 14:15:06 -0500
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 1/8] lgdt3306a: remove symbol count mismatch fix
Date: Tue,  6 Mar 2018 13:14:55 -0600
Message-Id: <1520363702-25536-2-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
References: <1520363702-25536-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This symbol mismatch is handled by NULL'ing out the release
callback if the driver is loaded as an i2c device.

This patch reverts:
- 94448e21cf08b10f7dc7acdaca387594370396b0
- 835d66173a38538c072a7c393d02360dcfac8582

The symbol count mismatch is handled by:
- 5b3a8e906973540b61dbf402c6b6f8d64d4ae119

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/dvb-frontends/lgdt3306a.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 5b19033..7eb4e14 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1814,13 +1814,7 @@ static void lgdt3306a_release(struct dvb_frontend *fe)
 	struct lgdt3306a_state *state = fe->demodulator_priv;
 
 	dbg_info("\n");
-
-	/*
-	 * If state->muxc is not NULL, then we are an i2c device
-	 * and lgdt3306a_remove will clean up state
-	 */
-	if (!state->muxc)
-		kfree(state);
+	kfree(state);
 }
 
 static const struct dvb_frontend_ops lgdt3306a_ops;
@@ -2221,7 +2215,7 @@ static int lgdt3306a_probe(struct i2c_client *client,
 			sizeof(struct lgdt3306a_config));
 
 	config->i2c_addr = client->addr;
-	fe = dvb_attach(lgdt3306a_attach, config, client->adapter);
+	fe = lgdt3306a_attach(config, client->adapter);
 	if (fe == NULL) {
 		ret = -ENODEV;
 		goto err_fe;
-- 
2.7.4

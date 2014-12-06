Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35282 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbaLFVfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/22] si2168: remove unneeded fw variable initialization
Date: Sat,  6 Dec 2014 23:34:45 +0200
Message-Id: <1417901696-5517-11-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 034e1ec0ce299b9e90056793dcb3187e7add6b62
si2168: One function call less in si2168_init() after error detection

That commit added goto label for error path to release firmware,
but forgets to remove variable NULL set. Remove those now.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index e8e715f..7f20fd0 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -346,7 +346,7 @@ static int si2168_init(struct dvb_frontend *fe)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	int ret, len, remaining;
-	const struct firmware *fw = NULL;
+	const struct firmware *fw;
 	u8 *fw_file;
 	struct si2168_cmd cmd;
 	unsigned int chip_id;
@@ -483,7 +483,6 @@ static int si2168_init(struct dvb_frontend *fe)
 	}
 
 	release_firmware(fw);
-	fw = NULL;
 
 	memcpy(cmd.args, "\x01\x01", 2);
 	cmd.wlen = 2;
-- 
http://palosaari.fi/


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40285 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaLFVfP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:15 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 17/22] si2157: change firmware download error handling
Date: Sat,  6 Dec 2014 23:34:51 +0200
Message-Id: <1417901696-5517-17-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename firmare download error path goto label. Remove firmware NULL
set as NULL value is not needed anymore, due to recent change which
started using goto labels for firmware error handling.

Cc: Olli Salonen <olli.salonen@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 88afb2a..6174c8e 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -81,7 +81,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	struct si2157_dev *dev = i2c_get_clientdata(client);
 	int ret, len, remaining;
 	struct si2157_cmd cmd;
-	const struct firmware *fw = NULL;
+	const struct firmware *fw;
 	u8 *fw_file;
 	unsigned int chip_id;
 
@@ -154,7 +154,7 @@ static int si2157_init(struct dvb_frontend *fe)
 		dev_err(&client->dev, "firmware file '%s' is invalid\n",
 				fw_file);
 		ret = -EINVAL;
-		goto fw_release_exit;
+		goto err_release_firmware;
 	}
 
 	dev_info(&client->dev, "downloading firmware from file '%s'\n",
@@ -169,12 +169,11 @@ static int si2157_init(struct dvb_frontend *fe)
 		if (ret) {
 			dev_err(&client->dev, "firmware download failed %d\n",
 					ret);
-			goto fw_release_exit;
+			goto err_release_firmware;
 		}
 	}
 
 	release_firmware(fw);
-	fw = NULL;
 
 skip_fw_download:
 	/* reboot the tuner with new firmware? */
@@ -191,7 +190,7 @@ warm:
 	dev->active = true;
 	return 0;
 
-fw_release_exit:
+err_release_firmware:
 	release_firmware(fw);
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
-- 
http://palosaari.fi/


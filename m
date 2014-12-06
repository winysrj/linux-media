Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48225 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaLFVfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:14 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/22] si2168: print chip version
Date: Sat,  6 Dec 2014 23:34:46 +0200
Message-Id: <1417901696-5517-12-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print chip version once using log level into when init() is called.
Remove cold/warm state printing as those are not very useful.

old printing:
si2168 6-0064: found a 'Silicon Labs Si2168' in cold state
si2168 6-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
si2168 6-0064: firmware version: 4.0.11
si2168 6-0064: found a 'Silicon Labs Si2168' in warm state

new printing:
si2168 6-0064: found a 'Silicon Labs Si2168-B40'
si2168 6-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
si2168 6-0064: firmware version: 4.0.11

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 7f20fd0..46a919b 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -414,17 +414,15 @@ static int si2168_init(struct dvb_frontend *fe)
 		fw_file = SI2168_B40_FIRMWARE;
 		break;
 	default:
-		dev_err(&client->dev,
-				"unknown chip version Si21%d-%c%c%c\n",
+		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
 				cmd.args[2], cmd.args[1],
 				cmd.args[3], cmd.args[4]);
 		ret = -EINVAL;
 		goto err;
 	}
 
-	/* cold state - try to download firmware */
-	dev_info(&client->dev, "found a '%s' in cold state\n",
-			si2168_ops.info.name);
+	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
+			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
 
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, &client->dev);
@@ -512,13 +510,11 @@ static int si2168_init(struct dvb_frontend *fe)
 		goto err;
 
 	dev->fw_loaded = true;
-
-	dev_info(&client->dev, "found a '%s' in warm state\n",
-			si2168_ops.info.name);
 warm:
 	dev->active = true;
 
 	return 0;
+
 err_release_firmware:
 	release_firmware(fw);
 err:
-- 
http://palosaari.fi/


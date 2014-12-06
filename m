Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37726 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbaLFVfQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 16:35:16 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 21/22] si2157: print chip version
Date: Sat,  6 Dec 2014 23:34:55 +0200
Message-Id: <1417901696-5517-21-git-send-email-crope@iki.fi>
In-Reply-To: <1417901696-5517-1-git-send-email-crope@iki.fi>
References: <1417901696-5517-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print chip version once using log level into when init() is called.
Remove cold/warm state printing as those are not very useful.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 6ae7620..27b488b 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -128,7 +128,8 @@ static int si2157_init(struct dvb_frontend *fe)
 	case SI2157_A30:
 	case SI2147_A30:
 	case SI2146_A10:
-		goto skip_fw_download;
+		fw_file = NULL;
+		break;
 	default:
 		dev_err(&client->dev, "unknown chip version Si21%d-%c%c%c\n",
 				cmd.args[2], cmd.args[1],
@@ -137,9 +138,11 @@ static int si2157_init(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	/* cold state - try to download firmware */
-	dev_info(&client->dev, "found a '%s' in cold state\n",
-			si2157_ops.info.name);
+	dev_info(&client->dev, "found a 'Silicon Labs Si21%d-%c%c%c'\n",
+			cmd.args[2], cmd.args[1], cmd.args[3], cmd.args[4]);
+
+	if (fw_file == NULL)
+		goto skip_fw_download;
 
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, &client->dev);
-- 
http://palosaari.fi/


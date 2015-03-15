Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:56493 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbCOW6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 18:58:06 -0400
From: Benjamin Larsson <benjamin@southpole.se>
To: crope@iki.fi, mchehab@osg.samsung.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/10] mn88473: check if firmware is already running before loading it
Date: Sun, 15 Mar 2015 23:57:53 +0100
Message-Id: <1426460275-3766-8-git-send-email-benjamin@southpole.se>
In-Reply-To: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
References: <1426460275-3766-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88473/mn88473.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/mn88473/mn88473.c b/drivers/staging/media/mn88473/mn88473.c
index 607ce4d..a23e59e 100644
--- a/drivers/staging/media/mn88473/mn88473.c
+++ b/drivers/staging/media/mn88473/mn88473.c
@@ -196,8 +196,19 @@ static int mn88473_init(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	if (dev->warm)
+	/* set cold state by default */
+	dev->warm = false;
+
+	/* check if firmware is already running */
+	ret = regmap_read(dev->regmap[0], 0xf5, &tmp);
+	if (ret)
+		goto err;
+
+	if (!(tmp & 0x1)) {
+		dev_info(&client->dev, "firmware already running\n");
+		dev->warm = true;
 		return 0;
+	}
 
 	/* request the firmware, this will block and timeout */
 	ret = request_firmware(&fw, fw_file, &client->dev);
-- 
2.1.0


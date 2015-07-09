Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47132 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbbGIEG4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:56 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/12] tda10071: use jiffies when poll firmware status
Date: Thu,  9 Jul 2015 07:06:29 +0300
Message-Id: <1436414792-9716-9-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use jiffies to set timeout for firmware command status polling.
It is more elegant solution than poll X times with sleep.

Shorten timeout to 30ms as all commands seems to be executed under
10ms.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 6226b57..c1507cc 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -53,8 +53,9 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
 	struct tda10071_cmd *cmd)
 {
 	struct i2c_client *client = dev->client;
-	int ret, i;
+	int ret;
 	unsigned int uitmp;
+	unsigned long timeout;
 
 	if (!dev->warm) {
 		ret = -EFAULT;
@@ -72,17 +73,19 @@ static int tda10071_cmd_execute(struct tda10071_dev *dev,
 		goto error;
 
 	/* wait cmd execution terminate */
-	for (i = 1000, uitmp = 1; i && uitmp; i--) {
+	#define CMD_EXECUTE_TIMEOUT 30
+	timeout = jiffies + msecs_to_jiffies(CMD_EXECUTE_TIMEOUT);
+	for (uitmp = 1; !time_after(jiffies, timeout) && uitmp;) {
 		ret = regmap_read(dev->regmap, 0x1f, &uitmp);
 		if (ret)
 			goto error;
-
-		usleep_range(200, 5000);
 	}
 
-	dev_dbg(&client->dev, "loop=%d\n", i);
+	dev_dbg(&client->dev, "cmd execution took %u ms\n",
+		jiffies_to_msecs(jiffies) -
+		(jiffies_to_msecs(timeout) - CMD_EXECUTE_TIMEOUT));
 
-	if (i == 0) {
+	if (uitmp) {
 		ret = -ETIMEDOUT;
 		goto error;
 	}
-- 
http://palosaari.fi/


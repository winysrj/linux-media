Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37380 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754341AbcLAAaH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 19:30:07 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] mn88472: fix chip id check on probe
Date: Thu,  1 Dec 2016 02:29:46 +0200
Message-Id: <1480552186-1179-2-git-send-email-crope@iki.fi>
In-Reply-To: <1480552186-1179-1-git-send-email-crope@iki.fi>
References: <1480552186-1179-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A register used to identify chip during probe was overwritten during
firmware download and due to that later probe's for warm chip were
failing. Detect chip from the another register, which is located on
different register bank 2.

Fixes: 94d0eaa41987 ("[media] mn88472: move out of staging to media")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index b6f5f83..29dd13b 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -488,18 +488,6 @@ static int mn88472_probe(struct i2c_client *client,
 		goto err_kfree;
 	}
 
-	/* Check demod answers with correct chip id */
-	ret = regmap_read(dev->regmap[0], 0xff, &utmp);
-	if (ret)
-		goto err_regmap_0_regmap_exit;
-
-	dev_dbg(&client->dev, "chip id=%02x\n", utmp);
-
-	if (utmp != 0x02) {
-		ret = -ENODEV;
-		goto err_regmap_0_regmap_exit;
-	}
-
 	/*
 	 * Chip has three I2C addresses for different register banks. Used
 	 * addresses are 0x18, 0x1a and 0x1c. We register two dummy clients,
@@ -536,6 +524,18 @@ static int mn88472_probe(struct i2c_client *client,
 	}
 	i2c_set_clientdata(dev->client[2], dev);
 
+	/* Check demod answers with correct chip id */
+	ret = regmap_read(dev->regmap[2], 0xff, &utmp);
+	if (ret)
+		goto err_regmap_2_regmap_exit;
+
+	dev_dbg(&client->dev, "chip id=%02x\n", utmp);
+
+	if (utmp != 0x02) {
+		ret = -ENODEV;
+		goto err_regmap_2_regmap_exit;
+	}
+
 	/* Sleep because chip is active by default */
 	ret = regmap_write(dev->regmap[2], 0x05, 0x3e);
 	if (ret)

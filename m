Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51253 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbbEEWB3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 May 2015 18:01:29 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] e4000: remove dummy register write
Date: Wed,  6 May 2015 01:01:18 +0300
Message-Id: <1430863280-10266-2-git-send-email-crope@iki.fi>
In-Reply-To: <1430863280-10266-1-git-send-email-crope@iki.fi>
References: <1430863280-10266-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chip is already probed, which means I2C bus is alive and working
unless something strange happens during sleep.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/e4000.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index 59190cb..a5d51d7 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -28,9 +28,6 @@ static int e4000_init(struct dvb_frontend *fe)
 
 	dev_dbg(&s->client->dev, "\n");
 
-	/* dummy I2C to ensure I2C wakes up */
-	ret = regmap_write(s->regmap, 0x02, 0x40);
-
 	/* reset */
 	ret = regmap_write(s->regmap, 0x00, 0x01);
 	if (ret)
-- 
http://palosaari.fi/


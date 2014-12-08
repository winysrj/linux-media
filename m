Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:34863 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbaLHUbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 15:31:10 -0500
From: Benjamin Larsson <benjamin@southpole.se>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] mn88472: fix firmware downloading
Date: Mon,  8 Dec 2014 21:31:06 +0100
Message-Id: <1418070667-13349-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The max amount of payload bytes in each i2c transfer when
loading the demodulator firmware is 16 bytes.

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/staging/media/mn88472/mn88472.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/mn88472/mn88472.c b/drivers/staging/media/mn88472/mn88472.c
index ffee187..df7dbe9 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -15,6 +15,7 @@
  */
 
 #include "mn88472_priv.h"
+#define FW_BUF_SIZE 16
 
 static int mn88472_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *s)
@@ -331,10 +332,10 @@ static int mn88472_init(struct dvb_frontend *fe)
 		goto err;
 
 	for (remaining = fw->size; remaining > 0;
-			remaining -= (dev->i2c_wr_max - 1)) {
+			remaining -= FW_BUF_SIZE) {
 		len = remaining;
-		if (len > (dev->i2c_wr_max - 1))
-			len = (dev->i2c_wr_max - 1);
+		if (len > FW_BUF_SIZE)
+			len = FW_BUF_SIZE;
 
 		ret = regmap_bulk_write(dev->regmap[0], 0xf6,
 				&fw->data[fw->size - remaining], len);
-- 
1.9.1


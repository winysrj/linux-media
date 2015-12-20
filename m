Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44148 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbLTCDy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2015 21:03:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] rtl2832: print reg number on error case
Date: Sun, 20 Dec 2015 04:03:35 +0200
Message-Id: <1450577015-29465-2-git-send-email-crope@iki.fi>
In-Reply-To: <1450577015-29465-1-git-send-email-crope@iki.fi>
References: <1450577015-29465-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is hard to debug possible I2C failures without knowing the
possible register itself. Add register number to error printing.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 78b87b2..60250cc 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -976,7 +976,8 @@ static int rtl2832_regmap_read(void *context, const void *reg_buf,
 
 	ret = __i2c_transfer(client->adapter, msg, 2);
 	if (ret != 2) {
-		dev_warn(&client->dev, "i2c reg read failed %d\n", ret);
+		dev_warn(&client->dev, "i2c reg read failed %d reg %02x\n",
+			 ret, *(u8 *)reg_buf);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 		return ret;
@@ -999,7 +1000,8 @@ static int rtl2832_regmap_write(void *context, const void *data, size_t count)
 
 	ret = __i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1) {
-		dev_warn(&client->dev, "i2c reg write failed %d\n", ret);
+		dev_warn(&client->dev, "i2c reg write failed %d reg %02x\n",
+			 ret, *(u8 *)data);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 		return ret;
@@ -1028,7 +1030,8 @@ static int rtl2832_regmap_gather_write(void *context, const void *reg,
 
 	ret = __i2c_transfer(client->adapter, msg, 1);
 	if (ret != 1) {
-		dev_warn(&client->dev, "i2c reg write failed %d\n", ret);
+		dev_warn(&client->dev, "i2c reg write failed %d reg %02x\n",
+			 ret, *(u8 const *)reg);
 		if (ret >= 0)
 			ret = -EREMOTEIO;
 		return ret;
-- 
http://palosaari.fi/


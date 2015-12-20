Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36419 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbbLTDP4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2015 22:15:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl2832: do not filter out slave TS null packets
Date: Sun, 20 Dec 2015 05:15:45 +0200
Message-Id: <1450581345-8187-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not remove slave TS NULL padding PID (0x1fff) by default as
there is no real need. After that whole TS is passed to kernel sw
PID filter.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index 60250cc..10f2119 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -1100,18 +1100,6 @@ static int rtl2832_enable_slave_ts(struct i2c_client *client)
 	if (ret)
 		goto err;
 
-	ret = rtl2832_bulk_write(client, 0x022, "\x01", 1);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_bulk_write(client, 0x026, "\x1f", 1);
-	if (ret)
-		goto err;
-
-	ret = rtl2832_bulk_write(client, 0x027, "\xff", 1);
-	if (ret)
-		goto err;
-
 	ret = rtl2832_bulk_write(client, 0x192, "\x7f\xf7\xff", 3);
 	if (ret)
 		goto err;
-- 
http://palosaari.fi/


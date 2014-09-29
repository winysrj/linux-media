Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:42690 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaI2Hoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 03:44:44 -0400
Received: by mail-la0-f54.google.com with SMTP id ty20so4797900lab.41
        for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 00:44:42 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 2/5] sp2: fix incorrect struct
Date: Mon, 29 Sep 2014 10:44:17 +0300
Message-Id: <1411976660-19329-2-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
References: <1411976660-19329-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Incorrect struct used in the SP2 driver.

Reported-by: Max Nibble <nibble.max@gmail.com>
Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/dvb-frontends/sp2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
index 9b684d5..1f4f250 100644
--- a/drivers/media/dvb-frontends/sp2.c
+++ b/drivers/media/dvb-frontends/sp2.c
@@ -407,7 +407,7 @@ err:
 
 static int sp2_remove(struct i2c_client *client)
 {
-	struct si2157 *s = i2c_get_clientdata(client);
+	struct sp2 *s = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "\n");
 
-- 
1.9.1


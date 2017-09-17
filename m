Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:54931 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdIQUWk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 16:22:40 -0400
Subject: [PATCH 6/8] [media] cx231xx: Use common error handling code in
 read_eeprom()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Message-ID: <8971b7e5-87ca-a1d5-f23d-64ed05c788b7@users.sourceforge.net>
Date: Sun, 17 Sep 2017 22:22:12 +0200
MIME-Version: 1.0
In-Reply-To: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 20:22:15 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index d204f220dfe5..04c0734aee79 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1117,20 +1117,17 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 
 	/* start reading at offset 0 */
 	ret = i2c_transfer(client->adapter, &msg_write, 1);
-	if (ret < 0) {
-		dev_err(dev->dev, "Can't read eeprom\n");
-		return ret;
-	}
+	if (ret < 0)
+		goto report_failure;
 
 	while (len_todo > 0) {
 		msg_read.len = (len_todo > 64) ? 64 : len_todo;
 		msg_read.buf = eedata_cur;
 
 		ret = i2c_transfer(client->adapter, &msg_read, 1);
-		if (ret < 0) {
-			dev_err(dev->dev, "Can't read eeprom\n");
-			return ret;
-		}
+		if (ret < 0)
+			goto report_failure;
+
 		eedata_cur += msg_read.len;
 		len_todo -= msg_read.len;
 	}
@@ -1140,6 +1137,10 @@ static int read_eeprom(struct cx231xx *dev, struct i2c_client *client,
 			i, 16, &eedata[i]);
 
 	return 0;
+
+report_failure:
+	dev_err(dev->dev, "Can't read eeprom\n");
+	return ret;
 }
 
 void cx231xx_card_setup(struct cx231xx *dev)
-- 
2.14.1

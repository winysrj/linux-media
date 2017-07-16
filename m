Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46237 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751252AbdGPAnj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:39 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 03/16] [media] dvb-core/dvb_ca_en50221.c: use usleep_range
Date: Sun, 16 Jul 2017 02:43:04 +0200
Message-Id: <1500165797-16987-4-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  WARNING: msleep < 20ms can sleep for up to 20ms
by using usleep_range.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index bb6aa0f..725fdd0 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -313,7 +313,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 		}
 
 		/* wait for a bit */
-		msleep(1);
+		usleep_range(1000, 1100);
 	}
 
 	dprintk("%s failed timeout:%lu\n", __func__, jiffies - start);
@@ -1489,7 +1489,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 			if (status != -EAGAIN)
 				goto exit;
 
-			msleep(1);
+			usleep_range(1000, 1100);
 		}
 		if (!written) {
 			status = -EIO;
-- 
2.7.4

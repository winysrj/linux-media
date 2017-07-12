Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54590 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdGLXBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 19:01:42 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH V2 3/9] [media] dvb-core/dvb_ca_en50221.c: use usleep_range
Date: Thu, 13 Jul 2017 01:00:52 +0200
Message-Id: <1499900458-2339-4-git-send-email-jasmin@anw.at>
In-Reply-To: <1499900458-2339-1-git-send-email-jasmin@anw.at>
References: <1499900458-2339-1-git-send-email-jasmin@anw.at>
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
index 66a58ed..c0fd63a 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -313,7 +313,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 		}
 
 		/* wait for a bit */
-		msleep(1);
+		usleep_range(1000, 1100);
 	}
 
 	dprintk("%s failed timeout:%lu\n", __func__, jiffies - start);
@@ -1484,7 +1484,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 			if (status != -EAGAIN)
 				goto exit;
 
-			msleep(1);
+			usleep_range(1000, 1100);
 		}
 		if (!written) {
 			status = -EIO;
-- 
2.7.4

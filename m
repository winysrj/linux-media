Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753526AbdEGWE0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:04:26 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com, jasmin@anw.at
Subject: [PATCH 09/11] [media] dvb-core/dvb_ca_en50221.c: Make checkpatch happy 5
Date: Sun,  7 May 2017 23:23:32 +0200
Message-Id: <1494192214-20082-10-git-send-email-jasmin@anw.at>
In-Reply-To: <1494192214-20082-1-git-send-email-jasmin@anw.at>
References: <1494192214-20082-1-git-send-email-jasmin@anw.at>
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
index 090f343..724fb34 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -314,7 +314,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 			break;
 
 		/* wait for a bit */
-		msleep(1);
+		usleep_range(1000, 1100);
 	}
 
 	dprintk("%s failed timeout:%lu\n", __func__, jiffies - start);
@@ -1504,7 +1504,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 			if (status != -EAGAIN)
 				goto exit;
 
-			msleep(1);
+			usleep_range(1000, 1100);
 		}
 		if (!written) {
 			status = -EIO;
-- 
2.7.4

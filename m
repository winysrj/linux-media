Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44749 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbdFYVhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:37:24 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH v2 5/7] [staging] cxd2099/cxd2099.c: Removed useless printing in cxd2099 driver
Date: Sun, 25 Jun 2017 23:37:09 +0200
Message-Id: <1498426631-17376-6-git-send-email-jasmin@anw.at>
In-Reply-To: <1498426631-17376-1-git-send-email-jasmin@anw.at>
References: <1498426631-17376-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ralph Metzler <rjkm@metzlerbros.de>

campoll and read_data are called very often and the printouts are very
annoying and make the driver unusable. They seem to be left over from
developing the buffer mode.

Original code change by Ralph Metzler, modified by Jasmin Jessich to
match current Kernel code.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 60d8dd0..6426ff1 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -568,14 +568,10 @@ static int campoll(struct cxd *ci)
 		return 0;
 	write_reg(ci, 0x05, istat);
 
-	if (istat & 0x40) {
+	if (istat & 0x40)
 		ci->dr = 1;
-		dev_info(&ci->i2c->dev, "DR\n");
-	}
-	if (istat & 0x20) {
+	if (istat & 0x20)
 		ci->write_busy = 0;
-		dev_info(&ci->i2c->dev, "WC\n");
-	}
 
 	if (istat & 2) {
 		u8 slotstat;
@@ -628,7 +624,6 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	campoll(ci);
 	mutex_unlock(&ci->lock);
 
-	dev_info(&ci->i2c->dev, "%s\n", __func__);
 	if (!ci->dr)
 		return 0;
 
-- 
2.7.4

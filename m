Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756650AbdEGWFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:05:06 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 6/7] [staging] cxd2099/cxd2099.c: Removed useless printing in cxd2099 driver
Date: Sun,  7 May 2017 22:51:52 +0200
Message-Id: <1494190313-18557-7-git-send-email-jasmin@anw.at>
In-Reply-To: <1494190313-18557-1-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index ac01433..64de129 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -231,7 +231,6 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
 	if (status)
 		return status;
-	dev_info(&ci->i2c->dev, "write_block %d\n", n);
 
 	ci->lastaddress = adr;
 	buf[0] = 1;
@@ -240,7 +239,6 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 
 		if (ci->cfg.max_i2c && (len + 1 > ci->cfg.max_i2c))
 			len = ci->cfg.max_i2c - 1;
-		dev_info(&ci->i2c->dev, "write %d\n", len);
 		memcpy(buf + 1, data, len);
 		status = i2c_write(ci->i2c, ci->cfg.adr, buf, len + 1);
 		if (status)
@@ -570,14 +568,11 @@ static int campoll(struct cxd *ci)
 		return 0;
 	write_reg(ci, 0x05, istat);
 
-	if (istat&0x40) {
+	if (istat&0x40)
 		ci->dr = 1;
-		dev_info(&ci->i2c->dev, "DR\n");
-	}
-	if (istat&0x20) {
+
+	if (istat&0x20)
 		ci->write_busy = 0;
-		dev_info(&ci->i2c->dev, "WC\n");
-	}
 
 	if (istat&2) {
 		u8 slotstat;
@@ -631,7 +626,6 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	campoll(ci);
 	mutex_unlock(&ci->lock);
 
-	dev_info(&ci->i2c->dev, "read_data\n");
 	if (!ci->dr)
 		return 0;
 
@@ -660,7 +654,6 @@ static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	if (ci->write_busy)
 		return -EAGAIN;
 	mutex_lock(&ci->lock);
-	dev_info(&ci->i2c->dev, "write_data %d\n", ecount);
 	write_reg(ci, 0x0d, ecount>>8);
 	write_reg(ci, 0x0e, ecount&0xff);
 	write_block(ci, 0x11, ebuf, ecount);
-- 
2.7.4

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44755 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbdFYVhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:37:24 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH v2 6/7] [staging] cxd2099/cxd2099.c: Removed printing in write_block
Date: Sun, 25 Jun 2017 23:37:10 +0200
Message-Id: <1498426631-17376-7-git-send-email-jasmin@anw.at>
In-Reply-To: <1498426631-17376-1-git-send-email-jasmin@anw.at>
References: <1498426631-17376-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

There were remaining debug prints which haven't been found earlier due to
the disabled buffer mode (see commit "Removed useless printing in cxd2099
driver" for the already removed printings.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 6426ff1..3431cf6 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -230,7 +230,6 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 		status = i2c_write_reg(ci->i2c, ci->cfg.adr, 0, adr);
 	if (status)
 		return status;
-	dev_info(&ci->i2c->dev, "write_block %d\n", n);
 
 	ci->lastaddress = adr;
 	buf[0] = 1;
@@ -239,7 +238,6 @@ static int write_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 
 		if (ci->cfg.max_i2c && (len + 1 > ci->cfg.max_i2c))
 			len = ci->cfg.max_i2c - 1;
-		dev_info(&ci->i2c->dev, "write %d\n", len);
 		memcpy(buf + 1, data, len);
 		status = i2c_write(ci->i2c, ci->cfg.adr, buf, len + 1);
 		if (status)
@@ -652,7 +650,6 @@ static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	if (ci->write_busy)
 		return -EAGAIN;
 	mutex_lock(&ci->lock);
-	dev_info(&ci->i2c->dev, "%s %d\n", __func__, ecount);
 	write_reg(ci, 0x0d, ecount >> 8);
 	write_reg(ci, 0x0e, ecount & 0xff);
 	write_block(ci, 0x11, ebuf, ecount);
-- 
2.7.4

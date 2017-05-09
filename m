Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:46743 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbdEIM2S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 08:28:18 -0400
From: Alexandre Ghiti <alex@ghiti.fr>
To: gregkh@linuxfoundation.org
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] staging: media: cxd2099: Use __func__ macro in messages
Date: Tue,  9 May 2017 14:27:13 +0200
Message-Id: <1494332833-6918-1-git-send-email-alex@ghiti.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace hardcoded function names in print info with __func__.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 drivers/staging/media/cxd2099/cxd2099.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 18186d0..370ecb9 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -473,7 +473,7 @@ static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct cxd *ci = ca->data;
 
-	dev_info(&ci->i2c->dev, "slot_shutdown\n");
+	dev_info(&ci->i2c->dev, "%s\n", __func__);
 	mutex_lock(&ci->lock);
 	write_regm(ci, 0x09, 0x08, 0x08);
 	write_regm(ci, 0x20, 0x80, 0x80); /* Reset CAM Mode */
@@ -564,7 +564,7 @@ static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	campoll(ci);
 	mutex_unlock(&ci->lock);
 
-	dev_info(&ci->i2c->dev, "read_data\n");
+	dev_info(&ci->i2c->dev, "%s\n", __func__);
 	if (!ci->dr)
 		return 0;
 
@@ -584,7 +584,7 @@ static int write_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount)
 	struct cxd *ci = ca->data;
 
 	mutex_lock(&ci->lock);
-	dev_info(&ci->i2c->dev, "write_data %d\n", ecount);
+	dev_info(&ci->i2c->dev, "%s %d\n", __func__, ecount);
 	write_reg(ci, 0x0d, ecount >> 8);
 	write_reg(ci, 0x0e, ecount & 0xff);
 	write_block(ci, 0x11, ebuf, ecount);
-- 
2.1.4

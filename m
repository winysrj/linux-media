Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51467 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751845AbdEPUIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 May 2017 16:08:05 -0400
From: eddi1983 <eddi1983@gmx.net>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, diaconitatamara@gmail.com,
        daniel.baluta@gmail.com, eraretuya@gmail.com,
        elise.lennion@gmail.com, linux-media@vger.kernel.org,
        0devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Fanelsa <eddi1983@gmx.net>
Subject: [PATCH] staging: media: cxd2099: Fix checkpatch issues
Date: Tue, 16 May 2017 22:07:40 +0200
Message-Id: <20170516200740.27692-1-eddi1983@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Christoph Fanelsa <eddi1983@gmx.net>

Fix checkpatch warnings of prefered using '%s..", __func__' as function name in a string

Signed-off-by: Christoph Fanelsa <eddi1983@gmx.net>
---
 drivers/staging/media/cxd2099/cxd2099.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 18186d0fa1a6..370ecb959543 100644
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
2.13.0

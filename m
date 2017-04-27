Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35595 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031906AbdD0NAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 09:00:34 -0400
Received: by mail-wm0-f66.google.com with SMTP id d79so4426580wmi.2
        for <linux-media@vger.kernel.org>; Thu, 27 Apr 2017 06:00:33 -0700 (PDT)
From: Thomas van Lingen <mafndev@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org, Thomas van Lingen <mafndev@gmail.com>
Subject: [PATCH] cxd2099: use __func__ instead of hand-written function names
Date: Thu, 27 Apr 2017 14:59:56 +0200
Message-Id: <20170427125956.19056-1-mafndev@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a minor coding-style fix, and `checkpatch.pl` complains about
it.

Signed-off-by: Thomas van Lingen <mafndev@gmail.com>
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
2.11.0

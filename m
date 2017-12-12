Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44524 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdLLSrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 13:47:03 -0500
Received: by mail-wm0-f65.google.com with SMTP id t8so608343wmc.3
        for <linux-media@vger.kernel.org>; Tue, 12 Dec 2017 10:47:02 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 2/3] [media] staging/cxd2099: fix debug message severity
Date: Tue, 12 Dec 2017 19:46:56 +0100
Message-Id: <20171212184657.19730-3-d.scheller.oss@gmail.com>
In-Reply-To: <20171212184657.19730-1-d.scheller.oss@gmail.com>
References: <20171212184657.19730-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Debug messages should go to KERN_DEBUG, thus change the slot_shutdown()
notice from dev_info() to dev_dbg().

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 21b1c6fcf9bf..38d43647d4bf 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -518,7 +518,7 @@ static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
 {
 	struct cxd *ci = ca->data;
 
-	dev_info(&ci->i2c->dev, "%s\n", __func__);
+	dev_dbg(&ci->i2c->dev, "%s\n", __func__);
 	if (ci->cammode)
 		read_data(ca, slot, ci->rbuf, 0);
 	mutex_lock(&ci->lock);
-- 
2.13.6

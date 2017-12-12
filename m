Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33259 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbdLLSrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 13:47:04 -0500
Received: by mail-wm0-f66.google.com with SMTP id g130so18643622wme.0
        for <linux-media@vger.kernel.org>; Tue, 12 Dec 2017 10:47:03 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 3/3] [media] staging/cxd2099: cosmetics: improve strings
Date: Tue, 12 Dec 2017 19:46:57 +0100
Message-Id: <20171212184657.19730-4-d.scheller.oss@gmail.com>
In-Reply-To: <20171212184657.19730-1-d.scheller.oss@gmail.com>
References: <20171212184657.19730-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Prefix dev_*() I2C address prints with 0x, change CXD2099 to CXD2099AR,
change the MODULE_DESCRIPTION to a proper one and have a better (and
shorter) description for the buffermode modparam.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 38d43647d4bf..227a329f0c6e 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -26,7 +26,7 @@
 
 static int buffermode;
 module_param(buffermode, int, 0444);
-MODULE_PARM_DESC(buffermode, "Enable use of the CXD2099AR buffer mode (default: disabled)");
+MODULE_PARM_DESC(buffermode, "Enable CXD2099AR buffer mode (default: disabled)");
 
 static int read_data(struct dvb_ca_en50221 *ca, int slot, u8 *ebuf, int ecount);
 
@@ -668,7 +668,8 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 	u8 val;
 
 	if (i2c_read_reg(i2c, cfg->adr, 0, &val) < 0) {
-		dev_info(&i2c->dev, "No CXD2099 detected at %02x\n", cfg->adr);
+		dev_info(&i2c->dev, "No CXD2099AR detected at 0x%02x\n",
+			 cfg->adr);
 		return NULL;
 	}
 
@@ -686,7 +687,7 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 	ci->en = en_templ;
 	ci->en.data = ci;
 	init(ci);
-	dev_info(&i2c->dev, "Attached CXD2099AR at %02x\n", ci->cfg.adr);
+	dev_info(&i2c->dev, "Attached CXD2099AR at 0x%02x\n", ci->cfg.adr);
 
 	if (!buffermode) {
 		ci->en.read_data = NULL;
@@ -699,6 +700,6 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 }
 EXPORT_SYMBOL(cxd2099_attach);
 
-MODULE_DESCRIPTION("cxd2099");
+MODULE_DESCRIPTION("CXD2099AR Common Interface controller driver");
 MODULE_AUTHOR("Ralph Metzler");
 MODULE_LICENSE("GPL");
-- 
2.13.6

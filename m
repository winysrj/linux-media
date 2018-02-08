Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34860 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752575AbeBHTx1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 14:53:27 -0500
Received: by mail-wm0-f67.google.com with SMTP id r78so12231115wme.0
        for <linux-media@vger.kernel.org>; Thu, 08 Feb 2018 11:53:27 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 5/7] [media] staging/cxd2099: remove remainders from old attach way
Date: Thu,  8 Feb 2018 20:53:16 +0100
Message-Id: <20180208195318.612-6-d.scheller.oss@gmail.com>
In-Reply-To: <20180208195318.612-1-d.scheller.oss@gmail.com>
References: <20180208195318.612-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As all drivers using the cxd2099 are converted to handle attach/detach
the generic I2C client way, the static inline cxd2099_attach isn't
required anymore. Thus cleanup cxd2099.h from the remainders, the adr
struct member isn't used anymore aswell.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
index 679e87512799..8fa45a4c615a 100644
--- a/drivers/staging/media/cxd2099/cxd2099.h
+++ b/drivers/staging/media/cxd2099/cxd2099.h
@@ -20,7 +20,6 @@
 
 struct cxd2099_cfg {
 	u32 bitrate;
-	u8  adr;
 	u8  polarity;
 	u8  clock_mode;
 
@@ -30,13 +29,4 @@ struct cxd2099_cfg {
 	struct dvb_ca_en50221 **en;
 };
 
-/* TODO: remove when done */
-static inline struct
-dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg, void *priv,
-			       struct i2c_adapter *i2c)
-{
-	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-
 #endif
-- 
2.13.6

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38217 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbeFJOte (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Jun 2018 10:49:34 -0400
Received: by mail-pl0-f65.google.com with SMTP id b14-v6so10872920pls.5
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2018 07:49:34 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH] dvb-frontends/dvb-pll: fix module ref-counting
Date: Sun, 10 Jun 2018 23:49:15 +0900
Message-Id: <20180610144915.7882-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

dvb-pll module was 'put' twice on exit:
once by dvb_frontend_detach() and another by dvb_module_release().

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/dvb-pll.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index e3894ff403d..4a663420190 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -884,6 +884,17 @@ dvb_pll_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (!dvb_pll_attach(fe, client->addr, client->adapter, desc_id))
 		return -ENOMEM;
 
+	/*
+	 * Unset tuner_ops.release (== dvb_pll_release)
+	 * which has been just set in the above dvb_pll_attach(),
+	 * because if tuner_ops.release was left defined,
+	 * this module would be 'put' twice on exit:
+	 * once by dvb_frontend_detach() and another by dvb_module_release().
+	 *
+	 * dvb_pll_release is instead executed in the i2c driver's .remove(),
+	 * keeping dvb_pll_attach untouched for legacy (dvb_attach) drivers.
+	 */
+	fe->ops.tuner_ops.release = NULL;
 	dev_info(&client->dev, "DVB Simple Tuner attached.\n");
 	return 0;
 }
-- 
2.17.1

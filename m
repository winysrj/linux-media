Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.31]:13382 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752622AbdGIWmX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 18:42:23 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id A402E1BFFB
        for <linux-media@vger.kernel.org>; Sun,  9 Jul 2017 17:18:15 -0500 (CDT)
Date: Sun, 9 Jul 2017 17:18:15 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] dib7000p: constify i2c_algorithm structure
Message-ID: <20170709221815.GA9515@embeddedgus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for i2c_algorithm structures that are only stored in
the algo field of an i2c_adapter structure. This field is
declared const, so i2c_algorithm structures that have this
property can be declared as const also.

This issue was identified using Coccinelle and the following
semantic patch:

@r disable optional_qualifier@
identifier i;
position p;
@@
static struct i2c_algorithm i@p = { ... };

@ok@
identifier r.i;
struct i2c_adapter e;
position p;
@@
e.algo = &i@p;

@bad@
position p != {r.p,ok.p};
identifier r.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r.i;
@@
static
+const
 struct i2c_algorithm i = { ... };

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/dvb-frontends/dib7000p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 1caa04d..0fbaabe 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2388,7 +2388,7 @@ static u32 dib7000p_i2c_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm dib7090_tuner_xfer_algo = {
+static const struct i2c_algorithm dib7090_tuner_xfer_algo = {
 	.master_xfer = dib7090_tuner_xfer,
 	.functionality = dib7000p_i2c_func,
 };
-- 
2.5.0

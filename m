Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.145.3]:41183 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752926AbdGJBD5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 21:03:57 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id B028F3283
        for <linux-media@vger.kernel.org>; Sun,  9 Jul 2017 20:03:54 -0500 (CDT)
Date: Sun, 9 Jul 2017 20:03:52 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] zd1301_demod: constify i2c_algorithm structure
Message-ID: <20170710010352.GA18419@embeddedgus>
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
 drivers/media/dvb-frontends/zd1301_demod.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/zd1301_demod.c b/drivers/media/dvb-frontends/zd1301_demod.c
index fcf5f69..84a2b25 100644
--- a/drivers/media/dvb-frontends/zd1301_demod.c
+++ b/drivers/media/dvb-frontends/zd1301_demod.c
@@ -445,7 +445,7 @@ static u32 zd1301_demod_i2c_functionality(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm zd1301_demod_i2c_algorithm = {
+static const struct i2c_algorithm zd1301_demod_i2c_algorithm = {
 	.master_xfer   = zd1301_demod_i2c_master_xfer,
 	.functionality = zd1301_demod_i2c_functionality,
 };
-- 
2.5.0

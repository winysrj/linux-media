Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.150.114]:48473 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752276AbdGJBAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 21:00:37 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 15A30338F0
        for <linux-media@vger.kernel.org>; Sun,  9 Jul 2017 20:00:35 -0500 (CDT)
Date: Sun, 9 Jul 2017 20:00:33 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] dib8000: constify i2c_algorithm structure
Message-ID: <20170710010033.GA16990@embeddedgus>
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
 drivers/media/dvb-frontends/dib8000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index e501ec9..a179a3f 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -1880,7 +1880,7 @@ static u32 dib8096p_i2c_func(struct i2c_adapter *adapter)
 	return I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm dib8096p_tuner_xfer_algo = {
+static const struct i2c_algorithm dib8096p_tuner_xfer_algo = {
 	.master_xfer = dib8096p_tuner_xfer,
 	.functionality = dib8096p_i2c_func,
 };
-- 
2.5.0

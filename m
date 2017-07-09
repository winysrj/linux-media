Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.162]:12348 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752600AbdGIWig (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 18:38:36 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id E7FDD9812
        for <linux-media@vger.kernel.org>; Sun,  9 Jul 2017 17:14:39 -0500 (CDT)
Date: Sun, 9 Jul 2017 17:14:38 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] marvell-ccic: constify i2c_algorithm structure
Message-ID: <20170709221438.GA7634@embeddedgus>
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
 drivers/media/platform/marvell-ccic/cafe-driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index 77890bd..063fd43 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -326,7 +326,7 @@ static u32 cafe_smbus_func(struct i2c_adapter *adapter)
 	       I2C_FUNC_SMBUS_WRITE_BYTE_DATA;
 }
 
-static struct i2c_algorithm cafe_smbus_algo = {
+static const struct i2c_algorithm cafe_smbus_algo = {
 	.smbus_xfer = cafe_smbus_xfer,
 	.functionality = cafe_smbus_func
 };
-- 
2.5.0

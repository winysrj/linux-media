Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.143.39]:47912 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752982AbdGJBTp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 21:19:45 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id B28F41BC74
        for <linux-media@vger.kernel.org>; Sun,  9 Jul 2017 20:19:37 -0500 (CDT)
Date: Sun, 9 Jul 2017 20:19:36 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] dm1105: constify i2c_algorithm structure
Message-ID: <20170710011936.GA25720@embeddedgus>
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
 drivers/media/pci/dm1105/dm1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 1d41934..36e94f8 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -571,7 +571,7 @@ static u32 functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm dm1105_algo = {
+static const struct i2c_algorithm dm1105_algo = {
 	.master_xfer   = dm1105_i2c_xfer,
 	.functionality = functionality,
 };
-- 
2.5.0

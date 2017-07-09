Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.150.114]:35669 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752623AbdGIWcI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 18:32:08 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id C9C9A4C389
        for <linux-media@vger.kernel.org>; Sun,  9 Jul 2017 17:09:17 -0500 (CDT)
Date: Sun, 9 Jul 2017 17:09:16 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] saa7146: constify i2c_algorithm structure
Message-ID: <20170709220916.GA5222@embeddedgus>
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
 drivers/media/common/saa7146/saa7146_i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/saa7146/saa7146_i2c.c b/drivers/media/common/saa7146/saa7146_i2c.c
index 239a2db..75897f9 100644
--- a/drivers/media/common/saa7146/saa7146_i2c.c
+++ b/drivers/media/common/saa7146/saa7146_i2c.c
@@ -395,7 +395,7 @@ static int saa7146_i2c_xfer(struct i2c_adapter* adapter, struct i2c_msg *msg, in
 /* i2c-adapter helper functions                                              */
 
 /* exported algorithm data */
-static struct i2c_algorithm saa7146_algo = {
+static const struct i2c_algorithm saa7146_algo = {
 	.master_xfer	= saa7146_i2c_xfer,
 	.functionality	= saa7146_i2c_func,
 };
-- 
2.5.0

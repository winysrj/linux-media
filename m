Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48050 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752994AbdLEOhx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Dec 2017 09:37:53 -0500
Date: Tue, 5 Dec 2017 17:37:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Leon Luo <leonl@leopardimaging.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] media: imx274: Silence uninitialized variable warning
Message-ID: <20171205143739.uoct55nitjrt4xun@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch complains that "err" can be uninitialized if we have a zero size
write.  The flow analysis is a little complicated so I'm not sure if
that's possible or not, but it's harmless to set this to zero and it
makes the code easier to read.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 800b9bf9cdd3..e7c12933cfd2 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -634,7 +634,7 @@ static int imx274_regmap_util_write_table_8(struct regmap *regmap,
 					    const struct reg_8 table[],
 					    u16 wait_ms_addr, u16 end_addr)
 {
-	int err;
+	int err = 0;
 	const struct reg_8 *next;
 	u8 val;
 
